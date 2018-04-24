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
    with ModelManager() as db_version:
        db_version.validate_db_model(dirs=params)


def update_checksums():
    with ModelManager() as mm:
        mm.update_model_checksums()


def get_cell_properties():
    with CellManager(params[0]) as mm:
        mm.get_cell_model_properties(model_dir=params[0])


def save_cell_model_responses():
    with CellManager(params[0]) as mm:
        mm.save_cell_model_responses(model_dir=params[0])

def save_cell_3D_image():
    with CellManager(params[0]) as mm:
        mm.save_3D_image()


def check_install_dependencies():
    import os

    # Check for missing installable dependencies
    deps = ["pydevd", "peewee", "pymysql", "sshtunnel", "numpy", "matplotlib", "cPickle"]

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
    import subprocess
    neuron_check = subprocess.check_output(
        "python -c 'from neuron import h, gui'; exit 0",
        stderr=subprocess.STDOUT,
        shell=True)

    if "No module" in neuron_check:
        print(neuron_check)
        raise Exception("Neuron+Python module must be compiled to run this script. For steps, "
                        "see: https://neurojustas.wordpress.com/2018/03/27/tutorial-installing-neuron-simulator-with"
                        "-python-on-ubuntu-linux/")

    # Extract noise stimulation files
    for file in ["noise1.pickle", "noise2.pickle", "noisyRamp.pickle"]:
        if not os.path.exists(file):
            os.system("tar -xzf noisyStims.tar.gz")
            break


if __name__ == "__main__":
    import pydevd
    pydevd.settrace('192.168.0.34', port=4200, suspend=False)

    check_install_dependencies()

    import sys
    from manager import ModelManager
    from cellmanager import CellManager

    command = sys.argv[1]
    params = sys.argv[2:]

    available_commands = [i for i in locals().keys() if not i.startswith("__") and hasattr(locals()[i],"__class__") and locals()[i].__class__.__name__ == "function"]

    if command not in available_commands:
        raise Exception("Command after 'python manage.py' must be one of: " + str(available_commands))

    eval(command + "()")

    print("EXITING...")
