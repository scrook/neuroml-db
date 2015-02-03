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

        cls.cerebellumIds = cls.Parser.GetKeywordOntologyIds("cerebellum")
        cls.hippocampusIds = cls.Parser.GetKeywordOntologyIds("hippocampus")
        cls.ca3alveus = cls.Parser.GetKeywordOntologyIds('"CA3 alveus"')
        cls.purkinjeGaba = cls.Parser.GetKeywordOntologyIds('purkinje gaba')
        cls.cerebellumgaba = cls.Parser.GetKeywordOntologyIds('cerebellum gaba')
        cls.cerebellumhippcomapus = cls.Parser.GetKeywordOntologyIds('cerebellum hippocampus')


    def test_find_cerebellar_subregions(self):
        result = self.Identifier.GetSubregions(self.cerebellumIds)
        self.assertTrue(len(result) > 1)

    def test_find_hippocampal_subregions(self):
        result = self.Identifier.GetSubregions(self.hippocampusIds)
        self.assertTrue(len(result) > 1)

    def test_find_no_subregions(self):
        result = self.Identifier.GetSubregions(self.ca3alveus)
        self.assertTrue(len(result) == 0)

    def test_find_direct_relationship_GABA_purkinje_cell(self):
        result = self.Identifier.GetDirectRelationships(self.purkinjeGaba, [])
        self.assertTrue(len(result) > 0)

    def test_find_no_direct_relationship(self):
        result = self.Identifier.GetDirectRelationships(self.cerebellumhippcomapus, [])
        self.assertTrue(len(result) == 0)

    def test_find_gap_relationship(self):
        result = self.Identifier.GetGapRelationships(self.cerebellumgaba, [])
        self.assertTrue(len(result) > 0)

    def test_find_no_gap_relationship(self):
        result = self.Identifier.GetGapRelationships(self.cerebellumhippcomapus, [])
        self.assertTrue(len(result) == 0)

if __name__ == '__main__':
    unittest.main()