from collections import defaultdict
import MySQLdb
from Classes.SearchResults import SearchResults
import database


class RubyInterfacer():

    def FormatForRuby(self, pythonResult):

        result = defaultdict(list)

        # Analyzing old code, these were all possible dictionary keys:
        #   "neurons in the same region" XXX
        #   "neurons from the same region" ***
        #   "neurons with the same neurotransmitter"
        #   "similar neurons"
        #
        # XXX - duplicate
        # *** - actually seen used on website

        # Get NeuroML model IDs from mysql db
        rows = self.GetNeuroMLids(pythonResult)

        # Build a NeuroLexUri -> ModelDBids dictionary
        models = {}
        for row in rows:
            if row[1] not in models:
                models[row[1]] = [row[0]]
            else:
                # Each uri can have more than one model
                models[row[1]].append(row[0])

        result["Gap Relationships"] = self.PopulateHeading(
            pythonResult.Relationships.GapRelationships,
            "gapObjectId",
            models
        )

        result["Direct Relationship Analogues"] = self.PopulateHeading(
            pythonResult.DirectRelationshipAnalogues,
            "id",
            models
        )

        result["Keyword Relations"] = self.PopulateHeading(
            pythonResult.KeywordRelations,
            "id",
            models
        )

        # # Fill out these
        # # result["neurons from the same region"]
        # # result["neurons with the same neurotransmitter"
        #
        # sameRegion = []
        # sameNeuroTrans = []
        # for analogue in pythonResult.DirectRelationshipAnalogues:
        #
        #     if analogue["id"] in models:
        #
        #         if analogue["relationship"].endswith("Located_in"):
        #             sameRegion.append(models[analogue["id"]])
        #
        #         elif analogue["relationship"].endswith("Neurotransmitter"):
        #             sameNeuroTrans.append(models[analogue["id"]])
        #
        # for keyword in pythonResult.KeywordRelations:
        #
        #     if keyword["id"] in models:
        #
        #         if keyword["relationship"].endswith("Located_in"):
        #             sameRegion.append(models[keyword["id"]])
        #
        #         elif keyword["relationship"].endswith("Neurotransmitter"):
        #             sameNeuroTrans.append(models[keyword["id"]])
        #
        # if len(sameRegion) > 0:
        #     result["neurons from the same region"] = sameRegion
        #
        # if len(sameNeuroTrans) > 0:
        #     result["neurons with the same neurotransmitter"] = sameNeuroTrans
        #
        # # Fill out this one
        # # result["similar neurons"]
        # similar = []
        # for gap in pythonResult.GapRelationships:
        #     if gap["gapObjectId"] in models:
        #         similar.append(models[gap["gapObjectId"]])
        #
        # if len(similar) > 0:
        #     result["similar neurons"] = similar

        return result

    def PopulateHeading(self, source, idProperty, models):

        result = []
        for line in source:
            if line[idProperty] in models:
                line["ModelIds"] = models[line[idProperty]]
                result.append(line)

        return result

    def GetNeuroMLids(self, pythonResult):

        connection = MySQLdb.connect("localhost", database.connection['user'], database.connection['password'], database.connection['db'])
        connection.autocommit(True)
        cursor = connection.cursor()

        with open("Queries/GetNeuroMLmodels.sql") as queryFile:
            query = queryFile.read()

            # Insert keyword ids into query
            query = query.replace("[NeuroLexUris]", self.GetNeuroLexUris(pythonResult))

        cursor.execute(query)
        result = cursor.fetchall()

        connection.commit()
        connection.close()

        return result


    def GetNeuroLexUris(self, pythonResult):

        uris = pythonResult.GetNeuroLexUris()

        # Surround with quotes
        result = []
        for uri in uris:
            result.append('"' + uri + '"')

        # CSV and line separate
        result = "\n , \n".join(result)

        return result
