# Obtains the cell threshold, rheobase, resting v, and bias currents for
# steady state v of a cell defined in a hoc file in the given directory.
# Usage: python getCellProperties /path/To/dir/with/.hoc

import os, sys

import pydevd
from quantities import ms, mV, nA
from neo.core import AnalogSignal
import numpy as np
import json
from pprint import pprint as pp
from matplotlib import pyplot as plt

#pydevd.settrace('192.168.0.34', port=4200, stdoutToServer=True, stderrToServer=True, suspend=False)

path = sys.argv[1]

stepsPerMs = 64
minCurrent = -0.5

# Load cell hoc and get soma
os.chdir(path)
from neuron import h,gui
h.load_file("nrngui.hoc")

cellHocFile = [f for f in os.listdir(path) if f.endswith(".hoc")][0]
cellTemplate = cellHocFile.replace(".hoc","")

h.load_file(cellHocFile)

cell = getattr(h,cellTemplate)()

for section in cell.soma_group:
    soma = section

h.tstop = 200.0

# Set up recordings
vVector = h.Vector()
vVector.record(soma(0.5)._ref_v)

tVector = h.Vector()
tVector.record(h._ref_t)

# set up stim
current = h.IClamp(soma(0.5))

current.delay = 50.0
current.amp = 0
current.dur = 100.0

vc = h.SEClamp(soma(0.5))
vc.dur1 = 0

def init():
    h.stdinit()
    current.amp = 0

def setDt(stepsPerMs):
    h.steps_per_ms = stepsPerMs
    h.dt = 1.0/stepsPerMs

def runFor(time):
    newStopTime = h.t + time
    h.tstop = newStopTime
    h.continuerun(newStopTime)

    # Get the waveform
    v = np.array(vVector.to_python())
    t = np.array(tVector.to_python())

    if np.isnan(v).any():
        raise Exception("Simulation is numericaly unstable with " + str(h.steps_per_ms) + " steps per ms")

    return (t,v)


def setCurrent(amp, delay, dur):
    current.delay = delay
    current.amp = amp
    current.dur = dur

def getSpikeCount(voltage):
    if np.max(voltage) < 0:
        return 0

    else:
        return len(crossings_nonzero_pos2neg(voltage))

def crossings_nonzero_pos2neg(data):
    pos = data > 0
    return (pos[:-1] & ~pos[1:]).nonzero()[0]

def getThreshold(maxI = 1):
    upperLevel = maxI
    lowerLevel = minCurrent
    upperSpikes = 0
    lowerSpikes = 0

    currentAmp = 0

    iterate = True
    iteration = 1
    gotSpike = False

    delay = 500
    init()
    runFor(delay)
    nState = h.SaveState()
    nState.save()

    plt.clf()

    while iterate:
        init()
        nState.restore()

        currentAmp = (lowerLevel + upperLevel) / 2.0
        setCurrent(amp = currentAmp, delay = delay, dur = 3)
        print("Trying " + str(currentAmp) + " nA...")

        t, v = runFor(50)

        numSpikes = getSpikeCount(v)
        print("Got " + str(numSpikes) + " spikes")

        if numSpikes < 1:
            lowerLevel = currentAmp
            lowerSpikes = numSpikes
        else:
            upperLevel = currentAmp
            upperSpikes = numSpikes
            gotSpike = True

        iteration = iteration + 1

        if iteration > 10:
            iterate = False

        plt.plot(t, v, label=str(round(currentAmp, 4)) + ": " + str(numSpikes) + "APs")


    result = (
        (lowerLevel, upperLevel),
        (lowerSpikes, upperSpikes)
    )

    plt.legend(loc='upper left')
    plt.xlabel("Threshold range: " + str(result))
    plt.savefig("threshold.png")

    if not gotSpike:
        raise Exception("Did not get any spikes with currents " + str(result))

    return result

def getRheobase(maxI = 1):
    delay = 500
    current_duration = 500
    check_period = 10
    first_early_stop_test = 200
    early_stop_max_v_percent_threshold = 0.95
    max_iterations = 17

    upperLevel = maxI
    lowerLevel = minCurrent
    upperSpikes = 0
    lowerSpikes = 0
    currentAmp = 0

    iterate = True
    iteration = 1
    gotSpike = False


    init()
    runFor(delay)
    nState = h.SaveState()
    nState.save()

    plt.clf()

    while iterate:
        init()
        nState.restore()

        currentAmp = (lowerLevel + upperLevel) / 2.0
        setCurrent(amp = currentAmp, delay = delay, dur = current_duration)
        print("Trying " + str(currentAmp) + " nA...")

        maxT = delay
        oneOrNoneSpikes = True
        earlyStop = False
        while not earlyStop and maxT < delay + current_duration and oneOrNoneSpikes:
            t, v = runFor(check_period)
            maxT = t.max()

            numSpikes = getSpikeCount(v)

            oneOrNoneSpikes = numSpikes < 2

            # Check for a spike-less bump in v
            if numSpikes < 1 and maxT > delay + first_early_stop_test and v[-1] < early_stop_max_v_percent_threshold*v.max():
                earlyStop = True

        plt.plot(t, v, label=str(round(currentAmp,4)) + ": " + str(numSpikes) + "APs")

        print("Got " + str(numSpikes) + " spikes")

        if numSpikes < 1:
            lowerLevel = currentAmp
            lowerSpikes = numSpikes

        else:
            upperLevel = currentAmp
            upperSpikes = numSpikes
            gotSpike = True

        iteration = iteration + 1

        if iteration > max_iterations:
            iterate = False


    result = (
        (lowerLevel, upperLevel),
        (lowerSpikes, upperSpikes)
    )

    plt.legend(loc='upper left')
    plt.xlabel("Rheobase range: " + str(result))
    plt.savefig("rheobase.png")

    if not gotSpike:
        raise Exception("Did not get any spikes with currents " + str(result))

    return result

