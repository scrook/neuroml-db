import sys, re, os

# usage: python createLEMS.py ChannelFile.nml Na/Kv/Cav/Kca/Ih [vLow] [vHigh]

path = sys.argv[1]
channelClass = sys.argv[2]

DirName = os.path.dirname(os.path.abspath(path))
FileName = os.path.basename(path)

# want to perform each sub-protocol separatelly @ each concentration level
# need to create separate LEMS files for each run LEMS_channelName_CaConc_Activation_..._.nml

vLow = -50 if len(sys.argv) <= 3 else int(sys.argv[3])
vHigh = 100 if len(sys.argv) <= 4 else int(sys.argv[4])

protocols = {
    "Kv": { "CaLevels": ["1E0 mM"], "Ion": "", "Activation": {}, "Inactivation": {}, "Deactivation": {} },
    "Na": { "CaLevels": ["1E0 mM"], "Ion": "", "Activation": {}, "Inactivation": {}, "Deactivation": {} },
    "Cav": { "CaLevels": ["1E0 mM"], "Ion": "", "Activation": {}, "Inactivation": {}, "Deactivation": {} },
    "Kca": { "CaLevels": ["1E0 mM"], "Ion": "", "Activation": {}, "Inactivation": {}, "Deactivation": {} },
    "Ih": { "CaLevels": ["1E0 mM"], "Ion": "", "Activation": {}, "Inactivation": {}, "Deactivation": {} }
}

protocols["Kv"]["Ion"] = { "Species": "k",    "ReversalE": "-86.7 mV" }
protocols["Na"]["Ion"] = { "Species": "na",   "ReversalE":  "50   mV" }
protocols["Kca"]["Ion"] = { "Species": "k",   "ReversalE": "-86.7 mV" }
protocols["Cav"]["Ion"] = { "Species": "ca",  "ReversalE": "135   mV" }
protocols["Ih"]["Ion"] = { "Species": "h",    "ReversalE": "-45   mV" }

# Protocols taken from ICG paper (pgs. 21 & 51): http://biorxiv.org/content/biorxiv/early/2016/06/16/058685.full.pdf

# ---- Activation Protocols ----
protocols["Kv"]["Activation"] = protocols["Kca"]["Activation"] = protocols["Cav"]["Activation"] = {
    "restStartDuration":    "100ms",
    "step1Duration":        "500ms",
    "step2Duration":        "0ms",  # One step only
    "restEndDuration":      "100ms",
    "restV":                "-80mV",
    "step1Vlow":            "-80mV",
    "step1Vhigh":           "70mV",
    "step2V":               "-80mV",  # Doesn't matter, but required
    "roiStart":             "95ms",
    "roiEnd":               "700ms",
}

protocols["Na"]["Activation"] = {
    "restStartDuration":    "20ms",
    "step1Duration":        "50ms",
    "step2Duration":        "0ms",
    "restEndDuration":      "30ms",
    "restV":                "-80mV",
    "step1Vlow":            "-80mV",
    "step1Vhigh":           "70mV",
    "step2V":               "-80mV",
    "roiStart":             "18ms",
    "roiEnd":               "100ms"
}

protocols["Ih"]["Activation"] = {
    "restStartDuration":    "100ms",
    "step1Duration":        "2000ms",
    "step2Duration":        "0ms",
    "restEndDuration":      "100ms",
    "restV":                "-40mV",
    "step1Vlow":            "-150mV",
    "step1Vhigh":           "0mV",
    "step2V":               "-40mV",
    "roiStart":             "95ms",
    "roiEnd":               "2130ms"
}


# ---- Inactivation Protocols ----
protocols["Kv"]["Inactivation"] = protocols["Kca"]["Inactivation"] = protocols["Cav"]["Inactivation"] = protocols["Na"]["Inactivation"] = {
    "restStartDuration":    "100ms",
    "step1Duration":        "1500ms",
    "step2Duration":        "50ms",
    "restEndDuration":      "100ms",
    "restV":                "-80mV",
    "step1Vlow":            "-40mV",
    "step1Vhigh":           "70mV",
    "step2V":               "30mV",
    "roiStart":             "1580ms",
    "roiEnd":               "1750ms"
}

