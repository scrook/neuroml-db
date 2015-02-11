import os

if os.getcwd().endswith("UnitTests"):
    os.chdir("..")

import unittest
from Classes.QueryParser import QueryParser
from Classes.RelationshipIdentifier import RelationshipIdentifier


class RelationshipIdentifierTest(unittest.TestCase):

    @classmethod
    def setUpClass(cls):

        cls.Identifier = RelationshipIdentifier()
        cls.Parser = QueryParser()

        cls.cerebellumIds = cls.Parser.ParseQuery("cerebellum")
        cls.hippocampusIds = cls.Parser.ParseQuery("hippocampus")
        cls.ca3alveus = cls.Parser.ParseQuery('"CA3 alveus"')
        cls.purkinjeGaba = cls.Parser.ParseQuery('purkinje gaba')
        cls.cerebellumgaba = cls.Parser.ParseQuery('cerebellum gaba')
        cls.cerebellumhippcomapus = cls.Parser.ParseQuery('cerebellum hippocampus')
        cls.cerebellumhippcomapusgaba = cls.Parser.ParseQuery('cerebellum hippocampus gaba')

    def test_find_direct_relationship_GABA_purkinje_cell(self):
        result = self.Identifier.GetDirectRelationships(self.purkinjeGaba)
        self.assertTrue(len(result) > 0)

    def test_find_no_direct_relationship(self):
        result = self.Identifier.GetDirectRelationships(self.cerebellumhippcomapus)
        self.assertTrue(len(result) == 0)

    def test_find_gap_relationship(self):
        result = self.Identifier.GetGapRelationships(self.cerebellumgaba)
        self.assertTrue(len(result) > 0)

    def test_find_no_gap_relationship(self):
        result = self.Identifier.GetGapRelationships(self.cerebellumhippcomapus)
        self.assertTrue(len(result) == 0)

    def test_find_3way_gap_relationship(self):
        result = self.Identifier.GetGapRelationships(self.cerebellumhippcomapusgaba)
        self.assertTrue(len(result) > 0)

if __name__ == '__main__':
    unittest.main()