SELECT mn.Model_ID, nlx.NeuroLex_URI, m.Name
FROM neurolexes nlx
JOIN model_neurolexes mn ON nlx.NeuroLex_ID = mn.NeuroLex_ID
JOIN models m ON mn.Model_ID=m.Model_ID
WHERE NeuroLex_URI IN
(
  [NeuroLexUris]
)
ORDER BY nlx.NeuroLex_URI
