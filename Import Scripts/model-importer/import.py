# This script will take one or more directory paths as inputs, parse the model info,
# and convert the model into a CSV description, a single directory simulation, or save into NeuroML-DB
# Can be used to modify a model that already exists in the database or import a new model into the db
# Usage examples:
#   For a new model:
#       python import.py "../Sources/OSB/Migliore 2014/inputs/"
#
#   For existing model:
#       python import.py "path/to/existing/models/NML...XX1", "path/to/existing/models/NML...XX2", ...

import os

# Check for missing installable dependencies
deps = ["pydevd", "peewee", "pymysql", "sshtunnel", "numpy", "matplotlib"]

for dep in deps:
    try:
        exec("import " + dep)
    except:
        os.system("pip install " + dep)

try:
    import dateutil
except:
    os.system("pip install python-dateutil")

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

import sys
from importer import ModelImporter
from cellassessor import CellAssessor

command = sys.argv[1]
params = sys.argv[2:]

if command == "to_csv":
    with ModelImporter() as mi:
        mi.parse_directories(params)
        mi.to_csv()
        mi.open_csv()

if command == "to_db":
    with ModelImporter() as mi:
        mi.parse_csv(params[0])
        mi.to_db_stored()

if command == "validate":
    with ModelImporter() as db_version, ModelImporter() as sim_version:
        # Build node tree from the DB data
        db_version.parse_directories(params)

        # Convert the DB tree to single-folder simulation
        db_version.to_simulation("temp/sim", clear_contents=True)

        # Build the tree from the simulation files
        sim_version.parse_directories(["temp/sim"])

        # Compare the db tree to the simulation tree - generate comparison CSV
        db_version.compare_to(sim_version)

        db_version.to_csv("temp/validation_results.csv")

        if any(node["file_status"] != "same" for node in db_version.tree_nodes.values()):
            db_version.open_csv("temp/validation_results.csv")
        else:
            print("Valid: DB records and simulation files are all SAME")

if command == "update_checksums":
    with ModelImporter() as mi:
        mi.update_model_checksums()

if command == "get_cell_properties":



    with ModelImporter() as mi:
        NEURON_folder = mi.cell_model_to_neuron(params[0])

    assessor = CellAssessor(path=NEURON_folder)
    try:
        assessor.start()
    except:
        print("Encountered an error. Saving progress...")
        import traceback

        assessor.cell_record.Errors = traceback.format_exc()
        assessor.save_cell_record()
        raise