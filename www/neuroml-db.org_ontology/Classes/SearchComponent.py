from Classes.SPARQLDB import SPARQLDB


class SearchComponent:

    """Abstract class from which other search module components inherit"""

    def __init__(self):

        # Setup SPARQL db access
        self.SPARQLDB = SPARQLDB()