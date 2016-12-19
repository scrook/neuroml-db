SELECT mma.Model_ID, nlx.NeuroLex_URI, Model_Name
FROM neurolexes nlx
JOIN model_metadata_associations mma ON nlx.NeuroLex_ID = mma.Metadata_ID
INNER JOIN all_models_view a ON mma.Model_ID=a.Model_ID
WHERE NeuroLex_URI IN
(
  [NeuroLexUris]
)
ORDER BY nlx.NeuroLex_URI
