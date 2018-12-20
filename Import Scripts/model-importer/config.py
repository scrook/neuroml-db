import os, socket


class Config(object):
    def __init__(self):
        self.debug = 'NONE'  # One of 'NONE', 'MANAGER', 'RUNNER'
        self.cleanup_temp = True # use False to leave the files in temp folder (e.g. for debugging)

        self.cvode_active = 1
        self.abs_tolerance = 0.001

        self.dt = 1 / 128.0 + 1 / 256.0
        self.collection_period_ms = 1 / 128.0  # 0.01

        self.default_temperature = 36.0
        self.simplification_constant = 1e-4  # fraction of waveform's max-min range. 0 - only remove perfectly colinear points

        self.skip_tolerance_setting_if_exists = True
        self.skip_obtaining_steady_state_if_state_file_exists = True

        self.debug_ip = '192.168.0.34'
        self.debug_port = 4200

        self.webserver_name = 'dendrite.asu.edu'  # spike.asu.edu - testing server
        self.webserver_port = '5000'
        self.pwd = os.environ['NMLDBPWD']  # This needs to be set to the password
        self.webserver = self.webserver_name + ":" + self.webserver_port
        self.server_IP = socket.gethostbyname(self.webserver_name)

        self.temp_models_folder = os.path.abspath('temp')
        self.server_model_path = '/var/www/NeuroMLmodels'

        self.out_sim_directory = os.path.abspath('temp/sim')
        self.default_out_csv_file = 'temp/models.csv'

        self.permanent_models_dir = os.path.abspath("../../www/NeuroMLmodels")  # Assumes script runs from model-importer directory


    def start_debugging_if_enabled(self, scope):
        if self.debug == scope:
            print("Starting debugger... Make sure it is running on " +
                  self.debug_ip + ":" + str(self.debug_port) +
                  ". These can be set in config.py")
            import pydevd
            pydevd.settrace(self.debug_ip, port=self.debug_port, suspend=False)
            print("Debugger CONNECTED.")



