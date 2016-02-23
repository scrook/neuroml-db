from Classes.RelationshipMap import RelationshipMap
from Classes.RelationshipCollection import RelationshipCollection
from Classes.SearchComponent import SearchComponent


class RelationshipIdentifier(SearchComponent):

    def GetDirectRelationships(self, keywords):

        # Search between keyword matches and subregions
        entities = keywords.GetKeywordAndSubregionUris()

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

    def GetGapRelationships(self, keywords):

        # No pairs if just one keyword
        if len(keywords) == 0:
            return []

        gapRelations = []

        # For every unique pair of keywords, specify the gap relations for which to look
        with open("Queries/FindGapRelationships.GapRelations.rq") as queryFile:

            gapRelationTemplate = queryFile.read()
            pairs = self.GetKeywordPairs(keywords)

            for pair in pairs:

                # Surround the values with "s and on separate lines
                gapRelations.append(
                    gapRelationTemplate
                    .replace("[End1Ids]", self
                             .SPARQLDB
                             .BuildValuesString(pair["End1"].GetKeywordAndSubregionUris())
                    )
                    .replace("[End2Ids]", self
                             .SPARQLDB
                             .BuildValuesString(pair["End2"].GetKeywordAndSubregionUris())
                    )
                )

        with open("Queries/FindGapRelationships.rq") as queryFile:
            query = queryFile.read()

            query = query.replace("[GapRelations]", "\n UNION \n".join(gapRelations))

        relationships = self.SPARQLDB.Query(query)

        # Add gap relationships to result list
        result = []
        for line in relationships:

            if "relationship1fwd" in line:
                relationship1 = RelationshipMap.Forward[line["relationship1fwd"]["value"]]
            else:
                relationship1 = RelationshipMap.Backward[line["relationship1back"]["value"]]

            if "relationship2fwd" in line:
                relationship2 = RelationshipMap.Forward[line["relationship2fwd"]["value"]]
            else:
                relationship2 = RelationshipMap.Backward[line["relationship2back"]["value"]]


            result.append({
                "end1": line["end1"]["value"],
                "end1id": line["end1id"]["value"],
                "relationship1": relationship1,
                "gapObject": line["gapObject"]["value"],
                "gapObjectId": line["gapObjectId"]["value"],
                "relationship2": relationship2,
                "end2": line["end2"]["value"],
                "end2id": line["end2id"]["value"],
            })

        return result

    def GetRelationships(self, parsedKeywords):

        result = RelationshipCollection()

        # One keyword will not have any other relationships
        if len(parsedKeywords) == 1:
            return result

        result.DirectRelationships = self.GetDirectRelationships(parsedKeywords)

        result.GapRelationships = self.GetGapRelationships(parsedKeywords)

        return result

    def GetKeywordPairs(self, keywords):

        # A start w A
        # B A-B         start w B
        # C A-C         B-C         start w C
        # D A-D         B-D         C-D

        pairs = []

        for o in range(len(keywords)):

            end1 = keywords[o]

            for i in range(o + 1, len(keywords)):

                end2 = keywords[i]

                pairs.append({"End1": end1, "End2": end2})

        return pairs