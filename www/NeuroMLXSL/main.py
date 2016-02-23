import lxml.etree as ET
import sys

def main():

    htmlNML1 = tryNML1()
    htmlNML2 = tryNML2()

    if htmlNML1.find('table') > 0:
        print(htmlNML1)

    elif htmlNML2.find('table') > 0:
        print(htmlNML2)

    else:
        print('Sorry, there is no HTML view available for this file. You may go back and view the raw XML file.')

def tryNML1():
    xml = ET.parse(sys.argv[1])
    xslt = ET.parse("/var/www/NeuroMLXSL/XSL/NeuroML_Level3_v1.8.1_HTML.xsl")
    #xslt = ET.parse("XSL/NeuroML_Level3_v1.8.1_HTML.xsl")
    transform = ET.XSLT(xslt)
    html = transform(xml)
    return str(html)

def tryNML2():
    xml = ET.parse(sys.argv[1])
    xslt = ET.parse("/var/www/NeuroMLXSL/XSL/NeuroML2_To_HTML.xsl")
    #xslt = ET.parse("XSL/NeuroML2_To_HTML.xsl")
    transform = ET.XSLT(xslt)
    html = transform(xml)
    return str(html)

if __name__ == "__main__":
    main()