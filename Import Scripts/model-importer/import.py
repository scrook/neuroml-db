# This script will take one or more directory paths as inputs, parse the model info,
# and convert the model into a CSV description, a single directory simulation, or save into NeuroML-DB
# Can be used to modify a model that already exists in the database or import a new model into the db
# Usage examples:
#   For a new model:
#       python import.py "../Sources/OSB/Migliore 2014/inputs/"
#
#   For existing model:
#       python import.py "path/to/existing/models/NML...XX1", "path/to/existing/models/NML...XX2", ...


import pydevd
pydevd.settrace('192.168.177.1', port=4202, suspend=False)


import sys
from importer import ModelImporter

command = sys.argv[1]
params = sys.argv[2:]

if command == "to_csv":
    with ModelImporter() as mi:
        mi.parse_directories(params)
        mi.to_csv()

if command == "to_db":
    with ModelImporter() as mi:
        mi.parse_csv(params[0])
        mi.to_db_stored()

if command == "validate":
    with ModelImporter() as db_version, ModelImporter() as sim_version:
        # Build node tree from the DB data
        db_version.parse_directories(params)

        # Convert the DB tree to single-folder simulation
        db_version.to_simulation("sim", clear_contents=True)

        # Build the tree from the simulation files
        sim_version.parse_directories(["sim"])

        # Compare the db tree to the simulation tree - generate comparison CSV
        db_version.compare_to(sim_version)

        db_version.to_csv("validation_results.csv")
