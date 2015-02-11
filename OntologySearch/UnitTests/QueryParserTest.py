import os

if os.getcwd().endswith("UnitTests"):
    os.chdir("..")

import unittest
from Classes.QueryParser import QueryParser


class QueryParserTest(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        cls.parser = QueryParser()

    def test_results_are_distinct(self):
        result = self.parser.ParseQuery("cerebelum")

        # Typo, 3 close matches, but only 2 distinct
        self.assertTrue(len(result[0].SearchSet) == 3)
        self.assertTrue(len(result[0].NLXuris) == 2)

    def test_close_words_found(self):
        result = self.parser.ParseQuery("cerebelu")  # note the typo

        # Should find cerebellum
        self.assertTrue(result[0].SearchSet[0] == "cerebellum")

        # Two other close matches too
        self.assertTrue(len(result[0].SearchSet) == 3)


    def test_quotes_filtered(self):
        result = self.parser.ParseQuery('"cell" "neuron"')  # should be empty list
        self.assertTrue(len(result) == 0)

    def test_quoted_phrases_found(self):
        result = self.parser.ParseQuery('"cerebellum"')

        # Finds 1 exact match even with quotes
        self.assertTrue(len(result[0].SearchSet) == 1)

        # Should find cerebellum
        self.assertTrue(result[0].SearchSet[0] == "cerebellum")

    def test_english_stopwords_filtered(self):
        result = self.parser.ParseQuery('is the not')  # should be empty list
        self.assertTrue(len(result) == 0)

    def test_custom_stopwords_filtered(self):
        result = self.parser.ParseQuery("neuron cell")  # should be empty list
        self.assertEqual(len(result), 0)

    def test_find_cerebellar_subregions(self):
        result = self.parser.ParseQuery("cerebellum")
        self.assertTrue(len(result[0].SubRegions) > 1)

    def test_find_hippocampal_subregions(self):
        result = self.parser.ParseQuery("hippocampus")
        self.assertTrue(len(result[0].SubRegions) > 1)

    def test_find_no_subregions(self):
        result = self.parser.ParseQuery('"CA3 alveus"')
        self.assertTrue(len(result[0].SubRegions) == 0)

    def test_find_two_different_subregion_hierarchies(self):
        result = self.parser.ParseQuery("cerebellum hippocampus")

        self.assertTrue(len(result[0].SubRegions) > 1)
        self.assertTrue(len(result[1].SubRegions) > 1)

if __name__ == '__main__':
    unittest.main()
