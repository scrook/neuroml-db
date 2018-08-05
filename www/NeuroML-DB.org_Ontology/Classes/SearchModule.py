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

    def Search(self, query):

        results = SearchResults()

        # Parse query, get close matches, and their NLX uris
        results.Keywords = self.Parser.ParseQuery(query)

        # Look for direct and gap relationships between the terms
        results.Relationships = self.Identifier.GetRelationships(results.Keywords)

        # If there are direct rels between search terms/subregions
        # Find analogue objects
        if len(results.Relationships.DirectRelationships) > 0:

            results.DirectRelationshipAnalogues = self \
                .Recommender \
                .RunAnaloguesQuery(results.Relationships.DirectRelationships)

        # If no gaps or direct relationships
        # Show objects related to the keywords via Located_in | Neurotransmitter
        results.KeywordRelations = self \
            .Recommender \
            .FindKeywordRelations(results.Keywords)

        return results