protocols["Ih"]["Inactivation"] = {
    "restStartDuration":    "100ms",
    "step1Duration":        "1000ms",
    "step2Duration":        "300ms",
    "restEndDuration":      "100ms",
    "restV":                "-40mV",
    "step1Vlow":            "-150mV",
    "step1Vhigh":           "-40mV",
    "step2V":               "-120mV",
    "roiStart":             "1095ms",
    "roiEnd":               "1500ms"
}


# ---- Deactivation Protocols ----
protocols["Kv"]["Deactivation"] = protocols["Kca"]["Deactivation"] = protocols["Cav"]["Deactivation"] = {
    "restStartDuration":    "100ms",
    "step1Duration":        "300ms",
    "step2Duration":        "200ms",
    "restEndDuration":      "100ms",
    "restV":                "-80mV",
    "step1V":               "70mV",
    "step2Vlow":            "-100mV",
    "step2Vhigh":           "40mV",
    "roiStart":             "380ms",
    "roiEnd":               "700ms"
}

protocols["Na"]["Deactivation"] = {
    "restStartDuration":    "20ms",
    "step1Duration":        "10ms",
    "step2Duration":        "30ms",
    "restEndDuration":      "20ms",
    "restV":                "-80mV",
    "step1V":               "70mV",
    "step2Vlow":            "-100mV",
    "step2Vhigh":           "40mV",
    "roiStart":             "29ms",
    "roiEnd":               "80ms"
}

protocols["Ih"]["Deactivation"] = {
    "restStartDuration":    "100ms",
    "step1Duration":        "1500ms",
    "step2Duration":        "500ms",
    "restEndDuration":      "400ms",
    "restV":                "-40mV",
    "step1V":               "-140mV",
    "step2Vlow":            "-110mV",
    "step2Vhigh":           "0mV",
    "roiStart":             "1595ms",
    "roiEnd":               "2105ms"
}

# Ca levels for KCa channels
protocols["Kca"]["CaLevels"] = ["1E-2 mM", "3.2E-3 mM", "1E-3 mM", "3.2E-4 mM", "1E-4 mM", "3.2E-5 mM", "1E-5 mM" ]

# Number of vclamp voltage steps
steps = 12

# Templates
clampTemplate = \
'   <voltageClampProtocol id="[ClampID]" \n'+ \
'       active = "1" \n'+ \
'        delay="[restStartDuration]" duration1="[step1Duration]" duration2="[step2Duration]" \n'+ \
'        restingVoltage="[restV]" \n'+ \
'        voltage1="[step1V]" \n'+ \
'        voltage2="[step2V]" \n'+ \
'        simpleSeriesResistance="1e0 ohm"/> \n'

populationTemplate = \
'   <population id="[ClampID]_pop" component="TestCell" type="populationList" size="1"> \n'+ \
'       <instance id="0"> \n'+ \
'           <location x="0" y="0" z="0"/> \n'+ \
'       </instance> \n'+ \
'   </population> \n'+ \
'   <inputList id="[ClampID]_input" component="[ClampID]" population="[ClampID]_pop"> \n'+ \
'       <input id="0" target="../[ClampID]_pop/0/TestCell" destination="synapses"/> \n'+ \
'   </inputList> \n'


voltagePlotTemplate = '<Line id="[ClampID]" timeScale="1 ms" quantity="[ClampID]_pop/0/TestCell/v" scale="1"/> \n'
currentPlotTemplate = '<Line id="[ClampID]" timeScale="1 ms" quantity="[ClampID]_pop/0/TestCell/biophys/membraneProperties/channel/iDensity" scale="1"/> \n'
conductancePlotTemplate = '<Line id="[ClampID]" timeScale="1 ms" quantity="[ClampID]_pop/0/TestCell/biophys/membraneProperties/channel/gDensity" scale="1" /> \n'

voltageOutputTemplate = '<OutputColumn id="[ClampID]_v" quantity="[ClampID]_pop/0/TestCell/v" />\n'
currentOutputTemplate = '<OutputColumn id="[ClampID]_i" quantity="[ClampID]_pop/0/TestCell/biophys/membraneProperties/channel/iDensity" />\n'
conductanceOutputTemplate = '<OutputColumn id="[ClampID]_g" quantity="[ClampID]_pop/0/TestCell/biophys/membraneProperties/channel/gDensity" />\n'

def replaceTokens(target, reps):
    result = target
    for r in reps.keys():
        result = result.replace(r,str(reps[r]))
    return result

