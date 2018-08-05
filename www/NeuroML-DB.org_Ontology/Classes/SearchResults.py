

class SearchResults:

    def __init__(self):

        self.Keywords = []
        self.Relationships = []
        self.KeywordRelations = []
        self.DirectRelationshipAnalogues = []

    def GetNeuroLexUris(self):

        result = []

        result.extend(self.Keywords.GetKeywordAndSubregionUris())

        for line in self.Relationships.GapRelationships:
            result.append(line["gapObjectId"])

        for line in self.DirectRelationshipAnalogues:
            result.append(line["id"])

        for line in self.KeywordRelations:
            result.append(line["id"])

        # Dedup
        result = list(set(result))

        return result