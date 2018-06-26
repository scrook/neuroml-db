import shutil
import os
import re
from runtimer import RunTimer
import numpy as np
from matplotlib import pyplot as plt
from nmldbmodel import NMLDB_Model
from tables import Channels
from collector import Collector
from neuronrunner import NeuronRunner, NumericalInstabilityException
from math import pi
from scipy.ndimage.filters import median_filter


class ChannelModel(NMLDB_Model):
    def __init__(self, *args, **kwargs):
        super(ChannelModel, self).__init__(*args, **kwargs)

        self.all_properties.extend([
            'stability_range',
            'ACTIVATION',
            'DEACTIVATION',
            'INACTIVATION'
        ])

        self.server.connect()

        # Fetch channel record
        self.channel_record = Channels.get_or_none(Channels.Model_ID == self.get_model_nml_id())

        if self.channel_record is None:
            raise Exception("No records found in Channels table for model: " + self.get_model_nml_id())

        self.is_passive = self.channel_record.Type.ID == 'pas'

        # Pre-retrieve the resting v of the channel type (the first voltage level of a protocol)
        self.rest_v = float(self.channel_record.Type.Activation_Protocol.Voltages.split(',')[0])

        self.ion = self.channel_record.Type.Species
        self.erev = self.channel_record.Type.Reversal_Potential

        self.ca_levels = self.channel_record.Type.Ca_Levels.split(',') \
            if self.channel_record.Type.Ca_Levels is not None \
            else None

    def save_ACTIVATION(self):
        self.save_channel_protocol(self.channel_record.Type.Activation_Protocol, "ACTIVATION")

    def save_INACTIVATION(self):
        self.save_channel_protocol(self.channel_record.Type.Inactivation_Protocol, "INACTIVATION")

    def save_DEACTIVATION(self):
        self.save_channel_protocol(self.channel_record.Type.Deactivation_Protocol, "DEACTIVATION")

    def save_channel_protocol(self, protocol_record, protocol_name):
        self.remove_protocol_waveforms(protocol_name)

        durations_ss, voltages_ss, durations_stim, voltages_stim = self.get_durations_voltages(protocol_record)

        self.save_vclamp_set(protocol_name,
                             durations_ss, voltages_ss,
                             durations_stim, voltages_stim,
                             protocol_record.Low_Voltage, protocol_record.High_Voltage,
                             step_count=11,
                             ca_concentrations=self.ca_levels)

    def get_durations_voltages(self, protocol):
        times = protocol.Times.split(',')
        voltages = protocol.Voltages.split(',')

        durations = []
        steps = []
        prev_time = None

        for t, time in enumerate(times):
            if prev_time == time:
                continue

            if prev_time is not None:
                duration = float(time) - float(prev_time)
                durations.append(duration)
                steps.append(voltages[t])

            prev_time = time

        durations_ss = []
        voltages_ss = []
        durations_stim = []
        voltages_stim = []

        for v, voltage in enumerate(steps):
            # SS is before the steps begin
            if len(durations_stim) == 0 and voltage != 'LOWHIGH':
                durations_ss.append(durations[v])
                voltages_ss.append(voltage)

            # Stim is after SS
            else:
                durations_stim.append(durations[v])
                voltages_stim.append(voltage)

        return durations_ss, voltages_ss, durations_stim, voltages_stim

    def save_vclamp_set(self, protocol,
                        durations_ss, voltages_ss,
                        durations_stim, voltages_stim,
                        voltage_low, voltage_high,
                        step_count, ca_concentrations=None):

        if ca_concentrations is None:
            ca_concentrations = [None]

        # Run the same protocol at different Ca concentrations
        for ca_conc in ca_concentrations:

            # Reach the desired steady-state
            result_ss = self.get_vclamp_response(durations=durations_ss,
                                                 voltages=voltages_ss,
                                                 ca_conc=ca_conc,
                                                 save_state=True)

            # Create current amplitude set
            steps = np.linspace(
                max(voltage_low, self.channel_record.Stability_Range_Low),
                min(voltage_high, self.channel_record.Stability_Range_High),
                num=step_count) \
                .tolist()

            # Run each vclamp as a separate simulation, resuming from desired steady state
            for step_v in steps:
                voltages = [step_v if v == 'LOWHIGH' else v for v in voltages_stim]

                result_stim = self.get_vclamp_response(durations=durations_stim,
                                                       voltages=voltages,
                                                       ca_conc=ca_conc,
                                                       restore_state=True)

                result = self.concat_tvig_dicts(result_ss, result_stim)

                self.save_tvig_plot(label=protocol, case=str(step_v) + " mV @ " + str(ca_conc) + " mM",
                                    tvig_dict=result)

                meta_protocol = None if ca_conc is None else "Ca2+ " + str(ca_conc) + " mM"

                self.save_tvig_waveforms(protocol=protocol,
                                         label=str(step_v) + " mV",
                                         tvig_dict=result,
                                         meta_protocol=meta_protocol)

    def concat_tvig_dicts(self, dict1, dict2):
        result = {
            "t": dict1['t'] + dict2['t'],
            "v": dict1['v'] + dict2['v'],
            "g": dict1['g'] + dict2['g'],
            "i": dict1['i'] + dict2['i'],
            "run_time": dict1['run_time'] + dict2['run_time'],
            "steps": dict1['steps'] + dict2['steps'],
            "cvode_active": dict1['cvode_active'],
            "dt_or_atol": dict1['dt_or_atol'],
        }

        return result

    def save_tvig_plot(self, label, tvig_dict, case=""):
        plt.clf()

        plt.figure(1)
        plt.subplot(311)
        plt.plot(tvig_dict["t"], tvig_dict["v"], label="Voltage - " + label + (" @ " + case if case != "" else ""))
        plt.ylim(-160, 80)
        plt.legend()

        plt.subplot(312)
        plt.plot(tvig_dict["t"], tvig_dict["g"], label="Conductance - " + label + (" @ " + case if case != "" else ""))
        plt.legend()

        plt.subplot(313)
        plt.plot(tvig_dict["t"], tvig_dict["i"], label="Current - " + label + (" @ " + case if case != "" else ""))
        plt.legend()
        plt.savefig(label + ("(" + case + ")" if case != "" else "") + ".png")

    def save_tvig_waveforms(self, protocol, label, tvig_dict, meta_protocol):
        self.server.connect()

        with self.server.db.atomic() as transaction:
            self.create_or_update_waveform(protocol, label, meta_protocol, tvig_dict["t"], "Voltage", tvig_dict["v"],
                                           "mV",
                                           tvig_dict["run_time"], None, tvig_dict["dt_or_atol"],
                                           tvig_dict["cvode_active"], tvig_dict["steps"])
            self.create_or_update_waveform(protocol, label, meta_protocol, tvig_dict["t"], "Conductance",
                                           tvig_dict["g"], "pS",
                                           tvig_dict["run_time"], None, tvig_dict["dt_or_atol"],
                                           tvig_dict["cvode_active"], tvig_dict["steps"])
            self.create_or_update_waveform(protocol, label, meta_protocol, tvig_dict["t"], "Current", tvig_dict["i"],
                                           "pA",
                                           tvig_dict["run_time"], None, tvig_dict["dt_or_atol"],
                                           tvig_dict["cvode_active"], tvig_dict["steps"])

    def get_vclamp_response(self,
                            durations,
                            voltages,
                            ca_conc,
                            restore_state=False, save_state=False):

        def vclamp_protocol(time_flag):
            self.time_flag = time_flag
            h = self.build_model()

            if ca_conc is not None:
                self.soma.cai = float(ca_conc)

            with RunTimer() as timer:
                if restore_state:
                    self.restore_state()
                else:
                    h.stdinit()

                for s in range(len(voltages)):
                    self.vc.dur1 = 1e9
                    self.vc.amp1 = float(voltages[s])

                    self.runFor(durations[s])

            if save_state:
                self.save_state()

            # Filter out transient spikelets seen when using CVODE
            from scipy.ndimage.filters import median_filter

            result = {
                "t": self.t_collector.get_values_list(),
                "v": self.v_collector.get_values_list(),
                "g": median_filter(self.g_collector.get_values_np(), 3).tolist(),
                "i": median_filter(self.i_collector.get_values_np(), 3).tolist(),
                "run_time": timer.get_run_time(),
                "steps": int(self.tvec.size()),
                "cvode_active": int(self.config.cvode_active),
                "dt_or_atol": self.config.abs_tolerance if self.config.cvode_active else self.config.dt
            }

            return result

        runner = NeuronRunner(vclamp_protocol)
        runner.DONTKILL = True
        result = runner.run()
        return result

    def save_stability_range(self):
        print("Getting stability range...")

        self.channel_record.Stability_Range_Low, self.channel_record.Stability_Range_High = self.get_stability_range()

        assert self.channel_record.Stability_Range_Low < self.channel_record.Stability_Range_High

        self.channel_record.save()

    def get_stability_range(self, testLow=-150, testHigh=70):

        print("Searching for UPPER boundary...")
        current_range, found_once = self.find_border(
            rest_v=self.rest_v,
            lower_level=self.rest_v,
            upper_level=testHigh,
            delay=500,
            stim_duration=3,
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
            rest_v=self.rest_v,
            lower_level=testLow,
            upper_level=self.rest_v,
            delay=500,
            stim_duration=3,
            run_for_after_delay=10,
            test_condition=lambda t, v: True,
            on_unstable=lambda: False,
            max_iterations=7,
            fig_file="stabilityLow.png",
            skip_current_delay=True
        )

        low_edge = max(current_range)

        return low_edge, high_edge

    def find_border(self, rest_v, lower_level, upper_level,
                    delay, stim_duration,
                    run_for_after_delay, test_condition, max_iterations, fig_file,
                    skip_current_delay=False, on_unstable=None, test_early=False):

        state_file = 'border_state.bin'

        if not skip_current_delay:
            def reach_resting_state(time_flag):
                self.time_flag = time_flag
                self.build_model()

                print("Simulating till current onset...")
                self.sim_init()
                self.set_voltages(voltages=(rest_v, 0, 0), durations=(delay, 0, 0))
                self.runFor(delay)
                self.save_state(state_file=state_file)
                print("Resting state reached. State saved.")

            runner = NeuronRunner(reach_resting_state)
            result = runner.run()

        iterate = True
        iteration = 0
        found_once = False

        upperLevel_start = upper_level
        lowerLevel_start = lower_level

        while iterate:
            if iteration == 0:
                stim = upper_level
            elif iteration == 1:
                stim = lower_level
            else:
                stim = (lower_level + upper_level) / 2.0

            def simulate_iteration(time_flag):
                self.time_flag = time_flag
                h = self.build_model()
                self.set_voltages(voltages=(0, stim, 0), durations=(delay, stim_duration, 0))

                self.restore_state(state_file=state_file)
                print("Trying " + str(stim) + " ...")

                if not test_early:
                    t, v = self.runFor(run_for_after_delay)
                    found = test_condition(t, v)
                else:
                    t, v = self.runFor(run_for_after_delay, test_condition)
                    found = test_condition(t, v)

                plt.plot(t, v, label=str(round(stim, 4)) + ", Found: " + str(found))
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
                upper_level = stim
                found_once = True
            else:
                lower_level = stim

            iteration = iteration + 1

            if iteration >= max_iterations or lower_level == upperLevel_start or upper_level == lowerLevel_start:
                iterate = False

        stim_range = (lower_level, upper_level)

        return stim_range, found_once

    def set_voltages(self, voltages, durations=(0, 0, 0)):
        self.vc.dur1, self.vc.dur2, self.vc.dur3 = durations
        self.vc.amp1, self.vc.amp2, self.vc.amp3 = voltages

    def sim_init(self):
        from neuron import h
        h.stdinit()
        h.tstop = 1000
        self.set_voltages((0, 0, 0),
                          (0, 0, 0))

    def load_model(self):
        # Load cell hoc and get soma
        os.chdir(self.temp_model_path)
        print(
            "Loading NEURON... If this step 'freezes', ensure there are no hung NEURON processes with 'pkill -9 nrn*'")
        from neuron import h, gui
        print("DONE")

        h.celsius = self.config.temperature

        # Create a test cell with the channel
        self.mod_name = self.get_mod_name()

        # Passive channels use a different naming scheme
        if self.is_passive:
            self.ion = "_" + self.mod_name

        self.soma = h.Section()
        self.soma.L = 10
        self.soma.diam = 10
        self.soma.cm = 1000.0 / pi

        self.soma.insert(self.mod_name)

        # Set max conductance
        setattr(self.soma, "gmax_" + self.mod_name, 10.0)

        # Set reversal pot
        if hasattr(self.soma, "e" + self.ion):
            setattr(self.soma, "e" + self.ion, self.erev)

        elif hasattr(self.soma, "e" + self.ion + "2"):
            setattr(self.soma, "e" + self.ion + "2", self.erev)

        else:
            setattr(self.soma, "e_" + self.mod_name, self.erev)

        return h

    def build_model(self, restore_tolerances=True):
        print("Loading channel: " + self.temp_model_path)
        h = self.load_model()

        # set up stim
        print('Setting up vi clamps...')
        self.vc = h.SEClamp(self.soma(0.5))
        self.vc.amp1 = 0
        self.vc.dur1 = 0
        self.vc.rs = 1e-6

        # Set up variable collectors
        print('Setting up tvi collectors...')
        self.t_collector = Collector(self.config.collection_period_ms, h._ref_t)
        self.v_collector = Collector(self.config.collection_period_ms, self.soma(0.5)._ref_v)
        self.g_collector = Collector(self.config.collection_period_ms,
                                     getattr(self.soma(0.5), "_ref_gion_" + self.mod_name))

        if hasattr(self.soma(0.5), "i" + self.ion):
            self.i_collector = Collector(self.config.collection_period_ms, getattr(self.soma(0.5), "_ref_i" + self.ion))

        elif hasattr(self.soma(0.5), "i" + self.ion + "2"):
            self.i_collector = Collector(self.config.collection_period_ms,
                                         getattr(self.soma(0.5), "_ref_i" + self.ion + "2"))

        else:
            self.i_collector = Collector(self.config.collection_period_ms,
                                         getattr(self.soma(0.5), "_ref_i_" + self.mod_name))

        # Keep track of all time steps taken
        self.tvec = h.Vector()
        self.tvec.record(h._ref_t)

        # h.nrncontrolmenu()
        self.nState = h.SaveState()
        self.sim_init()
        self.set_abs_tolerance(self.config.abs_tolerance)

        return h

    def get_id_from_nml_file(self, nml):
        return re.search('<.*ionChannel.*?id.*?=.*?"(.*?)"', nml, re.IGNORECASE).groups(1)[0]

    def get_tv(self):
        from neuron import h
        v_np = self.v_collector.get_values_np()
        t_np = self.t_collector.get_values_np()

        if np.isnan(v_np).any():
            raise NumericalInstabilityException(
                "Simulation is numericaly unstable with dt of " + str(h.dt) + " ms")

        return (t_np, v_np)

    def get_mod_name(self):
        mod_files = self.get_mod_files()

        if len(mod_files) != 1:
            raise Exception("There should be exactly one .mod file in: " + self.temp_model_path)

        mod_file = mod_files[0]

        return mod_file.replace(".mod", "")

    def on_before_mod_compile(self):
        if self.channel_record.Type.ID == 'KCa':
            mod_name = self.get_mod_name()

            with open(mod_name + ".mod", "r") as f:
                mod_file = f.read()

            mod_file = mod_file.replace("    SUFFIX " + mod_name,
                                        "    SUFFIX " + mod_name + "\n" +
                                        "    USEION ca READ cai")

            with open(mod_name + ".mod", "w") as f:
                f.write(mod_file)
