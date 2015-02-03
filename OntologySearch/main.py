import json
import sys
from Classes.SearchModule import SearchModule

def main():

    # Keywords are passed in as command parameters
    keywords = "".join(sys.argv[1:])

    #keywords = 'purkinje cerebellum'


    # Perform the ontology search
    result = SearchModule().Search(keywords)

    # Printed results are captured by calling code
    print json.dumps(
        result.__dict__,
        sort_keys=True,
        indent=4,
        separators=(',', ': ')
    )

if __name__ == "__main__":
    main()