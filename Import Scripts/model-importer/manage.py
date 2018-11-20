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


def validate_model_relationships():
    with ModelManager() as mm:
        mm.validate_model_relationships(dirs=params)


def save_model_properties():
    with ModelManager() as mm:
        models = params[0].split(',')
        properties = params[1].split(',')
        mm.save_model_properties(models, properties)

def find_waveforms_without_files():
    with ModelManager() as mm:
        mm.find_waveforms_without_files()

def find_multicomp_cells_without_gifs():
    with ModelManager() as mm:
        mm.find_multicomp_cells_without_gifs()

def process_batch():
    # check queue for tasks,
    # if got one, process it, in a separate process
    # else quit


    """
    we dont want to get too many tasks ahead of time
    want to keep getting tasks until: 1) no more tasks 2) all cpus busy
    once a task completes, get another task
    launch a thread for each cpu
    each thread checks the queue and retrieves tasks, if none available quits

    :return:
    """
    from multiprocessing import Pool, cpu_count

    threads = cpu_count() - 1
    
    if threads == 0:
        threads = 1

    if len(params) == 1:
        threads = int(params[0])

    print("Starting batch in " + str(threads) + " parallel processes...")
    pool = Pool(processes=threads)
    pool.map(single_cpu_job, range(threads))


def single_cpu_job(ignore):
    import os

    import time
    from random import randint

    print("Checking for tasks...")
    time.sleep(randint(0, 15))

    with ModelManager() as mm:
        mm.server.connect()

        keep_working = True
        while keep_working:

            cursor = mm.server.db.cursor()
            cursor.callproc("get_next_task")
            tasks = cursor.fetchall()

            if len(tasks) > 0:
                task_id, command = tasks[0]
                print("Working on task: " + str(task_id) + " '" + command + "'")

                try:
                    os.system(command)
                finally:
                    mm.server.db.execute_sql('call finish_task(%s)',(task_id))
                    print("Task finished: " + str(task_id))

                time.sleep(randint(0, 15))

            else:
                print('No more tasks, stopping worker process...')
                return




def check_install_dependencies():
    import os

    if 'NMLDBPWD' not in os.environ or os.environ['NMLDBPWD'] == '':
        raise Exception("Set the value of environment variable 'NMLDBPWD' to the NMLDB password")

    # Check for missing installable dependencies
    deps = ["pydevd", "peewee", "pymysql", "sshtunnel", "numpy", "matplotlib", "cPickle", "rdp", "scipy", "sklearn"]

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
            os.system("tar -xzf files/noisyStims.tar.gz")
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

    sys.exit(0)
