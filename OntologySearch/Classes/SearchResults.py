

class SearchResults:

    def __init__(self):

        self.KeywordIds = []
        self.Relationships = []
        self.GapRelationships = []
        self.KeywordRelations = []
        self.DirectRelationshipAnalogues = []

    def GetNeuroLexUris(self):

        result = []

        result.extend(self.KeywordIds)

        for line in self.GapRelationships:
            result.append(line["gapObjectId"])

        for line in self.KeywordRelations:
            result.append(line["id"])

        for line in self.KeywordRelations:
            result.append(line["id"])

        # Dedup
        result = list(set(result))

        return result