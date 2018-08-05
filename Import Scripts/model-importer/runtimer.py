import time


class RunTimer:
    def __init__(self):
        self.start_time = None
        self.end_time = None
        pass

    def __enter__(self):
        self.start_time = time.time()
        return self

    def __exit__(self, exc_type, exc_value, traceback):
        self.end_time = time.time()

        print("Simulation took: %.4f seconds" % self.get_run_time())

    def get_run_time(self):
        if any(v is None for v in [self.end_time, self.start_time]):
            return None

        return self.end_time - self.start_time
