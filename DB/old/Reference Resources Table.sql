#Refactor reference source into its own table

USE neuroml

#Create table
CREATE TABLE `resources` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(255) NOT NULL,
  `LogoUrl` VARCHAR(5000) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `Name_UNIQUE` (`Name` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 1;

ALTER TABLE `resources` 
ADD COLUMN `HomePageUrl` VARCHAR(255) NULL AFTER `LogoUrl`;

#Fill it with data
INSERT INTO `resources` (`Name`, `LogoUrl`, `HomePageUrl`) VALUES ('Open Source Brain', '/images/osblogo.png', 'http://www.opensourcebrain.org/');
INSERT INTO `resources` (`Name`, `LogoUrl`, `HomePageUrl`) VALUES ('ModelDB', '/images/modeldblogo.gif', 'http://senselab.med.yale.edu/ModelDB/default.cshtml');
INSERT INTO `resources` (`Name`, `LogoUrl`, `HomePageUrl`) VALUES ('neuronDB', '/images/neurondblogo.gif', 'https://senselab.med.yale.edu/NeuronDB/');

#Add column to references table
ALTER TABLE `refers` 
ADD COLUMN `Reference_Resource_ID` INT NULL DEFAULT 1 AFTER `Reference_ID`;

#Repoint old records to use new table
UPDATE `refers` SET `Reference_Resource_ID`='2' WHERE Reference_Resource = 'ModelDB' limit 1000;
UPDATE `refers` SET `Reference_Resource`='Open Source Brain' WHERE `Reference_Resource`='OpenSourceBrain' limit 1000;
UPDATE `refers` SET `Reference_Resource_ID`='3' WHERE `Reference_Resource`='neuronDB' limit 1000;

