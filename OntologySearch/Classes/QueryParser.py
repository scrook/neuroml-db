import difflib
from nltk.corpus import stopwords
from Classes.QueryStopwords import QueryStopwords
import re
import indexing


class QueryParser:
    def __init__(self):

        # Build the TermName<->Id index for quick close matches lookup
        self.TermIndex = indexing.build_index()
        self.TermIndexKeys = self.TermIndex.keys()

    def GetKeywordOntologyIds(self, keywords):

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
        matchingTerms = []
        for keyword in keywordList:
            matchingTerms.extend(
                difflib.get_close_matches(keyword, self.TermIndexKeys)
            )

        # Remove duplicate entries (if any)
        matchingTerms = list(set(matchingTerms))

        result = []

        # Build a list of NeuroLex ids corresponding to the keywords
        for keyword in matchingTerms:
            result.append(self.TermIndex[keyword])

        # Remove duplicate NLX ids (if any)
        result = list(set(result))

        return result

