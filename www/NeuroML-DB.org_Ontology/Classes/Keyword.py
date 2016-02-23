class Keyword:

    def __init__(self):

        self.SearchSet = []
        self.NLXuris = []
        self.SubRegions = []

    def GetKeywordAndSubregionUris(self):

        result = []

        result.extend(self.NLXuris)

        for subregion in self.SubRegions:
            result.append(subregion["id"])

        return result
