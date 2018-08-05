from collections import defaultdict
import MySQLdb
from Classes.SearchResults import SearchResults
import database


class RubyInterfacer():

    def FormatForRuby(self, pythonResult):

        result = defaultdict(list)

        # Get NeuroML model IDs from mysql db
        rows = self.GetNeuroMLids(pythonResult)

        # Build a NeuroLexUri -> ModelDBids dictionary
        # and ModelID->Name Table
        models = {}
        modelNames = {}

        for row in rows:
            #For each nlx, store the list of model IDs
            if row[1] not in models:
                models[row[1]] = [row[0]]
            else:
                # Each uri can have more than one model
                models[row[1]].append(row[0])

            # For each model ID, store model Name
            if row[0] not in modelNames:
                modelNames[row[0]] = row[2]

        result["ModelNames"] = modelNames

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

            uris = self.GetNeuroLexUris(pythonResult)

            if len(uris) == 0:
                uris = "''"

            # Insert keyword ids into query
            query = query.replace("[NeuroLexUris]", uris)

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
