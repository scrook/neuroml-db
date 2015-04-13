import lxml.etree as ET
import sys

def main():

    xml = ET.parse(sys.argv[1])
    xslt = ET.parse("/var/www/NeuroMLXSL/XSL/NeuroML_Level2_v1.8.1_HTML.xsl")
    transform = ET.XSLT(xslt)
    html = transform(xml)
    print(html)
    #print(ET.tostring(html, pretty_print=True))



if __name__ == "__main__":
    main()