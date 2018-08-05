use neuromldb;

SET SESSION TRANSACTION ISOLATION LEVEL READ uncommitted;
START TRANSACTION; 
#COMMIT;
#ROLLBACK;

#All is_translator = 3 should be = 0
update author_list_associations set is_translator = '0' where is_translator = '3' limit 1000;

#Fix authors
update model_metadata_associations as mma set mma.Metadata_ID = 1000003 where mma.Model_ID = 'NMLCH000025' and mma.Metadata_ID = 1000220 limit 1;

#Create new authors & make them part of author lists
#-----------
SET @nextId = (SELECT Person_ID FROM neuromldb.people order by Person_ID desc Limit 1) + 1;
INSERT INTO people SET Person_First_Name = 'Arnd', Person_Last_Name = 'Roth', Person_ID = @nextId;
INSERT INTO author_list_associations SET AuthorList_ID = 1000003, Person_ID = @nextId, is_translator = '1';

SET @nextId = (SELECT Person_ID FROM neuromldb.people order by Person_ID desc Limit 1) + 1;
INSERT INTO people SET Person_First_Name = 'David', Person_Last_Name = 'Beeman', Person_ID = @nextId;
INSERT INTO author_list_associations SET AuthorList_ID = 1000003, Person_ID = @nextId, is_translator = '1';

#-----------

SET @nextId = (SELECT Person_ID FROM neuromldb.people order by Person_ID desc Limit 1) + 1;
INSERT INTO people SET Person_First_Name = 'Guy', Person_Last_Name = 'Eyal', Person_ID = @nextId;
INSERT INTO author_list_associations SET AuthorList_ID = 1000044, Person_ID = @nextId, is_translator = '1';

SET @nextId = (SELECT Person_ID FROM neuromldb.people order by Person_ID desc Limit 1) + 1;
INSERT INTO people SET Person_First_Name = 'E', Person_Last_Name = 'Hay', Person_ID = @nextId;
INSERT INTO author_list_associations SET AuthorList_ID = 1000044, Person_ID = @nextId, is_translator = '0';

SET @nextId = (SELECT Person_ID FROM neuromldb.people order by Person_ID desc Limit 1) + 1;
INSERT INTO people SET Person_First_Name = 'S', Person_Last_Name = 'Hill', Person_ID = @nextId;
INSERT INTO author_list_associations SET AuthorList_ID = 1000044, Person_ID = @nextId, is_translator = '0';

SET @nextId = (SELECT Person_ID FROM neuromldb.people order by Person_ID desc Limit 1) + 1;
INSERT INTO people SET Person_First_Name = 'F', Person_Last_Name = 'Schürmann', Person_ID = @nextId;
INSERT INTO author_list_associations SET AuthorList_ID = 1000044, Person_ID = @nextId, is_translator = '0';

SET @nextId = (SELECT Person_ID FROM neuromldb.people order by Person_ID desc Limit 1) + 1;
INSERT INTO people SET Person_First_Name = 'H', Person_Last_Name = 'Markram', Person_ID = @nextId;
INSERT INTO author_list_associations SET AuthorList_ID = 1000044, Person_ID = @nextId, is_translator = '0';

#add missing osb link
SET @nextId = (SELECT Reference_ID FROM neuromldb.`refers` order by Reference_ID desc Limit 1) + 1;
INSERT INTO metadatas SET Metadata_id = @nextId;
INSERT INTO neuromldb.`refers` SET Reference_ID = @nextId, Reference_Resource = 'Open Source Brain', Reference_URI = 'http://www.opensourcebrain.org/projects/l5bpyrcellhayetal2011';
INSERT INTO model_metadata_associations SET Metadata_id = @nextId, Model_ID = 'NMLCL000073';

#-----------

UPDATE `neuromldb`.`model_metadata_associations` SET `Metadata_ID`='5000190' WHERE `Metadata_ID`='5000191' and`Model_ID`='NMLCH000067' limit 1;

UPDATE model_metadata_associations SET Metadata_id = 1000176 WHERE Metadata_id IN ( 1000037, 1000038, 1000039, 1000198, 1000041, 1000173, 1000221, 1000222 ) LIMIT 1000;

DELETE FROM `neuromldb`.`author_list_associations` WHERE `AuthorList_ID`='1000176' and`Person_ID`='2000040' limit 1;

UPDATE `neuromldb`.`author_list_associations` SET `is_translator`='2' WHERE `AuthorList_ID`='1000176' and`Person_ID`='2000028';


SET @nextId = (SELECT Person_ID FROM neuromldb.people order by Person_ID desc Limit 1) + 1;
INSERT INTO people SET Person_First_Name = 'Guy', Person_Last_Name = 'Eyal', Person_ID = @nextId;
INSERT INTO author_list_associations SET AuthorList_ID = 1000044, Person_ID = @nextId, is_translator = '1';

SET @nextId = (SELECT Person_ID FROM neuromldb.people order by Person_ID desc Limit 1) + 1;
INSERT INTO people SET Person_First_Name = 'Guy', Person_Last_Name = 'Eyal', Person_ID = @nextId;
INSERT INTO author_list_associations SET AuthorList_ID = 1000044, Person_ID = @nextId, is_translator = '1';

INSERT INTO `neuromldb`.`author_list_associations` (`AuthorList_ID`, `Person_ID`, `is_translator`) VALUES ('1000176', '2000014', '1');
INSERT INTO `neuromldb`.`author_list_associations` (`AuthorList_ID`, `Person_ID`, `is_translator`) VALUES ('1000176', '2000015', '1');


