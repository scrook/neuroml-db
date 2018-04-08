# -*- coding: utf-8 -*-

from itertools import ifilter
import os;
import xml.etree.ElementTree as ET
import csv
import threading
import re

startFile = "LargeConns.net.nml"
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

def main():
    # import pydevd
    # pydevd.settrace('10.211.55.3', port=4200, stdoutToServer=True, stderrToServer=True)

    # Read the XML files and their includes, using depth-first traversal
    getFilesAndTheirDependencies(startFile)


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
                '(OpenSourceBrain,http://www.opensourcebrain.org/projects/thalamocortical),(ModelDB,https://senselab.med.yale.edu/ModelDB/showmodel.cshtml?model=45539)',
                'neurolexTerm',
                'neurolexURI',
                'keywords',
                'pubmedID',
                'Chaitanya Chintaluri,Daniel Wójcik,Eugenio Piasini,Helena Głąbska,Jacek Rogala,Michael Hines,Padraig Gleeson,Rokas Stanislovas,Subhasis Ray,Tomás Fernández Alfonso,Yates Buckley,Angus Silver',
                None
            ])

        resultFile.close()

    print("DONE")
    
def getFilesAndTheirDependencies(fileName):

    if fileName in includes:
        return

    #read xml
    filePath = "inputs/" + fileName
    tree = ET.parse(filePath)
    root = tree.getroot()

    #get list of children
    children = []
    for child in root:
        if(child.tag =="{http://www.neuroml.org/schema/neuroml2}include"):
            if(child.attrib['href']):
                children.append(child.attrib['href']);

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

if __name__ == "__main__":
    main()