SELECT mma.Model_ID, nlx.NeuroLex_URI, m.Name
FROM neurolexes nlx
JOIN model_metadata_associations mma ON nlx.NeuroLex_ID = mma.Metadata_ID
JOIN models m ON mma.Model_ID=m.Model_ID
WHERE NeuroLex_URI IN
(
  [NeuroLexUris]
)
ORDER BY nlx.NeuroLex_URI
