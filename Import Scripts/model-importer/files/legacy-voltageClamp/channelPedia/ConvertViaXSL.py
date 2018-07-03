#
#   A simple file for converting any XML file via an XSL stylesheet
#
#   Author: Padraig Gleeson
#
#   This file has been developed as part of the neuroConstruct project
#   This work has been funded by the Medical Research Council and Wellcome Trust
#
#

import sys, os


# This can be changed to any local file or a public URL for the default XSL transformation. 
# The -xsl command line option overrides this 

defaultXSLfile = 'ChannelML2NeuroML2beta.xsl'    # or use local copy


# Preferred suffix for generated files
targetFileSuffix = 'nml'

# Flag definitions
fileFlag = '-f'
xslFlag = '-xsl'

# Needed for usage information
myFileName = 'ConvertViaXSL.py'




currentXSLfile = defaultXSLfile
currentXMLfiles = []
targetFiles = []
compileMod = 0



def usageInfo():

    print "Usage: \n\n"+  \
              "      python "+myFileName+" [xmlFile ["+fileFlag+" targetFile] ] ["+xslFlag+" xslFile] \n\n" + \
              "  This will use xslFile to transform xmlFile to file with name targetFile, or a *."+targetFileSuffix+" file if no targetFile specified.\n" + \
              "  If no xmlFile is present, will transform all *.xml files in current dir to files of form *."+targetFileSuffix+".\n" + \
              "  If no xslFile is present will use: "+defaultXSLfile
      
      
      
# Attempt to find 4suite libraries, and throw error if not found
try:
    from Ft.Xml.Xslt import Processor
    from Ft.Xml import InputSource
    from Ft.Lib.Uri import OsPathToUri  
except ImportError, detail:
    print "Error on import: "+ str(detail)
    print "Please download the Python libraries for handling XSL transformations from: http://www.4suite.org (or http://sourceforge.net/projects/foursuite)"
    print "Get the zip/tar file (e.g. 4Suite-XML-1.0.2.zip), unpack it and run: python setup.py install. "
    print "For Debian based Linux, e.g. Ubuntu, use package python-4suite-xml. "
    exit()
    
    

# Check through arguments
compileInfo = ""
remainingArgs = []

if len(sys.argv) == 1:
    usageInfo()
    exit()

argCount = 1 
while argCount <= len(sys.argv)-1:

    if sys.argv[argCount] == fileFlag:
        targetFiles.append(sys.argv[argCount+1])
        argCount = argCount +1
        
    elif sys.argv[argCount] == xslFlag:
        currentXSLfile = sys.argv[argCount+1]
        argCount = argCount +1
        
    else:
        remainingArgs.append(sys.argv[argCount])
        
    argCount = argCount +1
    

if len(remainingArgs)==1 and (remainingArgs[0] == '-?' or remainingArgs[0] == '-h' or remainingArgs[0] == '--help'):
    usageInfo()
    exit()

elif len(remainingArgs)==1:
    currentXMLfiles.append(remainingArgs[0])
    if len(targetFiles) == 0:
        targetFiles.append(remainingArgs[0][0:len(remainingArgs[0])-3]+targetFileSuffix)
    
elif len(remainingArgs)==0:
    fileList = os.listdir(os.getcwd())
    for file in fileList:
        if file.endswith('.xml') and file != 'properties.xml':    # properties.xml is used in neuroConstruct cellMechanism folders...
            currentXMLfiles.append(file)    
            targetFiles.append(file[0:len(file)-3]+targetFileSuffix)
    
    
else:
    print "error. Wrong number of arguments: "+str(sys.argv)
    usageInfo()
    exit()
    
    
    
print "Converting XML file(s): "+str(currentXMLfiles)+" to "+str(targetFiles)+" using XSL file: "+ currentXSLfile+compileInfo


# Load in source and stylesheet file and transform
processor = Processor.Processor()

ssAsUri = ""
if currentXSLfile.count('http') >0 or currentXSLfile.count('www') > 0:    # web location
    ssAsUri = currentXSLfile
else:
    ssAsUri = OsPathToUri(currentXSLfile)                                # local file
    
transform = InputSource.DefaultFactory.fromUri(ssAsUri)

processor.appendStylesheet(transform)


for i in range(0,len(currentXMLfiles)):

    srcAsUri = OsPathToUri(currentXMLfiles[i])
    source = InputSource.DefaultFactory.fromUri(srcAsUri)

    result = processor.run(source)
    
    out_file = open(targetFiles[i], "w")
    out_file.write(result)
    out_file.close()
        

