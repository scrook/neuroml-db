import os, socket

class Config(object):
    def __init__(self):
        self.debug = 'NONE'  # One of 'NONE', 'MANAGER', 'RUNNER'
        self.debug_ip = '192.168.0.34'
        self.debug_port = 4200

        self.webserver_name = 'spike.asu.edu'  # spike.asu.edu - testing server
        self.webserver_port = '5000'
        self.pwd = os.environ['NMLDBPWD']  # This needs to be set to the password
        self.webserver = self.webserver_name + ":" + self.webserver_port
        self.server_IP = socket.gethostbyname(self.webserver_name)

        self.server_model_path = '/var/www/NeuroMLmodels'
        self.temp_models_dir = '../../www/NeuroMLmodels'

        self.out_sim_directory = 'temp/sim'
        self.default_out_csv_file = 'temp/models.csv'

        self.temp_models_folder = 'temp'
        self.abs_tolerance = 0.001
        self.dt = 1/128.0
        self.cvode_active = 0
        self.collection_period_ms = 1/128.0 #0.01
        self.permanent_models_dir = "../../../../www/NeuroMLmodels"

        self.cell_protocols_to_run = [
            "STEADY_STATE",
            "RAMP",
            "SHORT_SQUARE",
            "SQUARE",
            "LONG_SQUARE",
            "SHORT_SQUARE_HOLD",
            "SHORT_SQUARE_TRIPPLE",
            "SQUARE_SUBTHRESHOLD",
            # "NOISE1",
            # "NOISE2",
            # "NOISE_RAMP"
        ]

    def start_debugging_if_enabled(self, scope):
        if self.debug == scope:
            import pydevd
            pydevd.settrace(self.debug_ip, port=self.debug_port, suspend=False)