def getBiasCurrent(targetV):

    vc.amp1 = targetV
    vc.dur1 = 10000

    iVector = h.Vector()
    iVector.record(vc._ref_i)

    init()

    t,v = runFor(500)

    i = np.array(iVector.to_python())
    crossings = getSpikeCount(i)

    if crossings > 2:
        print("No bias current exists for steady state at " + str(targetV) + " mV membrane potential (only spikes)")
        result = None
    else:
        result = vc.i

    vc.dur1 = 0

    plt.clf()
    plt.plot(t[np.where(t > 50)], i[np.where(t > 50)], label="Bias Current for " + str(targetV) + "mV = " + str(result))
    plt.legend(loc='upper left')
    plt.savefig("biasCurrent" + str(targetV) + ".png")

    return result

def getRestingV():
    init()
    t,v = runFor(500)

    crossings = getSpikeCount(v)

    if crossings > 1:
        print("No rest - cell produces multiple spikes without stimulation.")
        result = None
    else:
        result = v[-1]

    plt.clf()
    plt.plot(t, v, label="Resting V " + str(result))
    plt.legend()
    plt.savefig("restingV.png")

    return result

def connect_to_db():
    import os
    pwd = os.environ["NMLDBPWD"]  # This needs to be set to "the password"

    from sshtunnel import SSHTunnelForwarder

    server = SSHTunnelForwarder(
        ('149.169.30.15', 2200),  # Spike - testing server
        ssh_username='neuromine',
        ssh_password=pwd,
        remote_bind_address=('127.0.0.1', 3306)
    )

    server.start()

    import os
    from playhouse.db_url import connect

    db = connect('mysql://neuromldb2:' + pwd + '@127.0.0.1:' + str(server.local_bind_port) + '/neuromldb')
    return db

from peewee import *
class Cells(Model):
    Model_ID = CharField(primary_key=True)
    Is_Intrinsically_Spiking = BooleanField()
    Bias_Voltage = FloatField()

    class Meta:
        database = connect_to_db()

def save_cell_properties(cell):
    # Save or update
    try:
        Cells.get_by_id(cell.Model_ID)
        force_insert = False
    except:
        force_insert = True

    # Insert on first save
    cell.save(force_insert=force_insert)


setDt(stepsPerMs)
init()


# restingV = getRestingV()
#
# # For intrinsically spiking cells, threshold is undefined for the following reasons:
# # -A spike will result even if there is no stimulation
# # -Depending on where the cell is in its phase (since it's not resting, it will be either
# #  closer or further from firing, depending on time), a different current value will cause it to fire
#
# if restingV is None:
#     th, thSpikes = (None, None)
# else:
#     th, thSpikes = getThreshold(10)
#
# # Intrinisicaly spiking cells will have negative rheobase
# # Otherwise the rb will be below the threshold current
# if restingV is None:
#     rbMaxI = 0
# else:
#     rbMaxI = np.max(th)
#
# rb, rbSpikes = getRheobase(maxI = rbMaxI)
#
# bias60 = getBiasCurrent(targetV=-60)
# bias70 = getBiasCurrent(targetV=-70) # 0.2285
# bias80 = getBiasCurrent(targetV=-80)
#
# data = {
#     "thresholdLow": np.min(th),
#     "thresholdHigh": np.max(th),
#     "thresholdLowSpikes": np.min(thSpikes),
#     "thresholdHighSpikes": np.max(thSpikes),
#     "rheobaseLow": np.min(rb),
#     "rheobaseHigh": np.max(rb),
#     "rheobaseLowSpikes": np.min(rbSpikes),
#     "rheobaseHighSpikes": np.max(rbSpikes),
#     "rest": restingV,
#     "biasNeg60": bias60,
#     "biasNeg70": bias70,
#     "biasNeg80": bias80
# }
#
# pp(data)
#
# with open("CellProperties.json", "w") as outFile:
#     json.dump(data,outFile)