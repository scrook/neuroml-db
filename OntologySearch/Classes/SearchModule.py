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

        results = SearchResults()

        # Find id's of close matches to the keywords
        results.KeywordIds = self.Parser.GetKeywordOntologyIds(keywords)

        # Look for direct and gap relationships between the terms
        results.Relationships = self.Identifier.GetRelationships(results.KeywordIds)

        # If found gap objects, show them
        if len(results.Relationships.GapRelationships) > 0:

            results.GapRelationships = results.Relationships.GapRelationships

        else:

            # If there are direct rels between search terms/subregions
            # Find analogue objects
            if len(results.Relationships.DirectRelationships) > 0:

                results.DirectRelationshipAnalogues = self \
                    .Recommender \
                    .RunAnaloguesQuery(results.Relationships.DirectRelationships)

            # If no gaps or direct relationships
            # Show objects related to the keywords via Located_in | Neurotransmitter
            else:
                results.KeywordRelations = self \
                    .Recommender \
                    .FindKeywordRelations(results.KeywordIds)

        # Workaround for json serialization
        results.Relationships = results.Relationships.__dict__

        return results