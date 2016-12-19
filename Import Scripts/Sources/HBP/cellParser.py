import os;
import xml.etree.ElementTree as ET
import csv
import threading
import re


#This function reads the file names and seperates the .cell.nml files from the rest of the files
def readfiles(): 
    print("Processing ",len(os.listdir(dir)))
    for filename in os.listdir(dir):
        if(filename.endswith(".cell.nml")):
            cellFiles.append(filename)

    cellFiles.sort()

def getPubMedId():
    #As we don't have any PubMed in cell files, we are using the default PubMed from the referred paper
    return "26451489"

def writeCellRows():

    cellIndex = 0
    cellIncludes = []

    for cellFile in cellFiles:

        print(cellFile)

        # Reuse includes from first cell, all cells have same includes
        if len(cellIncludes) == 0:
            cv = dir + cellFile;
            tree = ET.parse(cv);
            root = tree.getroot();

            for child in root:
                if(child.tag =="{http://www.neuroml.org/schema/neuroml2}include"):
                    if(child.attrib['href']):
                        cellIncludes.append(child.attrib['href']);

        modelName, neurolexTerms, neurolexIDs, keywords = parseAcronyms(cellFile)

        modelName = modelNameCleanup(modelName)

        [children_set.add(child) for child in cellIncludes]

        writeCellRow(modelName + " (" + str(cellIndex % 5 + 1) + ")", cellIncludes, cellFile, neurolexTerms, neurolexIDs, keywords)

        cellIndex += 1

def appendToFile(row): #
    resultFile = open("cells_data.csv", 'ab')
    wr = csv.writer(resultFile, dialect='excel')
    wr.writerow(row)
    resultFile.close();

def writeCellRow(modelName, cellIncludes,cellFile,neurolexTerms, neurolexIDs, keywords):
    row=[]
    row.append('CL')
    row.append(modelName)
    row.append(cellFile)
    row.append(','.join(cellIncludes))
    row.append('(BlueBrainProject,https://bbp.epfl.ch/nmc-portal/downloads)')
    row.append(neurolexTerms)
    row.append(neurolexIDs)
    row.append(keywords)
    row.append(getPubMedId())
    row.append('Padraig Gleeson')
    row.append('none')

    appendToFile(row)

def modelNameCleanup(name):
    return name.replace("Layer 2, Layer 3","Layer 2/3")

def parseAcronyms(filename):

    # Find the cell file acronyms
    match = re.match(r"(\w+?)(?:int)?\d+?_(\w+?)_((?:\w+?(?:_L1|_L4)|\w+?))_", filename)
    etype = match.group(1)
    layer = match.group(2)
    mtype = match.group(3)

    fullE, neurolexE, keywordsE = getAcronymData(etype)
    fullL, neurolexL, keywordsL = getAcronymData(layer)
    fullM, neurolexM, keywordsM = getAcronymData(mtype)

    return (fullL + " " + fullE + " " + fullM), \
           (fullE + "," + fullL + "," + fullM), \
           (neurolexE + "," + neurolexL + "," + neurolexM), \
           (keywordsE + "," + keywordsL + "," + keywordsM)

terms = []

def getAcronymData(acronym):

    # Cache the term mapping file
    if len(terms) == 0:
        with open('term_mapping.csv', 'rb') as f:
            reader = csv.reader(f)
            reader.next()
            for row in reader:
                terms.append(row)

    for row in terms:
        if(acronym == row[0]):
            return row[1],row[2],row[3]

    return "none","none","none"

def getAvailableChannels():
    channelChildren = set()
    with open('ChannelsReformat.csv', 'rb') as channels:
        reader = csv.reader(channels)
        reader.next()
        for row in reader:
            channelChildren.add(row[2])
    #print channelChildren
    return channelChildren

def nonExistingChannels(childCells, channelChildren):
    return childCells - channelChildren


if __name__ == "__main__":
    import pydevd
    pydevd.settrace('10.211.55.3', port=4200, stdoutToServer=True, stderrToServer=True)

    dir = cv = "cells/"    # path to cells folder
    cellFiles = []
    cell_channel ={}
    children_set = set()
    readfiles();
    resultFile = open("cells_data.csv", 'wb')
    wr = csv.writer(resultFile, 'excel')
    wr.writerow(['modelType', 'modelName', 'fileName', 'children', 'references', 'neurolexTerm', 'neurolexURI', 'keywords', 'pubmedID', 'translator', 'authors']);
    resultFile.close()
    writeCellRows();
    getAvailableChannels()
    print(nonExistingChannels(children_set, getAvailableChannels()))

