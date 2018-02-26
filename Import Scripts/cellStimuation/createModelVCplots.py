# Validate NML, createLEMS, simulate, create chart js, and validate js of a model
# Usage:
# To generate voltage clamp plots:
#
#    createModelVCplots.py path/to/channel.nml Na/Kv/Cav/Kca/Ih [dtInMs]
#
# NOTE: this script assumes and has only been tested on linux OS (Ubuntu 16)
# WHY??? Because the devs of the tools used here (e.g. jnml and neuron) mostly tested them on *nix
# Feel free to get them to work on mac or win, but...
# be prepared for an extended period of frequent WTF's

import pydevd
#pydevd.settrace('192.168.0.34', port=4200, stdoutToServer=True, stderrToServer=True, suspend=False)

import numpy as np
from matplotlib import pyplot as plt
import csv, re, sys, os
from decimal import Decimal
import traceback
from subprocess import Popen,PIPE
import os
import signal
import psutil

channelPath = os.path.abspath(sys.argv[1])
channelDir = os.path.dirname(channelPath)
protocol = sys.argv[2]

try:
    dt = sys.argv[3]
except IndexError:
    dt = "0.001"

def printAndRun(command):
    print('   "'+command +'"')

    import sys, time, datetime
    from subprocess import PIPE, Popen
    from threading import Thread

    try:
        from Queue import Queue, Empty
    except ImportError:
        from queue import Queue, Empty  # python 3.x

    ON_POSIX = 'posix' in sys.builtin_module_names

    def enqueue_output(out, queue):
        for line in iter(out.readline, b''):
            queue.put(line)
        out.close()

    started = False
    pid = 0
    p = Popen(command, shell=True, stdout=PIPE, bufsize=1, close_fds=ON_POSIX)
    q = Queue()
    t = Thread(target=enqueue_output, args=(p.stdout, q))
    t.daemon = True  # thread dies with the program

    lines = ""

    # read line without blocking

    # check if process is alive and if so, wait up to 5 mins for output
    # handle non-outputting short processes eg. rm ...
    # and long running, non-outputting processes like neuron run
    # and long running, hung processes that show an error

    checking_since = time.time()

    #Wait 5 mins at most for next line e.g during sims
    while not started or (t.isAlive() and time.time() - checking_since < 5*60):

        if not started:
            pid = p.pid
            t.start()
            started = True


        try:
            line = q.get_nowait()
        except Empty:
            time.sleep(0.01)

        else:  # got line
            lines = lines + line

            cleanOutput = line\
                .replace("NRN Error","") \
                .replace("NMODL Error", "") \
                .lower()


            errorsFound = 'error' in cleanOutput or \
                          'is not valid against the schema' in cleanOutput or \
                          'problem in model' in cleanOutput or \
                          'traceback' in cleanOutput or \
                          'out of range, returning exp' in cleanOutput

            if errorsFound:
                logFile = channelDir+"/chart.log"

                with(open(logFile,"w")) as f:
                    f.write(command)
                    f.write(lines)

                kill_proc_tree(pid)

            assert not errorsFound # See chart.log file in channel directory

def kill_proc_tree(pid, sig=signal.SIGTERM, include_parent=True,
                   timeout=None, on_terminate=None):
    """Kill a process tree (including grandchildren) with signal
    "sig" and return a (gone, still_alive) tuple.
    "on_terminate", if specified, is a callabck function which is
    called as soon as a child terminates.
    """
    if pid == os.getpid():
        raise RuntimeError("I refuse to kill myself")
    parent = psutil.Process(pid)
    children = parent.children(recursive=True)
    if include_parent:
        children.append(parent)
    for p in children:
        p.send_signal(sig)
    gone, alive = psutil.wait_procs(children, timeout=timeout,
                                    callback=on_terminate)
    return (gone, alive)

def cleanup():
    print("Cleaning up NEURON files")
    printAndRun('rm -f ' + channelDir + '/*.dat')
    printAndRun('rm -f ' + channelDir + '/*.py')
    printAndRun('rm -f ' + channelDir + '/*.hoc')
    printAndRun('rm -f ' + channelDir + '/*.log')
    cleanupMod()

def cleanupMod():
    printAndRun('rm -f ' + channelDir + '/*.mod')
    printAndRun('rm -f -R ' + channelDir + '/x86_64')

cleanup()

print("Validating channel NML " + channelPath)
printAndRun("jnml -validate '" + channelPath + "'")

print("Generating LEMS files for " + channelPath)
printAndRun('rm -f ' + channelDir + '/LEMS*.nml')
printAndRun("python createLEMS.py '" + channelPath + "' " + protocol + " " + dt)

print("Running simulations for " + channelPath)
lemsFiles = [file for file in os.listdir(channelDir) if file.startswith("LEMS") and file.endswith(".nml")]
for lemsFile in lemsFiles:
    cleanupMod()
    printAndRun('cd '+channelDir + '; jnml ' + lemsFile + ' -neuron -nogui -run')

print("Remove old JS files")
printAndRun('rm -f '+channelDir+'/*.js')

print("Generating chart JS files " + channelPath)
printAndRun('find '+channelDir+' -name "fileOut*" -exec python createChartJS.py "{}" \;')

cleanup()

print("Validating plots " + channelPath)
printAndRun('python validateChartJS.py '+channelDir)

