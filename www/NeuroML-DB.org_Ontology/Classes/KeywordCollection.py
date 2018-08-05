
class KeywordCollection(list):

    def GetKeywordAndSubregionUris(self):

        result = []

        for keyword in self:

            result.extend(keyword.GetKeywordAndSubregionUris())

        return result