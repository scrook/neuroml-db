# Usage createChartJS.py "fileOut...dat"
# Will replace the .dat file with a
# sub-sampled .JS file in a format usable by the Chart.js library

removeDat = True

import csv, re, sys, os
from decimal import Decimal

path = sys.argv[1]
DirName = os.path.dirname(os.path.abspath(path))
FileName = os.path.basename(path)

print("Converting to JavaScript: "+path)

# Parse file name for parameters e.g. fileOut_ca1E0mM_Activation_-150.0_0.0_95_2130.dat
m = re.search(r"_ca(.*?)mM_(.*?)_(.*?)_(.*?)_(.*?)_(.*?).dat", FileName)
caConc = m.group(1).replace("minus","-").replace("point",".")
subProtocol = m.group(2)
vLow = int(float(m.group(3)))
vHigh = int(float(m.group(4)))
roiStart = int(m.group(5))
roiEnd = int(m.group(6))

data = []

# This shortens expression for a number (using 3 sig figs)
def shortString(x):
    return str(float('%.2E' % Decimal(x)))

# Count the number of rows
rowCount = 0
maxTime = 0
with open(path) as f:
    reader = csv.reader(f, delimiter="\t")
    for i, line in enumerate(reader):
        rowCount = rowCount + 1
        maxTime = float(line[0])*1000

# Sub-sample 150 rows
# subsampling of v and ig differently
# v subsample is from the whole file
# ig is from just the window in the roi
# 1 V
# 2
# 3 V
# 4   G I
# 5 V
# 6   G I
# need a v cursor and ig cursor
# keep rows based on match on either or both cursors

desiredRows = 150.0
vstep = int(rowCount / desiredRows)
vcursor = 0

rowsPerMs = rowCount / maxTime
igcursor = int(rowsPerMs * roiStart)
igstep = int((rowCount-igcursor) / desiredRows)

with open(path) as f:
    reader = csv.reader(f, delimiter="\t")
    for i, line in enumerate(reader):
        
        # Append whole line if matches both
        if i == vcursor and i == igcursor:
            data.append(line)
            vcursor = vcursor + vstep
            igcursor = igcursor + igstep
    
        # Append just the voltage
        elif i == vcursor :
            data.append(line[0:13])
            vcursor = vcursor + vstep
        
        # Just the ig values, leaving vs as Nones
        elif i == igcursor:
            data.append([line[0]]+([None]*12)+line[13:37])
            igcursor = igcursor + igstep



# Convert units time*1000, voltage*1000
# There are 3*12+1 columns. 1 time col, and 12*3 cols for each plot type
rowsProcessed = 0
try:
    for row in data:
        row[0] = float(row[0])*1000 # time
        row[1:13] = [float(e)*1000 if e != None else None for e in row[1:13]] #voltage
        row[13:25] = [float(e) if e != None else None for e in row[13:25]] #current
        row[25:37] = [float(e) if e != None else None for e in row[25:37]] #conductance
        
        rowsProcessed = rowsProcessed + 1
except:
    data = data[0:rowsProcessed]

# Format each column as {x:t0,y:321},{x:t1,y:321}...
dataStrings = []

for col in range(1,37):
    label = ((col-1)%12)*(vHigh-vLow)/10 + vLow
    intensity = ((col-1)%12)*50 - 250
    if intensity < 0:
        color = 'rgba(0,0,'+ str(-intensity) +',1)'
    else:
        color = 'rgba('+ str(intensity) +',0,0,1)'

    dataString = "label:'"+ str(label) +" mV', backgroundColor:'"+color+"', borderColor:'"+color+"', data:["

    for row in data:
        time = row[0]
        if col < len(row) and row[col] != None:
            dataString = dataString + "{{x:{},y:{}}},".format(time,shortString(row[col]))

    dataString = dataString + "]"
    dataStrings.append([col,dataString])

# Write reformated file
with open(DirName + "/vclamp_"+caConc+"_"+subProtocol+"_%s_%s"%(roiStart,roiEnd)+".js","w") as f:
    for row in dataStrings:
        col = row[0]

        if col == 1:
            f.write("var voltages = { datasets: [\n")
        if col == 13:
            f.write("]};\n")
            f.write("var currents = { datasets: [\n")
        if col == 25:
            f.write("]};\n")
            f.write("var conductances = { datasets: [\n")

        f.write("{" + row[1] + "},\n")

    f.write("]};\n")

if removeDat:
    os.remove(path)
