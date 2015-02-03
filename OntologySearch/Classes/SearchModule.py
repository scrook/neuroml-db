from Classes.QueryParser import QueryParser
from Classes.Recommender import Recommender
from Classes.RelationshipIdentifier import RelationshipIdentifier
from Classes.SPARQLDB import SPARQLDB
from Classes.SearchResults import SearchResults


class SearchModule:

    def __init__(self):
        self.Parser = QueryParser()
        self.Identifier = RelationshipIdentifier()
        self.Recommender = Recommender()

    def Search(self, keywords):

        # Find id's of close matches to the keywords
        keywordIds = self.Parser.GetKeywordOntologyIds(keywords)

        # Look for direct and gap relationships between the terms
        relationships = self.Identifier.GetRelationships(keywordIds)

        results = SearchResults()

        # If found gap objects, show them
        if len(relationships.GapRelationships) > 0:

            results.GapRelationships = relationships.GapRelationships

        else:

            # If there are direct rels between search terms/subregions
            # Find analogue objects
            if len(relationships.DirectRelationships) > 0:

                results.DirectRelationshipAnalogues = self \
                    .Recommender \
                    .RunAnaloguesQuery(relationships.DirectRelationships)

            # If no gaps or direct relationships
            # Show objects related to the keywords via Located_in | Neurotransmitter
            else:
                results.KeywordRelations = self \
                    .Recommender \
                    .FindKeywordRelations(keywordIds)

        return results