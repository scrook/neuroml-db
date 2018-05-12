import os
import string
import subprocess
from abc import abstractmethod, ABCMeta
from decimal import Decimal

import numpy as np
from matplotlib import pyplot as plt

from config import Config
from database import NMLDB
from neuronrunner import NeuronRunner
from tables import Model_Waveforms
from manager import ModelManager

from tables import *

class NMLDB_Model(object):
    __metaclass__ = ABCMeta

    def __init__(self, path):
        self.server = NMLDB()
        self.config = Config()
        self.model_manager = ModelManager()
        self.path = path

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_value, traceback):
        self.server.close()
        self.model_manager.server.close()

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

    def create_or_update_waveform(self, protocol, label, meta_protocol, times, variable_name, values, units, run_time):
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
        waveform.Units = units

        waveform.save()
        print("WAVE RECORD SAVED")

        # Create a waveform csv file in actual model waveforms dir as WaveID.csv
        waveforms_dir = self.get_waveforms_dir()

        waveform_csv = os.path.join(waveforms_dir, str(waveform.ID) + ".csv")

        # Use RCP algorithm to simplify the waveform (using 0.5% of value range as tolerance)
        print("Simplifying waveform...")
        times, values = zip(*self.rdp(zip(times, values), epsilon=(max(values) - min(values)) * 0.005))

        Times = string.join([str(v) for v in times], ',')
        Variable_Values = string.join([self.short_string(v) for v in values], ',')

        # The file will have two lines: line 1 - times, line 2 - values
        with open(waveform_csv, "w") as f:
            f.write(Times + '\n')
            f.write(Variable_Values + '\n')

        print("WAVE VALUES SAVED")

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

        self.server.connect()


        with self.server.db.atomic() as transaction:
            self.create_or_update_waveform(protocol, label, meta_protocol, times, "Voltage", voltage, "mV", run_time)
            self.create_or_update_waveform(protocol, label, meta_protocol, times, "Current", current, "nA", run_time)

    def save_tvi_plot(self, label, tvi_dict, case=""):
        plt.clf()

        plt.figure(1)
        plt.subplot(211)
        plt.plot(tvi_dict["t"], tvi_dict["v"], label="Voltage - " + label + (" @ " + case if case != "" else ""))
        plt.ylim(-80, 30)
        plt.legend()

        plt.subplot(212)
        plt.plot(tvi_dict["t"], tvi_dict["i"], label="Current - " + label + (" @ " + case if case != "" else ""))
        plt.legend()
        plt.savefig(label + ("(" + case + ")" if case != "" else "") + ".png")

    @abstractmethod
    def load_model(self):
        pass

    def get_hoc_files(self):
        return [f for f in os.listdir(self.temp_model_path) if f.endswith(".hoc")]

    def get_mod_files(self):
        return [f for f in os.listdir(self.temp_model_path) if f.endswith(".mod")]

    def set_abs_tolerance(self, abs_tol):
        from neuron import h
        h.steps_per_ms = 10
        h.dt = 1.0 / h.steps_per_ms  # NRN will ignore this using cvode

        h.cvode_active(1)
        h.cvode.condition_order(2)
        h.cvode.atol(abs_tol)

    def runFor(self, time, early_test=None):
        from neuron import h
        h.cvode_active(1)

        if not hasattr(self, "time_flag"):
            raise Exception("self.time_flag must be set to NeuronRunner parameter")

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

    def crossings_nonzero_pos2neg(self, data, theshold):
        pos = data > theshold
        return (pos[:-1] & ~pos[1:]).nonzero()[0]

    def getSpikeCount(self, voltage, threshold=-20.0):
        if np.max(voltage) < threshold:
            return 0
        else:
            return len(self.crossings_nonzero_pos2neg(voltage, threshold))

    def save_state(self, state_file='state.bin'):
        from neuron import h
        ns = h.SaveState()
        sf = h.File(state_file)
        ns.save()
        ns.fwrite(sf)

    @abstractmethod
    def restore_state(self, state_file, keep_events):
        pass

    @abstractmethod
    def build_model(self, restore_tolerances):
        pass

    def setTolerances(self, tstop=100):

        def run_atol_tool():

            h = self.build_model(restore_tolerances=False)

            h.NumericalMethodPanel[0].map()
            h.NumericalMethodPanel[0].atoltool()
            h.tstop = tstop

            print("Getting error tolerances...")

            # h.nrncontrolmenu()
            # h.newPlotV()

            h.AtolTool[0].anrun()
            h.AtolTool[0].rescale()
            h.AtolTool[0].fill_used()

            h.save_session('atols.ses')

            print("Error tolerances saved")

            h.AtolTool[0].box.unmap()
            h.NumericalMethodPanel[0].b1.unmap()

        runner = NeuronRunner(run_atol_tool, kill_slow_sims=False)
        runner.run()

    def restore_tolerances(self):
        from neuron import h
        h.load_file('atols.ses')

        h.NumericalMethodPanel[0].b1.unmap()
        print("Using saved error tolerances")

    def get_number_of_model_state_variables(self, h):
        result = h.Vector()
        h.cvode.spike_stat(result)
        return result[0]

    def update_model_simulation_status(self, id, status):
        self.update_model_status(id, "Simulation", status)

    def update_model_status(self, id, status_type, status):

        print("Updating model "+status_type+" status...")
        self.server.connect()

        model = Models.get(Models.Model_ID == id)
        setattr(model, status_type + "_Status", status)

        if status == "ERROR":
            import traceback
            model.Errors = traceback.format_exc()

        if status == "CURRENT":
            model.Errors = None

        model.save()

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

