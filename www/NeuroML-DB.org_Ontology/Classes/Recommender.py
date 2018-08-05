from Classes.RelationshipMap import RelationshipMap
from Classes.SearchComponent import SearchComponent


class Recommender(SearchComponent):

    def RunAnaloguesQuery(self, relationships):

        # Find neurons that have the same relationship to the object
        unions = self.ConstructRelationshipQueryUnions(relationships)

        # Find analogue triples
        with open("Queries/FindAnalogues.rq") as queryFile:
            query = queryFile.read()

            # Insert the union statements into the query
            query = query.replace("[RelationshipUnions]", unions)
            
        analogues = self.SPARQLDB.Query(query)

        # Add analogues to results
        result = []
        for analogue in analogues:
            result.append({
                "id": analogue["id"]["value"],
                "name": analogue["neuron"]["value"],
                "relationship": RelationshipMap.Forward[analogue["relationship"]["value"]],
                "relationshipTo": analogue["object"]["value"],
            })

        return result

    def FindKeywordRelations(self, parsedKeywords):

        # Search between keyword matches and subregions
        entities = parsedKeywords.GetKeywordAndSubregionUris()

        # Use Neurotransmitter and located_in to find related to KEYWORDS
        with open("Queries/FindRelationsToKeywords.rq") as queryFile:
            query = queryFile.read()

            # Insert keyword ids into query
            query = query.replace(
                "[NeuroLexUris]",
                self.SPARQLDB.BuildValuesString(entities)
            )

        relations = self.SPARQLDB.Query(query)

        # Add keyword relations to results
        result = []
        for relation in relations:

            if "forward" in relation:
                relationship = RelationshipMap.Forward[relation["forward"]["value"]]
            else:
                relationship = RelationshipMap.Backward[relation["backward"]["value"]]

            result.append({
                "id": relation["id"]["value"],
                "name": relation["keyword"]["value"],
                "relationship": relationship
            })

        return result

    def ConstructRelationshipQueryUnions(self, relationships):

        with open("Queries/FindAnalogues.RelationshipUnions.rq") as queryFile:
            unionBlockTemplate = queryFile.read()

        entries = []
        for relationship in relationships:

            entry = unionBlockTemplate \
                .replace("[Relationship]", relationship["relationship"]) \
                .replace("[NeuroLexId]", relationship["id2"])

            entries.append(entry)

        result = "\n UNION \n".join(entries)

        return result