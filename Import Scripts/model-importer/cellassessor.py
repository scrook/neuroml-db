# Obtains the cell threshold, rheobase, resting v, and bias currents for
# steady state v of a cell defined in a hoc file in the given directory.
# Usage: python getCellProperties /path/To/dir/with/.hoc

import os, string

import numpy as np
from matplotlib import pyplot as plt
from playhouse.db_url import connect
from sshtunnel import SSHTunnelForwarder

from collector import Collector
from neuronrunner import NeuronRunner, NumericalInstabilityException
from tables import Cells, Model_Waveforms, Protocols, db_proxy


class CellAssessor:
    def __init__(self, path):
        self.path = path
        self.abs_tolerance = 0.001
        self.collection_period_ms = 0.1

    def get_model_nml_id(self):
        return self.path.split("/")[-1]

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
        self.cell_record.Resting_Voltage = self.getRestingV()
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

    def get_cell_model_responses(self):
        self.setTolerances()

        self.connect_to_db()

        t, v = self.get_ramp_response()
        self.create_or_update_waveform("RAMP", None, None, t, "Voltage", v)



    def create_or_update_waveform(self, protocol, label, meta_protocol, times, variable, values):
        model_id = self.get_model_nml_id()

        waveform = Model_Waveforms.get_or_none((Model_Waveforms.Model == model_id) &
                                               (Model_Waveforms.Protocol == protocol) &
                                               (Model_Waveforms.Meta_Protocol == meta_protocol) &
                                               (Model_Waveforms.Waveform_Label == label))

        if waveform is None:
            waveform = Model_Waveforms()
            waveform.Model = model_id
            waveform.Protocol = protocol
            waveform.Meta_Protocol = meta_protocol
            waveform.Waveform_Label = label

        waveform.Times = string.join([str(v) for v in times], ',')
        waveform.Variable_Name = variable
        waveform.Variable_Values = string.join([str(v) for v in values], ',')

        waveform.save()

    def get_ramp_response(self):
        ramp_delay = 500
        ramp_max_duration = 5000
        ramp_increase_rate_per_second = 25
        stop_after_n_spikes_found = 10

        def test_condition(t, v):
            num_spikes = self.getSpikeCount(v)

            if num_spikes >= stop_after_n_spikes_found:
                print("Got " + str(num_spikes) + " spikes at " + str(t[-1]) + " ms. Stopping ramp current injection.")
                return True

            return False

        def ramp_protocol(flag):
            # import pydevd
            # pydevd.settrace('192.168.0.34', port=4200, suspend=False)

            self.activity_flag = flag
            h = self.build()
            self.sim_init()

            # Set up IClamp for arbitrary current
            self.current.dur = 1e9
            self.current.delay = 0

            # Create ramp waveform
            ramp_i = [0, 0, ramp_max_duration / 1000.0 * ramp_increase_rate_per_second, 0]
            ramp_t = [0, ramp_delay, ramp_delay + ramp_max_duration, ramp_delay + ramp_max_duration]

            rv = h.Vector(ramp_i)
            tv = h.Vector(ramp_t)

            # Play ramp waveform into the IClamp (last param is continuous=True)
            rv.play(self.current._ref_amp, tv, 1)
            h.stdinit()

            t, v = self.runFor(ramp_delay + ramp_max_duration, test_condition)

            result = {"t": t.tolist(), "v": v.tolist()}  # needs a list conversion

            plt.clf()
            plt.plot(t, v, label="Ramp Response")
            plt.legend()
            plt.savefig("rampResponse.png")

            return result

        runner = NeuronRunner(ramp_protocol)
        runner.DONTKILL = True
        result = runner.run()
        return result["t"], result["v"]

    def load_cell(self):
        # Load cell hoc and get soma
        os.chdir(self.path)
        from neuron import h

        # Create the cell
        if self.is_abstract_cell():
            self.test_cell = self.get_abstract_cell(h)
        elif len(self.get_hoc_files()) > 0:
            self.test_cell = self.get_cell_with_morphology(h)
        else:
            raise Exception("Could not find cell .hoc or abstract cell .mod file in: " + self.path)

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

    def build(self, restore_tolerances=True):
        print("Loading cell: " + self.path)
        h = self.load_cell()

        # set up stim
        self.current = h.IClamp(self.soma(0.5))
        self.current.delay = 50.0
        self.current.amp = 0
        self.current.dur = 100.0

        self.vc = h.SEClamp(self.soma(0.5))
        self.vc.dur1 = 0

        # Set up variable collectors
        self.t_collector = Collector(self.collection_period_ms, lambda: h.t)
        self.v_collector = Collector(self.collection_period_ms, lambda: self.soma(0.5).v)
        self.i_collector = Collector(self.collection_period_ms, lambda: self.vc.i)

        # h.nrncontrolmenu()
        self.nState = h.SaveState()
        self.set_abs_tolerance(self.abs_tolerance)
        self.sim_init()

        if not self.is_abstract_cell() and restore_tolerances:
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

    def get_hoc_files(self):
        return [f for f in os.listdir(self.path) if f.endswith(".hoc")]

    def get_mod_files(self):
        return [f for f in os.listdir(self.path) if f.endswith(".mod")]

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
        self.i_collector.clear()

    def set_abs_tolerance(self, abs_tol):
        from neuron import h, gui
        h.steps_per_ms = 10
        h.dt = 1.0 / h.steps_per_ms  # NRN will ignore this using cvode

        h.cvode_active(1)
        h.cvode.condition_order(2)
        h.cvode.atol(abs_tol)

    def runFor(self, time, early_test=None):
        from neuron import h
        h.cvode_active(1)

        self.activity_flag.value = h.t

        h.tstop = h.t + time
        t = h.t
        while t < h.tstop and h.t < h.tstop:
            t += 1.0

            h.continuerun(t)
            self.activity_flag.value = h.t

            if early_test is not None:
                t_np, v_np = self.get_tv()
                if early_test(t_np, v_np):
                    return (t_np, v_np)

        # Get the waveform
        return self.get_tv()

    def get_tv(self):
        from neuron import h
        v_np = self.v_collector.get_np_values()
        t_np = self.t_collector.get_np_values()

        if np.isnan(v_np).any():
            raise NumericalInstabilityException(
                "Simulation is numericaly unstable with " + str(h.steps_per_ms) + " steps per ms")

        return (t_np, v_np)

    def setCurrent(self, amp, delay, dur):
        self.current.delay = delay
        self.current.amp = amp
        self.current.dur = dur

    def crossings_nonzero_pos2neg(self, data):
        pos = data > 0
        return (pos[:-1] & ~pos[1:]).nonzero()[0]

    def getSpikeCount(self, voltage):
        if np.max(voltage) < 0:
            return 0
        else:
            return len(self.crossings_nonzero_pos2neg(voltage))

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

    def save_state(self):
        from neuron import h
        ns = h.SaveState()
        sf = h.File('state.bin')
        ns.save()
        ns.fwrite(sf)

    def restore_state(self):
        from neuron import h
        ns = h.SaveState()
        sf = h.File('state.bin')
        h.stdinit()
        ns.fread(sf)
        ns.restore()
        h.cvode_active(1)

    def find_border(self, lowerLevel, upperLevel,
                    current_delay, current_duration,
                    run_for_after_delay, test_condition, max_iterations, fig_file,
                    skip_current_delay=False, on_unstable=None, test_early=False):

        if not skip_current_delay:
            def reach_resting_state(activity_flag):
                self.activity_flag = activity_flag
                self.build()

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

            def simulate_iteration(activity_flag):
                self.activity_flag = activity_flag
                h = self.build()
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
            self.activity_flag = flag
            self.build()
            self.sim_init()

            self.vc.amp1 = targetV
            self.vc.dur1 = 10000

            t, v = self.runFor(500)

            i = self.i_collector.get_np_values()
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

    def getRestingV(self):
        def rest_protocol(flag):
            self.activity_flag = flag
            self.build()
            self.sim_init()

            t, v = self.runFor(1000)

            crossings = self.getSpikeCount(v)

            if crossings > 1:
                print("No rest - cell produces multiple spikes without stimulation.")
                result = None
            else:
                result = v[-1]

            plt.clf()
            plt.plot(t, v, label="Resting V " + str(result))
            plt.legend()
            plt.savefig("restingV.png")

            return result

        runner = NeuronRunner(rest_protocol)
        result = runner.run()
        return result

    def setTolerances(self, tstop=100):

        print("Running tolerance tool...")
        if self.is_abstract_cell():
            print("Cell is abstract, skipping tolerance tool")
            return

        def run_atol_tool():
            # import pydevd
            # pydevd.settrace('192.168.0.34', port=4200, suspend=False)

            h = self.build(restore_tolerances=False)

            h.NumericalMethodPanel[0].map()
            h.NumericalMethodPanel[0].atoltool()
            h.tstop = tstop

            print("Getting error tolerances...")
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

    def connect_to_db(self):
        pwd = os.environ["NMLDBPWD"]  # This needs to be set to "the password"

        if pwd == '':
            raise Exception("The environment variable 'NMLDBPWD' needs to contain the password to the NML database")

        server = SSHTunnelForwarder(
            ('149.169.30.15', 2200),  # Spike - testing server
            ssh_username='neuromine',
            ssh_password=pwd,
            remote_bind_address=('127.0.0.1', 3306)
        )

        print("Connecting to server...")
        server.start()

        print("Connecting to MySQL database...")
        db = connect('mysql://neuromldb2:' + pwd + '@127.0.0.1:' + str(server.local_bind_port) + '/neuromldb')
        db_proxy.initialize(db)
        return (db, server)

    def save_cell_record(self):
        cell = self.cell_record
        db, server = self.connect_to_db()

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
