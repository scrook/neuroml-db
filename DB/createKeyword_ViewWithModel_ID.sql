create view Keyword_View as
select Model_ID, Model_ID as Keywords from models
UNION
select Model_ID,OK.Other_Keyword_Term as Keywords from Model_Metadata_Associations mma,Other_Keywords OK,neuroml_dev.references ref where OK.Other_Keyword_ID=mma.Metadata_ID 
union
select Model_ID,concat(' ', IFNULL(pub.Full_Title,''), ' ', IFNULL(pub.Pubmed_Ref,''), ' ', IFNULL(pub.Comments,'')) as Keywords from Model_Metadata_Associations mma,publications pub where pub.Publication_ID=mma.Metadata_ID
UNION
select Model_ID,concat(' ', IFNULL(nlx.Neurolex_Term,''), ' ', IFNULL(nlx.NeuroLex_URI,''), ' ', IFNULL(nlx.Comments,'')) from Model_Metadata_Associations mma,neurolexes nlx where nlx.Neurolex_ID = mma.Metadata_ID
UNION
select Cell_ID,concat(' ', IFNULL(Cell_Name,''), ' ', IFNULL(Comments,'')) from cells
union
select Network_ID,concat(' ', IFNULL(Network_Name,''), ' ', IFNULL(Comments,'')) from networks
union
select Channel_ID,concat(' ', IFNULL(Channel_Name,''), ' ', IFNULL(Comments,'')) from channels
union
select Synapse_ID,concat(' ', IFNULL(Synapse_Name,''), ' ', IFNULL(Comments,'')) from synapses
UNION
SELECT mma.Model_ID,concat(' ', IFNULL(ppl.Person_First_Name,''), ' ', IFNULL(ppl.Person_Last_Name,''), ' ', IFNULL(ppl.Instituition,''), ' ', IFNULL(ppl.Comments,'')) from People ppl,Model_Metadata_Associations mma,author_list_associations ala where mma.Metadata_ID = ala.AuthorList_ID and ala.Person_id = ppl.Person_ID;

