# Obtains the cell threshold, rheobase, resting v, and bias currents for
# steady state v of a cell defined in a hoc file in the given directory.
# Usage: python getCellProperties /path/To/dir/with/.hoc

import cPickle
import csv
import json
import os
import re
import shutil
import string
import urllib
from abc import abstractmethod, ABCMeta
from decimal import Decimal

import numpy as np
from matplotlib import pyplot as plt
from playhouse.db_url import connect
from sshtunnel import SSHTunnelForwarder

from collector import Collector
from manager import ModelManager
from neuronrunner import NeuronRunner, NumericalInstabilityException
from runtimer import RunTimer
from tables import Cells, Model_Waveforms, Morphometrics, Cell_Morphometrics, db_proxy, Models
from nmldbmodel import NMLDB_Model

class CellModel(NMLDB_Model):
    def __init__(self, path):
        super(CellModel, self).__init__(path)
        self.pickle_file_cache = {}

    def save_cell_model_properties(self, model_dir):
        NEURON_folder = self.cell_model_to_neuron(model_dir)

        assessor = CellModel(path=NEURON_folder)

        id = assessor.get_model_nml_id()

        try:
            assessor.get_cell_properties()
            self.update_model_simulation_status(id, status="CURRENT")

        except:
            print("Encountered an error. Saving progress...")

            assessor.save_cell_record()

            self.update_model_simulation_status(id, status="ERROR")

            raise

    def get_cell_properties(self):
        self.cell_record = Cells(
            Model_ID=self.get_model_nml_id(),
            Stability_Range_Low=None,
            Stability_Range_High=None,
            Is_Intrinsically_Spiking=False,
            Resting_Voltage=None,
            Rheobase_Low=None,
            Rheobase_High=None,
            Threshold_Current_Low=None,
            Threshold_Current_High=None,
            Bias_Current=None,
            Bias_Voltage=None,
            Errors=None
        )

        self.setTolerances()

        print("Getting stability range...")
        self.cell_record.Stability_Range_Low, self.cell_record.Stability_Range_High = self.getStabilityRange()
        # self.cell_record.Stability_Range_Low, self.cell_record.Stability_Range_High = (-1.5, 76.0)

        if self.cell_record.Stability_Range_Low == self.cell_record.Stability_Range_High:
            print("Cell is not stable, skipping tests...")
            self.save_cell_record()

        print("Getting resting voltage...")
        self.cell_record.Resting_Voltage = self.getRestingV()["rest"]
        # self.cell_record.Resting_Voltage = -76.0

        # If intrinsically spiking, skip the remaining tests
        if self.cell_record.Resting_Voltage is None:
            print("Cell is intrinsincally spiking, skipping other tests...")
            self.cell_record.Is_Intrinsically_Spiking = True
            self.save_cell_record()
        else:
            self.cell_record.Is_Intrinsically_Spiking = False

            print("Getting threshold...")
            th = self.getThreshold(0, self.cell_record.Stability_Range_High)
            self.cell_record.Threshold_Current_Low = np.min(th)
            self.cell_record.Threshold_Current_High = np.max(th)
            # self.cell_record.Threshold_Current_Low = 0.16
            # self.cell_record.Threshold_Current_High = 0.25

            print("Getting rheobase...")
            rb = self.getRheobase(0, self.cell_record.Threshold_Current_High)
            self.cell_record.Rheobase_Low = np.min(rb)
            self.cell_record.Rheobase_High = np.max(rb)
            # self.cell_record.Rheobase_Low = 0.16
            # self.cell_record.Rheobase_High = 0.25

            roundedRest = round(self.cell_record.Resting_Voltage / 10) * 10

            if roundedRest == -80:
                bias_v = -70
            else:
                bias_v = -80

            print("Getting current for bias voltage...")
            bias_i = self.getBiasCurrent(targetV=bias_v)

            self.cell_record.Bias_Voltage = bias_v
            self.cell_record.Bias_Current = bias_i

            print("Starting validation...")
            assert self.cell_record.Stability_Range_Low < self.cell_record.Stability_Range_High
            assert self.cell_record.Resting_Voltage < 0
            assert self.cell_record.Rheobase_Low < self.cell_record.Rheobase_High
            assert self.cell_record.Rheobase_High < self.cell_record.Threshold_Current_High
            assert self.cell_record.Threshold_Current_Low < self.cell_record.Threshold_Current_High
            assert self.cell_record.Bias_Current < self.cell_record.Rheobase_High

            if self.cell_record.Bias_Voltage < self.cell_record.Resting_Voltage:
                assert self.cell_record.Bias_Current < 0
            else:
                assert self.cell_record.Bias_Current > 0

            self.cell_record.Errors = ""

            print("Tests finished, saving...")
            self.save_cell_record()

    def get_number_of_compartments(self, h):
        return sum(s.nseg for s in h.allsec())

    def save_to_SWC(self, h):
        import xml.etree.ElementTree

        self.server.connect()
        model = Models.get_by_id(self.get_model_nml_id())
        root = xml.etree.ElementTree.parse(model.File_Name).getroot()

        seg_tags = root.findall(".//{http://www.neuroml.org/schema/neuroml2}segment")

        point_ids = {}
        self.current_id = 1

        def add_point(prox_dist):
            if len(prox_dist) > 0:
                point_str = str(prox_dist[0].attrib)

                if point_str not in point_ids:
                    point_ids[point_str] = str(self.current_id)
                    self.current_id += 1

        for seg_tag in seg_tags:
            proximal = seg_tag.findall('{http://www.neuroml.org/schema/neuroml2}proximal')
            distal   = seg_tag.findall('{http://www.neuroml.org/schema/neuroml2}distal')

            add_point(proximal)
            add_point(distal)

        segment_distal_point_ids = {}

        for seg_tag in seg_tags:
            distal = seg_tag.findall('{http://www.neuroml.org/schema/neuroml2}distal')
            point_id = point_ids[str(distal[0].attrib)]
            segment_distal_point_ids[seg_tag.attrib["id"]] = point_id

        swc_points = []

        def get_type(seg_tag):
            seg_name = seg_tag.attrib["name"].lower()

            if "dend" in seg_name:
                return "3"

            if "axon" in seg_name:
                return "2"

            if "soma" in seg_name:
                return "1"

            return "5"

        for tag in seg_tags:
            parent_tag = tag.findall('{http://www.neuroml.org/schema/neuroml2}parent')
            proximal = tag.findall('{http://www.neuroml.org/schema/neuroml2}proximal')
            distal   = tag.findall('{http://www.neuroml.org/schema/neuroml2}distal')

            if parent_tag:

                # parent - with prox - use proximal as parent id
                if proximal:
                    parent_id = point_ids[str(proximal[0].attrib)]

                    # If diameter of proximal is not the same as parent's distal - add as separate point
                    if parent_id not in [pt["id"] for pt in swc_points]:
                        swc_point = {
                            "id": parent_id,
                            "type": get_type(tag),
                            "parent": segment_distal_point_ids[parent_tag[0].attrib["segment"]],
                            "x": proximal[0].attrib["x"],
                            "y": proximal[0].attrib["y"],
                            "z": proximal[0].attrib["z"],
                            "radius": str(float(proximal[0].attrib["diameter"]) / 2.0)
                        }

                        swc_points.append(swc_point)

                # parent - no prox - use parent's distal as parent id
                else:
                    parent_id = segment_distal_point_ids[parent_tag[0].attrib["segment"]]

            # no parent - add proximal - will become distal's parent
            else:
                swc_point = {
                    "id": point_ids[str(proximal[0].attrib)],
                    "type": get_type(tag),
                    "parent": "-1",
                    "x": proximal[0].attrib["x"],
                    "y": proximal[0].attrib["y"],
                    "z": proximal[0].attrib["z"],
                    "radius": str(float(proximal[0].attrib["diameter"]) / 2.0)
                }

                parent_id = swc_point["id"]

                swc_points.append(swc_point)


            # Always add distal
            swc_point = {
                "id": point_ids[str(distal[0].attrib)],
                "type": get_type(tag),
                "parent": str(parent_id),
                "x": distal[0].attrib["x"],
                "y": distal[0].attrib["y"],
                "z": distal[0].attrib["z"],
                "radius": str(float(distal[0].attrib["diameter"]) / 2.0)
            }

            swc_points.append(swc_point)

        try:
            os.makedirs("morphology")
        except:
            pass

        swc_file_path = "morphology/cell.swc"

        with open(swc_file_path, "w") as file:
            for point in swc_points:
                file.write(
                    point["id"] + " " +
                    point["type"] + " " +
                    point["x"] + " " +
                    point["y"] + " " +
                    point["z"] + " " +
                    point["radius"] + " " +
                    point["parent"] + "\n")

        permanent_morphology_dir = os.path.join(self.config.permanent_model_parent_dir, self.get_model_nml_id(), "morphology")

        try:
            os.makedirs(permanent_morphology_dir)
        except:
            pass

        shutil.copy2(swc_file_path, permanent_morphology_dir)

        return os.path.abspath(swc_file_path)

    def save_LMeasure_metrics(self, swc_file):

        db = self.server.connect()
        cell_id = self.get_model_nml_id()

        # Do all the work within a transaction
        with db.atomic():
            # Clear out existing cell metrics
            Cell_Morphometrics.delete().where(Cell_Morphometrics.Cell == cell_id).execute()

            # Get a list of metrics
            metrics = Morphometrics.select()

            for metric in metrics:
                # Compute the metric with lmeasure
                f = metric.Function_ID
                swc_file = swc_file.replace(os.path.abspath(os.getcwd()) + "/", "")
                os.system('../../lmeasure -f'+str(f)+',0,0,10.0 -slmeasure_out.csv '+swc_file)

                # Read the result
                with open('lmeasure_out.csv') as f:
                    line = list(csv.reader(f, delimiter="\t"))[0]

                    # Make sure the db function id corresponds to the Lmeasure function name
                    assert line[1].startswith(metric.ID)

                    # Save to DB
                    record = Cell_Morphometrics(
                        Cell=cell_id,
                        Metric=metric,
                        Total = float(line[2]),
                        Compartments_Considered=int(line[3]),
                        Compartments_Discarded=int(line[4].replace("(", "").replace(")", "")),
                        Minimum = float(line[5]),
                        Average = float(line[6]),
                        Maximum = float(line[7]),
                        StDev = float(line[8])
                    )

                    record.save()

            # Cleanup lmeasure files
            os.system("rm lmeasure_out.csv")

    def save_morphology_data(self):
        # Convert NML to NEURON
        self.cell_model_to_neuron(self.temp_model_path)

        # Load the model
        h = self.build_model(restore_tolerances=False)

        # Compute morphometrics
        self.save_morphometrics(h)

        # Rotate the cell to be upright along the x,y,z coord PCA axes
        self.rotate_cell_along_PCA_axes(h)

        import sys
        sys.path.append('/home/justas/Repositories/BlenderNEURON/ForNEURON')
        from blenderneuron import BlenderNEURON

        bl = BlenderNEURON(h)
        bl.prepare_for_collection()

        self.server.connect()

        cell = Cells.get_or_none(self.get_model_nml_id())

        # Skip simulation if no basic properties are present
        if cell is not None:
            # Inject continous threshold current into non-intrinisic-spikers
            if not cell.Is_Intrinsically_Spiking:
                self.current.delay = 0
                self.current.dur = 100
                self.current.amp = cell.Threshold_Current_High

            # No additional stim for intrinisic spikers
            h.tstop = 100.0
            h.run()

        self.save_rotating_gif(bl)

        # id = assessor.get_model_nml_id()
        #
        # try:
        #     assessor.get_cell_model_responses()
        #     self.update_model_simulation_status(id, status="CURRENT")
        #
        # except:
        #     print("Encountered an error. Saving progress...")
        #     self.update_model_simulation_status(id, status="ERROR")
        #
        #     raise

    def save_rotating_gif(self, bl):
        bl.enqueue_method("clear")
        bl.enqueue_method('set_render_params', file_format="JPEG2000")
        bl.send_model()
        bl.enqueue_method('link_objects')
        bl.enqueue_method('show_full_scene')
        bl.enqueue_method('color_by_unique_materials')
        bl.run_method('orbit_camera_around_model')
        # Wait till prev tasks and rendering is finished
        bl.run_method('render_animation',
                      destination_path="R:/neuroml-db/www/NeuroMLmodels/" + self.get_model_nml_id() + "/morphology/")
        self.make_gif_from_frames()

    def save_morphometrics(self, h):
        swc = self.save_to_SWC(h)
        self.save_LMeasure_metrics(swc)

    def rotate_cell_along_PCA_axes(self, h):
        sections = [s for s in h.allsec()]

        # Using the first and last coords of sections
        coords = [[h.x3d(0, sec=s),
                   h.y3d(0, sec=s),
                   h.z3d(0, sec=s)] for s in sections] \
                 + \
                 [[h.x3d(h.n3d(sec=s) - 1, sec=s),
                   h.y3d(h.n3d(sec=s) - 1, sec=s),
                   h.z3d(h.n3d(sec=s) - 1, sec=s)] for s in sections]

        coords = np.array(coords)

        # Get the PCA components
        pca = PCA()
        pca.fit(coords)

        # Rotate each section point to be along the PCA axes
        for sec in sections:
            for i in range(int(h.n3d(sec=sec))):
                transformed = pca.transform([[h.x3d(i, sec=sec), h.y3d(i, sec=sec), h.z3d(i, sec=sec)]])

                x = transformed[0][2]
                y = transformed[0][1]
                z = transformed[0][0]
                diam = h.diam3d(i, sec=sec)

                h.pt3dchange(i, x, y, z, diam, sec=sec)

    def save_cell_model_responses(self, model_dir, protocols):
        NEURON_folder = self.cell_model_to_neuron(model_dir)

        assessor = CellModel(path=NEURON_folder)

        id = assessor.get_model_nml_id()

        try:
            assessor.get_cell_model_responses(protocols)
            return
            self.update_model_simulation_status(id, status="CURRENT")

        except:
            print("Encountered an error. Saving progress...")
            self.update_model_simulation_status(id, status="ERROR")

            raise

    def get_cell_model_responses(self, protocols):
        self.setTolerances()

        steady_state_delay = 1000  # 1000

        self.server.connect()
        #self.server.close()
        return

        try:
            id = self.get_model_nml_id()

            print("Removing existing model waveforms: " + str(protocols))
            Model_Waveforms.delete().where(
                (Model_Waveforms.Model == id) & (Model_Waveforms.Protocol.in_(protocols))).execute()

            cell_props = Cells.get(Cells.Model_ID == id)


            # Reach steady state and save model state
            if "STEADY_STATE" in protocols:
                result = self.getRestingV(save_resting_state=True, run_time=steady_state_delay)
                self.save_tvi_plot(label="STEADY STATE", tvi_dict=result)
                self.save_vi_waveforms(protocol="STEADY_STATE", tvi_dict=result)

            # From steady state, run ramp injection
            if "RAMP" in protocols:
                result = self.get_ramp_response(ramp_delay=steady_state_delay,
                                                ramp_max_duration=5 * 1000,
                                                ramp_increase_rate_per_second=cell_props.Rheobase_High,
                                                stop_after_n_spikes_found=10,
                                                restore_state=True)

                self.save_tvi_plot(label="RAMP", tvi_dict=result)
                self.save_vi_waveforms(protocol="RAMP", tvi_dict=result)

            # Short square is a brief, threshold current pulse after steady state
            if "SHORT_SQUARE" in protocols:
                self.save_square_current_set(protocol="SHORT_SQUARE",
                                             square_low=cell_props.Threshold_Current_Low,
                                             square_high=cell_props.Threshold_Current_High,
                                             square_steps=2,
                                             delay=steady_state_delay,
                                             duration=3)

            if "SQUARE" in protocols:
                self.save_square_current_set(protocol="SQUARE",
                                             square_low=-cell_props.Rheobase_High * 0.5,  # Note the "-"
                                             square_high=cell_props.Rheobase_High * 1.5,
                                             square_steps=11,
                                             delay=steady_state_delay,
                                             duration=1000)

            # Long square is a 2s current pulse after steady state
            if "LONG_SQUARE" in protocols:
                self.save_square_current_set(protocol="LONG_SQUARE",
                                             square_low=cell_props.Rheobase_High,
                                             square_high=cell_props.Rheobase_High * 1.5,
                                             square_steps=3,
                                             delay=steady_state_delay,
                                             duration=2000)

            if "SHORT_SQUARE_HOLD" in protocols:
                def get_current_ti():
                    ramp_t = [
                        0,
                        steady_state_delay,
                        steady_state_delay,
                        steady_state_delay + 3.0,
                        steady_state_delay + 3.0,
                        steady_state_delay + 250
                    ]
                    ramp_i = [
                        cell_props.Bias_Current,
                        cell_props.Bias_Current,
                        -cell_props.Bias_Current + cell_props.Threshold_Current_High,
                        -cell_props.Bias_Current + cell_props.Threshold_Current_High,
                        cell_props.Bias_Current,
                        cell_props.Bias_Current
                    ]

                    return ramp_t, ramp_i

                self.save_arb_current(protocol="SHORT_SQUARE_HOLD",
                                      delay=steady_state_delay,
                                      duration=250,
                                      get_current_ti=get_current_ti,
                                      restore_state=False)  # Holding v, not resting


            if "SHORT_SQUARE_TRIPPLE" in protocols:
                self.save_square_tuple_set(delay=steady_state_delay,
                                           threshold_current=cell_props.Threshold_Current_High
                                           )

            # Subthreshold pulses to measure capacitance
            if "SQUARE_SUBTHRESHOLD" in protocols:
                self.save_square_current_set(protocol="SQUARE_SUBTHRESHOLD",
                                             square_low=-cell_props.Threshold_Current_Low,
                                             square_high=cell_props.Threshold_Current_Low,
                                             square_steps=2,
                                             delay=steady_state_delay,
                                             duration=0.5)

            if "NOISE1" in protocols:
                self.save_noise_response_set(protocol="NOISE",
                                             meta_protocol="SEED1",
                                             delay=steady_state_delay,
                                             duration=3000,
                                             post_delay=250,
                                             rheobase=cell_props.Rheobase_High,
                                             multiples=[0.75, 1.0, 1.25],
                                             noise_pickle_file="noise1.pickle",
                                             restore_state=True)

            if "NOISE2" in protocols:
                self.save_noise_response_set(protocol="NOISE",
                                             meta_protocol="SEED2",
                                             delay=steady_state_delay,
                                             duration=3000,
                                             post_delay=250,
                                             rheobase=cell_props.Rheobase_High,
                                             multiples=[0.75, 1.0, 1.25],
                                             noise_pickle_file="noise2.pickle",
                                             restore_state=True)

            if "NOISE_RAMP" in protocols:
                self.save_noise_response_set(protocol="NOISE_RAMP",
                                             delay=steady_state_delay,
                                             duration=32000,
                                             post_delay=250,
                                             rheobase=cell_props.Rheobase_High,
                                             multiples=[1.0],
                                             noise_pickle_file="noisyRamp.pickle",
                                             restore_state=True)

        finally:
            self.cleanup_waveforms()

    def save_square_tuple_set(self, delay, threshold_current,
                              intervals=[7, 11, 15, 19, 23, 27, 31, 35], stim_width=3, tuples=3):

        # Create a short square triple waveform
        def get_current_ti(interval):
            ramp_ti = [(0, 0)]

            for ti in range(tuples):
                ramp_ti.append((delay + interval * ti,              0))
                ramp_ti.append((delay + interval * ti,              threshold_current))
                ramp_ti.append((delay + interval * ti + stim_width, threshold_current))
                ramp_ti.append((delay + interval * ti + stim_width, 0))

            ramp_ti.append((delay + interval * tuples + 100, 0))

            # Split the tuple list into t and i lists
            return zip(*ramp_ti)

        for interval in intervals:
            freq = round(1000.0 / interval)
            self.save_arb_current(protocol="SHORT_SQUARE_TRIPPLE",
                                  label=str(freq) + " Hz",
                                  delay=delay,
                                  duration=interval * tuples + 100,
                                  get_current_ti=lambda: get_current_ti(interval),
                                  restore_state=True)

    def save_square_current_set(self, protocol, square_low, square_high, square_steps, delay, duration):

        # Create current amplitude set
        amps = np.linspace(square_low, square_high, num=square_steps).tolist()

        # Run each injection as a separate simulation, resuming from steady state
        for amp in amps:
            result = self.get_square_response(delay=delay,
                                              duration=duration,
                                              post_delay=250,
                                              amp=amp,
                                              restore_state=True)

            self.save_tvi_plot(label=protocol, case=self.short_string(amp) + " nA", tvi_dict=result)

            self.save_vi_waveforms(protocol=protocol,
                                   label=self.short_string(amp) + " nA",
                                   tvi_dict=result)

    def get_square_response(self,
                            delay,
                            duration,
                            post_delay,
                            amp,
                            restore_state=False):

        def square_protocol(time_flag):
            print('Starting SQUARE PROTOCOL...' + str(amp))
            # import pydevd
            # pydevd.settrace('192.168.0.34', port=4200, suspend=False)

            self.time_flag = time_flag
            h = self.build_model()
            print('Cell model built, starting current injection...')

            # Set the sqauare current injector
            self.current.dur = duration
            self.current.delay = delay
            self.current.amp = amp

            with RunTimer() as timer:
                if restore_state:
                    self.restore_state()
                    t, v = self.runFor(duration + post_delay)
                else:
                    h.stdinit()
                    t, v = self.runFor(delay + duration + post_delay)

            result = {
                "t": t.tolist(),
                "v": v.tolist(),
                "i": self.ic_i_collector.get_values_list(),
                "run_time": timer.get_run_time()
            }

            return result

        runner = NeuronRunner(square_protocol)
        # runner.DONTKILL = True
        result = runner.run()
        return result

    def get_ramp_response(self,
                          ramp_delay,
                          ramp_max_duration,
                          ramp_increase_rate_per_second,
                          stop_after_n_spikes_found,
                          restore_state=False):

        def test_condition(t, v):
            num_spikes = self.getSpikeCount(v)

            if num_spikes >= stop_after_n_spikes_found:
                print("Got " + str(num_spikes) + " spikes at " + str(t[-1]) + " ms. Stopping ramp current injection.")
                return True

            return False

        def get_current_ti():
            ramp_i = [0, 0, ramp_max_duration / 1000.0 * ramp_increase_rate_per_second, 0]
            ramp_t = [0, ramp_delay, ramp_delay + ramp_max_duration, ramp_delay + ramp_max_duration]
            return ramp_t, ramp_i

        return self.get_arb_current_response(delay=ramp_delay,
                                             duration=ramp_max_duration,
                                             get_current_ti=get_current_ti,
                                             test_condition=test_condition,
                                             restore_state=restore_state)

    def save_noise_response_set(self,
                                protocol,
                                delay,
                                duration,
                                post_delay,
                                rheobase,
                                noise_pickle_file,
                                multiples,
                                meta_protocol=None,
                                restore_state=False):

        # Cache the files - they're slow to load
        if noise_pickle_file not in self.pickle_file_cache:
            with open(os.path.join("..", "..", noise_pickle_file), "r") as f:
                self.pickle_file_cache[noise_pickle_file] = cPickle.load(f)

        def get_current_ti():
            noise = self.pickle_file_cache[noise_pickle_file]

            ramp_t = [0, delay] + (np.array(noise["t"]) + delay).tolist() + [delay + duration,
                                                                             delay + duration + post_delay]
            ramp_i = [0, 0] + (np.array(noise["i"]) * rheobase * multiple).tolist() + [0, 0]

            return ramp_t, ramp_i

        for multiple in multiples:
            result = self.get_arb_current_response(delay=delay,
                                                   duration=duration,
                                                   post_delay=post_delay,
                                                   get_current_ti=get_current_ti,
                                                   restore_state=restore_state)

            multiple_str = str(multiple) + "xRB"

            self.save_tvi_plot(label=protocol,
                               case=(meta_protocol if meta_protocol is not None else "") + " " + multiple_str,
                               tvi_dict=result)

            self.save_vi_waveforms(protocol=protocol,
                                   label=multiple_str,
                                   meta_protocol=meta_protocol,
                                   tvi_dict=result)

        # Clear the cache for this file
        self.pickle_file_cache.pop(noise_pickle_file)

    def save_arb_current(self,
                         protocol,
                         delay,
                         duration,
                         get_current_ti,
                         meta_protocol=None,
                         label=None,
                         restore_state=False):

        result = self.get_arb_current_response(delay=delay,
                                               duration=duration,
                                               get_current_ti=get_current_ti,
                                               restore_state=restore_state)

        self.save_tvi_plot(label=protocol,
                           case=(meta_protocol if meta_protocol is not None else "") + " " + (label if label is not None else ""),
                           tvi_dict=result)

        self.save_vi_waveforms(protocol=protocol,
                               label=label,
                               tvi_dict=result)

    def get_arb_current_response(self,
                                 delay,
                                 duration,
                                 get_current_ti,
                                 post_delay=0,
                                 test_condition=None,
                                 restore_state=False):

        def arb_current_protocol(flag):

            self.time_flag = flag
            h = self.build_model()

            # Set up IClamp for arbitrary current
            self.current.dur = 1e9
            self.current.delay = 0

            # Create ramp waveform
            ramp_t, ramp_i = get_current_ti()

            rv = h.Vector(ramp_i)
            tv = h.Vector(ramp_t)

            # Play ramp waveform into the IClamp (last param is continuous=True)
            rv.play(self.current._ref_amp, tv, 1)

            with RunTimer() as timer:
                if restore_state:
                    self.restore_state(keep_events=True)  # Keep events ensures .play() works
                    t, v = self.runFor(duration + post_delay, test_condition)
                else:
                    h.stdinit()
                    t, v = self.runFor(delay + duration + post_delay, test_condition)

            result = {
                "t": t.tolist(),
                "v": v.tolist(),
                "i": self.ic_i_collector.get_values_list(),
                "run_time": timer.get_run_time()
            }

            return result

        runner = NeuronRunner(arb_current_protocol)
        # runner.DONTKILL = True
        result = runner.run()
        return result

    def load_model(self):
        # Load cell hoc and get soma
        os.chdir(self.temp_model_path)
        print("Loading NEURON...")
        from neuron import h, gui
        print("DONE")

        # Create the cell
        print('Determining cell model type...')
        if self.is_abstract_cell():
            print('Building abstract cell...')
            self.test_cell = self.get_abstract_cell(h)
        elif len(self.get_hoc_files()) > 0:
            print('Building cell with compartment(s)...')
            self.test_cell = self.get_cell_with_morphology(h)
        else:
            raise Exception("Could not find cell .hoc or abstract cell .mod file in: " + self.temp_model_path)

        # Get the root sections and try to find the soma
        self.roots = h.SectionList()
        self.roots.allroots()
        self.roots = [s for s in self.roots]
        self.somas = [sec for sec in self.roots if "soma" in sec.name().lower()]
        if len(self.somas) == 1:
            self.soma = self.somas[0]
        elif len(self.somas) == 0 and len(self.roots) == 1:
            self.soma = self.roots[0]
        else:
            raise Exception("Problem finding the soma section")

        return h

    def build_model(self, restore_tolerances=True):
        print("Loading cell: " + self.temp_model_path)
        h = self.load_model()

        # set up stim
        print('Setting up vi clamps...')
        self.current = h.IClamp(self.soma(0.5))
        self.current.delay = 50.0
        self.current.amp = 0
        self.current.dur = 100.0

        self.vc = h.SEClamp(self.soma(0.5))
        self.vc.dur1 = 0


        # Set up variable collectors
        print('Setting up tvi collectors...')
        self.t_collector = Collector(self.config.collection_period_ms, lambda: h.t)
        self.v_collector = Collector(self.config.collection_period_ms, lambda: self.soma(0.5).v)
        self.vc_i_collector = Collector(self.config.collection_period_ms, lambda: self.vc.i)
        self.ic_i_collector = Collector(self.config.collection_period_ms, lambda: self.current.i)

        # h.nrncontrolmenu()
        self.nState = h.SaveState()
        self.sim_init()
        self.set_abs_tolerance(self.config.abs_tolerance)

        if not self.is_abstract_cell() and restore_tolerances:
            print('Restoring cvode tolerances...')
            self.restore_tolerances()

        return h

    def is_abstract_cell(self):
        return len(self.get_hoc_files()) == 0 and len(self.get_mod_files()) == 1

    def get_abstract_cell(self, h):
        cell_mod_file = self.get_mod_files()[0]
        cell_mod_name = cell_mod_file.replace(".mod", "")

        soma = h.Section()
        soma.L = 10
        soma.diam = 10
        soma.cm = 318.31927  # Magic number, see: https://github.com/NeuroML/org.neuroml.export/issues/60

        mod = getattr(h, cell_mod_name)(0.5, sec=soma)

        self.abstract_soma = soma
        self.abstract_mod = mod

        return soma

    def get_cell_with_morphology(self, h):
        cell_hoc_file = self.get_hoc_files()[0]
        cell_template = cell_hoc_file.replace(".hoc", "")
        h.load_file(cell_hoc_file)
        cell = getattr(h, cell_template)()
        return cell

    def sim_init(self):
        from neuron import h
        h.stdinit()
        self.clear_tvi()
        h.tstop = 1000
        self.current.amp = 0
        self.vc.dur1 = 0

    def clear_tvi(self):
        self.t_collector.clear()
        self.v_collector.clear()
        self.vc_i_collector.clear()
        self.ic_i_collector.clear()

    def setCurrent(self, amp, delay, dur):
        self.current.delay = delay
        self.current.amp = amp
        self.current.dur = dur

    def getStabilityRange(self, testLow=-10, testHigh=15):

        print("Searching for UPPER boundary...")
        current_range, found_once = self.find_border(
            lowerLevel=0,
            upperLevel=testHigh,
            current_delay=500,
            current_duration=3,
            run_for_after_delay=10,
            test_condition=lambda t, v: False,
            on_unstable=lambda: True,
            max_iterations=7,
            fig_file="stabilityHigh.png",
            skip_current_delay=False
        )

        high_edge = min(current_range)

        print("Searching for LOWER boundary...")
        current_range, found_once = self.find_border(
            lowerLevel=testLow,
            upperLevel=0,
            current_delay=500,
            current_duration=3,
            run_for_after_delay=10,
            test_condition=lambda t, v: True,
            on_unstable=lambda: False,
            max_iterations=7,
            fig_file="stabilityLow.png",
            skip_current_delay=True
        )

        low_edge = max(current_range)

        return low_edge, high_edge

    def getThreshold(self, minCurrent, maxI):

        def test_condition(t, v):
            num_spikes = self.getSpikeCount(v)
            print("Got " + str(num_spikes) + " spikes")
            return num_spikes > 0

        current_range, found_once = self.find_border(
            lowerLevel=minCurrent,
            upperLevel=maxI,
            current_delay=500,
            current_duration=3,
            run_for_after_delay=50,
            test_condition=test_condition,
            max_iterations=10,
            fig_file="threshold.png",
            skip_current_delay=True
        )

        if not found_once:
            raise Exception("Did not find threshold with currents " + str(current_range))

        return current_range

    def restore_state(self, state_file='state.bin', keep_events=False):
        from neuron import h
        ns = h.SaveState()
        sf = h.File(state_file)
        ns.fread(sf)

        # Workaround, see: https://www.neuron.yale.edu/phpBB/viewtopic.php?f=2&t=3845&p=16542#p16542
        if keep_events:
            ns.restore(1)
            self.t_collector.stim.start = h.t
            self.v_collector.stim.start = h.t
            self.vc_i_collector.stim.start = h.t
            self.ic_i_collector.stim.start = h.t

        h.stdinit()

        if keep_events:
            ns.restore(1)
        else:
            ns.restore()

        h.cvode_active(1)

    def find_border(self, lowerLevel, upperLevel,
                    current_delay, current_duration,
                    run_for_after_delay, test_condition, max_iterations, fig_file,
                    skip_current_delay=False, on_unstable=None, test_early=False):

        if not skip_current_delay:
            def reach_resting_state(time_flag):
                self.time_flag = time_flag
                self.build_model()

                print("Simulating till current onset...")
                self.sim_init()
                self.setCurrent(amp=0, delay=current_delay, dur=current_duration)
                self.runFor(current_delay)
                self.save_state()
                print("Resting state reached. State saved.")

            runner = NeuronRunner(reach_resting_state)
            result = runner.run()

        iterate = True
        iteration = 0
        found_once = False

        upperLevel_start = upperLevel
        lowerLevel_start = lowerLevel

        while iterate:
            if iteration == 0:
                currentAmp = upperLevel
            elif iteration == 1:
                currentAmp = lowerLevel
            else:
                currentAmp = (lowerLevel + upperLevel) / 2.0

            def simulate_iteration(time_flag):
                self.time_flag = time_flag
                h = self.build_model()
                self.restore_state()

                self.setCurrent(amp=currentAmp, delay=current_delay, dur=current_duration)
                print("Trying " + str(currentAmp) + " nA...")

                if not test_early:
                    t, v = self.runFor(run_for_after_delay)
                    found = test_condition(t, v)
                else:
                    t, v = self.runFor(run_for_after_delay, test_condition)
                    found = test_condition(t, v)

                plt.plot(t, v, label=str(round(currentAmp, 4)) + ", Found: " + str(found))
                plt.legend(loc='upper left')
                plt.savefig(str(iteration) + " " + fig_file)

                print("FOUND" if found else "NOT FOUND")

                return found

            runner = NeuronRunner(simulate_iteration)

            try:
                found = runner.run()

            except NumericalInstabilityException:
                if on_unstable is not None:
                    found = on_unstable()
                else:
                    raise

            if found:
                upperLevel = currentAmp
                found_once = True
            else:
                lowerLevel = currentAmp

            iteration = iteration + 1

            if iteration >= max_iterations or lowerLevel == upperLevel_start or upperLevel == lowerLevel_start:
                iterate = False

        current_range = (lowerLevel, upperLevel)

        return current_range, found_once

    def getRheobase(self, minCurrent, maxI):

        def test_condition(t, v):
            return self.getSpikeCount(v) > 0

        current_range, found_once = self.find_border(
            lowerLevel=minCurrent,
            upperLevel=maxI,
            current_delay=500,
            current_duration=500,
            run_for_after_delay=500,
            test_condition=test_condition,
            test_early=True,
            max_iterations=10,
            fig_file="rheobase.png",
            skip_current_delay=True
        )

        if not found_once:
            raise Exception("Did not find rheobase with currents " + str(current_range))

        return current_range

    def getBiasCurrent(self, targetV):
        def bias_protocol(flag):
            self.time_flag = flag
            self.build_model()
            self.sim_init()

            self.vc.amp1 = targetV
            self.vc.dur1 = 10000

            t, v = self.runFor(500)

            i = self.vc_i_collector.get_values_np()
            crossings = self.getSpikeCount(i)

            if crossings > 2:
                print(
                    "No bias current exists for steady state at " + str(
                        targetV) + " mV membrane potential (only spikes)")
                result = None
            else:
                result = self.vc.i

            self.vc.dur1 = 0

            plt.clf()
            plt.plot(t[np.where(t > 50)], i[np.where(t > 50)],
                     label="Bias Current for " + str(targetV) + "mV = " + str(result))
            plt.legend(loc='upper left')
            plt.savefig("biasCurrent" + str(targetV) + ".png")

            return result

        runner = NeuronRunner(bias_protocol)
        return runner.run()

    def getRestingV(self, run_time=1000, save_resting_state=False):
        def rest_protocol(flag):
            self.time_flag = flag
            self.build_model()
            self.sim_init()

            with RunTimer() as timer:
                t, v = self.runFor(run_time)

            result = {
                "t": t.tolist(),
                "v": v.tolist(),
                "i": self.ic_i_collector.get_values_list(),
                "run_time": timer.get_run_time()
            }

            crossings = self.getSpikeCount(v)

            if crossings > 1:
                print("No rest - cell produces multiple spikes without stimulation.")
                result["rest"] = None
            else:
                result["rest"] = v[-1]

            if save_resting_state:
                self.save_state()

            return result

        runner = NeuronRunner(rest_protocol)
        result = runner.run()
        return result

    def setTolerances(self, tstop=100):

        print("Running tolerance tool...")
        if self.is_abstract_cell():
            print("Cell is abstract, skipping tolerance tool")
            return

        super(CellModel, self).setTolerances(tstop)

    def save_cell_record(self):
        cell = self.cell_record
        db = self.server.connect()

        # Save or update
        try:
            Cells.get_by_id(cell.Model_ID)
            force_insert = False
        except:
            force_insert = True

        print("Saving record for cell " + cell.Model_ID + " ...")

        # Insert on first save
        cell.save(force_insert=force_insert)

        # Disconnect SSH
        server.stop()

        print("SAVED")

    def cell_model_to_neuron(self, path):

        print("Converting cell NML model to NEURON...")

        # Get the parent folder of the model
        if self.model_manager.is_nmldb_id(path):
            model_dir_name = self.model_manager.get_model_directory(path)

            dir_nml_files = [f for f in os.listdir(model_dir_name) if self.model_manager.is_nml2_file(f)]

            if len(dir_nml_files) != 1:
                raise Exception("There should be exactly one NML file in the model directory: " + str(dir_nml_files))

            cell_file_name = dir_nml_files[0]

        else:
            model_dir_name = os.path.dirname(os.path.abspath(path))
            cell_file_name = os.path.basename(path)

        nml_db_id = model_dir_name.split("/")[-1]

        if not self.model_manager.is_nmldb_id(nml_db_id):
            raise Exception("The name of the parent folder of the model should be a NeuroML-DB id: " + nml_db_id)

        # Templates
        include_file_template = '	<Include file="[File]"/>'

        # Find the NML id of the cell
        with open(os.path.join(model_dir_name, cell_file_name)) as f:
            nml = f.read()
            cell_id = re.search('<.*cell.*?id.*?=.*?"(.*?)"', nml, re.IGNORECASE).groups(1)[0]
            cell_files = set(re.compile('<include.*?href.*?=.*?"(.*?)"').findall(nml))

        # Get all cell channel files from the model API
        children_in_db = self.get_cell_children(nml_db_id)

        db_files = set(c["File_Name"] for c in children_in_db)

        if len(db_files - cell_files) > 0:
            print("Misbehaving children: The following files are in DATABASE but MISSING IN CELL: " + nml_db_id)
            print(
            [(c["Model_ID"], c["File_Name"]) for c in children_in_db if c["File_Name"] in (db_files - cell_files)])
            raise Exception("Database has extra children for the cell")

        if len(cell_files - db_files) > 0:
            print("Misbehaving children: The following files are in CELL but MISSING IN DATABASE: " + nml_db_id)
            print(cell_files - db_files)
            raise Exception("Database is missing children for the cell")

        # Set the location where the NEURON files will be stored
        temp_model_folder = os.path.join(os.path.abspath(self.config.temp_models_folder), nml_db_id)

        # Clear it if exists or create it
        if os.path.exists(temp_model_folder):
            shutil.rmtree(temp_model_folder)

        os.makedirs(temp_model_folder)

        # Copy the model to the temp folder
        shutil.copy2(os.path.join(model_dir_name, cell_file_name), temp_model_folder)

        # Create file includes for each channel
        child_includes = ''

        for c in children_in_db:
            id = c["Model_ID"]
            file = c["File_Name"]
            child_path = "../" + id + "/" + file

            # Copy the children to the NEURON temp files folder
            shutil.copy2(os.path.join(model_dir_name, child_path), temp_model_folder)
            child_includes = child_includes + include_file_template.replace("[File]", file) + "\n"

        replacements = {
            "[CellInclude]": include_file_template.replace("[File]", cell_file_name),
            "[ChannelIncludes]": child_includes,
            "[Cell_ID]": cell_id
        }

        with open("templates/LEMS_single_cell_template.xml") as t:
            template = t.read()

        for r in replacements:
            template = template.replace(r, str(replacements[r]))

        out_file = temp_model_folder + "/LEMS_" + cell_file_name

        with open(out_file, "w") as outF:
            outF.write(template)

        # Convert LEMS to NEURON with JNML
        os.chdir(temp_model_folder)

        self.run_command("jnml LEMS_" + cell_file_name + " -neuron")

        # Compile mod files
        self.run_command("nrnivmodl")

        self.temp_model_path = temp_model_folder

        return temp_model_folder

    def get_cell_children(self, modelID):
        url = "http://" + self.config.webserver + "/api/model?id=" + modelID
        response = urllib.urlopen(url)
        model = json.loads(response.read())
        channels = [m for m in model["children"] if m["Type"] == "Channel" or m["Type"] == "Concentration"]
        return channels

    def get_tv(self):
        from neuron import h
        v_np = self.v_collector.get_values_np()
        t_np = self.t_collector.get_values_np()

        if np.isnan(v_np).any():
            raise NumericalInstabilityException(
                "Simulation is numericaly unstable with " + str(h.steps_per_ms) + " steps per ms")

        return (t_np, v_np)
