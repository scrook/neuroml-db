import numpy as np


class Collector:
    def __init__(self, collection_period_ms, expr):
        from neuron import h
        self.collection_period_ms = collection_period_ms
        self.rvec = h.Vector()
        self.rvec.record(expr, collection_period_ms)

    def get_values_np(self):
        result = np.empty([int(self.rvec.size())], dtype=float)
        self.rvec.to_python(result)
        return result

    def get_values_list(self):
        return self.rvec.to_python()

