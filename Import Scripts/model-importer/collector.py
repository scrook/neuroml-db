import numpy as np


class Collector:
    def __init__(self, collection_period_ms, expr):
        from neuron import h

        self.collection_period_ms = collection_period_ms

        self.stim = h.NetStim(0.5)
        self.stim.start = 0
        self.stim.number = 1e9
        self.stim.noise = 0
        self.stim.interval = self.collection_period_ms

        self.con = h.NetCon(self.stim, None)
        self.con.record((self.collect, expr))

        self.fih = h.FInitializeHandler(self.clear)

        self.clear()

    def clear(self):
        self.values = []

    def collect(self, new_value):
        self.values.append(new_value())

    def get_np_values(self):
        return np.array(self.values[1:])