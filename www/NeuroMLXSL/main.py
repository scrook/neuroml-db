import lxml.etree as ET
import sys
import re
import os

def main():

    #DEBUG
    #import pydevd
    #pydevd.settrace('10.211.55.3', port=4200, stdoutToServer=True, stderrToServer=True)

    # Read XML
    xml = ET.parse(sys.argv[1])

    try:
        # Get the xml schema version
        schemaURI = xml.getroot().get('{http://www.w3.org/2001/XMLSchema-instance}schemaLocation')
        match = re.match(r".*/(.*?_v)(\d)(.*?)\.xsd", schemaURI)
        schemaMainVersion = int(match.group(2))
        schemaFile = match.group(1) + match.group(2) + match.group(3)
    except:
        print("Sorry, could not determine the NeuroML schema from the XML file")

    # Get the corresponding XSL file
    xslFile = schemaFile + "_HTML.xsl"

    if schemaMainVersion == 2:
        xslFile = "NeuroML2_To_HTML.xsl"

    #xslFile = "XSL/" + xslFile
    xslFile = "/var/www/NeuroMLXSL/XSL/" + xslFile

    if not os.path.isfile(xslFile):
        print("Sorry, could not find a required XSL file: " + xslFile)
        return

    # Transform
    xsl = ET.parse(xslFile)
    transform = ET.XSLT(xsl)
    html = str(transform(xml))

    # Output HTML
    print(html)

if __name__ == "__main__":
    main()