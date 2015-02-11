import difflib
from nltk.corpus import stopwords
from Classes.Keyword import Keyword
from Classes.KeywordCollection import KeywordCollection
from Classes.QueryStopwords import QueryStopwords
import re
from Classes.SearchComponent import SearchComponent
import indexing


class QueryParser(SearchComponent):
    def __init__(self):

        SearchComponent.__init__(self)

        # Build the TermName<->Id index for quick close matches lookup
        self.TermIndex = indexing.build_index()
        self.TermIndexKeys = self.TermIndex.keys()

    def ParseQuery(self, keywords):

        # Result will be a list of dictionaries with
        # parsed keywords & their related words
        result = KeywordCollection()

        keywords = keywords.lower()

        # Find all quoted phrases/words and lone words
        keywordList = re.findall(r'"[\w\s]+"|[\w]+', keywords)

        # Remove quotes
        for i in range(len(keywordList)):
            keywordList[i] = keywordList[i].replace('"', '')

        # Filter out English and custom stopwords
        keywordList = filter(
            lambda x:
                x not in stopwords.words('english') and
                x not in QueryStopwords.words,
            keywordList
        )

        # Find close matches to keywords in the database term index
        # and get their NeuroLexUris
        for keyword in keywordList:

            # First check if there is an exact keyword match
            if keyword in self.TermIndexKeys:
                searchSet = [keyword]

            # Otherwise find close matches
            else:
                searchSet = difflib.get_close_matches(keyword, self.TermIndexKeys)

            # Build a list of NeuroLex ids corresponding to the keywords
            neuroLexUris = []
            for member in searchSet:
                neuroLexUris.append(self.TermIndex[member])

            # Deduplicate
            neuroLexUris = list(set(neuroLexUris))

            # Find the keyword sub-regions (if any)
            subRegions = self.GetSubregions(neuroLexUris)

            # Store result in array of Keyword instances
            entry = Keyword()
            entry.RawKeyword = keyword
            entry.SearchSet = searchSet
            entry.NLXuris = neuroLexUris
            entry.SubRegions = subRegions

            result.append(entry)

        return result

    def GetSubregions(self, ids):

        # Find subregions with recursive SPARQL query
        with open("Queries/FindSubregions.rq") as queryFile:
            query = queryFile.read()

            # Surround the values with "s and on separate lines
            query = query.replace("[NeuroLexUris]", self.SPARQLDB.BuildValuesString(ids))

        subregions = self.SPARQLDB.Query(query)

        # Add subregions to result list
        result = []
        for subregion in subregions:
            result.append({
                "id": subregion["id"]["value"],
                "subregion": subregion["subregion"]["value"]
            })

        return result

