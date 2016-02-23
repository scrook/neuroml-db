import json
import os
import sys
from Classes.RubyInterfacer import RubyInterfacer
from Classes.SearchModule import SearchModule

# If executing from Ruby code
if os.path.isdir("/home/neuromine/Neurolex_py"):
    os.chdir("/home/neuromine/Neurolex_py")

if os.path.isdir("/var/www/NeuroML-DB.org_Ontology"):
    os.chdir("/var/www/NeuroML-DB.org_Ontology")

def main():

    # Keywords are passed in as command parameters
    keywords = " ".join(sys.argv[1:])

    # keywords = 'cerebellum gaba'

    # Perform the ontology search
    result = SearchModule().Search(keywords)

    # Ruby expects a dictionary in this format:
    # {
    #   "Heading1": [ 'NeuroMLmodelId1', 'ModelId2' ],
    #   "Heading2": [ 'NeuroMLmodelId3', 'ModelId4' ],
    # }

    rubyResult = RubyInterfacer().FormatForRuby(result)

    # Ruby code consumes printed output
    print rubyResult

    # Workarounds for json serialization
    result.Keywords = result.Keywords.__dict__
    result.Relationships = result.Relationships.__dict__

    # For Debugging - Ruby ignores everything after the first set of { }'s
    print json.dumps(
        result.__dict__,
        sort_keys=True,
        indent=4,
        separators=(',', ': ')
    )

if __name__ == "__main__":
    main()
