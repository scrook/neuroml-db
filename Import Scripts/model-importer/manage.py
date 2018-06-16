# This script will take one or more directory paths as inputs, parse the model info,
# and convert the model into a CSV description, a single directory simulation, or save into NeuroML-DB
# Can be used to modify a model that already exists in the database or import a new model into the db
# Usage examples:
#   For a new model:
#       python import.py "../Sources/OSB/Migliore 2014/inputs/"
#
#   For existing model:
#       python import.py "path/to/existing/models/NML...XX1", "path/to/existing/models/NML...XX2", ...


def to_csv():
    with ModelManager() as mm:
        mm.model_to_csv(dirs=params)


def to_db():
    with ModelManager() as mm:
        mm.csv_to_db(csv_file=params[0])


def validate():
    with ModelManager() as mm:
        mm.validate_db_model(dirs=params)


def save_model_properties():
    with ModelManager() as mm:
        models = params[0].split(',')
        properties = params[1].split(',')
        mm.save_model_properties(models, properties)



def save_cell_properties():
    with CellModel(params[0]) as cm:
        cm.save_cell_model_properties(model_dir=params[0])


def save_cell_model_responses():
    with CellModel(params[0]) as cm:
        cm.save_cell_model_responses(model_dir=params[0], protocols=Config().cell_protocols_to_run)


def save_optimal_time_steps():
    with ModelManager() as mm:
        mm.save_optimal_time_steps()


def save_cvode_runtime_complexity_metrics():
    with ModelManager() as mm:
        mm.save_cvode_runtime_complexity_metrics()

def save_morphology_data():
    with CellModel(params[0]) as cm:
        cm.save_morphology_data()


def check_install_dependencies():
    import os

    if 'NMLDBPWD' not in os.environ or os.environ['NMLDBPWD'] == '':
        raise Exception("Set the value of environment variable 'NMLDBPWD' to the NMLDB password")

    # Check for missing installable dependencies
    deps = ["pydevd", "peewee", "pymysql", "sshtunnel", "numpy", "matplotlib", "cPickle", "rdp", "scipy"]

    for dep in deps:
        try:
            exec ("import " + dep)
        except:
            os.system("pip install " + dep)

    try:
        from dateutil.parser import parse

    except:
        os.system("pip install python-dateutil")

    # Check if NEURON package has been installed
    check_output_for(command = "python -c 'from neuron import h, gui'; exit 0",
                     dissalowed_text="No module",
                     error_to_show="Neuron+Python module must be compiled to run this script. For steps, "
                                   "see: https://neurojustas.wordpress.com/2018/03/27/tutorial-installing-neuron-simulator-with"
                                   "-python-on-ubuntu-linux/")

    # Check if blender is installed
    check_output_for(command="blender -v; exit 0;",
                     dissalowed_text="command not found",
                     error_to_show="Could not find blender. Blender can be downloaded from: "
                                   "http://download.blender.org/release/Blender2.79/blender-2.79b-linux-glibc219-x86_64.tar.bz2 "
                                   "After download and extraction, add the blender directory to the PATH environment variable. "
                                   "This script will allow proceeding if the following command can run 'blender -v'"
                     )

    # Check if ffmpeg is installed
    check_output_for(command="ffmpeg -h; exit 0;",
                     dissalowed_text="currently not installed",
                     error_to_show="ffmpeg ubuntu package must be installed to run this script. "
                                   "Install it with: sudo apt install ffmpeg")

    # Make sure lmeasure can run - has exec permissions
    try:
        check_output_for("./lmeasure", "Permission denied", "Allow lmeasure to run with: chmod +x lmeasure")
    except:
        os.system("chmod +x lmeasure")

    # Extract noise stimulation files
    for file in ["noise1.pickle", "noise2.pickle", "noisyRamp.pickle"]:
        if not os.path.exists(file):
            os.system("tar -xzf noisyStims.tar.gz")
            break


def check_output_for(command, dissalowed_text, error_to_show):
    import subprocess

    try:
        neuron_check = subprocess.check_output(
        command,
        stderr=subprocess.STDOUT,
        shell=True)
    except:
        raise Exception(error_to_show)

    if dissalowed_text in neuron_check:
        print(neuron_check)
        raise Exception(error_to_show)


if __name__ == "__main__":
    check_install_dependencies()

    import sys
    from manager import ModelManager
    from cellmodel import CellModel
    from config import Config

    Config().start_debugging_if_enabled('MANAGER')

    available_commands = [i for i in locals().keys() if
                          not i.startswith("__") and
                          hasattr(locals()[i], "__class__") and
                          locals()[i].__class__.__name__ == "function"]

    command = sys.argv[1] if len(sys.argv) >= 2 else None
    params = sys.argv[2:]

    if command not in available_commands:
        raise Exception("Command after 'python manage.py' must be one of: " + str(available_commands))

    eval(command + "()")

    print("EXITING...")
