import os
import re

import numpy as np
from matplotlib import pyplot as plt
from nmldbmodel import NMLDB_Model
from tables import Channels
from collector import Collector
from neuronrunner import NeuronRunner, NumericalInstabilityException
from math import pi

class ChannelModel(NMLDB_Model):
    def __init__(self, *args, **kwargs):
        super(ChannelModel, self).__init__(*args, **kwargs)

        self.all_properties.extend([
            'stability_range',
            'ACTIVATION',
            'DEACTIVATION',
            'INACTIVATION'
        ])

        self.init_channel_record()

    def init_channel_record(self):
        self.server.connect()

        # Fetch channel record
        self.channel_record = Channels.get_or_none(Channels.Model_ID == self.get_model_nml_id())

        # Pre-retrieve the resting v of the channel type (the first voltage level of a protocol)
        self.rest_v = float(self.channel_record.Type.Activation_Protocol.Voltages.split(',')[0])


        if self.channel_record is None:
            raise Exception("No records found in Channels table for model: " + self.get_model_nml_id())

    def save_ACTIVATION(self):
        raise NotImplementedError()

    def save_INACTIVATION(self):
        raise NotImplementedError()

    def save_DEACTIVATION(self):
        raise NotImplementedError()

    def save_vclamp_set(self, protocol, square_low, square_high, square_steps, delay, duration,
                        post_delay=250):

        # Create current amplitude set
        amps = np.linspace(square_low, square_high, num=square_steps).tolist()

        # Run each injection as a separate simulation, resuming from steady state
        for amp in amps:
            result = self.get_vclamp_response(durations=duration,
                                              post_delay=post_delay,
                                              amp=amp,
                                              restore_state=True)

            self.save_tvi_plot(label=protocol, case=self.short_string(amp) + " nA", tvi_dict=result)

            self.save_vi_waveforms(protocol=protocol,
                                   label=self.short_string(amp) + " nA",
                                   tvi_dict=result)

    def get_vclamp_response(self,
                            durations,
                            voltages,
                            restore_state):

        def vclamp_protocol(time_flag):
            self.time_flag = time_flag
            h = self.build_model()

            # Set the sqauare current injector
            self.current.dur = durations
            self.current.delay = delay
            self.current.amp = amp

            t = []
            v = []
            i = []
            g = []

            with RunTimer() as timer:
                if restore_state:
                    self.restore_state()
                    t, v = self.runFor(durations + post_delay)
                else:
                    h.stdinit()
                    t, v = self.runFor(delay + durations + post_delay)

                for v in range(len(voltages)):
                    t, v = self.runFor(durations + post_delay)


            result = {
                "t": t.tolist(),
                "v": v.tolist(),
                "i": self.ic_i_collector.get_values_list(),
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
        print("Loading NEURON... If this step 'freezes', ensure there are no hung NEURON processes with 'pkill -9 nrn*'")
        from neuron import h, gui
        print("DONE")

        # Create a test cell with the channel
        mod_files = self.get_mod_files()

        if len(mod_files) <= 0:
            raise Exception("Did not find any .mod files in " + self.temp_model_path)

        mod_file = mod_files[0]
        mod_name = mod_file.replace(".mod", "")

        self.soma = h.Section()
        self.soma.L = 10
        self.soma.diam = 10
        self.soma.cm = 1000.0/pi

        self.soma.insert(mod_name)

        return h

    def build_model(self, restore_tolerances=True):
        print("Loading channel: " + self.temp_model_path)
        h = self.load_model()

        # set up stim
        print('Setting up vi clamps...')
        self.vc = h.SEClamp(self.soma(0.5))
        self.vc.dur1 = 0

        # Set up variable collectors
        print('Setting up tvi collectors...')
        self.t_collector = Collector(self.config.collection_period_ms, h._ref_t)
        self.v_collector = Collector(self.config.collection_period_ms, self.soma(0.5)._ref_v)
        self.vc_i_collector = Collector(self.config.collection_period_ms, self.vc._ref_i)

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