import datetime
import json
import os
import random
import sys
import time
from multiprocessing import Process, Value
from threading import Timer


class NumericalInstabilityException(Exception):
    pass


class NeuronRunner:
    def __init__(self, target, kill_slow_sims=True):
        self.DONTKILL = False  # True
        self.sim_t = Value('d', -1)
        self.sim_t_previous = -1
        self.kill_slow_sims = kill_slow_sims
        self.sim_result_file = os.getcwd() + "/sim_result_" + str(random.randint(0, 999999)) + ".json"
        self.killed_process = False

        def wrapper():
            result = {"result": None, "error": None}

            try:
                if kill_slow_sims:
                    result["result"] = target(self.sim_t)
                else:
                    result["result"] = target()
            except:
                import traceback
                result["error"] = traceback.format_exc()

            import json
            with open(self.sim_result_file, "w") as f:
                json.dump(result, f)
                print("Saved result to: " + self.sim_result_file)

        self.process = Process(target=wrapper)

    def run(self):
        self.reset_killer()
        self.process.start()

        while self.process.is_alive():
            # Every so often
            time.sleep(1)

            # Check for sim time changes
            sim_t_now = self.sim_t.value

            # Display sim speed
            self.print_speed(sim_t_now)

            if sim_t_now != self.sim_t_previous:
                self.sim_t_previous = sim_t_now
                self.reset_killer()

        self.process.join()
        self.reset_killer(renew=False)

        if self.killed_process:
            raise NumericalInstabilityException(
                "Stopped early because either the simulation speed was too low or the activity_flag was not updated")
        else:
            try:
                with open(self.sim_result_file) as f:
                    result = json.load(f)
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
            speed = sim_mseconds / clock_seconds
            print("Simulation time: " + str(sim_t_now) + " ms. Speed: %.2f ms/s" % speed)

    def reset_killer(self, renew=True):
        if hasattr(self, "killer"):
            self.killer.cancel()

        if self.kill_slow_sims and renew:
            self.killer = Timer(10, self.kill)
            self.killer.start()

        self.last_reset = datetime.datetime.now()

    def kill(self):
        print("NEURON did not respond within 10s, KILLING SIM...")

        if self.DONTKILL:
            print("DONTKILL flag set... KEEPING")
        else:
            self.process.terminate()
            self.killed_process = True
