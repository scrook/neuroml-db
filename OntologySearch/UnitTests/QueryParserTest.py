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
        result = self.parser.GetKeywordOntologyIds("cerebellum")  # 3 matches, but only 2 distinct
        self.assertTrue(len(result) == 2)

    def test_close_words_found(self):
        result = self.parser.GetKeywordOntologyIds("cerebelu")  # note the typo, should still find something
        self.assertTrue(len(result) > 0)

    def test_quotes_filtered(self):
        result = self.parser.GetKeywordOntologyIds('"cell" "neuron"')  # should be empty list
        self.assertTrue(len(result) == 0)

    def test_quoted_phrases_found(self):
        result = self.parser.GetKeywordOntologyIds('"cerebellum"')  # finds 2 entries even with quotes
        self.assertTrue(len(result) == 2)

    def test_english_stopwords_filtered(self):
        result = self.parser.GetKeywordOntologyIds('is the not')  # should be empty list
        self.assertTrue(len(result) == 0)

    def test_custom_stopwords_filtered(self):
        result = self.parser.GetKeywordOntologyIds("neuron cell")  # should be empty list
        self.assertEqual(len(result), 0)


if __name__ == '__main__':
    unittest.main()
