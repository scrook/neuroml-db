import math
import json
import os, sys
import re
import string
import subprocess
import urllib
from abc import abstractmethod, ABCMeta
from decimal import Decimal
import datetime
from scipy.optimize import curve_fit
from math import sqrt
import numpy as np
import nmldbutils
import shutil
from runtimer import RunTimer
from matplotlib import pyplot as plt

from config import Config
from database import NMLDB
from neuronrunner import NeuronRunner
from tables import Model_Waveforms
from manager import ModelManager

from tables import *

class NMLDB_Model(object):
    __metaclass__ = ABCMeta

    def __init__(self, model="", server=None):
        if server is None:
            self.server = NMLDB()
            self.server_passed_in = False

        else:
            self.server = server
            self.server_passed_in = True

        self.config = Config()

        # If passing in a pre-retrieved Model DB record, re-use it
        if model.__class__.__name__ == "Models":
            self.path = model.Model_ID
            self.model_record = model

        # Otherwise, retrieve a fresh copy
        else:
            self.path = model
            self.server.connect()
            self.model_record = Models.get(Models.Model_ID == self.get_model_nml_id())

        sys.setrecursionlimit(10000)

        self.all_properties = [
            'checksum'
        ]

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_value, traceback):
        if not self.server_passed_in:
            self.server.close()

        if self.config.cleanup_temp and hasattr(self, "temp_model_path"):
            print("Cleaning up temp files in: " + self.temp_model_path + " ...")
            os.system('rm -rf "' + self.temp_model_path + '"')
            print("Cleanup done")

    def save_properties(self, properties=['ALL'], skip_conversion_to_NEURON=False):
        property = None

        if properties == ['ALL']:
            properties = self.all_properties

        try:
            if not skip_conversion_to_NEURON:
                self.convert_to_NEURON(self.get_model_nml_id())

            for property in properties:
                self.save_property(property)

            self.update_model_status(status="CURRENT")

        except:
            print("Encountered an error. Saving error message...")
            self.update_model_status(status="ERROR", property=property)
            raise

        finally:
            self.cleanup_waveforms()

    def save_property(self, property):
        print("Saving " + self.get_model_nml_id() + " " + property + "...")

        # Call save_[property] method eg. save_checksum()
        method = "save_" + property
        if not hasattr(self, method):
            print(self.__class__.__name__ + " does not have a method called '" + method + "()'. Skipping property...")
            return

        getattr(self, method)()

    def is_nosim(self):
        if self.model_record.Status == 'NOSIM':
            print("Model " + self.model_record.Model_ID + " has simulation status NOSIM...")
            return True

        return False

    def remove_protocol_waveforms(self, protocol):
        print("Removing existing model waveforms: " + str(protocol))

        Model_Waveforms \
            .delete() \
            .where((Model_Waveforms.Model == self.model_record) & (Model_Waveforms.Protocol == protocol)) \
            .execute()

        print("DONE")

    def save_checksum(self):
        file_path = os.path.join(self.get_permanent_model_directory(), self.model_record.File_Name)

        new_checksum = nmldbutils.get_file_checksum(file_path)

        if new_checksum is None:
            raise Exception("File " + file_path + " does not exist to compute checksum")

        if self.model_record.File_MD5_Checksum != new_checksum:
            print("Checksum different, saving...")
            self.model_record.File_MD5_Checksum = new_checksum
            self.model_record.save()

    def save_equation_count(self):
        count = self.get_equation_count()

        if count is not None:
            self.server.connect()
            self.model_record.Equations = count
            self.model_record.save()

    def get_equation_count(self):
        """
        Counts the number of model differential equations
        :return: The total count of differential equation states in the model
        """
        def run_eq_counter():
            h = self.build_model(restore_tolerances=False)

            return self.get_number_of_model_state_variables(h)

        runner = NeuronRunner(run_eq_counter, kill_slow_sims=False)
        eq_count = runner.run()

        return eq_count

    def save_runtime_per_step(self):
        def step_timer(time_flag):
            print('Starting Step Runtime protocol...')
            self.time_flag = time_flag

            # Extremely light setup - to minimize impact on run-time
            h = self.load_model()
            h.cvode_active(0)
            h.dt = 1/128.0
            h.steps_per_ms = 1.0

            # Obtain a rough estimate of the model speed - from a 100ms sample
            with RunTimer() as timer:
                h.tstop = 100
                h.run()

            sample_time = timer.get_run_time()

            # Use the estimate to run the simulation for about ~60 seconds
            runtime_approx_60s = 60.0/sample_time*100.0

            print("Estimating runtime per step with a ~60 sec run...")
            with RunTimer() as timer:
                h.tstop = runtime_approx_60s
                h.run()

            full_time = timer.get_run_time()

            # Get the actual number of steps taken
            full_steps = int(round(h.t / h.dt))

            result = {
                "runtime_per_step": full_time / full_steps
            }

            return result

        runner = NeuronRunner(step_timer)
        runner.DONTKILL = True
        result = runner.run()

        self.model_record.Runtime_Per_Step = result["runtime_per_step"]
        self.model_record.save()

    def convert_to_NEURON(self, path=None):
        """
        Converts the model to NEURON, storing files in config.temp_models_folder.
        :param path: NML ID or path to NeuroML file
        :return: None
        """
        if path is None:
            path = self.path

        print("Converting NML model to NEURON...")

        # Get the parent folder of the model
        if nmldbutils.is_nmldb_id(path):
            model_dir_name = self.get_permanent_model_directory()

            dir_nml_files = [f for f in os.listdir(model_dir_name) if nmldbutils.is_nml2_file(f)]

            if len(dir_nml_files) != 1:
                raise Exception("There should be exactly one NML file in the model directory: " + str(dir_nml_files))

            model_file_name = dir_nml_files[0]

        else:
            model_dir_name = os.path.dirname(os.path.abspath(path))
            model_file_name = os.path.basename(path)

        nml_db_id = model_dir_name.split("/")[-1]

        if not nmldbutils.is_nmldb_id(nml_db_id):
            raise Exception("The name of the parent folder of the model should be a NeuroML-DB id: " + nml_db_id)

        # Templates
        with open("templates/LEMS_single_model_template.xml") as t:
            template = t.read()

        include_file_template = '	<Include file="[File]"/>'

        # Find the NML id of the cell
        with open(os.path.join(model_dir_name, model_file_name)) as f:
            nml = f.read()
            model_nml_id = self.get_id_from_nml_file(nml)
            model_child_filenames = self.get_children_from_nml_file(nml)

        # Get all cell channel files from the model API
        children_in_db = self.get_model_children_from_DB(nml_db_id)

        db_child_filenames = set(c["File_Name"] for c in children_in_db)

        if len(db_child_filenames - model_child_filenames) > 0:
            print("Misbehaving children: The following files are in DATABASE but MISSING IN MODEL: " + nml_db_id)
            print([(c["Model_ID"], c["File_Name"]) for c in children_in_db if c["File_Name"] in (db_child_filenames - model_child_filenames)])
            raise Exception("Database has extra children for the model")

        if len(model_child_filenames - db_child_filenames) > 0:
            print("Misbehaving children: The following files are in model but MISSING IN DATABASE: " + nml_db_id)
            print(model_child_filenames - db_child_filenames)
            raise Exception("Database is missing children for the model")

        # Set the location where the NEURON files will be stored
        temp_model_folder = os.path.join(os.path.abspath(self.config.temp_models_folder), nml_db_id)

        # Clear it if exists or create it
        if os.path.exists(temp_model_folder):
            shutil.rmtree(temp_model_folder)

        os.makedirs(temp_model_folder)

        # Copy the model to the temp folder
        shutil.copy2(os.path.join(model_dir_name, model_file_name), temp_model_folder)

        # Create file includes for each child model
        child_includes = ''

        for c in children_in_db:
            id = c["Model_ID"]
            file = c["File_Name"]
            child_path = "../" + id + "/" + file

            # Copy the children to the NEURON temp files folder
            shutil.copy2(os.path.join(model_dir_name, child_path), temp_model_folder)
            child_includes = child_includes + include_file_template.replace("[File]", file) + "\n"

        replacements = {
            "[ParentInclude]": include_file_template.replace("[File]", model_file_name),
            "[ChildIncludes]": child_includes,
            "[Parent_ID]": model_nml_id
        }

        for r in replacements:
            template = template.replace(r, str(replacements[r]))

        out_file = temp_model_folder + "/LEMS_" + model_file_name

        with open(out_file, "w") as outF:
            outF.write(template)

        # Convert LEMS to NEURON with JNML
        os.chdir(temp_model_folder)

        self.run_command("jnml LEMS_" + model_file_name + " -neuron")

        self.temp_model_path = temp_model_folder

        self.on_before_mod_compile()

        # Compile mod files
        self.run_command("nrnivmodl")

        return temp_model_folder

    def get_children_from_nml_file(self, nml):
        return set(re.compile('<include.*?href.*?=.*?"(.*?)"').findall(nml))


    def get_id_from_nml_file(self, nml):
        """
        When implemented in a sub-class, returns the id attribute of the top-level parent model's NML element
        :param nml: Contents of the NML file of the model
        :return: A string with the value of the model's element's id attribute
        """
        raise NotImplementedError()


    def get_model_children_from_DB(self, modelID):
        url = "http://" + self.config.webserver + "/api/model?id=" + modelID
        response = urllib.urlopen(url)
        model = json.loads(response.read())

        # restrict to cell children
        #channels = [m for m in model["children"] if m["Type"] == "Channel" or m["Type"] == "Concentration"]

        children = model["children"]
        return children

    def get_model_nml_id(self):
        return self.path.split("/")[-1]

    def make_gif_from_frames(self, gif_path, gif_name="cell.gif", frame_naming_scheme='"%04d.jp2"', ):
        # generate gif with ffmpeg
        current_cwd = os.getcwd()

        # Go to the render output dir
        os.chdir(gif_path)

        # Create a palette for the gif using 0-padding-numbered jp2 files
        os.system('ffmpeg -y -i '+frame_naming_scheme+' -vf palettegen palette.png ')

        # Use the palette and jp2 files to create color-corrected animated gif
        os.system('ffmpeg -y -i '+frame_naming_scheme+' -i palette.png -lavfi "fps=24, paletteuse" ' + gif_name)

        # Remove the palette and the frame files
        os.system('rm *.jp2')
        os.system('rm *.png')

        os.chdir(current_cwd)

    @staticmethod
    def short_string(x):
        return str(float('%.4E' % Decimal(x)))

    def get_waveforms_dir(self):
        result = os.path.abspath(os.path.join(self.config.permanent_models_dir, self.get_model_nml_id(), "waveforms"))

        if not os.path.exists(result):
            os.mkdir(result)

        return result

    def get_morphology_dir(self):
        result = os.path.abspath(os.path.join(self.config.permanent_models_dir, self.get_model_nml_id(), "morphology"))

        if not os.path.exists(result):
            os.mkdir(result)

        return result

    def set_wave_metrics(self, wave, values):
        wave.Spikes = self.getSpikeCount(values)
        wave.Min = np.min(values)
        wave.Max = np.max(values)
        wave.Mean = np.mean(values)
        wave.STD = np.std(values)

    def create_or_update_waveform(self, protocol, label, meta_protocol, times, variable_name, values, units,
                                  run_time, error, dt_or_atol, cvode_active, steps):
        print("Saving waveform...")

        model_id = self.get_model_nml_id()

        waveform = Model_Waveforms.get_or_none((Model_Waveforms.Model == model_id) &
                                               (Model_Waveforms.Protocol == protocol) &
                                               (Model_Waveforms.Meta_Protocol == meta_protocol) &
                                               (Model_Waveforms.Waveform_Label == label) &
                                               (Model_Waveforms.Variable_Name == variable_name))

        if waveform is None:
            waveform = Model_Waveforms()
            waveform.Model = model_id
            waveform.Protocol = protocol
            waveform.Meta_Protocol = meta_protocol
            waveform.Waveform_Label = label
            waveform.Variable_Name = variable_name

        waveform.Time_Start = min(times)
        waveform.Time_End = max(times)
        waveform.Run_Time = run_time
        waveform.Steps = steps
        waveform.dt_or_atol = dt_or_atol
        waveform.CVODE_active = cvode_active

        self.set_wave_metrics(waveform, np.array(values))

        waveform.Units = units
        waveform.Timestamp = datetime.datetime.now()

        if error is not None:
            waveform.Percent_Error = error

        waveform.save()
        print("WAVE RECORD SAVED")

        # Create a waveform csv file in actual model waveforms dir as WaveID.csv
        waveforms_dir = self.get_waveforms_dir()

        waveform_csv = os.path.join(waveforms_dir, str(waveform.ID) + ".csv")

        # Use RCP algorithm to simplify the waveform (using x% of value range as tolerance)
        print("Simplifying waveform...")
        times, values = zip(*self.rdp(zip(times, values), epsilon=(max(values) - min(values)) * self.config.simplification_constant))

        Times = string.join([str(v) for v in times], ',')
        Variable_Values = string.join([self.short_string(v) for v in values], ',')

        # The file will have two lines: line 1 - times, line 2 - values
        with open(waveform_csv, "w") as f:
            f.write(Times + '\n')
            f.write(Variable_Values + '\n')

        print("WAVE VALUES SAVED")

    def get_permanent_model_directory(self):
        return os.path.join(self.config.permanent_models_dir, self.get_model_nml_id())

    def line_dists(self, points, start, end):
        if np.all(start == end):
            return np.linalg.norm(points - start, axis=1)

        vec = end - start
        cross = np.cross(vec, start - points)
        return np.divide(abs(cross), np.linalg.norm(vec))

    def rdp(self, M, epsilon=0.0):
        M = np.array(M)
        start, end = M[0], M[-1]
        dists = self.line_dists(M, start, end)

        index = np.argmax(dists)
        dmax = dists[index]

        if dmax > epsilon:
            result1 = self.rdp(M[:index + 1], epsilon)
            result2 = self.rdp(M[index:], epsilon)

            result = np.vstack((result1[:-1], result2))
        else:
            result = np.array([start, end])

        return result

    def cleanup_waveforms(self):
        print("Removing orphan wave files...")
        waveforms_dir = self.get_waveforms_dir()
        wave_files = set(f.replace(".csv", "") for f in os.listdir(waveforms_dir))
        wave_records = set(str(r.ID) for r in Model_Waveforms.select(Model_Waveforms.ID).where(Model_Waveforms.Model == self.get_model_nml_id()))
        extra_waves = wave_files-wave_records

        for wave in extra_waves:
            os.remove(os.path.join(waveforms_dir, wave + ".csv"))

    def save_vi_waveforms(self, protocol, tvi_dict, label=None, meta_protocol=None):
        times = tvi_dict["t"]
        voltage = tvi_dict["v"]
        current = tvi_dict["i"]
        run_time = tvi_dict["run_time"]

        error = tvi_dict["error"] if "error" in tvi_dict else None
        dt_or_atol = tvi_dict["dt_or_atol"]
        cvode_active = tvi_dict["cvode_active"]
        steps = tvi_dict["steps"]

        self.server.connect()

        with self.server.db.atomic() as transaction:
            self.create_or_update_waveform(protocol, label, meta_protocol, times, "Voltage", voltage, "mV", run_time, error, dt_or_atol, cvode_active, steps)
            self.create_or_update_waveform(protocol, label, meta_protocol, times, "Current", current, "nA", run_time, None, dt_or_atol, cvode_active, steps)

    def save_tvi_plot(self, label, tvi_dict, case=""):
        plt.clf()

        plt.figure(1)
        plt.subplot(211)
        plt.plot(tvi_dict["t"], tvi_dict["v"], label="Voltage - " + label + (" @ " + case if case != "" else ""))
        plt.ylim(-80, 50)
        plt.legend()

        plt.subplot(212)
        plt.plot(tvi_dict["t"], tvi_dict["i"], label="Current - " + label + (" @ " + case if case != "" else ""))
        plt.legend()
        plt.savefig(label + ("(" + case + ")" if case != "" else "") + ".png")

    def load_model(self):
        raise NotImplementedError()

    def get_hoc_files(self):
        return [f for f in os.listdir(self.temp_model_path) if f.endswith(".hoc")]

    def get_mod_files(self):
        return [f for f in os.listdir(self.temp_model_path) if f.endswith(".mod")]

    def set_abs_tolerance(self, abs_tol):
        from neuron import h

        # NRN will ignore this using cvode
        h.steps_per_ms = 1.0/self.config.collection_period_ms
        h.dt = self.config.dt

        h.cvode_active(self.config.cvode_active)
        h.cvode.condition_order(2)
        h.cvode.atol(abs_tol)

    def runFor(self, time, early_test=None):
        from neuron import h
        h.cvode_active(self.config.cvode_active)

        if not hasattr(self, "time_flag"):
            raise Exception("self.time_flag must be set to the parameter passed into NeuronRunner call")

        self.time_flag.value = h.t

        h.tstop = h.t + time
        t = h.t
        while t < h.tstop and h.t < h.tstop:
            t += 1.0

            h.continuerun(t)

            if early_test is not None:
                # Notify sim is paused during test eval
                self.time_flag.value = -1

                t_np, v_np = self.get_tv()
                if early_test(t_np, v_np):
                    return (t_np, v_np)

            # Notify change in sim time
            self.time_flag.value = h.t

        # -1 indicates simulation stopped
        self.time_flag.value = -1

        # Get the waveform
        return self.get_tv()

    def get_tv(self):
        raise NotImplementedError()

    def crossings_nonzero_neg2pos(self, data, threshold):
        pos = data > threshold
        return (~pos[:-1] & pos[1:]).nonzero()[0]

    def getSpikeCount(self, voltage, threshold=None):

        if threshold is None:
            # If not specified, get it from cell record, if any
            if hasattr(self, "cell_record"):
                threshold = self.cell_record.Threshold if self.cell_record.Threshold is not None else 0
            else:
                threshold = 0

        if np.max(voltage) < threshold:
            return 0
        else:
            return len(self.crossings_nonzero_neg2pos(voltage, threshold))

    def save_state(self, state_file='state.bin'):
        from neuron import h
        ns = h.SaveState()
        sf = h.File(os.path.join(self.get_permanent_model_directory(), state_file))
        ns.save()
        ns.fwrite(sf)

    def restore_state(self, state_file='state.bin', keep_events=False):
        from neuron import h
        ns = h.SaveState()
        sf = h.File(os.path.join(self.get_permanent_model_directory(), state_file))
        ns.fread(sf)

        h.stdinit()

        if keep_events:
            ns.restore(1)

            # Workaround - without the fixed step cycle, NEURON crashes with same error as in:
            # https://www.neuron.yale.edu/phpBB/viewtopic.php?f=2&t=3845&p=16542#p16542
            # Only happens when there is a vector.play added after a state restore
            # Running one cycle using the fixed integration method addresses the problem
            h.cvode_active(0)
            prev_dt = h.dt
            h.dt = 0.000001
            h.steprun()
            h.dt = prev_dt
            # END Workaround

        else:
            ns.restore()

        h.cvode_active(self.config.cvode_active)

    def build_model(self, restore_tolerances):
        raise NotImplementedError()

    def save_tolerances(self, tstop=100, current_amp=0.0):

        if self.config.cvode_active == 0:
            return

        if os.path.exists(os.path.join(self.get_permanent_model_directory(), 'atols.ses')) and self.config.skip_tolerance_setting_if_exists:
            print("Previous tolerance file exists. Skipping...")
            return

        def run_atol_tool():

            h = self.build_model(restore_tolerances=False)

            h.NumericalMethodPanel[0].map()
            h.NumericalMethodPanel[0].atoltool()
            h.tstop = tstop

            print("Getting error tolerances...")

            # h.nrncontrolmenu()
            # h.newPlotV()

            if current_amp != 0.0:
                self.current.delay = 0
                self.current.amp = current_amp
                self.current.dur = tstop

            h.AtolTool[0].anrun()
            h.AtolTool[0].rescale()
            h.AtolTool[0].fill_used()

            h.save_session(os.path.join(self.get_permanent_model_directory(), 'atols.ses'))

            print("Error tolerances saved")

            h.AtolTool[0].box.unmap()
            h.NumericalMethodPanel[0].b1.unmap()

        runner = NeuronRunner(run_atol_tool, kill_slow_sims=False)
        runner.run()

    def restore_tolerances(self):

        if self.config.cvode_active == 0:
            return

        from neuron import h
        h.load_file(os.path.join(self.get_permanent_model_directory(), 'atols.ses'))

        h.NumericalMethodPanel[0].b1.unmap()
        print("Using saved error tolerances")

    def get_number_of_model_state_variables(self, h):
        print("Turning on CVODE to compute number of equations...")
        h.cvode_active(1)

        result = h.Vector()
        h.cvode.spike_stat(result)
        return int(result[0])

    def update_model_status(self, status, property=None):

        print("Updating model status...")
        self.server.connect()

        # Don't change the status of NOSIM models
        if self.model_record.Status != "NOSIM":
            self.model_record.Status = status

        self.model_record.Status_Timestamp = datetime.datetime.now()

        if status == "ERROR":
            import traceback
            self.model_record.Errors = "Error while updating property: '" + str(property) + "'\n" + traceback.format_exc()

        if status == "CURRENT":
            self.model_record.Errors = None

        self.model_record.save()

    def save_cvode_runtime_complexity_metrics(self):
        print("Variable step complexity metrics for " + self.get_model_nml_id()+ "...")

        # CVODE Steps ~ a*spikes + b
        def steps_vs_spikes_func(spikes, a, b):
            return a * np.array(spikes) + b

        waves = Model_Waveforms \
            .select() \
            .where(
                (Model_Waveforms.Model == self.model_record) &
                (Model_Waveforms.Protocol == 'CVODE_STEP_FREQUENCIES') &
                (Model_Waveforms.Variable_Name == 'Voltage') &
                (Model_Waveforms.Waveform_Label != '0.0 nA')) \
            .order_by(Model_Waveforms.Model, Model_Waveforms.Waveform_Label)

        if len(waves) == 0:
            print("Model " + self.get_model_nml_id() + " does not have any 'CVODE_STEP_FREQUENCIES' waveforms. Skipping...")
            return

        else:
            print("Computing baseline steps/s and steps per spike for " + self.model_record.Model_ID + "...")

            # Don't exclude the 0-current if no 0-spike waveforms exist
            if len([w.Spikes for w in waves if w.Spikes == 0]) == 0 and max([w.Spikes for w in waves]) == 1:
                waves = Model_Waveforms \
                    .select() \
                    .where(
                        (Model_Waveforms.Model == self.model_record) &
                        (Model_Waveforms.Protocol == 'CVODE_STEP_FREQUENCIES') &
                        (Model_Waveforms.Variable_Name == 'Voltage')) \
                    .order_by(Model_Waveforms.Model, Model_Waveforms.Waveform_Label)

            spikes = [w.Spikes for w in waves]
            steps = [w.Steps for w in waves]

            steps_params, _ = curve_fit(steps_vs_spikes_func, spikes, steps)

            a = steps_params[0]
            b = steps_params[1]

            # plt.scatter(spikes, np.array(steps))
            # plt.plot(spikes, steps_vs_spikes_func(spikes, *steps_params))
            # plt.show()

            self.model_record.CVODE_steps_per_spike = a
            self.model_record.CVODE_baseline_step_frequency = b
            self.model_record.save()

    def save_optimal_time_step(self):
        print("Getting optimal time step for " + self.get_model_nml_id() + "...")

        # Run time ~ 1/dt
        def time_func(dt, a):
            return a / np.array(dt)

        # Error ~ dt
        def error_func(dt, b, c):
            return b * np.array(dt) + c

        waves = Model_Waveforms \
            .select() \
            .where((Model_Waveforms.Model == self.model_record) &
                   (Model_Waveforms.Protocol == 'DT_SENSITIVITY') &
                   (Model_Waveforms.Variable_Name == 'Voltage')) \
            .order_by(Model_Waveforms.Model, Model_Waveforms.Waveform_Label)

        if len(waves) == 0:
            print("Model " + self.get_model_nml_id() + " does not have any 'DT_SENSITIVITY' waveforms. Skipping...")
            return

        if len(waves) == 1:
            print("Model " + self.get_model_nml_id() + " has one 'DT_SENSITIVITY' waveform. Using waveform dt as optimal...")
            optimal_dt = float(waves[0].Waveform_Label.replace(" ms", ""))
            print("Saving optimal time step 1/" + str(1 / optimal_dt) + "...")
            self.model_record.Optimal_DT = optimal_dt
            self.model_record.save()

        else:
            print("Computing optimal time step for " + self.model_record.Model_ID + "...")

            # Compute the runtime based on steps taken and the more accurate estimate of runtime/step
            # The actual runtime of a waveform for very fast models is very noisy
            time_max = max([w.Steps for w in waves]) * self.model_record.Runtime_Per_Step
            time_min = min([w.Steps for w in waves]) * self.model_record.Runtime_Per_Step
            time_range = time_max-time_min

            error_max = max([w.Percent_Error for w in waves])
            #Error min is always 0

            time_norm = [((w.Steps * self.model_record.Runtime_Per_Step)-time_min) / time_range for w in waves]
            error_norm = [w.Percent_Error / error_max for w in waves]
            dts = [float(w.Waveform_Label.replace(" ms", "")) for w in waves]

            time_params, _ = curve_fit(time_func, dts, time_norm)
            error_params, _ = curve_fit(error_func, dts, error_norm)

            # Find the dt at minimum total cost
            # Total cost = normalized time cost + normalized error cost (here weighed equally)
            # Time cost is in the 1/dt form
            # Error cost is in slope*dt+constant form
            # Total cost = a/x+(b*x+c)
            # dt of minimum total cost is where total cost derivative = 0
            # Total cost derivative is b-a/x^2
            # The positive root of which is at sqrt(a/b) when a,b > 0
            a = time_params[0]
            b = error_params[0]
            c = error_params[1]
            optimal_dt = sqrt(a / b)

            # plt.plot(dts, np.array(time_norm))
            # plt.plot(dts, np.array(error_norm))
            # plt.plot(dts, np.array(time_norm)+np.array(error_norm))
            # plt.plot(dts, time_func(dts, *time_params) + error_func(dts, *error_params))
            # plt.plot([optimal_dt, optimal_dt], [0, 1])
            # plt.show()

            print("Saving optimal time step 1/" + str(1 / optimal_dt) + "...")
            self.model_record.Optimal_DT = optimal_dt
            self.model_record.Optimal_DT_a = a
            self.model_record.Optimal_DT_b = b
            self.model_record.Optimal_DT_c = c
            self.model_record.save()

        return optimal_dt

    def run_command(self, command):
        print("Running command: '" + command + "'...")

        result = subprocess.check_output(
            command + "; exit 0",
            stderr=subprocess.STDOUT,
            shell=True)

        print(result)  # Output and errors will be in string

        if any(x in result.lower() for x in ["error", "not found", "missing"]):
            raise Exception("Errors found while running command: " + command)

        print("SUCCESS")

        return result

    def on_before_mod_compile(self):
        """
        When overwritten by a sub-class, this method can be used to execute additional
        steps after the model has been converted to NEURON, but before mod files are compiled
        :return:
        """
        pass

    def save_wave_stats(self):
        self.server.connect()

        waves = Model_Waveforms \
            .select(Model_Waveforms.Model, Model_Waveforms.ID, Model_Waveforms.Protocol) \
            .where(
                (Model_Waveforms.Model == self.get_model_nml_id())
            )

        for wave in waves:
            print("Getting stats for wave " + str(wave.ID) + "...")

            file = os.path.join(self.get_waveforms_dir(), str(wave.ID) + ".csv")

            if os.path.exists(file):
                with open(file) as f:
                    lines = f.readlines()

                    # times = lines[0]
                    values = np.fromstring(lines[1], dtype=float, sep=',')

                    self.set_wave_metrics(wave, values)

                    wave.save()
