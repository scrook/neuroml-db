import os
import unittest
from UnitTests.RecommenderTest import RecommenderTest
from UnitTests.RelationshipIdentifierTest import RelationshipIdentifierTest
from UnitTests.QueryParserTest import QueryParserTest
from UnitTests.SearchModuleTest import SearchModuleTest


if os.getcwd().endswith("NeuroML"):
    os.chdir("OntologySearch")

suite = unittest.TestSuite()
suite.addTest(unittest.makeSuite(QueryParserTest))
suite.addTest(unittest.makeSuite(RelationshipIdentifierTest))
suite.addTest(unittest.makeSuite(RecommenderTest))
suite.addTest(unittest.makeSuite(SearchModuleTest))

unittest.TextTestRunner(verbosity=2).run(suite)
