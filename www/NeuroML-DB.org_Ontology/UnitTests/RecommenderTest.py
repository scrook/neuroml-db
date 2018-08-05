import os

if os.getcwd().endswith("UnitTests"):
    os.chdir("..")

from Classes.RelationshipIdentifier import RelationshipIdentifier
import unittest
from Classes.QueryParser import QueryParser
from Classes.Recommender import Recommender


class RecommenderTest(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        cls.Recommender = Recommender()
        cls.QueryParser = QueryParser()
        cls.RelIdentifier = RelationshipIdentifier()

        cls.purkinjeCell = cls.QueryParser.ParseQuery("purkinje")
        cls.dopamine = cls.QueryParser.ParseQuery("dopamine")
        cls.purkinjeCerebellum = cls.QueryParser.ParseQuery("purkinje cerebellum")

        # Purk & cerebellum without region assist
        cls.purkCerebDirectRels = cls.RelIdentifier \
            .GetDirectRelationships(cls.purkinjeCerebellum, [])

    def test_find_keyword_relations(self):
        result = self.Recommender.FindKeywordRelations(self.purkinjeCell)
        self.assertTrue(len(result) > 0)

    def test_find_keyword_relations_2(self):
        result = self.Recommender.FindKeywordRelations(self.dopamine)
        self.assertTrue(len(result) > 0)

    def test_find_direct_rel_analogues(self):
        result = self.Recommender.RunAnaloguesQuery(self.purkCerebDirectRels)
        self.assertTrue(len(result) > 0)

if __name__ == '__main__':
    unittest.main()
