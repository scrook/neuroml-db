from Classes.RelationshipCollection import RelationshipCollection
from Classes.SearchComponent import SearchComponent


class RelationshipIdentifier(SearchComponent):

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

    def GetDirectRelationships(self, ids, subRegions):

        # Search between keyword matches and subregions
        entities = []
        entities.extend(ids)

        for region in subRegions:
            entities.append(region["id"])

        # Search for direct relationship
        with open("Queries/FindDirectRelationships.rq") as queryFile:
            query = queryFile.read()

            # Inject ids into the query
            query = query.replace(
                "[NeuroLexUris]",
                self.SPARQLDB.BuildValuesString(entities)
            )
            
        relationships = self.SPARQLDB.Query(query)

        # Add relationships to result list
        result = []
        for line in relationships:
            result.append({
                "id1": line["id1"]["value"],
                "name1": line["name1"]["value"],
                "relationship": line["relationship"]["value"],
                "id2": line["id2"]["value"],
                "name2": line["name2"]["value"],
            })

        return result


    def GetGapRelationships(self, ids, subRegions):

        # Search between keyword matches and subregions
        entities = []
        entities.extend(ids)

        for region in subRegions:
            entities.append(region["id"])

        # Search for gap relationships
        with open("Queries/FindGapRelationships.rq") as queryFile:
            query = queryFile.read()

            # Surround the values with "s and on separate lines
            query = query.replace("[NeuroLexUris]", self.SPARQLDB.BuildValuesString(entities))

        relationships = self.SPARQLDB.Query(query)

        # Remove A -> B -> C & C <- B <- A results
        relationships = self.RemoveDuplicateGapResults(relationships)

        # Add gap relationships to result list
        result = []
        for line in relationships:
            result.append({
                "end1": line["end1"]["value"],
                "end1id": line["end1id"]["value"],
                "relationship1": line["relationship1"]["value"],
                "gapObject": line["gapObject"]["value"],
                "gapObjectId": line["gapObjectId"]["value"],
                "relationship2": line["relationship2"]["value"],
                "end2": line["end2"]["value"],
                "end2id": line["end2id"]["value"],
            })

        return result

    def GetRelationships(self, parsedKeywords):

        result = RelationshipCollection()

        result.SubRegions = self.GetSubregions(parsedKeywords)

        # One keyword will not have any other relationships
        if len(parsedKeywords) == 1:
            return result

        result.DirectRelationships = self.GetDirectRelationships(parsedKeywords, result.SubRegions)

        if len(result.DirectRelationships) == 0:
            result.GapRelationships = self.GetGapRelationships(parsedKeywords, result.SubRegions)

        return result

    def RemoveDuplicateGapResults(self, relationships):

        result = []

        for line in relationships:

            forward = line["end1"]["value"] + \
                      line["gapObject"]["value"] + \
                      line["end2"]["value"]

            dupExists = False

            for line2 in result:

                backward = line2["end2"]["value"] + \
                           line2["gapObject"]["value"] + \
                           line2["end1"]["value"]

                if forward == backward:
                    dupExists = True

                    break

            if not dupExists:
                result.append(line)

        return result