# Find the NML id of the channel
with open(path) as f:
    nml = f.read()
    ChannelName = re.search('<ionChannel.*?id="(.*?)"',nml).groups(1)[0]

classProtocol = protocols[channelClass]

#from pprint import pprint as pp
#pp(protocols)

# For every [Ca2+] level, perform the activation, inactivation, and deactivation vclamp protocols
for caConc in classProtocol["CaLevels"]:
    for subProtocolName in ["Activation", "Inactivation", "Deactivation"]:
        subProtocol = classProtocol[subProtocolName]
        
        clampLines = ""
        populationLines = ""
        vPlotLines = ""
        iPlotLines = ""
        gPlotLines = ""
        vOutLines = ""
        iOutLines = ""
        gOutLines = ""

        caConcShort = caConc.replace(" ","").replace("-","minus").replace(".","point")
        
        vHigh = float(subProtocol["step1Vhigh" if subProtocolName != "Deactivation" else "step2Vhigh"].replace("mV",""))
        vLow  = float(subProtocol["step1Vlow"  if subProtocolName != "Deactivation" else "step2Vlow"].replace("mV",""))

        stepSize = (vHigh - vLow) / (steps-1.0)
        
        SimDuration = sum([float(e.replace("ms","")) for e in [subProtocol["restStartDuration"],subProtocol["step1Duration"],subProtocol["step2Duration"],subProtocol["restEndDuration"]]])
        
        for step in range(steps):
            vTarget = vLow + stepSize*step

            replacements = { \
                "[FileName]": FileName, \
                "[ChannelName]":ChannelName, \
                "[ClampID]": "caconc"+caConcShort+"_protocol"+subProtocolName+"_step"+str(step),\
                "[CaConc]": caConc, \
                "[Ion]":classProtocol["Ion"]["Species"], \
                "[ReversalE]":classProtocol["Ion"]["ReversalE"], \
                "[restStartDuration]":subProtocol["restStartDuration"], \
                "[step1Duration]":subProtocol["step1Duration"], \
                "[step2Duration]":subProtocol["step2Duration"], \
                "[restEndDuration]": subProtocol["restEndDuration"], \
                "[restV]":subProtocol["restV"], \
                "[step1V]":str(vTarget)+"mV" if subProtocolName != "Deactivation" else subProtocol["step1V"], \
                "[step2V]":str(vTarget)+"mV" if subProtocolName == "Deactivation" else subProtocol["step2V"], \
                "[SimDuration]": str(SimDuration) + "ms", \
                "[xmin]": 0, \
                "[xmax]": SimDuration \
            }

            clampLines = clampLines + replaceTokens(clampTemplate, replacements) + "\n"
            populationLines = populationLines + replaceTokens(populationTemplate, replacements) + "\n"
            
            vPlotLines = vPlotLines + replaceTokens(voltagePlotTemplate, replacements) + "\n"
            iPlotLines = iPlotLines + replaceTokens(currentPlotTemplate, replacements) + "\n"
            gPlotLines = gPlotLines + replaceTokens(conductancePlotTemplate, replacements) + "\n"

            vOutLines = vOutLines + replaceTokens(voltageOutputTemplate, replacements) + "\n"
            iOutLines = iOutLines + replaceTokens(currentOutputTemplate, replacements) + "\n"
            gOutLines = gOutLines + replaceTokens(conductanceOutputTemplate, replacements) + "\n"

        replacements["[VoltageClamps]"] = clampLines
        replacements["[Populations]"] = populationLines
        replacements["[VoltagePlots]"] = vPlotLines
        replacements["[ConductancePlots]"] = gPlotLines
        replacements["[CurrentPlots]"] = iPlotLines
        replacements["[FileColumns]"] = vOutLines + iOutLines + gOutLines
        replacements["[OutFile]"] = "fileOut_ca" + caConcShort + "_" + subProtocolName + "_%s_%s"%(vLow,vHigh) + "_%s_%s"%(subProtocol["roiStart"].replace("ms",""),subProtocol["roiEnd"].replace("ms","")) + ".dat"

        with open("LEMS_Template.xml") as t:
            template = t.read()

        for r in replacements:
            template = template.replace(r,str(replacements[r]))

        outFile = DirName + "/LEMS_" + caConcShort + "_" + subProtocolName + "_" + FileName
        
        with open(outFile, "w") as outF:
            outF.write(template)
