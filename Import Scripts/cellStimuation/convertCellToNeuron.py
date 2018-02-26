import sys, re, os
import urllib, json
import shutil

# usage: python convertCellToNeuron.py CellFile.nml
# creates a NEURON version of the cell file by creating a LEMS file and using jnml to convert to NEURON

path = sys.argv[1]

import pydevd
pydevd.settrace('192.168.0.34', port=4201, suspend=False)

DirName = os.path.dirname(os.path.abspath(path))
cellFileName = os.path.basename(path)
nmlDBID = DirName.split("/")[-1]

# Templates
includeFileTemplate = '	<Include file="[File]"/>'

def replaceTokens(target, reps):
    result = target
    for r in reps.keys():
        result = result.replace(r,str(reps[r]))
    return result

def getChannels(modelID):
    url = "http://spike.asu.edu:5000/api/model?id="+modelID
    response = urllib.urlopen(url)
    model = json.loads(response.read())
    channels = [m for m in model["children"] if m["Type"] == "Channel" or m["Type"] == "Concentration"]
    return channels


# Find the NML id of the cell
with open(path) as f:
    nml = f.read()
    cellID = re.search('<cell.*?id="(.*?)"', nml).groups(1)[0]

# Get all cell channel files from the model API
channels = getChannels(nmlDBID)

# Create file includes for each channel
channelIncludes = ''

for c in channels:
    id = c["Model_ID"]
    file = c["File_Name"]
    path = "../"+id+"/"+file
    shutil.copy2(DirName + "/" + path, DirName)
    channelIncludes = channelIncludes + includeFileTemplate.replace("[File]", file) + "\n"

replacements = { \
    "[CellInclude]": includeFileTemplate.replace("[File]", cellFileName), \
    "[ChannelIncludes]": channelIncludes, \
    "[Cell_ID]": cellID
}

with open("LEMS_single_cell_template.xml") as t:
    template = t.read()

for r in replacements:
    template = template.replace(r,str(replacements[r]))

outFile = DirName + "/LEMS_Isolated_" + cellFileName

with open(outFile, "w") as outF:
    outF.write(template)