# -*- coding: utf-8 -*-

from itertools import ifilter
import os;
import xml.etree.ElementTree as ET
import csv
import threading
import re

rootFiles = ["FiveCells.net.nml"]
#startFile = "test.net.nml"

typeMap = \
    [
        ("net.nml", "NT"),
        ("cell.nml", "CL"),
        ("synapse.nml", "SY"),
        ("channel.nml", "CH")
    ]

firstRow = \
    [
        'modelType',
        'modelName',
        'fileName',
        'children',
        'references',
        'neurolexTerm',
        'neurolexURI',
        'keywords',
        'pubmedID',
        'translators',
        'authors'
    ]

files = []
includes = {}
startPath = os.getcwd() + "/inputs/"

def main():
    import pydevd
    pydevd.settrace('10.211.55.3', port=4200, stdoutToServer=True, stderrToServer=True)

    os.chdir(startPath)

    # Read the XML files and their includes, using depth-first traversal
    for rootFile in rootFiles:
        getFilesAndTheirDependencies(rootFile)

    os.chdir(startPath + "..")

    with open("output/output.csv", 'wb') as resultFile:
        wr = csv.writer(resultFile, 'excel')
        wr.writerow(firstRow);

        # Write model rows
        for file in files:
            fileIncludes = includes[file]

            # Determine the model type, if possible, from file name. XX = unknown
            type = "XX"

            for row in typeMap:
                if file.endswith(row[0]):
                    type = row[1]

            wr.writerow(\
            [
                type,
                'model name',
                file,
                ','.join(fileIncludes),
                'referenses',
                'neurolexTerm',
                'neurolexURI',
                'keywords',
                'pubmedID',
                'translators',
                None
            ])

        resultFile.close()

    print("DONE")
    
def getFilesAndTheirDependencies(fileName):

    if fileName in includes:
        return

    #read xml
    tree = ET.parse(startPath + fileName)
    root = tree.getroot()

    #get list of children
    children = []
    parentDir = os.path.dirname(fileName)
    for child in root:
        if(child.tag =="{http://www.neuroml.org/schema/neuroml2}include"):
            if(child.attrib['href']):
                href = child.attrib['href']
                childPath = ("" if parentDir == '' else parentDir + "/") + href
                children.append(os.path.normpath(childPath));

    tree = None
    root = None

    # distinct them
    children = sorted(list(set(children)))

    # repeat for each include
    for node in children:
        getFilesAndTheirDependencies(node)

    # append to result
    print("Adding: " + fileName)
    files.append(fileName)
    includes[fileName] = children

def relativeToStartPath(fileName):
    return os.path.abspath(os.path.basename(fileName)).replace(startPath,"")

if __name__ == "__main__":
    main()