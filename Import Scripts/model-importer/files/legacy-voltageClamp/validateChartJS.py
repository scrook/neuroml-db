# Will check the channel folder ChartJS files for common problems
#
# Usage:
#    validateChartJS.py "path/to/NeuroMLmodels" to validate_relationships all models
# OR
#    validateChartJS.py "path/to/NMLCH....XXX" to validate_relationships a single model

import numpy as np
from matplotlib import pyplot as plt
import csv, re, sys, os
from decimal import Decimal
import traceback

#import pydevd
#pydevd.settrace('192.168.0.34', port=4200, stdoutToServer=True, stderrToServer=True, suspend=False)

path = os.path.abspath(sys.argv[1])

if path.endswith('NeuroMLmodels'):
    modelDirs = [path + '/' + dir for dir in os.listdir(path) if dir.startswith('NMLCH')]
else:
    modelDirs = [path]

for modelPath in modelDirs:
    try:
        print("Validating model plots: " + modelPath)

        file = None
        modelFiles = os.listdir(modelPath)

        # Look for .js files that contain one of the xactivation protocols
        protocolFiles = [modelPath + '/' + f for f in modelFiles if "activation" in f.lower() and f.endswith(".js")]

        # Look for LEMS files
        lemsFiles = [modelPath + '/' + f for f in modelFiles if f.lower().startswith('lems') and f.endswith(".nml")]

        assert len(protocolFiles) >= 3 # There should be at least three protocol files for each channel
        assert len(protocolFiles) == len(lemsFiles)  # The number of LEMS and .js files should be the same

        for file in protocolFiles:

            roiRangeMatches = re.search(r"_(\d*)_(\d*).js",file)
            roiStart = int(roiRangeMatches.group(1))
            roiEnd = int(roiRangeMatches.group(2))

            data = {}
            measure = None
            with open(file) as f:
                for line in f:
                    if line.startswith("var "):
                        measure = re.findall(r"var (.*?) = {", line)[0]
                        data[measure] = {}

                    elif line.startswith("{label"):
                        labeledVoltage = float(re.findall(r"label:'(.*?) mV'", line)[0])
                        matches = re.findall(r"{x:(.*?),y:(.*?)}",line)

                        if len(matches) > 0:
                            times = np.array([float(x[0]) for x in matches])
                            values = np.array([float(x[1]) for x in matches])

                            # FOR DEBUGGING
                            plt.plot(times,values)

                        data[measure][labeledVoltage] = {"times": times, "values": values}

            ### Basic checks

            # There are three measures
            assert len(data) == 3 # There are three measures

            # Each measure has at least one plot
            for measure in data:
                assert len(data[measure].values()) > 0 # Each measure has at least one plot

            # The number of plot per measure is the same
            plotsInFirst = None
            for measure in data:
                numPlots = len(data[measure].values())
                if plotsInFirst is None:
                    plotsInFirst = numPlots
                else:
                    assert numPlots == plotsInFirst # The number of plot per measure is the same

            # The min and max voltage labels are the same across measures
            firstMin = None
            firstMax = None
            for measure in data:
                voltages = np.array(data[measure].keys())
                min = voltages.min()
                max = voltages.max()

                if firstMin is None:
                    firstMin = min
                    firstMax = max
                else:
                    assert firstMin == min # The min and max voltage labels are the same across measures
                    assert firstMax == max # The min and max voltage labels are the same across measures

            # The values within the region of interest (roi) should be present in each plot
            for measure in data:
                for stepV in data[measure].keys():
                    times = data[measure][stepV]['times']

                    assert times.min() < (roiStart + 1) and times.max() > (roiEnd - 1) # The values within the region of interest (roi) should be present in each plot

            # Voltage steps match voltage labels
            # Find the differences across the plots
            lowVStep = data['voltages'][np.min(data['voltages'].keys())]['values']
            highVStep = data['voltages'][np.max(data['voltages'].keys())]['values']
            lowHighDiff = highVStep - lowVStep

            for labeledVoltage in data['voltages']:
                values = data['voltages'][labeledVoltage]['values']
                times = data['voltages'][labeledVoltage]['times']

                # Only check if the different parts match the voltage label
                medianV = np.median(values[lowHighDiff != 0])

                # Allow for 1 mV tolerance
                assert np.abs(medianV - labeledVoltage) <= 1.0 # Voltage steps match voltage labels

                # Debug
                # plt.plot(times,values);

            # Numerical Stability Checks
            # Detect extreme conductance or current values abs>10000
            measuresToCheck = ['conductances', 'currents']
            for measure in measuresToCheck:
                for labeledVoltage in data[measure]:
                    values = data[measure][labeledVoltage]['values']
                    assert np.max(np.abs([values.min(), values.max()])) < 10000 # Detect extreme conductance or current values abs>10000

            # Missing conductances - all conductances identical
            def IdenticalMeasures(measureName):
                isDifferent = False
                firstConductance = None
                measure = data[measureName]
                try:
                    for labeledVoltage in measure:
                        values = measure[labeledVoltage]['values']

                        for value in values:
                            if firstConductance is None:
                                firstConductance = value
                            elif firstConductance != value:
                                raise StopIteration

                except StopIteration:
                    isDifferent = True

                assert isDifferent # Missing measure - all values identical - probably ok if this is a [Ca2+] dependent Kahp channel

            IdenticalMeasures('conductances')
            IdenticalMeasures('currents')

    except AssertionError:
        print("Problem in model: " + modelPath)
        print("File: " + str(file))
        print(traceback.format_exc())
        print(traceback.print_exc())