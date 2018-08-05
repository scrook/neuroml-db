import os

if os.getcwd().endswith("UnitTests"):
    os.chdir("..")

import json
from Classes.SearchModule import SearchModule

__author__ = 'Justas Birgiolas'

import unittest


class SearchModuleTest(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        cls.search = SearchModule()

    def test_purkcerb_VS_cerbpurk(self):

        result1 = self.search.Search("purkinje cerebellum")
        result2 = self.search.Search("cerebellum purkinje")

        self.assertEqual(
            json.dumps(result1.__dict__),
            json.dumps(result2.__dict__)
        )

    def test_gabacerb_VS_cerbgaba(self):

        result1 = self.search.Search("gaba cerebellum")
        result2 = self.search.Search("cerebellum gaba")

        self.assertEqual(
            json.dumps(result1.__dict__),
            json.dumps(result2.__dict__)
        )

    def test_gaba_cerebellum(self):

        result = self.search.Search("gaba cerebellum")

        self.assertTrue(len(result.GapRelationships) > 0)

    def test_purkcellcerb_vs_purkcerb(self):

        result1 = self.search.Search("purkinje cell cerebellum")
        result2 = self.search.Search("purkinje cerebellum")

        self.assertEqual(
            json.dumps(result1.__dict__),
            json.dumps(result2.__dict__)
        )

    def test_purkinje(self):

        result = self.search.Search("purkinje")

        self.assertTrue(len(result.KeywordRelations) > 0)

if __name__ == '__main__':
    unittest.main()
