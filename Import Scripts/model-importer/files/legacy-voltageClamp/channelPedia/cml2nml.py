from lxml.etree import parse, XSLT, tostring
import sys

try:
    infile = sys.argv[1]
    inss = sys.argv[2]
except:
    print "usage: cml2nml _fileToConvert_ _schema_"
    sys.exit(1)

try:
    dom = parse(infile)
except:
    print "can't parse infile " + infile
    sys.exit(1)
try:
    xslt = parse(inss)
except:
    print "can't parse stylesheet " + inss
    sys.exit(1)


transform = XSLT(xslt)
newdom = transform(dom)

print(tostring(newdom, pretty_print=True))
