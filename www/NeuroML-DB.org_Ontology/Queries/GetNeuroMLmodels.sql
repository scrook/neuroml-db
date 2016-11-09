SELECT mma.Model_ID,nlx.NeuroLex_URI
FROM neuroml_dev.neurolexes nlx
JOIN neuroml_dev.model_metadata_associations mma ON nlx.NeuroLex_ID = mma.Metadata_ID
WHERE NeuroLex_URI IN 
(
  [NeuroLexUris]
)
ORDER BY nlx.NeuroLex_URI
