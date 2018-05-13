import datetime
import cPickle
import os
import random
import sys
import time
from multiprocessing import Process, Value
from threading import Timer
from config import Config

class NumericalInstabilityException(Exception):
    pass


class NeuronRunner:
    def __init__(self, target, kill_slow_sims=True):
        self.DONTKILL = False  # Set this to True when debugging
        # Time flag - set it's value to a positive number to indicate running simulation time
        # Negative number indicates simulation not running (e.g. building model or post-processing)
        self.sim_t = Value('d', -1)
        self.sim_t_previous = -1
        self.kill_slow_sims = kill_slow_sims
        self.max_clock_wait_time_s_for_1ms_of_sim_time = 10
        self.sim_result_file = os.getcwd() + "/sim_result_" + str(random.randint(0, 999999)) + ".pickle"
        self.killed_process = False

        def wrapper():
            Config().start_debugging_if_enabled('RUNNER')

            result = {"result": None, "error": None}

            try:
                if kill_slow_sims:
                    result["result"] = target(self.sim_t)
                else:
                    result["result"] = target()
            except:
                import traceback
                result["error"] = traceback.format_exc()

            import cPickle

            with open(self.sim_result_file, "wb") as f:
                cPickle.dump(result, f)


        self.process = Process(target=wrapper)
        self.process.daemon = True

    def run(self):
        self.reset_killer()
        self.process.start()

        while self.process.is_alive():
            # Every so often
            time.sleep(1)

            # Check for sim time changes
            sim_t_now = self.sim_t.value

            # If simulation is not running, don't kill
            if sim_t_now < 0:
                self.reset_killer()

            # If simulation is running, check if it's too slow
            else:
                # Display sim speed
                self.print_speed(sim_t_now)

                if sim_t_now != self.sim_t_previous:
                    self.sim_t_previous = sim_t_now
                    self.reset_killer()

        self.process.join()
        self.reset_killer(renew=False)

        if self.killed_process:
            raise NumericalInstabilityException(
                "Stopped early because either the simulation speed was too low or the time_flag was not updated")
        else:
            try:

                with open(self.sim_result_file) as f:
                    result = cPickle.load(f)


                os.remove(self.sim_result_file)

            except:
                raise Exception("NEURON process crashed before result or error information could be saved.")

            if result["error"] is not None:
                print(result["error"])
                raise Exception("Error during NEURON simulation")

        return result["result"]

    def print_speed(self, sim_t_now):
        clock_seconds = (datetime.datetime.now() - self.last_reset).total_seconds()

        if self.sim_t_previous != -1:
            sim_mseconds = sim_t_now - self.sim_t_previous
            if sim_mseconds > 0:
                speed = sim_mseconds / clock_seconds
                print("Simulation time: " + str(sim_t_now) + " ms. Speed: %.4f ms/s" % speed)
            else:
                speed = 1.0 / clock_seconds
                print("Simulation time: " + str(sim_t_now) + " ms. Speed: <%.4f ms/s" % speed)


    def reset_killer(self, renew=True):
        if hasattr(self, "killer"):
            self.killer.cancel()

        if self.kill_slow_sims and renew:
            self.killer = Timer(self.max_clock_wait_time_s_for_1ms_of_sim_time, self.kill)
            self.killer.start()

        self.last_reset = datetime.datetime.now()

    def kill(self):
        print("NEURON did not respond within 10s, KILLING SIM...")

        if self.DONTKILL:
            print("DONTKILL flag set... KEEPING")
        else:
            self.process.terminate()
            self.process.join()
            self.killed_process = True
            print('NEURON PROCESS KILLED')
