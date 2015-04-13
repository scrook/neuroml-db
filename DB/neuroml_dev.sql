CREATE DATABASE  IF NOT EXISTS `neuroml_dev` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `neuroml_dev`;
-- MySQL dump 10.13  Distrib 5.6.17, for Win32 (x86)
--
-- Host: localhost    Database: neuroml_dev
-- ------------------------------------------------------
-- Server version	5.5.40-0ubuntu0.14.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Temporary table structure for view `all_metadata_view`
--

DROP TABLE IF EXISTS `all_metadata_view`;
/*!50001 DROP VIEW IF EXISTS `all_metadata_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `all_metadata_view` (
  `Model_ID` tinyint NOT NULL,
  `Metadata_id` tinyint NOT NULL,
  `Metadata_type` tinyint NOT NULL,
  `Metadata_value` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `all_models_view`
--

DROP TABLE IF EXISTS `all_models_view`;
/*!50001 DROP VIEW IF EXISTS `all_models_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `all_models_view` (
  `Model_ID` tinyint NOT NULL,
  `Model_Name` tinyint NOT NULL,
  `Model_File` tinyint NOT NULL,
  `upload_time` tinyint NOT NULL,
  `comments` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `attachments`
--

DROP TABLE IF EXISTS `attachments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attachments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `container_id` int(11) DEFAULT NULL,
  `container_type` varchar(30) DEFAULT NULL,
  `filename` varchar(255) NOT NULL DEFAULT '',
  `disk_filename` varchar(255) NOT NULL DEFAULT '',
  `filesize` int(11) NOT NULL DEFAULT '0',
  `content_type` varchar(255) DEFAULT '',
  `digest` varchar(40) NOT NULL DEFAULT '',
  `downloads` int(11) NOT NULL DEFAULT '0',
  `author_id` int(11) NOT NULL DEFAULT '0',
  `created_on` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `disk_directory` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_attachments_on_author_id` (`author_id`),
  KEY `index_attachments_on_created_on` (`created_on`),
  KEY `index_attachments_on_container_id_and_container_type` (`container_id`,`container_type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attachments`
--

LOCK TABLES `attachments` WRITE;
/*!40000 ALTER TABLE `attachments` DISABLE KEYS */;
/*!40000 ALTER TABLE `attachments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_sources`
--

DROP TABLE IF EXISTS `auth_sources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_sources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(30) NOT NULL DEFAULT '',
  `name` varchar(60) NOT NULL DEFAULT '',
  `host` varchar(60) DEFAULT NULL,
  `port` int(11) DEFAULT NULL,
  `account` varchar(255) DEFAULT NULL,
  `account_password` varchar(255) DEFAULT '',
  `base_dn` varchar(255) DEFAULT NULL,
  `attr_login` varchar(30) DEFAULT NULL,
  `attr_firstname` varchar(30) DEFAULT NULL,
  `attr_lastname` varchar(30) DEFAULT NULL,
  `attr_mail` varchar(30) DEFAULT NULL,
  `onthefly_register` tinyint(1) NOT NULL DEFAULT '0',
  `tls` tinyint(1) NOT NULL DEFAULT '0',
  `filter` varchar(255) DEFAULT NULL,
  `timeout` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_auth_sources_on_id_and_type` (`id`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_sources`
--

LOCK TABLES `auth_sources` WRITE;
/*!40000 ALTER TABLE `auth_sources` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_sources` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `author_list_associations`
--

DROP TABLE IF EXISTS `author_list_associations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `author_list_associations` (
  `AuthorList_ID` int(11) NOT NULL,
  `Person_ID` int(11) NOT NULL,
  `is_translator` enum('0','1','2','3','4') NOT NULL DEFAULT '0' COMMENT '\\\\\\''0\\\\\\'' is author, \\\\\\''1\\\\\\'' is translator, \\\\\\''2\\\\\\'' is both, \\\\\\''3\\\\\\'' is the first author, \\\\\\''4\\\\\\'' means both first author and translator.',
  `Comments` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`AuthorList_ID`,`Person_ID`),
  KEY `FK_list_Person_idx` (`Person_ID`),
  KEY `FK_authorlist_idx` (`AuthorList_ID`),
  CONSTRAINT `FK_authorlist` FOREIGN KEY (`AuthorList_ID`) REFERENCES `author_lists` (`AuthorList_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_list_Person` FOREIGN KEY (`Person_ID`) REFERENCES `people` (`Person_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `author_list_associations`
--

LOCK TABLES `author_list_associations` WRITE;
/*!40000 ALTER TABLE `author_list_associations` DISABLE KEYS */;
INSERT INTO `author_list_associations` VALUES (1000001,2000001,'3',NULL),(1000001,2000002,'0',NULL),(1000001,2000003,'0',NULL),(1000001,2000004,'1',NULL),(1000002,2000004,'1',NULL),(1000002,2000005,'3',NULL),(1000002,2000006,'0',NULL),(1000003,2000004,'1',NULL),(1000003,2000006,'3',NULL),(1000003,2000007,'0',NULL),(1000035,2000004,'1',NULL),(1000036,2000004,'1',NULL),(1000037,2000004,'1',NULL),(1000037,2000009,'0',NULL),(1000037,2000036,'0',NULL),(1000037,2000037,'0',NULL),(1000037,2000038,'0',NULL),(1000037,2000039,'0',NULL),(1000037,2000040,'0',NULL),(1000038,2000004,'1',NULL),(1000038,2000033,'0',NULL),(1000038,2000036,'0',NULL),(1000038,2000037,'0',NULL),(1000038,2000038,'0',NULL),(1000038,2000039,'0',NULL),(1000038,2000040,'0',NULL),(1000039,2000004,'1',NULL),(1000039,2000033,'0',NULL),(1000039,2000036,'0',NULL),(1000039,2000037,'0',NULL),(1000039,2000038,'0',NULL),(1000039,2000039,'0',NULL),(1000039,2000040,'0',NULL),(1000041,2000004,'1',NULL),(1000041,2000013,'0',NULL),(1000041,2000036,'0',NULL),(1000041,2000037,'0',NULL),(1000041,2000038,'0',NULL),(1000041,2000039,'0',NULL),(1000041,2000040,'0',NULL),(1000043,2000004,'2',NULL),(1000043,2000018,'1',NULL),(1000043,2000019,'1',NULL),(1000044,2000004,'1',NULL),(1000044,2000010,'1',NULL),(1000044,2000020,'0',NULL),(1000045,2000014,'1',NULL),(1000045,2000021,'1',NULL),(1000045,2000022,'1',NULL),(1000045,2000024,'1',NULL),(1000046,2000014,'1',NULL),(1000046,2000021,'1',NULL),(1000046,2000025,'1',NULL),(1000046,2000026,'1',NULL),(1000046,2000027,'0',NULL),(1000047,2000028,'1',NULL),(1000051,2000005,'0',NULL),(1000051,2000006,'0',NULL),(1000051,2000028,'1',NULL),(1000055,2000005,'0',NULL),(1000055,2000006,'0',NULL),(1000055,2000028,'1',NULL),(1000059,2000005,'0',NULL),(1000059,2000006,'0',NULL),(1000059,2000028,'1',NULL),(1000068,2000001,'0',NULL),(1000068,2000002,'0',NULL),(1000068,2000003,'0',NULL),(1000068,2000028,'1',NULL),(1000072,2000001,'0',NULL),(1000072,2000002,'0',NULL),(1000072,2000003,'0',NULL),(1000072,2000028,'1',NULL),(1000076,2000001,'0',NULL),(1000076,2000002,'0',NULL),(1000076,2000003,'0',NULL),(1000076,2000028,'1',NULL),(1000080,2000001,'0',NULL),(1000080,2000002,'0',NULL),(1000080,2000003,'0',NULL),(1000080,2000028,'1',NULL),(1000084,2000001,'0',NULL),(1000084,2000002,'0',NULL),(1000084,2000003,'0',NULL),(1000084,2000028,'1',NULL),(1000088,2000001,'0',NULL),(1000088,2000002,'0',NULL),(1000088,2000003,'0',NULL),(1000088,2000028,'1',NULL),(1000092,2000001,'0',NULL),(1000092,2000002,'0',NULL),(1000092,2000003,'0',NULL),(1000092,2000028,'1',NULL),(1000156,2000006,'0',NULL),(1000156,2000028,'1',NULL),(1000156,2000029,'0',NULL),(1000160,2000006,'0',NULL),(1000160,2000028,'1',NULL),(1000160,2000030,'0',NULL),(1000164,2000006,'0',NULL),(1000164,2000028,'1',NULL),(1000164,2000031,'0',NULL),(1000168,2000006,'0',NULL),(1000168,2000028,'1',NULL),(1000168,2000032,'0',NULL),(1000173,2000028,'1',NULL),(1000173,2000033,'0',NULL),(1000173,2000036,'0',NULL),(1000173,2000037,'0',NULL),(1000173,2000038,'0',NULL),(1000173,2000039,'0',NULL),(1000173,2000040,'0',NULL),(1000176,2000028,'1',NULL),(1000176,2000033,'0',NULL),(1000176,2000036,'0',NULL),(1000176,2000037,'0',NULL),(1000176,2000038,'0',NULL),(1000176,2000039,'0',NULL),(1000176,2000040,'0',NULL),(1000198,2000028,'1',NULL),(1000198,2000033,'0',NULL),(1000198,2000036,'0',NULL),(1000198,2000037,'0',NULL),(1000198,2000038,'0',NULL),(1000198,2000039,'0',NULL),(1000198,2000040,'0',NULL),(1000220,2000006,'0',NULL),(1000220,2000007,'0',NULL),(1000220,2000028,'1',NULL),(1000221,2000028,'1',NULL),(1000221,2000034,'0',NULL),(1000221,2000036,'0',NULL),(1000221,2000037,'0',NULL),(1000221,2000038,'0',NULL),(1000221,2000039,'0',NULL),(1000221,2000040,'0',NULL),(1000222,2000028,'1',NULL),(1000222,2000034,'0',NULL),(1000222,2000036,'0',NULL),(1000222,2000037,'0',NULL),(1000222,2000038,'0',NULL),(1000222,2000039,'0',NULL),(1000222,2000040,'0',NULL);
/*!40000 ALTER TABLE `author_list_associations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `author_lists`
--

DROP TABLE IF EXISTS `author_lists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `author_lists` (
  `AuthorList_ID` int(11) NOT NULL,
  PRIMARY KEY (`AuthorList_ID`),
  KEY `FK_Meta_Author_idx` (`AuthorList_ID`),
  CONSTRAINT `FK_Meta_Author` FOREIGN KEY (`AuthorList_ID`) REFERENCES `metadatas` (`Metadata_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `author_lists`
--

LOCK TABLES `author_lists` WRITE;
/*!40000 ALTER TABLE `author_lists` DISABLE KEYS */;
INSERT INTO `author_lists` VALUES (1000001),(1000002),(1000003),(1000035),(1000036),(1000037),(1000038),(1000039),(1000041),(1000043),(1000044),(1000045),(1000046),(1000047),(1000051),(1000055),(1000059),(1000068),(1000072),(1000076),(1000080),(1000084),(1000088),(1000092),(1000156),(1000160),(1000164),(1000168),(1000173),(1000176),(1000198),(1000220),(1000221),(1000222);
/*!40000 ALTER TABLE `author_lists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `boards`
--

DROP TABLE IF EXISTS `boards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `boards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  `description` varchar(255) DEFAULT NULL,
  `position` int(11) DEFAULT '1',
  `topics_count` int(11) NOT NULL DEFAULT '0',
  `messages_count` int(11) NOT NULL DEFAULT '0',
  `last_message_id` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `boards_project_id` (`project_id`),
  KEY `index_boards_on_last_message_id` (`last_message_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `boards`
--

LOCK TABLES `boards` WRITE;
/*!40000 ALTER TABLE `boards` DISABLE KEYS */;
/*!40000 ALTER TABLE `boards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cell_channel_associations`
--

DROP TABLE IF EXISTS `cell_channel_associations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cell_channel_associations` (
  `Cell_ID` varchar(45) NOT NULL,
  `Channel_ID` varchar(45) NOT NULL,
  `Comments` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`Cell_ID`,`Channel_ID`),
  KEY `CellID_idx` (`Cell_ID`),
  KEY `ChannelID_idx` (`Channel_ID`),
  KEY `FK_cell_idx` (`Cell_ID`),
  KEY `FK_channel_idx` (`Channel_ID`),
  CONSTRAINT `FK_cell` FOREIGN KEY (`Cell_ID`) REFERENCES `cells` (`Cell_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_cell_channel` FOREIGN KEY (`Channel_ID`) REFERENCES `channels` (`Channel_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cell_channel_associations`
--

LOCK TABLES `cell_channel_associations` WRITE;
/*!40000 ALTER TABLE `cell_channel_associations` DISABLE KEYS */;
INSERT INTO `cell_channel_associations` VALUES ('NMLCL000001','NMLCH000001',NULL),('NMLCL000001','NMLCH000002',NULL),('NMLCL000001','NMLCH000003',NULL),('NMLCL000001','NMLCH000004',NULL),('NMLCL000001','NMLCH000005',NULL),('NMLCL000001','NMLCH000006',NULL),('NMLCL000001','NMLCH000007',NULL),('NMLCL000002','NMLCH000008',NULL),('NMLCL000002','NMLCH000009',NULL),('NMLCL000002','NMLCH000010',NULL),('NMLCL000002','NMLCH000011',NULL),('NMLCL000002','NMLCH000012',NULL),('NMLCL000002','NMLCH000013',NULL),('NMLCL000002','NMLCH000014',NULL),('NMLCL000002','NMLCH000015',NULL),('NMLCL000003','NMLCH000016',NULL),('NMLCL000004','NMLCH000017',NULL),('NMLCL000004','NMLCH000018',NULL),('NMLCL000004','NMLCH000019',NULL),('NMLCL000004','NMLCH000020',NULL),('NMLCL000004','NMLCH000021',NULL),('NMLCL000004','NMLCH000022',NULL),('NMLCL000004','NMLCH000023',NULL),('NMLCL000004','NMLCH000024',NULL),('NMLCL000005','NMLCH000025',NULL),('NMLCL000005','NMLCH000026',NULL),('NMLCL000005','NMLCH000027',NULL),('NMLCL000005','NMLCH000028',NULL),('NMLCL000005','NMLCH000029',NULL),('NMLCL000005','NMLCH000030',NULL),('NMLCL000005','NMLCH000031',NULL),('NMLCL000005','NMLCH000032',NULL),('NMLCL000005','NMLCH000033',NULL),('NMLCL000005','NMLCH000034',NULL),('NMLCL000005','NMLCH000035',NULL),('NMLCL000005','NMLCH000036',NULL),('NMLCL000005','NMLCH000037',NULL),('NMLCL000054','NMLCH000048',NULL),('NMLCL000054','NMLCH000049',NULL),('NMLCL000054','NMLCH000050',NULL),('NMLCL000054','NMLCH000051',NULL),('NMLCL000054','NMLCH000052',NULL),('NMLCL000054','NMLCH000053',NULL),('NMLCL000060','NMLCH000048',NULL),('NMLCL000060','NMLCH000049',NULL),('NMLCL000060','NMLCH000050',NULL),('NMLCL000060','NMLCH000051',NULL),('NMLCL000060','NMLCH000053',NULL),('NMLCL000060','NMLCH000055',NULL),('NMLCL000060','NMLCH000056',NULL),('NMLCL000060','NMLCH000057',NULL),('NMLCL000060','NMLCH000058',NULL),('NMLCL000060','NMLCH000059',NULL),('NMLCL000061','NMLCH000048',NULL),('NMLCL000061','NMLCH000049',NULL),('NMLCL000061','NMLCH000050',NULL),('NMLCL000061','NMLCH000051',NULL),('NMLCL000061','NMLCH000053',NULL),('NMLCL000061','NMLCH000055',NULL),('NMLCL000061','NMLCH000056',NULL),('NMLCL000061','NMLCH000057',NULL),('NMLCL000061','NMLCH000058',NULL),('NMLCL000061','NMLCH000059',NULL),('NMLCL000077','NMLCH000048',NULL),('NMLCL000077','NMLCH000049',NULL),('NMLCL000077','NMLCH000051',NULL),('NMLCL000077','NMLCH000053',NULL),('NMLCL000077','NMLCH000055',NULL),('NMLCL000077','NMLCH000056',NULL),('NMLCL000077','NMLCH000058',NULL),('NMLCL000077','NMLCH000059',NULL),('NMLCL000078','NMLCH000048',NULL),('NMLCL000078','NMLCH000049',NULL),('NMLCL000078','NMLCH000051',NULL),('NMLCL000078','NMLCH000052',NULL),('NMLCL000078','NMLCH000053',NULL),('NMLCL000085','NMLCH000066',NULL),('NMLCL000085','NMLCH000067',NULL),('NMLCL000085','NMLCH000068',NULL),('NMLCL000085','NMLCH000069',NULL),('NMLCL000085','NMLCH000086',NULL),('NMLCL000085','NMLCH000087',NULL),('NMLCL000085','NMLCH000088',NULL),('NMLCL000085','NMLCH000089',NULL),('NMLCL000085','NMLCH000090',NULL),('NMLCL000085','NMLCH000091',NULL),('NMLCL000085','NMLCH000092',NULL),('NMLCL000085','NMLCH000093',NULL),('NMLCL000085','NMLCH000094',NULL),('NMLCL000085','NMLCH000095',NULL),('NMLCL000085','NMLCH000096',NULL),('NMLCL000085','NMLCH000097',NULL),('NMLCL000085','NMLCH000098',NULL);
/*!40000 ALTER TABLE `cell_channel_associations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cell_synapse_associations`
--

DROP TABLE IF EXISTS `cell_synapse_associations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cell_synapse_associations` (
  `Cell_ID` varchar(45) NOT NULL,
  `Synapse_ID` varchar(45) NOT NULL,
  `Comments` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`Cell_ID`,`Synapse_ID`),
  KEY `FK_Synapses_Synapse_idx` (`Synapse_ID`),
  KEY `FK_Synapses_Cell_idx` (`Cell_ID`),
  CONSTRAINT `FK_Synapses_Cell` FOREIGN KEY (`Cell_ID`) REFERENCES `cells` (`Cell_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_Synapses_Synapse` FOREIGN KEY (`Synapse_ID`) REFERENCES `synapses` (`Synapse_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cell_synapse_associations`
--

LOCK TABLES `cell_synapse_associations` WRITE;
/*!40000 ALTER TABLE `cell_synapse_associations` DISABLE KEYS */;
INSERT INTO `cell_synapse_associations` VALUES ('NMLCL000002','NMLSY000080',NULL),('NMLCL000002','NMLSY000081',NULL),('NMLCL000002','NMLSY000082',NULL),('NMLCL000002','NMLSY000083',NULL),('NMLCL000003','NMLSY000082',NULL),('NMLCL000003','NMLSY000083',NULL),('NMLCL000004','NMLSY000080',NULL),('NMLCL000004','NMLSY000081',NULL),('NMLCL000054','NMLSY000065',NULL),('NMLCL000085','NMLSY000084',NULL),('NMLCL000085','NMLSY000099',NULL),('NMLCL000085','NMLSY000100',NULL);
/*!40000 ALTER TABLE `cell_synapse_associations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cells`
--

DROP TABLE IF EXISTS `cells`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cells` (
  `Cell_ID` varchar(45) NOT NULL,
  `Cell_Name` varchar(250) DEFAULT NULL COMMENT 'The name of the cell model',
  `MorphML_File` varchar(250) NOT NULL,
  `Upload_Time` datetime NOT NULL,
  `Comments` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`Cell_ID`),
  KEY `FK_Model_Cell_idx` (`Cell_ID`),
  CONSTRAINT `FK_Model_Cell` FOREIGN KEY (`Cell_ID`) REFERENCES `models` (`Model_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cells`
--

LOCK TABLES `cells` WRITE;
/*!40000 ALTER TABLE `cells` DISABLE KEYS */;
INSERT INTO `cells` VALUES ('NMLCL000001','CA1 Pyramidal Cell','/var/www/NeuroMLmodels/NMLCL000001/CA1.morph.xml','2012-12-21 00:00:00','updated July 2014'),('NMLCL000002','Granule Cell','/var/www/NeuroMLmodels/NMLCL000002/Granule_98.morph.xml','2014-01-10 00:00:00','updated July 2014'),('NMLCL000003','Granule Input Mossy Fiber','/var/www/NeuroMLmodels/NMLCL000003/MossyFiber.morph.xml','2013-01-10 00:00:00','Updated July 2014'),('NMLCL000004','Golgi Cell','/var/www/NeuroMLmodels/NMLCL000004/Golgi_98.morph.xml','2013-12-12 00:00:00','updated July 2014'),('NMLCL000005','Purkinje Cell','/var/www/NeuroMLmodels/NMLCL000005/purk2.nml','2013-01-26 00:00:00',''),('NMLCL000054','Layer 2/3 Pyramidal Cell with Regular Spiking','/var/www/NeuroMLmodels/NMLCL000054/L23PyrRS.nml','2013-10-22 06:19:07',''),('NMLCL000060','Superficial Pyramidal Cells AxoAxonic Connectivity','/var/www/NeuroMLmodels/NMLCL000060/SupAxAx.morph.xml','2013-10-17 07:16:59',''),('NMLCL000061','Superficial Low Threshold Spiking Interneurons','/home/neuromine/models/SupLTSInter/SupLTSInter.nml','2013-12-08 10:24:18','Cell: supLTS_0 exported from NEURON ModelView'),('NMLCL000072','Izhikevich Spiking Neuron Model','/home/neuromine/models/Izhikevich_Spiking_Neuron_Model/WhichModel.nml','2013-10-29 05:52:37',''),('NMLCL000073','Layer 5b Pyramidal cell ','/home/neuromine/models/Layer_5b_Pyramidal_cell/L5PCbiophys3_pas.nml','2013-10-30 06:02:54','Layer 5b Pyramidal cell constrained by experimental data on perisomatic firing properties as well as dendritic activity during backpropagation of the action potential.'),('NMLCL000077','Nucleus Reticularis Thalami Cell','/home/neuromine/models/Nucleus_Reticularis_Thalami_Cell/nRT.nml','2013-10-31 07:10:15',''),('NMLCL000078','Layer 2/3 Pyramidal Fast Rhythmic Bursting','/home/neuromine/models/Layer_2_3_Pyramidal_Fast_Rhythmic_Bursting/L23PyrFRB.nml','2013-10-30 07:31:23','This is a project implementing cells from the thalamocortical network model of Traub et al 2005 in NeuroML.'),('NMLCL000085','Golgi_Cell','/var/www/NeuroMLmodels/NMLCL000085/Golgi_NeuroML.morph.xml','2014-07-23 02:24:31','');
/*!40000 ALTER TABLE `cells` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `changes`
--

DROP TABLE IF EXISTS `changes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `changes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `changeset_id` int(11) NOT NULL,
  `action` varchar(1) NOT NULL DEFAULT '',
  `path` text NOT NULL,
  `from_path` text,
  `from_revision` varchar(255) DEFAULT NULL,
  `revision` varchar(255) DEFAULT NULL,
  `branch` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `changesets_changeset_id` (`changeset_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `changes`
--

LOCK TABLES `changes` WRITE;
/*!40000 ALTER TABLE `changes` DISABLE KEYS */;
/*!40000 ALTER TABLE `changes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `changeset_parents`
--

DROP TABLE IF EXISTS `changeset_parents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `changeset_parents` (
  `changeset_id` int(11) NOT NULL,
  `parent_id` int(11) NOT NULL,
  KEY `changeset_parents_changeset_ids` (`changeset_id`),
  KEY `changeset_parents_parent_ids` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `changeset_parents`
--

LOCK TABLES `changeset_parents` WRITE;
/*!40000 ALTER TABLE `changeset_parents` DISABLE KEYS */;
/*!40000 ALTER TABLE `changeset_parents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `changesets`
--

DROP TABLE IF EXISTS `changesets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `changesets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `repository_id` int(11) NOT NULL,
  `revision` varchar(255) NOT NULL,
  `committer` varchar(255) DEFAULT NULL,
  `committed_on` datetime NOT NULL,
  `comments` text,
  `commit_date` date DEFAULT NULL,
  `scmid` varchar(255) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `changesets_repos_rev` (`repository_id`,`revision`),
  KEY `index_changesets_on_user_id` (`user_id`),
  KEY `index_changesets_on_repository_id` (`repository_id`),
  KEY `index_changesets_on_committed_on` (`committed_on`),
  KEY `changesets_repos_scmid` (`repository_id`,`scmid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `changesets`
--

LOCK TABLES `changesets` WRITE;
/*!40000 ALTER TABLE `changesets` DISABLE KEYS */;
/*!40000 ALTER TABLE `changesets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `changesets_issues`
--

DROP TABLE IF EXISTS `changesets_issues`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `changesets_issues` (
  `changeset_id` int(11) NOT NULL,
  `issue_id` int(11) NOT NULL,
  UNIQUE KEY `changesets_issues_ids` (`changeset_id`,`issue_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `changesets_issues`
--

LOCK TABLES `changesets_issues` WRITE;
/*!40000 ALTER TABLE `changesets_issues` DISABLE KEYS */;
/*!40000 ALTER TABLE `changesets_issues` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `channels`
--

DROP TABLE IF EXISTS `channels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `channels` (
  `Channel_ID` varchar(45) NOT NULL,
  `Channel_Name` varchar(250) DEFAULT NULL,
  `ChannelML_File` varchar(250) NOT NULL,
  `Upload_Time` datetime NOT NULL,
  `Comments` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`Channel_ID`),
  KEY `FK_Model_Channel_idx` (`Channel_ID`),
  CONSTRAINT `FK_Model_Channel` FOREIGN KEY (`Channel_ID`) REFERENCES `models` (`Model_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `channels`
--

LOCK TABLES `channels` WRITE;
/*!40000 ALTER TABLE `channels` DISABLE KEYS */;
INSERT INTO `channels` VALUES ('NMLCH000001','hd Channel','/var/www/NeuroMLmodels/NMLCH000001/hd.xml','2012-12-21 00:00:00','updated July 2014'),('NMLCH000002','kad Channel','/var/www/NeuroMLmodels/NMLCH000002/kad.xml','2012-12-21 00:00:00','updated July 2014'),('NMLCH000003','kap Channel','/var/www/NeuroMLmodels/NMLCH000003/kap.xml','2013-12-21 00:00:00','updated July 2014'),('NMLCH000004','kdr Channel','/var/www/NeuroMLmodels/NMLCH000004/kdr.xml','2012-12-21 00:00:00','updated July 2014'),('NMLCH000005','Na3 Channel','/var/www/NeuroMLmodels/NMLCH000005/na3.xml','2012-12-21 00:00:00','updated July 2014'),('NMLCH000006','nax Channel','/var/www/NeuroMLmodels/NMLCH000006/nax.xml','2012-12-21 00:00:00','updated July 2014'),('NMLCH000007','pas Channel','/var/www/NeuroMLmodels/NMLCH000007/pas.xml','2012-12-21 00:00:00','updated July 2014'),('NMLCH000008','Gran_NaF_98 Channel','/var/www/NeuroMLmodels/NMLCH000008/Gran_NaF_98.xml','2013-01-10 00:00:00','updated July 2014'),('NMLCH000009','Gran_KDr_98 Channel','/var/www/NeuroMLmodels/NMLCH000009/Gran_KDr_98.xml','2013-01-10 00:00:00','updated July 2014'),('NMLCH000010','Gran_KCa_98 Channel','/var/www/NeuroMLmodels/NMLCH000010/Gran_KCa_98.xml','2013-01-10 00:00:00','updated July 2014'),('NMLCH000011','Gran_KA_98 Channel','/var/www/NeuroMLmodels/NMLCH000011/Gran_KA_98.xml','2013-01-10 00:00:00','updated July 2014'),('NMLCH000012','Gran_H_98 Channel','/var/www/NeuroMLmodels/NMLCH000012/Gran_H_98.xml','2013-01-10 00:00:00','updated July 2014'),('NMLCH000013','Gran_CaPool_98 Channel','/var/www/NeuroMLmodels/NMLCH000013/Gran_CaPool_98.xml','2013-01-10 00:00:00','updated July 2014'),('NMLCH000014','Gran_CaHVA_98 Channel','/var/www/NeuroMLmodels/NMLCH000014/Gran_CaHVA_98.xml','2013-01-10 00:00:00','updated July 2014'),('NMLCH000015','GranPassiveCond Channel','/var/www/NeuroMLmodels/NMLCH000015/GranPassiveCond.xml','2013-01-10 00:00:00','updated July 2014'),('NMLCH000016','MFFastLeakCond Channel','/var/www/NeuroMLmodels/NMLCH000016/MFFastLeakCond.xml','2013-01-10 00:00:00',''),('NMLCH000017','Golgi_CaHVA_CML Channel','/var/www/NeuroMLmodels/NMLCH000017/Golgi_CaHVA_CML.xml','2013-01-10 00:00:00',''),('NMLCH000018','Golgi_CaPool_CML Channel','/var/www/NeuroMLmodels/NMLCH000018/Golgi_CaPool_CML.xml','2013-01-10 00:00:00',''),('NMLCH000019','Golgi_H_CML Channel','/var/www/NeuroMLmodels/NMLCH000019/Golgi_H_CML.xml','2013-01-10 00:00:00',''),('NMLCH000020','Golgi_KA_CML Channel','/var/www/NeuroMLmodels/NMLCH000020/Golgi_KA_CML.xml','2013-01-10 00:00:00',''),('NMLCH000021','Golgi_KCa_CML Channel','/var/www/NeuroMLmodels/NMLCH000021/Golgi_KCa_CML.xml','2013-01-10 00:00:00',''),('NMLCH000022','Golgi_KDr_CML Channel','/var/www/NeuroMLmodels/NMLCH000022/Golgi_KDr_CML.xml','2013-01-10 00:00:00',''),('NMLCH000023','Golgi_NaF_CML Channel','/var/www/NeuroMLmodels/NMLCH000023/Golgi_NaF_CML.xml','2013-01-10 00:00:00',''),('NMLCH000024','GolgiPassiveCond Channel','/var/www/NeuroMLmodels/NMLCH000024/GolgiPassiveCond.xml','2013-01-10 00:00:00',''),('NMLCH000025','NaP Channel','/var/www/NeuroMLmodels/NMLCH000025/NaP_Chan.xml','2013-01-31 00:00:00',''),('NMLCH000026','NaF Channel','/var/www/NeuroMLmodels/NMLCH000026/NaF_Chan.xml','2013-01-31 00:00:00',''),('NMLCH000027','Leak Channel','/var/www/NeuroMLmodels/NMLCH000027/LeakConductance.xml','2013-01-31 00:00:00',''),('NMLCH000028','KM Channel','/var/www/NeuroMLmodels/NMLCH000028/KMnew2_Chan.xml','2013-01-31 00:00:00',''),('NMLCH000029','Kh2 Channel','/var/www/NeuroMLmodels/NMLCH000029/Kh2_Chan.xml','2013-01-31 00:00:00',''),('NMLCH000030','Kh1 Channel','/var/www/NeuroMLmodels/NMLCH000030/Kh1_Chan.xml','2013-01-31 00:00:00',''),('NMLCH000031','Kdr Channel','/var/www/NeuroMLmodels/NMLCH000031/Kdr_Chan.xml','2013-01-31 00:00:00',''),('NMLCH000032','Kc Channel','/var/www/NeuroMLmodels/NMLCH000032/Kc_Chan.xml','2013-01-31 00:00:00',''),('NMLCH000033','KA Channel','/var/www/NeuroMLmodels/NMLCH000033/KA_Chan.xml','2013-01-31 00:00:00',''),('NMLCH000034','K2 Channel','/var/www/NeuroMLmodels/NMLCH000034/K2_Chan.xml','2013-01-31 00:00:00',''),('NMLCH000035','CaT Channel','/var/www/NeuroMLmodels/NMLCH000035/CaT_Chan.xml','2013-01-31 00:00:00',''),('NMLCH000036','Calcium Pool','/var/www/NeuroMLmodels/NMLCH000036/CaPool.xml','2013-01-31 00:00:00',''),('NMLCH000037','CaP_Channel','/var/www/NeuroMLmodels/NMLCH000037/CaP_Chan.xml','2013-01-31 00:00:00',''),('NMLCH000048','ar','/home/neuromine/models/ar/ar.xml','2013-10-11 05:13:39','Anomalous Rectifier conductance, also known as h-conductance (hyperpolarizing).'),('NMLCH000049','km','/home/neuromine/models/km/km.xml','2013-10-15 05:41:17','Potasium M type current (muscarinic receptor-suppressed).'),('NMLCH000050','nap Channel','/home/neuromine/models/nap_Channel/nap.xml','2013-10-15 05:46:45','Persistent (non inactivating) Sodium channel'),('NMLCH000051','Cad Channel','/home/neuromine/models/Cad_Channel/cad.xml','2013-10-15 05:52:08','An expontially decaying pool of calcium, with a ceiling concentration'),('NMLCH000052','Kahp Channel','/home/neuromine/models/Kahp_Channel/kahp.xml','2013-10-15 05:54:03','[Ca2+] dependent K AHP (afterhyperpolarization) conductance.'),('NMLCH000053','Cal Channel','/home/neuromine/models/Cal_Channel/cal.xml','2013-10-15 05:56:06','High threshold, long lasting Calcium L-type current.'),('NMLCH000055','kdr_fs Channel','/home/neuromine/models/kdr_fs_Channel/kdr_fs.xml','2013-10-15 06:39:37','Potasium delayed rectifier type conductance for fast-spiking (FS) interneurons for RD Traub et al 2005'),('NMLCH000056','kahp_slower','/home/neuromine/models/kahp_slower/kahp_slower.xml','2013-10-15 06:51:41','Slow [Ca2+] dependent K AHP (afterhyperpolarization) conductance. Slower version of kahp from Trau'),('NMLCH000057','kc_fast Channel','/home/neuromine/models/kc_fast_Channel/kc_fast.xml','2013-10-15 06:53:44','Fast voltage and [Ca2+] dependent K conductance (BK channel).'),('NMLCH000058','naf2 Channel','/home/neuromine/models/naf2_Channel/naf2.xml','2013-10-15 07:01:26','Fast Sodium transient (inactivating) current. Channel used in Traub et al 2005, slight modification of naf from Traub et al 2003'),('NMLCH000059','k2 Channel','/home/neuromine/models/k2_Channel/k2.xml','2013-10-15 07:02:53','Potasium K2-type current (slowly activating and inactivating).'),('NMLCH000066','CaHVA_CML','/var/www/NeuroMLmodels/NMLCH000066/CaHVA_CML.xml','2013-10-18 05:40:39',''),('NMLCH000067','CaLVA_CML','/var/www/NeuroMLmodels/NMLCH000067/CaLVA_CML.xml','2013-10-18 06:58:56',''),('NMLCH000068','Golgi_CALC_CML ','/var/www/NeuroMLmodels/NMLCH000068/Golgi_CALC_CML.xml','2013-10-18 07:02:48',''),('NMLCH000069','Golgi_CALC_ca2_CML ','/var/www/NeuroMLmodels/NMLCH000069/Golgi_CALC_ca2_CML.xml','2013-10-18 07:48:54',''),('NMLCH000086','hcn1f_CML','/var/www/NeuroMLModels/NMLCH000086/hcn1f_CML.xml','2014-07-23 02:29:53',''),('NMLCH000087','hcn1s_CML','/var/www/NeuroMLmodels/NMLCH000087/hcn1s_CML.xml','2014-07-23 02:31:19',''),('NMLCH000088','hcn2f_CML','/var/www/NeuroMLmodels/NMLCH000088/hcn2f_CML.xml','2014-07-23 02:32:21',''),('NMLCH000089','hcn2s_CML','/var/www/NeuroMLmodels/NMLCH000089/hcn2s_CML.xml','2014-07-23 02:33:27',''),('NMLCH000090','KA_CML','/var/www/NeuroMLmodels/NMLCH000090/KA_CML.xml','2014-07-23 02:34:25',''),('NMLCH000091','KAHP_CML','/var/www/NeuroMLmodels/NMLCH000091/KAHP_CML.xml','2014-07-23 02:35:23',''),('NMLCH000092','KC_CML','/var/www/NeuroMLmodels/NMLCH000092/KC_CML.xml','2014-07-23 02:36:14',''),('NMLCH000093','Kslow_CML','/var/www/NeuroMLmodels/NMLCH000093/Kslow_CML.xml','2014-07-23 02:37:08',''),('NMLCH000094','KV_CML','/var/www/NeuroMLmodels/NMLCH000094/KV_CML.xml','2014-07-23 02:37:48',''),('NMLCH000095','LeakConductance','/var/www/NeuroMLmodels/NMLCH000095/LeakConductance.xml','2014-07-23 02:38:30',''),('NMLCH000096','NaP_CML','/var/www/NeuroMLmodels/NMLCH000096/NaP_CML.xml','2014-07-23 02:39:10',''),('NMLCH000097','NaR_CML','/var/www/NeuroMLmodels/NMLCH000097/NaR_CML.xml','2014-07-23 02:39:51',''),('NMLCH000098','NaT_CML','/var/www/NeuroMLmodels/NMLCH000098/NaT_CML.xml','2014-07-23 02:40:31','');
/*!40000 ALTER TABLE `channels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `commented_type` varchar(30) NOT NULL DEFAULT '',
  `commented_id` int(11) NOT NULL DEFAULT '0',
  `author_id` int(11) NOT NULL DEFAULT '0',
  `comments` text,
  `created_on` datetime NOT NULL,
  `updated_on` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_comments_on_commented_id_and_commented_type` (`commented_id`,`commented_type`),
  KEY `index_comments_on_author_id` (`author_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `curationusers`
--

DROP TABLE IF EXISTS `curationusers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `curationusers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password_digest` varchar(255) DEFAULT NULL,
  `remember_token` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curationusers`
--

LOCK TABLES `curationusers` WRITE;
/*!40000 ALTER TABLE `curationusers` DISABLE KEYS */;
INSERT INTO `curationusers` VALUES (1,'admin',NULL,'$2a$10$Fo8JYJVxFUBMhkmLZtsGl.1VLZM14Sg3DN9nXNQQT9Dz2vwE9l0wO','d1f473f32504256b40dbc95c604372fb0bc7a9cb','2014-03-14 18:37:12','2014-03-20 16:02:17');
/*!40000 ALTER TABLE `curationusers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `custom_fields`
--

DROP TABLE IF EXISTS `custom_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `custom_fields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(30) NOT NULL DEFAULT '',
  `name` varchar(30) NOT NULL DEFAULT '',
  `field_format` varchar(30) NOT NULL DEFAULT '',
  `possible_values` text,
  `regexp` varchar(255) DEFAULT '',
  `min_length` int(11) NOT NULL DEFAULT '0',
  `max_length` int(11) NOT NULL DEFAULT '0',
  `is_required` tinyint(1) NOT NULL DEFAULT '0',
  `is_for_all` tinyint(1) NOT NULL DEFAULT '0',
  `is_filter` tinyint(1) NOT NULL DEFAULT '0',
  `position` int(11) DEFAULT '1',
  `searchable` tinyint(1) DEFAULT '0',
  `default_value` text,
  `editable` tinyint(1) DEFAULT '1',
  `visible` tinyint(1) NOT NULL DEFAULT '1',
  `multiple` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_custom_fields_on_id_and_type` (`id`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `custom_fields`
--

LOCK TABLES `custom_fields` WRITE;
/*!40000 ALTER TABLE `custom_fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `custom_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `custom_fields_projects`
--

DROP TABLE IF EXISTS `custom_fields_projects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `custom_fields_projects` (
  `custom_field_id` int(11) NOT NULL DEFAULT '0',
  `project_id` int(11) NOT NULL DEFAULT '0',
  UNIQUE KEY `index_custom_fields_projects_on_custom_field_id_and_project_id` (`custom_field_id`,`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `custom_fields_projects`
--

LOCK TABLES `custom_fields_projects` WRITE;
/*!40000 ALTER TABLE `custom_fields_projects` DISABLE KEYS */;
/*!40000 ALTER TABLE `custom_fields_projects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `custom_fields_trackers`
--

DROP TABLE IF EXISTS `custom_fields_trackers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `custom_fields_trackers` (
  `custom_field_id` int(11) NOT NULL DEFAULT '0',
  `tracker_id` int(11) NOT NULL DEFAULT '0',
  UNIQUE KEY `index_custom_fields_trackers_on_custom_field_id_and_tracker_id` (`custom_field_id`,`tracker_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `custom_fields_trackers`
--

LOCK TABLES `custom_fields_trackers` WRITE;
/*!40000 ALTER TABLE `custom_fields_trackers` DISABLE KEYS */;
/*!40000 ALTER TABLE `custom_fields_trackers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `custom_values`
--

DROP TABLE IF EXISTS `custom_values`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `custom_values` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `customized_type` varchar(30) NOT NULL DEFAULT '',
  `customized_id` int(11) NOT NULL DEFAULT '0',
  `custom_field_id` int(11) NOT NULL DEFAULT '0',
  `value` text,
  PRIMARY KEY (`id`),
  KEY `custom_values_customized` (`customized_type`,`customized_id`),
  KEY `index_custom_values_on_custom_field_id` (`custom_field_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `custom_values`
--

LOCK TABLES `custom_values` WRITE;
/*!40000 ALTER TABLE `custom_values` DISABLE KEYS */;
/*!40000 ALTER TABLE `custom_values` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `documents`
--

DROP TABLE IF EXISTS `documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `documents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL DEFAULT '0',
  `category_id` int(11) NOT NULL DEFAULT '0',
  `title` varchar(60) NOT NULL DEFAULT '',
  `description` text,
  `created_on` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `documents_project_id` (`project_id`),
  KEY `index_documents_on_category_id` (`category_id`),
  KEY `index_documents_on_created_on` (`created_on`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `documents`
--

LOCK TABLES `documents` WRITE;
/*!40000 ALTER TABLE `documents` DISABLE KEYS */;
/*!40000 ALTER TABLE `documents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `enabled_modules`
--

DROP TABLE IF EXISTS `enabled_modules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `enabled_modules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `enabled_modules_project_id` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enabled_modules`
--

LOCK TABLES `enabled_modules` WRITE;
/*!40000 ALTER TABLE `enabled_modules` DISABLE KEYS */;
/*!40000 ALTER TABLE `enabled_modules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `enumerations`
--

DROP TABLE IF EXISTS `enumerations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `enumerations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL DEFAULT '',
  `position` int(11) DEFAULT '1',
  `is_default` tinyint(1) NOT NULL DEFAULT '0',
  `type` varchar(255) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `project_id` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `position_name` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_enumerations_on_project_id` (`project_id`),
  KEY `index_enumerations_on_id_and_type` (`id`,`type`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enumerations`
--

LOCK TABLES `enumerations` WRITE;
/*!40000 ALTER TABLE `enumerations` DISABLE KEYS */;
INSERT INTO `enumerations` VALUES (1,'Low',1,0,'IssuePriority',1,NULL,NULL,'lowest'),(2,'Normal',2,1,'IssuePriority',1,NULL,NULL,'default'),(3,'High',3,0,'IssuePriority',1,NULL,NULL,'high3'),(4,'Urgent',4,0,'IssuePriority',1,NULL,NULL,'high2'),(5,'Immediate',5,0,'IssuePriority',1,NULL,NULL,'highest'),(6,'User documentation',1,0,'DocumentCategory',1,NULL,NULL,NULL),(7,'Technical documentation',2,0,'DocumentCategory',1,NULL,NULL,NULL),(8,'Design',1,0,'TimeEntryActivity',1,NULL,NULL,NULL),(9,'Development',2,0,'TimeEntryActivity',1,NULL,NULL,NULL);
/*!40000 ALTER TABLE `enumerations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `groups_users`
--

DROP TABLE IF EXISTS `groups_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `groups_users` (
  `group_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  UNIQUE KEY `groups_users_ids` (`group_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groups_users`
--

LOCK TABLES `groups_users` WRITE;
/*!40000 ALTER TABLE `groups_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `groups_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `issue_categories`
--

DROP TABLE IF EXISTS `issue_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `issue_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(30) NOT NULL DEFAULT '',
  `assigned_to_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `issue_categories_project_id` (`project_id`),
  KEY `index_issue_categories_on_assigned_to_id` (`assigned_to_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issue_categories`
--

LOCK TABLES `issue_categories` WRITE;
/*!40000 ALTER TABLE `issue_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `issue_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `issue_relations`
--

DROP TABLE IF EXISTS `issue_relations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `issue_relations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `issue_from_id` int(11) NOT NULL,
  `issue_to_id` int(11) NOT NULL,
  `relation_type` varchar(255) NOT NULL DEFAULT '',
  `delay` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_issue_relations_on_issue_from_id_and_issue_to_id` (`issue_from_id`,`issue_to_id`),
  KEY `index_issue_relations_on_issue_from_id` (`issue_from_id`),
  KEY `index_issue_relations_on_issue_to_id` (`issue_to_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issue_relations`
--

LOCK TABLES `issue_relations` WRITE;
/*!40000 ALTER TABLE `issue_relations` DISABLE KEYS */;
/*!40000 ALTER TABLE `issue_relations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `issue_statuses`
--

DROP TABLE IF EXISTS `issue_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `issue_statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL DEFAULT '',
  `is_closed` tinyint(1) NOT NULL DEFAULT '0',
  `is_default` tinyint(1) NOT NULL DEFAULT '0',
  `position` int(11) DEFAULT '1',
  `default_done_ratio` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_issue_statuses_on_position` (`position`),
  KEY `index_issue_statuses_on_is_closed` (`is_closed`),
  KEY `index_issue_statuses_on_is_default` (`is_default`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issue_statuses`
--

LOCK TABLES `issue_statuses` WRITE;
/*!40000 ALTER TABLE `issue_statuses` DISABLE KEYS */;
INSERT INTO `issue_statuses` VALUES (1,'New',0,1,1,NULL),(2,'In Progress',0,0,2,NULL),(3,'Resolved',0,0,3,NULL),(4,'Feedback',0,0,4,NULL),(5,'Closed',1,0,5,NULL),(6,'Rejected',1,0,6,NULL);
/*!40000 ALTER TABLE `issue_statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `issues`
--

DROP TABLE IF EXISTS `issues`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `issues` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tracker_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `subject` varchar(255) NOT NULL DEFAULT '',
  `description` text,
  `due_date` date DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `status_id` int(11) NOT NULL,
  `assigned_to_id` int(11) DEFAULT NULL,
  `priority_id` int(11) NOT NULL,
  `fixed_version_id` int(11) DEFAULT NULL,
  `author_id` int(11) NOT NULL,
  `lock_version` int(11) NOT NULL DEFAULT '0',
  `created_on` datetime DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `done_ratio` int(11) NOT NULL DEFAULT '0',
  `estimated_hours` float DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `root_id` int(11) DEFAULT NULL,
  `lft` int(11) DEFAULT NULL,
  `rgt` int(11) DEFAULT NULL,
  `is_private` tinyint(1) NOT NULL DEFAULT '0',
  `closed_on` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `issues_project_id` (`project_id`),
  KEY `index_issues_on_status_id` (`status_id`),
  KEY `index_issues_on_category_id` (`category_id`),
  KEY `index_issues_on_assigned_to_id` (`assigned_to_id`),
  KEY `index_issues_on_fixed_version_id` (`fixed_version_id`),
  KEY `index_issues_on_tracker_id` (`tracker_id`),
  KEY `index_issues_on_priority_id` (`priority_id`),
  KEY `index_issues_on_author_id` (`author_id`),
  KEY `index_issues_on_created_on` (`created_on`),
  KEY `index_issues_on_root_id_and_lft_and_rgt` (`root_id`,`lft`,`rgt`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issues`
--

LOCK TABLES `issues` WRITE;
/*!40000 ALTER TABLE `issues` DISABLE KEYS */;
/*!40000 ALTER TABLE `issues` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `journal_details`
--

DROP TABLE IF EXISTS `journal_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `journal_details` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `journal_id` int(11) NOT NULL DEFAULT '0',
  `property` varchar(30) NOT NULL DEFAULT '',
  `prop_key` varchar(30) NOT NULL DEFAULT '',
  `old_value` text,
  `value` text,
  PRIMARY KEY (`id`),
  KEY `journal_details_journal_id` (`journal_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `journal_details`
--

LOCK TABLES `journal_details` WRITE;
/*!40000 ALTER TABLE `journal_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `journal_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `journals`
--

DROP TABLE IF EXISTS `journals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `journals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `journalized_id` int(11) NOT NULL DEFAULT '0',
  `journalized_type` varchar(30) NOT NULL DEFAULT '',
  `user_id` int(11) NOT NULL DEFAULT '0',
  `notes` text,
  `created_on` datetime NOT NULL,
  `private_notes` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `journals_journalized_id` (`journalized_id`,`journalized_type`),
  KEY `index_journals_on_user_id` (`user_id`),
  KEY `index_journals_on_journalized_id` (`journalized_id`),
  KEY `index_journals_on_created_on` (`created_on`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `journals`
--

LOCK TABLES `journals` WRITE;
/*!40000 ALTER TABLE `journals` DISABLE KEYS */;
/*!40000 ALTER TABLE `journals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `kcategories`
--

DROP TABLE IF EXISTS `kcategories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `kcategories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category_name` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kcategories`
--

LOCK TABLES `kcategories` WRITE;
/*!40000 ALTER TABLE `kcategories` DISABLE KEYS */;
INSERT INTO `kcategories` VALUES (1,'Biological Keywords','2013-04-19 13:20:19','2013-04-19 13:21:30'),(2,'Modelling','2013-04-19 13:22:02','2013-04-19 13:22:02'),(3,'Simulation Software','2013-04-19 13:22:42','2013-04-19 13:22:42'),(4,'Organism','2013-04-19 13:24:21','2013-04-19 13:24:21');
/*!40000 ALTER TABLE `kcategories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `keyword_symbol_tables`
--

DROP TABLE IF EXISTS `keyword_symbol_tables`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `keyword_symbol_tables` (
  `Model_ID` varchar(45) NOT NULL,
  `Keyword` varchar(500) NOT NULL,
  PRIMARY KEY (`Model_ID`,`Keyword`),
  KEY `model_ID` (`Model_ID`),
  KEY `keyword` (`Keyword`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `keyword_symbol_tables`
--

LOCK TABLES `keyword_symbol_tables` WRITE;
/*!40000 ALTER TABLE `keyword_symbol_tables` DISABLE KEYS */;
INSERT INTO `keyword_symbol_tables` VALUES ('NMLCH000001','HCN channel, Hyperpolarization and cyclic-nucleotide gated'),('NMLCH000002','Voltage-gated potassium channel, K+'),('NMLCH000003','Voltage-gated potassium channel, K+'),('NMLCH000004','Voltage-gated potassium channel, K+'),('NMLCH000005','Voltage-gated sodium channel, Na+, Nav'),('NMLCH000006','Voltage-gated sodium channel, Na+, Nav'),('NMLCH000007','Leak Passive'),('NMLCH000008','Voltage-gated sodium channel, Na+, Nav'),('NMLCH000009','Voltage-gated potassium channel, K+'),('NMLCH000010','Calcium-activated potassium channel, Kca'),('NMLCH000011','Voltage-gated potassium channel, K+'),('NMLCH000012','HCN channel, Hyperpolarization and cyclic-nucleotide gated'),('NMLCH000013','Calcium Pool'),('NMLCH000013','Voltage-gated calcium channel, Ca+2. CaV'),('NMLCH000014','Voltage-gated calcium channel, Ca+2. CaV'),('NMLCH000015','Leak Passive'),('NMLCH000016','Leak Passive'),('NMLCH000017','Voltage-gated calcium channel, Ca+2. CaV'),('NMLCH000018','Calcium Pool'),('NMLCH000018','Voltage-gated calcium channel, Ca+2. CaV'),('NMLCH000019','HCN channel, Hyperpolarization and cyclic-nucleotide gated'),('NMLCH000020','Voltage-gated potassium channel, K+'),('NMLCH000021','Calcium-activated potassium channel, Kca'),('NMLCH000022','Voltage-gated potassium channel, K+'),('NMLCH000023','Voltage-gated sodium channel, Na+, Nav'),('NMLCH000024','Leak Passive'),('NMLCH000025','Voltage-gated sodium channel, Na+, Nav'),('NMLCH000026','Voltage-gated sodium channel, Na+, Nav'),('NMLCH000027','Leak Passive'),('NMLCH000028','Voltage-gated potassium channel, K+'),('NMLCH000029','Voltage-gated potassium channel, K+'),('NMLCH000030','Voltage-gated potassium channel, K+'),('NMLCH000031','Voltage-gated potassium channel, K+'),('NMLCH000032','Calcium-activated potassium channel, Kca'),('NMLCH000033','Voltage-gated potassium channel, K+'),('NMLCH000034','Calcium-activated potassium channel, Kca'),('NMLCH000035','Voltage-gated calcium channel, Ca+2. CaV'),('NMLCH000036','Calcium Pool'),('NMLCH000036','Voltage-gated calcium channel, Ca+2. CaV'),('NMLCH000037','Voltage-gated calcium channel, Ca+2. CaV'),('NMLCL000001','Ascoli'),('NMLCL000001','Ferrante'),('NMLCL000001','Giorgio'),('NMLCL000001','Gleeson'),('NMLCL000001','Hippocampus CA1 pyramidal cell, neuron'),('NMLCL000001','Michele'),('NMLCL000001','Migliore'),('NMLCL000001','Padraig '),('NMLCL000002','Cerebellum granule cell, Cerebellar, neuron'),('NMLCL000003','Cerebellar mossy fiber'),('NMLCL000004','Cerebellum Golgi cell, Cerebellar, neuron'),('NMLCL000005','Bower'),('NMLCL000005','Cerebellum Purkinje cell, Cerebellar, Purkyne, Corpuscles'),('NMLCL000005','De Schutter'),('NMLCL000005','Erik'),('NMLCL000005','Gleeson'),('NMLCL000005','James'),('NMLCL000005','Padraig '),('NMLNT000001','De Schutter'),('NMLNT000001','Erik'),('NMLNT000001','Gleeson'),('NMLNT000001','Granular layer of cerebellar cortex, granule, Network'),('NMLNT000001','Maex'),('NMLNT000001','Padraig '),('NMLNT000001','Reinoud');
/*!40000 ALTER TABLE `keyword_symbol_tables` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `keyword_view`
--

DROP TABLE IF EXISTS `keyword_view`;
/*!50001 DROP VIEW IF EXISTS `keyword_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `keyword_view` (
  `Model_ID` tinyint NOT NULL,
  `Keywords` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `kkeywords`
--

DROP TABLE IF EXISTS `kkeywords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `kkeywords` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `keyword_name` varchar(255) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kkeywords`
--

LOCK TABLES `kkeywords` WRITE;
/*!40000 ALTER TABLE `kkeywords` DISABLE KEYS */;
/*!40000 ALTER TABLE `kkeywords` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `later_keyword_query_results`
--

DROP TABLE IF EXISTS `later_keyword_query_results`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `later_keyword_query_results` (
  `Model_ID` varchar(45) NOT NULL,
  PRIMARY KEY (`Model_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `later_keyword_query_results`
--

LOCK TABLES `later_keyword_query_results` WRITE;
/*!40000 ALTER TABLE `later_keyword_query_results` DISABLE KEYS */;
INSERT INTO `later_keyword_query_results` VALUES ('NMLCH000017'),('NMLCH000018'),('NMLCH000019'),('NMLCH000020'),('NMLCH000021'),('NMLCH000022'),('NMLCH000023'),('NMLCH000024'),('NMLCL000004'),('NMLNT000001');
/*!40000 ALTER TABLE `later_keyword_query_results` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_roles`
--

DROP TABLE IF EXISTS `member_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `member_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  `inherited_from` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_member_roles_on_member_id` (`member_id`),
  KEY `index_member_roles_on_role_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_roles`
--

LOCK TABLES `member_roles` WRITE;
/*!40000 ALTER TABLE `member_roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `member_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members`
--

DROP TABLE IF EXISTS `members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `members` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `project_id` int(11) NOT NULL DEFAULT '0',
  `created_on` datetime DEFAULT NULL,
  `mail_notification` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_members_on_user_id_and_project_id` (`user_id`,`project_id`),
  KEY `index_members_on_user_id` (`user_id`),
  KEY `index_members_on_project_id` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members`
--

LOCK TABLES `members` WRITE;
/*!40000 ALTER TABLE `members` DISABLE KEYS */;
/*!40000 ALTER TABLE `members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `board_id` int(11) NOT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `subject` varchar(255) NOT NULL DEFAULT '',
  `content` text,
  `author_id` int(11) DEFAULT NULL,
  `replies_count` int(11) NOT NULL DEFAULT '0',
  `last_reply_id` int(11) DEFAULT NULL,
  `created_on` datetime NOT NULL,
  `updated_on` datetime NOT NULL,
  `locked` tinyint(1) DEFAULT '0',
  `sticky` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `messages_board_id` (`board_id`),
  KEY `messages_parent_id` (`parent_id`),
  KEY `index_messages_on_last_reply_id` (`last_reply_id`),
  KEY `index_messages_on_author_id` (`author_id`),
  KEY `index_messages_on_created_on` (`created_on`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `metadata`
--

DROP TABLE IF EXISTS `metadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `metadata` (
  `Metadata_ID` int(11) NOT NULL,
  PRIMARY KEY (`Metadata_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `metadata`
--

LOCK TABLES `metadata` WRITE;
/*!40000 ALTER TABLE `metadata` DISABLE KEYS */;
INSERT INTO `metadata` VALUES (1000001),(1000002),(1000003),(3000001),(3000002),(3000003),(3000004),(3000005),(3000006),(3000007),(3000008),(3000009),(3000010),(3000011),(4000001),(4000002),(5000001),(5000002),(5000003),(5000004),(5000005),(5000006),(6000001),(6000002),(6000003);
/*!40000 ALTER TABLE `metadata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `metadatas`
--

DROP TABLE IF EXISTS `metadatas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `metadatas` (
  `Metadata_ID` int(11) NOT NULL,
  PRIMARY KEY (`Metadata_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `metadatas`
--

LOCK TABLES `metadatas` WRITE;
/*!40000 ALTER TABLE `metadatas` DISABLE KEYS */;
INSERT INTO `metadatas` VALUES (1000001),(1000002),(1000003),(1000035),(1000036),(1000037),(1000038),(1000039),(1000041),(1000043),(1000044),(1000045),(1000046),(1000047),(1000051),(1000055),(1000059),(1000068),(1000072),(1000076),(1000080),(1000084),(1000088),(1000092),(1000156),(1000160),(1000164),(1000168),(1000173),(1000176),(1000198),(1000220),(1000221),(1000222),(3000001),(3000002),(3000003),(3000004),(3000005),(3000006),(3000007),(3000008),(3000009),(3000010),(3000011),(3000041),(3000044),(3000045),(3000046),(4000001),(4000002),(4000003),(4000004),(4000005),(4000006),(4000007),(4000008),(4000020),(4000021),(4000022),(4000023),(4000024),(4000025),(4000026),(4000027),(4000028),(4000029),(4000030),(4000031),(4000032),(4000033),(4000035),(4000036),(4000037),(4000038),(4000039),(4000040),(4000043),(4000044),(4000045),(4000046),(4000203),(4000229),(5000001),(5000002),(5000003),(5000004),(5000005),(5000006),(5000020),(5000021),(5000022),(5000023),(5000024),(5000025),(5000026),(5000027),(5000030),(5000032),(5000033),(5000035),(5000036),(5000037),(5000038),(5000041),(5000044),(5000045),(5000046),(5000049),(5000050),(5000053),(5000054),(5000057),(5000058),(5000066),(5000067),(5000070),(5000071),(5000074),(5000075),(5000078),(5000079),(5000082),(5000083),(5000086),(5000087),(5000090),(5000091),(5000093),(5000094),(5000095),(5000096),(5000097),(5000098),(5000101),(5000102),(5000105),(5000106),(5000109),(5000110),(5000113),(5000114),(5000117),(5000118),(5000121),(5000122),(5000125),(5000126),(5000129),(5000130),(5000133),(5000134),(5000137),(5000138),(5000141),(5000142),(5000145),(5000146),(5000149),(5000150),(5000153),(5000154),(5000158),(5000159),(5000162),(5000163),(5000166),(5000167),(5000170),(5000171),(5000172),(5000174),(5000175),(5000176),(5000177),(5000178),(5000179),(5000180),(5000181),(5000182),(5000183),(5000184),(5000185),(5000186),(5000187),(5000188),(5000189),(5000190),(5000191),(5000192),(5000194),(5000196),(5000197),(5000199),(5000201),(5000202),(5000204),(5000205),(5000206),(5000207),(5000208),(5000209),(5000210),(5000211),(5000212),(5000213),(5000214),(5000215),(5000216),(5000218),(5000219),(5000224),(5000225),(5000227),(5000228),(6000001),(6000002),(6000003),(6000019),(6000020),(6000021),(6000022),(6000023),(6000026),(6000032),(6000033),(6000037),(6000038),(6000041),(6000042),(6000043),(6000044),(6000045),(6000046),(6000048),(6000052),(6000056),(6000060),(6000062),(6000064),(6000065),(6000069),(6000073),(6000077),(6000081),(6000085),(6000089),(6000100),(6000104),(6000108),(6000112),(6000116),(6000120),(6000124),(6000128),(6000132),(6000136),(6000140),(6000144),(6000148),(6000152),(6000157),(6000161),(6000165),(6000169),(6000176),(6000177),(6000178),(6000179),(6000180),(6000181),(6000182),(6000183),(6000184),(6000185),(6000186),(6000187),(6000188),(6000189),(6000193),(6000195),(6000200),(6000217),(6000223),(6000226);
/*!40000 ALTER TABLE `metadatas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `model`
--

DROP TABLE IF EXISTS `model`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `model` (
  `Model_ID` varchar(45) NOT NULL,
  PRIMARY KEY (`Model_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `model`
--

LOCK TABLES `model` WRITE;
/*!40000 ALTER TABLE `model` DISABLE KEYS */;
INSERT INTO `model` VALUES ('NMLCH000001'),('NMLCH000002'),('NMLCH000003'),('NMLCH000004'),('NMLCH000005'),('NMLCH000006'),('NMLCH000007'),('NMLCH000008'),('NMLCH000009'),('NMLCH000010'),('NMLCH000011'),('NMLCH000012'),('NMLCH000013'),('NMLCH000014'),('NMLCH000015'),('NMLCH000016'),('NMLCH000017'),('NMLCH000018'),('NMLCH000019'),('NMLCH000020'),('NMLCH000021'),('NMLCH000022'),('NMLCH000023'),('NMLCH000024'),('NMLCH000025'),('NMLCH000026'),('NMLCH000027'),('NMLCH000028'),('NMLCH000029'),('NMLCH000030'),('NMLCH000031'),('NMLCH000032'),('NMLCH000033'),('NMLCH000034'),('NMLCH000035'),('NMLCH000036'),('NMLCH000037'),('NMLCL000001'),('NMLCL000002'),('NMLCL000003'),('NMLCL000004'),('NMLCL000005'),('NMLNT000001');
/*!40000 ALTER TABLE `model` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `model_metadata_associations`
--

DROP TABLE IF EXISTS `model_metadata_associations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `model_metadata_associations` (
  `Metadata_ID` int(11) NOT NULL,
  `Model_ID` varchar(45) NOT NULL,
  `Comments` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`Metadata_ID`,`Model_ID`),
  KEY `FK_Metadata_idx` (`Metadata_ID`),
  KEY `FK_Model_idx` (`Model_ID`),
  CONSTRAINT `FK_Metadata` FOREIGN KEY (`Metadata_ID`) REFERENCES `metadatas` (`Metadata_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_Model` FOREIGN KEY (`Model_ID`) REFERENCES `models` (`Model_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `model_metadata_associations`
--

LOCK TABLES `model_metadata_associations` WRITE;
/*!40000 ALTER TABLE `model_metadata_associations` DISABLE KEYS */;
INSERT INTO `model_metadata_associations` VALUES (1000001,'NMLCL000001',NULL),(1000002,'NMLNT000001',NULL),(1000003,'NMLCH000026','Inherited author_list metadata from parent NMLCL000005'),(1000003,'NMLCH000027','Inherited author_list metadata from parent NMLCL000005'),(1000003,'NMLCH000028','Inherited author_list metadata from parent NMLCL000005'),(1000003,'NMLCH000029','Inherited author_list metadata from parent NMLCL000005'),(1000003,'NMLCH000030','Inherited author_list metadata from parent NMLCL000005'),(1000003,'NMLCH000031','Inherited author_list metadata from parent NMLCL000005'),(1000003,'NMLCH000032','Inherited author_list metadata from parent NMLCL000005'),(1000003,'NMLCH000033','Inherited author_list metadata from parent NMLCL000005'),(1000003,'NMLCH000034','Inherited author_list metadata from parent NMLCL000005'),(1000003,'NMLCH000035','Inherited author_list metadata from parent NMLCL000005'),(1000003,'NMLCH000036','Inherited author_list metadata from parent NMLCL000005'),(1000003,'NMLCH000037','Inherited author_list metadata from parent NMLCL000005'),(1000003,'NMLCL000005',NULL),(1000035,'NMLSY000064',NULL),(1000036,'NMLSY000065',NULL),(1000037,'NMLCH000066',NULL),(1000038,'NMLCH000067',NULL),(1000039,'NMLCH000068',NULL),(1000041,'NMLNT000070',NULL),(1000043,'NMLCL000072',NULL),(1000044,'NMLCL000073',NULL),(1000045,'NMLCL000077',NULL),(1000046,'NMLCL000078',NULL),(1000047,'NMLSY000079',NULL),(1000051,'NMLCH000008','Inherited author_list metadata from parent NMLCL000002'),(1000051,'NMLCH000009','Inherited author_list metadata from parent NMLCL000002'),(1000051,'NMLCH000010','Inherited author_list metadata from parent NMLCL000002'),(1000051,'NMLCH000011','Inherited author_list metadata from parent NMLCL000002'),(1000051,'NMLCH000012','Inherited author_list metadata from parent NMLCL000002'),(1000051,'NMLCH000013','Inherited author_list metadata from parent NMLCL000002'),(1000051,'NMLCH000014','Inherited author_list metadata from parent NMLCL000002'),(1000051,'NMLCH000015','Inherited author_list metadata from parent NMLCL000002'),(1000051,'NMLCL000002',NULL),(1000055,'NMLCH000016','Inherited author_list metadata from parent NMLCL000003'),(1000055,'NMLCL000003',NULL),(1000059,'NMLCH000017','Inherited author_list metadata from parent NMLCL000004'),(1000059,'NMLCH000018','Inherited author_list metadata from parent NMLCL000004'),(1000059,'NMLCH000019','Inherited author_list metadata from parent NMLCL000004'),(1000059,'NMLCH000020','Inherited author_list metadata from parent NMLCL000004'),(1000059,'NMLCH000021','Inherited author_list metadata from parent NMLCL000004'),(1000059,'NMLCH000022','Inherited author_list metadata from parent NMLCL000004'),(1000059,'NMLCH000023','Inherited author_list metadata from parent NMLCL000004'),(1000059,'NMLCH000024','Inherited author_list metadata from parent NMLCL000004'),(1000059,'NMLCL000004',NULL),(1000068,'NMLCH000001',NULL),(1000072,'NMLCH000002',NULL),(1000076,'NMLCH000003',NULL),(1000080,'NMLCH000004',NULL),(1000084,'NMLCH000005',NULL),(1000088,'NMLCH000006',NULL),(1000092,'NMLCH000007',NULL),(1000156,'NMLSY000080',NULL),(1000160,'NMLSY000081',NULL),(1000164,'NMLSY000082',NULL),(1000168,'NMLSY000083',NULL),(1000173,'NMLSY000084',NULL),(1000176,'NMLCH000086','Inherited author_list metadata from parent NMLCL000085'),(1000176,'NMLCH000087','Inherited author_list metadata from parent NMLCL000085'),(1000176,'NMLCH000088','Inherited author_list metadata from parent NMLCL000085'),(1000176,'NMLCH000089','Inherited author_list metadata from parent NMLCL000085'),(1000176,'NMLCH000090','Inherited author_list metadata from parent NMLCL000085'),(1000176,'NMLCH000091','Inherited author_list metadata from parent NMLCL000085'),(1000176,'NMLCH000092','Inherited author_list metadata from parent NMLCL000085'),(1000176,'NMLCH000093','Inherited author_list metadata from parent NMLCL000085'),(1000176,'NMLCH000094','Inherited author_list metadata from parent NMLCL000085'),(1000176,'NMLCH000095','Inherited author_list metadata from parent NMLCL000085'),(1000176,'NMLCH000096','Inherited author_list metadata from parent NMLCL000085'),(1000176,'NMLCH000097','Inherited author_list metadata from parent NMLCL000085'),(1000176,'NMLCH000098','Inherited author_list metadata from parent NMLCL000085'),(1000176,'NMLCL000085',NULL),(1000198,'NMLCH000069',NULL),(1000220,'NMLCH000025',NULL),(1000221,'NMLSY000099',NULL),(1000222,'NMLSY000100',NULL),(3000001,'NMLCL000001',NULL),(3000002,'NMLCH000002',NULL),(3000002,'NMLCH000003',NULL),(3000002,'NMLCH000004',NULL),(3000002,'NMLCH000009',NULL),(3000002,'NMLCH000011',NULL),(3000002,'NMLCH000020',NULL),(3000002,'NMLCH000022',NULL),(3000002,'NMLCH000028',NULL),(3000002,'NMLCH000029',NULL),(3000002,'NMLCH000030',NULL),(3000002,'NMLCH000031',NULL),(3000002,'NMLCH000033',NULL),(3000003,'NMLCH000005',NULL),(3000003,'NMLCH000006',NULL),(3000003,'NMLCH000008',NULL),(3000003,'NMLCH000023',NULL),(3000003,'NMLCH000025',NULL),(3000003,'NMLCH000026',NULL),(3000004,'NMLCH000001',NULL),(3000004,'NMLCH000012',NULL),(3000004,'NMLCH000019',NULL),(3000005,'NMLNT000001',NULL),(3000006,'NMLCL000002',NULL),(3000007,'NMLCL000003',NULL),(3000008,'NMLCL000004',NULL),(3000009,'NMLCH000010',NULL),(3000009,'NMLCH000021',NULL),(3000009,'NMLCH000032',NULL),(3000009,'NMLCH000034',NULL),(3000010,'NMLCH000013',NULL),(3000010,'NMLCH000014',NULL),(3000010,'NMLCH000017',NULL),(3000010,'NMLCH000018',NULL),(3000010,'NMLCH000035',NULL),(3000010,'NMLCH000036',NULL),(3000010,'NMLCH000037',NULL),(3000011,'NMLCL000005',NULL),(3000041,'NMLNT000070',NULL),(3000044,'NMLCL000073',NULL),(3000045,'NMLCL000077',NULL),(3000046,'NMLCL000078',NULL),(4000001,'NMLCH000013',NULL),(4000001,'NMLCH000018',NULL),(4000001,'NMLCH000036',NULL),(4000002,'NMLCH000007',NULL),(4000002,'NMLCH000015',NULL),(4000002,'NMLCH000016',NULL),(4000002,'NMLCH000024',NULL),(4000002,'NMLCH000027',NULL),(4000003,'NMLNT000001',NULL),(4000004,'NMLNT000001',NULL),(4000005,'NMLCL000001',NULL),(4000006,'NMLCL000001',NULL),(4000007,'NMLCL000001',NULL),(4000008,'NMLCL000005',NULL),(4000020,'NMLCH000048',NULL),(4000021,'NMLCH000049',NULL),(4000022,'NMLCH000050',NULL),(4000023,'NMLCH000051',NULL),(4000024,'NMLCH000052',NULL),(4000025,'NMLCH000053',NULL),(4000026,'NMLCL000054',NULL),(4000027,'NMLCH000055',NULL),(4000028,'NMLCH000056',NULL),(4000029,'NMLCH000057',NULL),(4000030,'NMLCH000058',NULL),(4000031,'NMLCH000059',NULL),(4000032,'NMLCL000060',NULL),(4000033,'NMLCL000061',NULL),(4000035,'NMLSY000064',NULL),(4000036,'NMLSY000065',NULL),(4000037,'NMLCH000066',NULL),(4000038,'NMLCH000067',NULL),(4000039,'NMLCH000068',NULL),(4000040,'NMLCH000069',NULL),(4000043,'NMLCL000072',NULL),(4000044,'NMLCL000073',NULL),(4000045,'NMLCL000077',NULL),(4000046,'NMLCL000078',NULL),(4000203,'NMLSY000084',NULL),(4000229,'NMLNT000070',NULL),(5000001,'NMLCL000001',NULL),(5000002,'NMLCL000001',NULL),(5000003,'NMLNT000001',NULL),(5000004,'NMLNT000001',NULL),(5000005,'NMLCH000026','Inherited references metadata from parent NMLCL000005'),(5000005,'NMLCH000027','Inherited references metadata from parent NMLCL000005'),(5000005,'NMLCH000028','Inherited references metadata from parent NMLCL000005'),(5000005,'NMLCH000029','Inherited references metadata from parent NMLCL000005'),(5000005,'NMLCH000030','Inherited references metadata from parent NMLCL000005'),(5000005,'NMLCH000031','Inherited references metadata from parent NMLCL000005'),(5000005,'NMLCH000032','Inherited references metadata from parent NMLCL000005'),(5000005,'NMLCH000033','Inherited references metadata from parent NMLCL000005'),(5000005,'NMLCH000034','Inherited references metadata from parent NMLCL000005'),(5000005,'NMLCH000035','Inherited references metadata from parent NMLCL000005'),(5000005,'NMLCH000036','Inherited references metadata from parent NMLCL000005'),(5000005,'NMLCH000037','Inherited references metadata from parent NMLCL000005'),(5000005,'NMLCL000005',NULL),(5000006,'NMLCH000026','Inherited references metadata from parent NMLCL000005'),(5000006,'NMLCH000027','Inherited references metadata from parent NMLCL000005'),(5000006,'NMLCH000028','Inherited references metadata from parent NMLCL000005'),(5000006,'NMLCH000029','Inherited references metadata from parent NMLCL000005'),(5000006,'NMLCH000030','Inherited references metadata from parent NMLCL000005'),(5000006,'NMLCH000031','Inherited references metadata from parent NMLCL000005'),(5000006,'NMLCH000032','Inherited references metadata from parent NMLCL000005'),(5000006,'NMLCH000033','Inherited references metadata from parent NMLCL000005'),(5000006,'NMLCH000034','Inherited references metadata from parent NMLCL000005'),(5000006,'NMLCH000035','Inherited references metadata from parent NMLCL000005'),(5000006,'NMLCH000036','Inherited references metadata from parent NMLCL000005'),(5000006,'NMLCH000037','Inherited references metadata from parent NMLCL000005'),(5000006,'NMLCL000005',NULL),(5000020,'NMLCH000048',NULL),(5000021,'NMLCH000049',NULL),(5000022,'NMLCH000050',NULL),(5000023,'NMLCH000051',NULL),(5000024,'NMLCH000052',NULL),(5000025,'NMLCH000053',NULL),(5000026,'NMLCL000054',NULL),(5000027,'NMLCH000055',NULL),(5000030,'NMLCH000058',NULL),(5000032,'NMLCL000060',NULL),(5000033,'NMLCL000061',NULL),(5000035,'NMLSY000064',NULL),(5000036,'NMLSY000065',NULL),(5000037,'NMLCH000066',NULL),(5000038,'NMLCH000067',NULL),(5000041,'NMLNT000070',NULL),(5000044,'NMLCL000073',NULL),(5000045,'NMLCL000077',NULL),(5000046,'NMLCL000078',NULL),(5000049,'NMLCL000002',NULL),(5000050,'NMLCL000002',NULL),(5000053,'NMLCL000003',NULL),(5000054,'NMLCL000003',NULL),(5000057,'NMLCL000004',NULL),(5000058,'NMLCL000004',NULL),(5000066,'NMLCH000001',NULL),(5000067,'NMLCH000001',NULL),(5000070,'NMLCH000002',NULL),(5000071,'NMLCH000002',NULL),(5000074,'NMLCH000003',NULL),(5000075,'NMLCH000003',NULL),(5000078,'NMLCH000004',NULL),(5000079,'NMLCH000004',NULL),(5000082,'NMLCH000005',NULL),(5000083,'NMLCH000005',NULL),(5000086,'NMLCH000006',NULL),(5000087,'NMLCH000006',NULL),(5000090,'NMLCH000007',NULL),(5000091,'NMLCH000007',NULL),(5000093,'NMLCH000008',NULL),(5000094,'NMLCH000008',NULL),(5000095,'NMLCH000009',NULL),(5000096,'NMLCH000009',NULL),(5000097,'NMLCH000010',NULL),(5000098,'NMLCH000010',NULL),(5000101,'NMLCH000011',NULL),(5000102,'NMLCH000011',NULL),(5000105,'NMLCH000012',NULL),(5000106,'NMLCH000012',NULL),(5000109,'NMLCH000013',NULL),(5000110,'NMLCH000013',NULL),(5000113,'NMLCH000014',NULL),(5000114,'NMLCH000014',NULL),(5000117,'NMLCH000015',NULL),(5000118,'NMLCH000015',NULL),(5000121,'NMLCH000017',NULL),(5000122,'NMLCH000017',NULL),(5000125,'NMLCH000018',NULL),(5000126,'NMLCH000018',NULL),(5000129,'NMLCH000019',NULL),(5000130,'NMLCH000019',NULL),(5000133,'NMLCH000020',NULL),(5000134,'NMLCH000020',NULL),(5000137,'NMLCH000021',NULL),(5000138,'NMLCH000021',NULL),(5000141,'NMLCH000022',NULL),(5000142,'NMLCH000022',NULL),(5000145,'NMLCH000023',NULL),(5000146,'NMLCH000023',NULL),(5000149,'NMLCH000024',NULL),(5000150,'NMLCH000024',NULL),(5000153,'NMLCH000016',NULL),(5000154,'NMLCH000016',NULL),(5000158,'NMLSY000080',NULL),(5000159,'NMLSY000080',NULL),(5000162,'NMLSY000081',NULL),(5000163,'NMLSY000081',NULL),(5000166,'NMLSY000082',NULL),(5000167,'NMLSY000082',NULL),(5000170,'NMLSY000083',NULL),(5000171,'NMLSY000083',NULL),(5000172,'NMLNT000070',NULL),(5000174,'NMLCL000054',NULL),(5000175,'NMLCL000060',NULL),(5000176,'NMLCL000085',NULL),(5000177,'NMLCH000086',NULL),(5000178,'NMLCH000087',NULL),(5000179,'NMLCH000088',NULL),(5000180,'NMLCH000089',NULL),(5000181,'NMLCH000090',NULL),(5000182,'NMLCH000091',NULL),(5000183,'NMLCH000092',NULL),(5000184,'NMLCH000093',NULL),(5000185,'NMLCH000094',NULL),(5000186,'NMLCH000095',NULL),(5000187,'NMLCH000096',NULL),(5000188,'NMLCH000097',NULL),(5000189,'NMLCH000098',NULL),(5000190,'NMLCH000066',NULL),(5000191,'NMLCH000067',NULL),(5000192,'NMLCH000068',NULL),(5000194,'NMLCH000068',NULL),(5000196,'NMLCH000069',NULL),(5000197,'NMLCH000069',NULL),(5000199,'NMLCL000085',NULL),(5000201,'NMLSY000084',NULL),(5000202,'NMLSY000084',NULL),(5000204,'NMLCH000086',NULL),(5000205,'NMLCH000087',NULL),(5000206,'NMLCH000088',NULL),(5000207,'NMLCH000089',NULL),(5000208,'NMLCH000090',NULL),(5000209,'NMLCH000091',NULL),(5000210,'NMLCH000092',NULL),(5000211,'NMLCH000093',NULL),(5000212,'NMLCH000094',NULL),(5000213,'NMLCH000095',NULL),(5000214,'NMLCH000096',NULL),(5000215,'NMLCH000097',NULL),(5000216,'NMLCH000098',NULL),(5000218,'NMLCH000025',NULL),(5000219,'NMLCH000025',NULL),(5000224,'NMLSY000099',NULL),(5000225,'NMLSY000099',NULL),(5000227,'NMLSY000100',NULL),(5000228,'NMLSY000100',NULL),(6000001,'NMLCL000001',NULL),(6000002,'NMLNT000001',NULL),(6000003,'NMLCH000026','Inherited publications metadata from parent NMLCL000005'),(6000003,'NMLCH000027','Inherited publications metadata from parent NMLCL000005'),(6000003,'NMLCH000028','Inherited publications metadata from parent NMLCL000005'),(6000003,'NMLCH000029','Inherited publications metadata from parent NMLCL000005'),(6000003,'NMLCH000030','Inherited publications metadata from parent NMLCL000005'),(6000003,'NMLCH000031','Inherited publications metadata from parent NMLCL000005'),(6000003,'NMLCH000032','Inherited publications metadata from parent NMLCL000005'),(6000003,'NMLCH000033','Inherited publications metadata from parent NMLCL000005'),(6000003,'NMLCH000034','Inherited publications metadata from parent NMLCL000005'),(6000003,'NMLCH000035','Inherited publications metadata from parent NMLCL000005'),(6000003,'NMLCH000036','Inherited publications metadata from parent NMLCL000005'),(6000003,'NMLCH000037','Inherited publications metadata from parent NMLCL000005'),(6000003,'NMLCL000005',NULL),(6000020,'NMLCH000048',NULL),(6000021,'NMLCH000049',NULL),(6000022,'NMLCH000050',NULL),(6000023,'NMLCH000051',NULL),(6000026,'NMLCL000054',NULL),(6000032,'NMLCL000060',NULL),(6000033,'NMLCL000061',NULL),(6000037,'NMLCH000066',NULL),(6000038,'NMLCH000067',NULL),(6000041,'NMLNT000070',NULL),(6000043,'NMLCL000072',NULL),(6000044,'NMLCL000073',NULL),(6000045,'NMLCL000077',NULL),(6000046,'NMLCL000078',NULL),(6000048,'NMLCL000002',NULL),(6000052,'NMLCL000003',NULL),(6000056,'NMLCL000004',NULL),(6000060,'NMLCH000008',NULL),(6000062,'NMLCH000009',NULL),(6000064,'NMLCH000010',NULL),(6000065,'NMLCH000001',NULL),(6000069,'NMLCH000002',NULL),(6000073,'NMLCH000003',NULL),(6000077,'NMLCH000004',NULL),(6000081,'NMLCH000005',NULL),(6000085,'NMLCH000006',NULL),(6000089,'NMLCH000007',NULL),(6000100,'NMLCH000011',NULL),(6000104,'NMLCH000012',NULL),(6000108,'NMLCH000013',NULL),(6000112,'NMLCH000014',NULL),(6000116,'NMLCH000015',NULL),(6000120,'NMLCH000017',NULL),(6000124,'NMLCH000018',NULL),(6000128,'NMLCH000019',NULL),(6000132,'NMLCH000020',NULL),(6000136,'NMLCH000021',NULL),(6000140,'NMLCH000022',NULL),(6000144,'NMLCH000023',NULL),(6000148,'NMLCH000024',NULL),(6000152,'NMLCH000016',NULL),(6000157,'NMLSY000080',NULL),(6000161,'NMLSY000081',NULL),(6000165,'NMLSY000082',NULL),(6000169,'NMLSY000083',NULL),(6000176,'NMLCL000085',NULL),(6000177,'NMLCH000086',NULL),(6000178,'NMLCH000087',NULL),(6000179,'NMLCH000088',NULL),(6000180,'NMLCH000089',NULL),(6000181,'NMLCH000090',NULL),(6000182,'NMLCH000091',NULL),(6000183,'NMLCH000092',NULL),(6000184,'NMLCH000093',NULL),(6000185,'NMLCH000094',NULL),(6000186,'NMLCH000095',NULL),(6000187,'NMLCH000096',NULL),(6000188,'NMLCH000097',NULL),(6000189,'NMLCH000098',NULL),(6000193,'NMLCH000068',NULL),(6000195,'NMLCH000069',NULL),(6000200,'NMLSY000084',NULL),(6000217,'NMLCH000025',NULL),(6000223,'NMLSY000099',NULL),(6000226,'NMLSY000100',NULL);
/*!40000 ALTER TABLE `model_metadata_associations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `models`
--

DROP TABLE IF EXISTS `models`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `models` (
  `Model_ID` varchar(45) NOT NULL,
  PRIMARY KEY (`Model_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `models`
--

LOCK TABLES `models` WRITE;
/*!40000 ALTER TABLE `models` DISABLE KEYS */;
INSERT INTO `models` VALUES ('NMLCH000001'),('NMLCH000002'),('NMLCH000003'),('NMLCH000004'),('NMLCH000005'),('NMLCH000006'),('NMLCH000007'),('NMLCH000008'),('NMLCH000009'),('NMLCH000010'),('NMLCH000011'),('NMLCH000012'),('NMLCH000013'),('NMLCH000014'),('NMLCH000015'),('NMLCH000016'),('NMLCH000017'),('NMLCH000018'),('NMLCH000019'),('NMLCH000020'),('NMLCH000021'),('NMLCH000022'),('NMLCH000023'),('NMLCH000024'),('NMLCH000025'),('NMLCH000026'),('NMLCH000027'),('NMLCH000028'),('NMLCH000029'),('NMLCH000030'),('NMLCH000031'),('NMLCH000032'),('NMLCH000033'),('NMLCH000034'),('NMLCH000035'),('NMLCH000036'),('NMLCH000037'),('NMLCH000048'),('NMLCH000049'),('NMLCH000050'),('NMLCH000051'),('NMLCH000052'),('NMLCH000053'),('NMLCH000055'),('NMLCH000056'),('NMLCH000057'),('NMLCH000058'),('NMLCH000059'),('NMLCH000066'),('NMLCH000067'),('NMLCH000068'),('NMLCH000069'),('NMLCH000086'),('NMLCH000087'),('NMLCH000088'),('NMLCH000089'),('NMLCH000090'),('NMLCH000091'),('NMLCH000092'),('NMLCH000093'),('NMLCH000094'),('NMLCH000095'),('NMLCH000096'),('NMLCH000097'),('NMLCH000098'),('NMLCL000001'),('NMLCL000002'),('NMLCL000003'),('NMLCL000004'),('NMLCL000005'),('NMLCL000054'),('NMLCL000060'),('NMLCL000061'),('NMLCL000072'),('NMLCL000073'),('NMLCL000077'),('NMLCL000078'),('NMLCL000085'),('NMLNT000001'),('NMLNT000070'),('NMLSY000064'),('NMLSY000065'),('NMLSY000079'),('NMLSY000080'),('NMLSY000081'),('NMLSY000082'),('NMLSY000083'),('NMLSY000084'),('NMLSY000099'),('NMLSY000100');
/*!40000 ALTER TABLE `models` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `modeluploads`
--

DROP TABLE IF EXISTS `modeluploads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `modeluploads` (
  `SubmissionID` int(11) NOT NULL AUTO_INCREMENT,
  `FirstName` varchar(45) NOT NULL,
  `MiddleName` varchar(45) DEFAULT NULL,
  `LastName` varchar(45) DEFAULT NULL,
  `ModelName` varchar(45) NOT NULL,
  `Email` varchar(45) NOT NULL,
  `Institution` varchar(45) NOT NULL,
  `Publication` text,
  `Modelref` text,
  `Description` text,
  `Modelspath` varchar(45) NOT NULL,
  `Keywords` text,
  `Comments` text,
  `Contributor` text,
  `Modeltype` varchar(10) DEFAULT NULL,
  `Upload_Time` datetime DEFAULT NULL,
  PRIMARY KEY (`SubmissionID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `modeluploads`
--

LOCK TABLES `modeluploads` WRITE;
/*!40000 ALTER TABLE `modeluploads` DISABLE KEYS */;
INSERT INTO `modeluploads` VALUES (1,'Padraig','','Gleeson','ca1 pyramidal cell','p.gleeson@ucl.ac.uk','INCF','http://www.ncbi.nlm.nih.gov/pubmed/21822270','','Cell exported from NEURON ModelView in NeuroML Level 2 format and imported into neuroConstruct. The densities of hd, kap, kad have been replaced with variable mechanisms recreating the densities as used in the original model from ModelDB.','/home/neuromine/models/ca1_pyramidal_cell/CA1','Hippocampal CA1 pyramidal ,CA1 sublayers,proximo-distal,somatodendritic backpropagation ,gamma oscillations ,bimodal distribution,calbindin immunoreactivity,neuronal somata','These files are not the source files for the model, they have been generated from the source of the model in the neuroConstruct directory. \r\n\r\nThese have been added to provide examples of valid NeuroML files for testing applications & the OSB website and may be removed at any time.','0','Cell','2014-03-12 00:00:00'),(2,'Padraig','','Gleeson','purkinje cell','p.gleeson@ucl.ac.uk','INCF','http://www.ncbi.nlm.nih.gov/pubmed/15665875','http://www.opensourcebrain.org/projects/purkinjecell','Cell: soma exported from NEURON ModelView','/home/neuromine/models/purkinje_cell/purk2.nm','','These files are not the source files for the model, they have been generated from the source of the model in the neuroConstruct directory. \r\n\r\nThese have been added to provide examples of valid NeuroML files for testing applications & the OSB website and may be removed at any time.\r\n\r\n','0','Cell','2014-03-12 00:00:00'),(3,'Padraig','','Gleeson','Thalamocortical','p.gleeson@ucl.ac.uk','INCF','http://www.ncbi.nlm.nih.gov/pubmed/23032387','http://www.opensourcebrain.org/embedded/thalamocortical/index.html','his is a project implementing cells from the thalamocortical network model of Traub et al 2005 in NeuroML. Based on the NEURON implementation from: http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=45539.\r\n\r\nThis model can be run on NEURON, GENESIS and MOOSE (though not yet PSICS as calcium dynamics aren\'t supported). It can also be used to generate a smaller version of the Layer 2/3 network model described in Cunningham et al 2004.\r\n\r\nThe Default Simulation Configuration contains a single compartment cell model containing all of the 22 active channels (plus a passive conductance and a calcium pool) as used in the more detailed cell models. To run this simulation through the neuroConstruct interface, click on tab Generate, select Default Simulation Configuration, press Generate, go to tab Export -> NEURON, press Create hoc simulation, and run the simulation (or do the equivalent at tab GENESIS; MOOSE can be generated at that tab too).\r\n\r\nThe Simulation Configurations CellX-xxx-Figxx etc. attempt to reproduce the figures for cell behaviour in Appendix A of Traub et al 2005. The sim configs CellX-xxx-10ms etc. had been used for comparison to the cell behaviour in the NEURON download from ModelDB, but have not all been kept up to date. ','/home/neuromine/models/Thalamocortical/L23Pyr','ar, AR_mod, cad_mod, cal, CaL_mod, cat, cat_a, cat_a_mod, CaT_mod, k2, K2_mod, ka, ka_ib, ka_ib_mod, Ka_mod, kahp, kahp_deeppyr, kahp_deeppyr_mod, Kahp_mod, kahp_slower, kahp_slower_mod, kc, kc_fast, kc_fast_mod, Kc_mod, kdr, kdr_fs, kdr_fs_mod, Kdr_mod, km, Km_mod, LeakCond, naf, naf2, naf2_mod, Na','Most of the cells have a spatial discretisation which will allow single cell simulations to run in a reasonable time (a few minutes). However, most cells will require a greater spatial discretisation (and/or smaller timestep) to ensure NEURON, GENESIS and MOOSE simulations are in close alignment. See Help -> Glossary -> Electrotonic length.\r\n\r\nThe simulation configuration CunninghamEtAl04_small generates a 56 cell Layer 2/3 network based on Cunningham Et Al 2004. This simulation too requires a much finer spatial discretisation and a small dt (~0.001) to get precise spike time agreement across simulators.\r\n\r\nOther simulation configurations are present for testing a lagre scale thalamocortical network version of the model, but are not yet stable. ','0','Cell','2014-03-12 00:00:00'),(4,'harsha','','vp','purkinje cell 12','svelugot@asu.edu','asu','test','http://neurolex.org/wiki/Category:Cerebellum_Purkinje_cell','test','/home/neuromine/models/purkinje_cell_12/SupLT','test,test12','tet','0','Cell','2014-03-12 00:00:00');
/*!40000 ALTER TABLE `modeluploads` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `network_cell_associations`
--

DROP TABLE IF EXISTS `network_cell_associations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `network_cell_associations` (
  `Network_ID` varchar(45) NOT NULL,
  `Cell_ID` varchar(45) NOT NULL,
  `Comments` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`Network_ID`,`Cell_ID`),
  KEY `NetworkID_idx` (`Cell_ID`),
  KEY `FK_Network_idx` (`Network_ID`),
  KEY `FK_Network_cell_idx` (`Cell_ID`),
  CONSTRAINT `FK_Network` FOREIGN KEY (`Network_ID`) REFERENCES `networks` (`Network_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_Network_cell` FOREIGN KEY (`Cell_ID`) REFERENCES `cells` (`Cell_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `network_cell_associations`
--

LOCK TABLES `network_cell_associations` WRITE;
/*!40000 ALTER TABLE `network_cell_associations` DISABLE KEYS */;
INSERT INTO `network_cell_associations` VALUES ('NMLNT000001','NMLCL000002',NULL),('NMLNT000001','NMLCL000003',NULL),('NMLNT000001','NMLCL000004',NULL),('NMLNT000070','NMLCL000085',NULL);
/*!40000 ALTER TABLE `network_cell_associations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `network_cell_channel_association_views`
--

DROP TABLE IF EXISTS `network_cell_channel_association_views`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `network_cell_channel_association_views` (
  `Network_ID` varchar(45) DEFAULT NULL,
  `Cell_ID` varchar(45) DEFAULT NULL,
  `Channel_ID` varchar(45) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `network_cell_channel_association_views`
--

LOCK TABLES `network_cell_channel_association_views` WRITE;
/*!40000 ALTER TABLE `network_cell_channel_association_views` DISABLE KEYS */;
/*!40000 ALTER TABLE `network_cell_channel_association_views` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `network_synapse_associations`
--

DROP TABLE IF EXISTS `network_synapse_associations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `network_synapse_associations` (
  `Network_ID` varchar(45) NOT NULL,
  `Synapse_ID` varchar(45) NOT NULL,
  `Comments` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`Network_ID`,`Synapse_ID`),
  KEY `FK_Synapses_Synapse_idx` (`Synapse_ID`),
  KEY `FK_Synapses_Network_idx` (`Network_ID`),
  CONSTRAINT `FK_Synapses_Network` FOREIGN KEY (`Network_ID`) REFERENCES `networks` (`Network_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_Synapses_Synapse1` FOREIGN KEY (`Synapse_ID`) REFERENCES `synapses` (`Synapse_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `network_synapse_associations`
--

LOCK TABLES `network_synapse_associations` WRITE;
/*!40000 ALTER TABLE `network_synapse_associations` DISABLE KEYS */;
INSERT INTO `network_synapse_associations` VALUES ('NMLNT000001','NMLSY000080',NULL),('NMLNT000001','NMLSY000081',NULL),('NMLNT000001','NMLSY000082',NULL),('NMLNT000001','NMLSY000083',NULL),('NMLNT000070','NMLSY000084',NULL),('NMLNT000070','NMLSY000099',NULL),('NMLNT000070','NMLSY000100',NULL);
/*!40000 ALTER TABLE `network_synapse_associations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `networks`
--

DROP TABLE IF EXISTS `networks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `networks` (
  `Network_ID` varchar(45) NOT NULL,
  `Network_Name` varchar(250) DEFAULT NULL COMMENT 'The name of the Network model',
  `NetworkML_File` varchar(250) NOT NULL,
  `Upload_Time` datetime NOT NULL,
  `Comments` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`Network_ID`),
  KEY `FK_Model_Network_idx` (`Network_ID`),
  CONSTRAINT `FK_Model_Network` FOREIGN KEY (`Network_ID`) REFERENCES `models` (`Model_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `networks`
--

LOCK TABLES `networks` WRITE;
/*!40000 ALTER TABLE `networks` DISABLE KEYS */;
INSERT INTO `networks` VALUES ('NMLNT000001','Cerebellar Granule Layer Network','/var/www/NeuroMLmodels/NMLNT000001/Generated.net.xml','2012-01-10 00:00:00','Updated July 2014'),('NMLNT000070','Golgi Cell Network - Vervaeke','/var/www/NeuroMLmodels/NMLNT000070/Generated.net.xml','2013-10-23 06:23:53','');
/*!40000 ALTER TABLE `networks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `neurolexes`
--

DROP TABLE IF EXISTS `neurolexes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `neurolexes` (
  `NeuroLex_ID` int(11) NOT NULL,
  `NeuroLex_URI` varchar(500) NOT NULL,
  `NeuroLex_Term` varchar(250) NOT NULL,
  `Comments` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`NeuroLex_ID`),
  KEY `FK_Meta_NeuroLex_idx` (`NeuroLex_ID`),
  CONSTRAINT `FK_Meta_NeuroLex` FOREIGN KEY (`NeuroLex_ID`) REFERENCES `metadatas` (`Metadata_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `neurolexes`
--

LOCK TABLES `neurolexes` WRITE;
/*!40000 ALTER TABLE `neurolexes` DISABLE KEYS */;
INSERT INTO `neurolexes` VALUES (3000001,'sao830368389','Hippocampus CA1 pyramidal cell, neuron',NULL),(3000002,'nifext_2511','Voltage-gated potassium channel, K+',NULL),(3000003,'nifext_2509','Voltage-gated sodium channel, Na+, Nav',NULL),(3000004,'nifext_2516','HCN channel, Hyperpolarization and cyclic-nucleotide gated',NULL),(3000005,'birnlex_779','Granular layer of cerebellar cortex, granule, Network',''),(3000006,'nifext_128','Cerebellum granule cell, Cerebellar, neuron',NULL),(3000007,'nlx_260','Cerebellar mossy fiber',NULL),(3000008,'sao1415726815','Cerebellum Golgi cell, Cerebellar, neuron',NULL),(3000009,'nifext_2512','Calcium-activated potassium channel, Kca',NULL),(3000010,'nifext_2510','Voltage-gated calcium channel, Ca+2. CaV',NULL),(3000011,'sao471801888','Cerebellum Purkinje cell, Cerebellar, Purkyne, Corpuscles',NULL),(3000041,'sao1415726815','Cerebellar Golgi',NULL),(3000044,'nifext_50','Neocortex pyramidal cell layer 5-6,deep pyramidal cell, Neocortex pyramidal neuron layer 5-6, Layer 5-6 pyramidal cell, layer 5 pyramidal neuron, layer 5 pyramidal cell, Tufted layer 5 (TL5) pyramidal neurons',NULL),(3000045,'nlx_cell_20081203','Thalamus geniculate nucleus (lateral) principal neuron,	Relay cell, Thalamic relay neuron, Thalamus relay neuron, Thalamocortical cell, Thalamocortical neuron, Thalamus relay cell',NULL),(3000046,'nifext_49',' Neocortex pyramidal layer 2-3 cell,corticocortical cell, superficial pyramidal cell, Neocortex pyramidal neuron layer 2-3, Layer 2-3 pyramidal cell, Neocortical pyramidal neuron: superficial, deep layer (layer 5, 6) pyramidal cell',NULL);
/*!40000 ALTER TABLE `neurolexes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `news`
--

DROP TABLE IF EXISTS `news`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `news` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `title` varchar(60) NOT NULL DEFAULT '',
  `summary` varchar(255) DEFAULT '',
  `description` text,
  `author_id` int(11) NOT NULL DEFAULT '0',
  `created_on` datetime DEFAULT NULL,
  `comments_count` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `news_project_id` (`project_id`),
  KEY `index_news_on_author_id` (`author_id`),
  KEY `index_news_on_created_on` (`created_on`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `news`
--

LOCK TABLES `news` WRITE;
/*!40000 ALTER TABLE `news` DISABLE KEYS */;
/*!40000 ALTER TABLE `news` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `open_id_authentication_associations`
--

DROP TABLE IF EXISTS `open_id_authentication_associations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `open_id_authentication_associations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `issued` int(11) DEFAULT NULL,
  `lifetime` int(11) DEFAULT NULL,
  `handle` varchar(255) DEFAULT NULL,
  `assoc_type` varchar(255) DEFAULT NULL,
  `server_url` blob,
  `secret` blob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `open_id_authentication_associations`
--

LOCK TABLES `open_id_authentication_associations` WRITE;
/*!40000 ALTER TABLE `open_id_authentication_associations` DISABLE KEYS */;
/*!40000 ALTER TABLE `open_id_authentication_associations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `open_id_authentication_nonces`
--

DROP TABLE IF EXISTS `open_id_authentication_nonces`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `open_id_authentication_nonces` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp` int(11) NOT NULL,
  `server_url` varchar(255) DEFAULT NULL,
  `salt` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `open_id_authentication_nonces`
--

LOCK TABLES `open_id_authentication_nonces` WRITE;
/*!40000 ALTER TABLE `open_id_authentication_nonces` DISABLE KEYS */;
/*!40000 ALTER TABLE `open_id_authentication_nonces` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `other_keywords`
--

DROP TABLE IF EXISTS `other_keywords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `other_keywords` (
  `Other_Keyword_ID` int(11) NOT NULL,
  `Other_Keyword_term` varchar(200) NOT NULL,
  `Comments` text,
  PRIMARY KEY (`Other_Keyword_ID`),
  KEY `FK_Meta_Other_idx` (`Other_Keyword_ID`),
  CONSTRAINT `FK_Meta_Other` FOREIGN KEY (`Other_Keyword_ID`) REFERENCES `metadatas` (`Metadata_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `other_keywords`
--

LOCK TABLES `other_keywords` WRITE;
/*!40000 ALTER TABLE `other_keywords` DISABLE KEYS */;
INSERT INTO `other_keywords` VALUES (4000001,'Calcium Pool',NULL),(4000002,'Leak Passive',NULL),(4000003,'Cerebellum, Synchronization, Nerve Fibers, Nerve Net, Neural Inhibition, Rat ','publication keywords'),(4000004,'GABAA, AMPA, NMDA','Receptors'),(4000005,'Age Factors, Dendrites, Hippocampus, Imaging, Three-Dimensional, Pyramidal Cell, Rat CA1, Oblique Branches, Back-propagation','publish keywords'),(4000006,'AMPA','Receptor'),(4000007,'Glutamate','Transmitter '),(4000008,'Rat, Active Dendrites, Purkinje  Cell,  Fast Somatic Spikes, Dendritic Calcium Spikes, Plateau Potentials','publication keywords'),(4000020,'Anomalous Rectifier conductance,  h-conductance (hyperpolarizing).fast rhythmic bursting,cortical neuron',NULL),(4000021,'Potasium M type current,muscarinic receptor suppressed,Single-column thalamocortical network,gamma oscillations, sleep spindles,epileptogenic bursts',NULL),(4000022,'Persistent non inactivating Sodium channel, Na ,',NULL),(4000023,'expontially decaying pool  calcium,  ceiling concentration',NULL),(4000024,'[Ca2+] dependent K AHP afterhyperpolarization conductance,calcium dependence table',NULL),(4000025,'High threshold, long lasting Calcium L-type current',NULL),(4000026,'thalamocortical neuronal, persistent gamma oscillations,thalamocortical sleep spindles,series of synchronized population bursts',NULL),(4000027,'Potasium delayed rectifier type conductance, fast-spiking ',NULL),(4000028,'Slow Ca2+ dependent K AHP afterhyperpolarization conductance',NULL),(4000029,'Fast voltage, Ca2+ dependent K conductance, BK channel',NULL),(4000030,'Fast Sodium transient inactivating current',NULL),(4000031,'Potasium K2-type current slowly activating inactivating',NULL),(4000032,'isolated double population bursts, superimposed very fast oscillations, persistent gamma oscillations, thalamocortical sleep spindles ',NULL),(4000033,'isolated double population bursts, superimposed very fast oscillations, persistent gamma oscillations, thalamocortical sleep spindles, epileptiform bursts, kainate',NULL),(4000035,'postsynaptic conductance,double exponential',NULL),(4000036,'synaptic mechanism, postsynaptic conductance,double exponential function time',NULL),(4000037,'High voltage Activated Ca2+ channel,',NULL),(4000038,'Low voltage Activated Ca2+ channel,Ca++ current responsible  low threshold spikes',NULL),(4000039,'Calcium first order kinetics',NULL),(4000040,'Calcium first order kinetics',NULL),(4000043,'spiking bursting cortical',''),(4000044,'mammalian Neocortical,neocortex pyramidal , layer 5b,perisomatic Na+ dendritic Ca2+ ','The thick-tufted layer 5b pyramidal cell extends its dendritic tree to all six layers of the mammalian neocortex and serves as a major building block for the cortical column. L5b pyramidal cells have been the subject of extensive experimental and modeling studies, yet conductance-based models of these cells that faithfully reproduce both their perisomatic Na(+)-spiking behavior as well as key dendritic active properties, including Ca(2+) spikes and back-propagating action potentials, are still lacking. Based on a large body of experimental recordings from both the soma and dendrites of L5b pyramidal cells in adult rats, we characterized key features of the somatic and dendritic firing and quantified their statistics. We used these features to constrain the density of a set of ion channels over the soma and dendritic surface via multi-objective optimization with an evolutionary algorithm, thus generating a set of detailed conductance-based models that faithfully replicate the back-propagating action potential activated Ca(2+) spike firing and the perisomatic firing response to current steps, as well as the experimental variability of the properties. Furthermore, we show a useful way to analyze model parameters with our sets of models, which enabled us to identify some of the mechanisms responsible for the dynamic properties of L5b pyramidal cells as well as mechanisms that are sensitive to morphological changes. This automated framework can be used to develop a database of faithful models for other neuron types. The models we present provide several experimentally-testable predictions and can serve as a powerful tool for theoretical investigations of the contribution of single-cell dynamics to network activity and its computational capabilities'),(4000045,'nucleus reticularis','To better understand population phenomena in thalamocortical neuronal ensembles, we have constructed a preliminary network model with 3,560 multicompartment neurons (containing soma, branching dendrites, and a portion of axon). Types of neurons included superficial pyramids (with regular spiking [RS] and fast rhythmic bursting [FRB] firing behaviors); RS spiny stellates; fast spiking (FS) interneurons, with basket-type and axoaxonic types of connectivity, and located in superficial and deep cortical layers; low threshold spiking (LTS) interneurons, which contacted principal cell dendrites; deep pyramids, which could have RS or intrinsic bursting (IB) firing behaviors, and endowed either with nontufted apical dendrites or with long tufted apical dendrites; thalamocortical relay (TCR) cells; and nucleus reticularis (nRT) cells. To the extent possible, both electrophysiology and synaptic connectivity were based on published data, although many arbitrary choices were necessary. In addition to synaptic connectivity (by AMPA/kainate, NMDA, and GABA(A) receptors), we also included electrical coupling between dendrites of interneurons, nRT cells, and TCR cells, and--in various combinations--electrical coupling between the proximal axons of certain cortical principal neurons. Our network model replicates several observed population phenomena, including 1) persistent gamma oscillations; 2) thalamocortical sleep spindles; 3) series of synchronized population bursts, resembling electrographic seizures; 4) isolated double population bursts with superimposed very fast oscillations (>100 Hz, \"VFO\"); 5) spike-wave, polyspike-wave, and fast runs (about 10 Hz). We show that epileptiform bursts, including double and multiple bursts, containing VFO occur in rat auditory cortex in vitro, in the presence of kainate, when both GABA(A) and GABA(B) receptors are blocked. Electrical coupling between axons appears necessary (as reported previously) for persistent gamma and additionally plays a role in the detailed shaping of epileptogenic events. The degree of recurrent synaptic excitation between spiny stellate cells, and their tendency to fire throughout multiple bursts, also appears critical in shaping epileptogenic events.'),(4000046,' fast rhythmic bursting [FRB] firing behaviors',''),(4000203,'gap junction',''),(4000229,'cerebellum Golgi cell gap junctions','');
/*!40000 ALTER TABLE `other_keywords` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `out_query_results`
--

DROP TABLE IF EXISTS `out_query_results`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `out_query_results` (
  `Model_ID` varchar(45) NOT NULL,
  PRIMARY KEY (`Model_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `out_query_results`
--

LOCK TABLES `out_query_results` WRITE;
/*!40000 ALTER TABLE `out_query_results` DISABLE KEYS */;
INSERT INTO `out_query_results` VALUES ('NMLCH000025'),('NMLCH000026'),('NMLCH000027'),('NMLCH000028'),('NMLCH000029'),('NMLCH000030'),('NMLCH000031'),('NMLCH000032'),('NMLCH000033'),('NMLCH000034'),('NMLCH000035'),('NMLCH000036'),('NMLCH000037'),('NMLCL000005');
/*!40000 ALTER TABLE `out_query_results` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `parent_child_association_views`
--

DROP TABLE IF EXISTS `parent_child_association_views`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `parent_child_association_views` (
  `Parent` varchar(45) DEFAULT NULL,
  `Child` varchar(45) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `parent_child_association_views`
--

LOCK TABLES `parent_child_association_views` WRITE;
/*!40000 ALTER TABLE `parent_child_association_views` DISABLE KEYS */;
/*!40000 ALTER TABLE `parent_child_association_views` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `partof_tables`
--

DROP TABLE IF EXISTS `partof_tables`;
/*!50001 DROP VIEW IF EXISTS `partof_tables`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `partof_tables` (
  `parent` tinyint NOT NULL,
  `child` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `people`
--

DROP TABLE IF EXISTS `people`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `people` (
  `Person_ID` int(11) NOT NULL,
  `Person_First_Name` varchar(100) DEFAULT NULL,
  `Person_Middle_Name` varchar(100) DEFAULT NULL,
  `Person_Last_Name` varchar(100) DEFAULT NULL,
  `Instituition` varchar(200) DEFAULT NULL,
  `Email` varchar(200) DEFAULT NULL,
  `Comments` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`Person_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `people`
--

LOCK TABLES `people` WRITE;
/*!40000 ALTER TABLE `people` DISABLE KEYS */;
INSERT INTO `people` VALUES (2000001,'Michele','','Migliore','Yale University','michele.migliore@yale.edu ',''),(2000002,'Michele','','Ferrante','George Mason University','mferran1@gmu.edu',''),(2000003,'Giorgio',' A. ','Ascoli','George Mason University','ascoli@gmu.edu',NULL),(2000004,'Padraig ',NULL,'Gleeson','UCL','p.gleeson@ucl.ac.uk',NULL),(2000005,'Reinoud',NULL,'Maex','University of Antwerp','reinoud@tnb.ua.ac.be',NULL),(2000006,'Erik',NULL,'De Schutter','University of Antwerp','Erik@tnb.ua.ac.be',NULL),(2000007,'James','M','Bower','UTSA','bower@uthscsa.edu',NULL),(2000008,'Avrama','','Blackwell','George Mason University','kblackw1@gmu.edu',NULL),(2000009,'K','','Vervaeke','','',''),(2000010,'Matteo','','Farinella','UCL','m.farinella@ucl.ac.uk',NULL),(2000011,'Alain','','Destexhe','','',NULL),(2000012,'A','','Fontana','','',NULL),(2000013,'K','','Vervaeke','','',''),(2000014,'Eugenio','','Piasini','','e.piasini@ucl.ac.uk',NULL),(2000015,'Miklos','','Szoboszlay','','szoboszlay.miklos@tdk.koki.mta.hu',NULL),(2000016,'Stephen','','Larson','','slarson@ucsd.edu',NULL),(2000017,'Mike','','Vella','','mv333@cam.ac.uk',NULL),(2000018,'Andrew','','Davison','','andrew.davison@unic.cnrs-gif.fr',NULL),(2000019,'Vitor','','Chaud','','chaudvm@gmail.com',NULL),(2000020,'Idan','','Segev','','idan@lobster.ls.huji.ac.il',NULL),(2000021,'Chaitanya','','Chintaluri','','',NULL),(2000022,' Daniel','','Wójcik','','',NULL),(2000024,' Helena','','','','',NULL),(2000025,'Daniel','','Wojcik','','',NULL),(2000026,'Helena','','Glabska','','',NULL),(2000027,'Traub','','RD','','',NULL),(2000028,'Padraig','','Gleeson','','',''),(2000029,'Reinoud','','Maex','','',''),(2000030,'Reinoud','','Maex','','',''),(2000031,'Reinoud','','Maex','','',''),(2000032,'Reinoud','','Maex','','',''),(2000033,'K','','Vervaeke','','',''),(2000034,'K','','Vervaeke','','',''),(2000035,'s','','c','','sharon.crook@asu.edu',NULL),(2000036,'A','','Lorincz','','',NULL),(2000037,'M','','Farinella','','',NULL),(2000038,'Z','','Nusser','','',NULL),(2000039,'RA','','Silver','','',NULL),(2000040,'P','','Gleeson','','',NULL);
/*!40000 ALTER TABLE `people` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `projects`
--

DROP TABLE IF EXISTS `projects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `description` text,
  `homepage` varchar(255) DEFAULT '',
  `is_public` tinyint(1) NOT NULL DEFAULT '1',
  `parent_id` int(11) DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `identifier` varchar(255) DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT '1',
  `lft` int(11) DEFAULT NULL,
  `rgt` int(11) DEFAULT NULL,
  `inherit_members` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_projects_on_lft` (`lft`),
  KEY `index_projects_on_rgt` (`rgt`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projects`
--

LOCK TABLES `projects` WRITE;
/*!40000 ALTER TABLE `projects` DISABLE KEYS */;
/*!40000 ALTER TABLE `projects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `projects_trackers`
--

DROP TABLE IF EXISTS `projects_trackers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `projects_trackers` (
  `project_id` int(11) NOT NULL DEFAULT '0',
  `tracker_id` int(11) NOT NULL DEFAULT '0',
  UNIQUE KEY `projects_trackers_unique` (`project_id`,`tracker_id`),
  KEY `projects_trackers_project_id` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projects_trackers`
--

LOCK TABLES `projects_trackers` WRITE;
/*!40000 ALTER TABLE `projects_trackers` DISABLE KEYS */;
/*!40000 ALTER TABLE `projects_trackers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `publications`
--

DROP TABLE IF EXISTS `publications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `publications` (
  `Publication_ID` int(11) NOT NULL,
  `Pubmed_Ref` varchar(250) DEFAULT NULL,
  `Full_Title` varchar(500) DEFAULT NULL,
  `Comments` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`Publication_ID`),
  KEY `FK_Meta_Publication_idx` (`Publication_ID`),
  CONSTRAINT `FK_Meta_Publication` FOREIGN KEY (`Publication_ID`) REFERENCES `metadatas` (`Metadata_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `publications`
--

LOCK TABLES `publications` WRITE;
/*!40000 ALTER TABLE `publications` DISABLE KEYS */;
INSERT INTO `publications` VALUES (6000001,'pubmed/16293591','Signal propagation in oblique dendrites of CA1 pyramidal cells',''),(6000002,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000003,'pubmed/7512629','An active membrane model of the cerebellar Purkinje cell. I. Simulation of current clamps in slice',NULL),(6000019,'pubmed/7451684','Fine structure and synaptic connections of the common spiny neuron of the rat neostriatum',NULL),(6000020,'pubmed/12574468','Fast rhythmic bursting can be induced in layer 2/3 cortical neurons by enhancing persistent Na+ conductance or by blocking BK channels',NULL),(6000021,'pubmed/15525801','Single-column thalamocortical network model exhibiting gamma oscillations, sleep spindles, and epileptogenic bursts.',NULL),(6000022,'pubmed/15525801','Single-column thalamocortical network model exhibiting gamma oscillations, sleep spindles, and epileptogenic bursts.',NULL),(6000023,'pubmed/15525801','Single-column thalamocortical network model exhibiting gamma oscillations, sleep spindles, and epileptogenic bursts.',NULL),(6000026,'pubmed/15525801','Single-column thalamocortical network model exhibiting gamma oscillations, sleep spindles, and epileptogenic bursts. J. Neurophysiol. 93, 2194-2232, 2005',NULL),(6000032,'pubmed/15525801','A single-column thalamocortical network model exhibiting gamma oscillations, sleep spindles and epileptogenic bursts',''),(6000033,'pubmed/12574468','Fast Rhythmic Bursting Can Be Induced in Layer 2/3 Cortical Neurons by Enhancing Persistent Na+ Conductance or by Blocking BK Channels J Neurophysiol 89: 909-921, 2003',NULL),(6000037,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network ',''),(6000038,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network',''),(6000041,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network (Vervaeke et al. 2010)',NULL),(6000042,'pubmed/18619514','Caenorhabditis elegans body wall muscles are simple actuators.Boyle JH, Cohen N.',NULL),(6000043,'pubmed/15484883','Which model to use for cortical spiking neurons? Izhikevich EM',NULL),(6000044,'pubmed/21829333','Models of Neocortical Layer 5b Pyramidal Cells Capturing a Wide Range of Dendritic and Perisomatic Active Properties, Etay Hay, Sean Hill, Felix Schürmann, Henry Markram and Idan Segev',NULL),(6000045,'pubmed/15525801','Single-column thalamocortical network model exhibiting gamma oscillations, sleep spindles, and epileptogenic bursts.',NULL),(6000046,'pubmed/15525801','Single-column thalamocortical network model exhibiting gamma oscillations, sleep spindles, and epileptogenic bursts.',NULL),(6000048,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000052,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000056,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000060,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000062,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000064,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000065,'pubmed/16293591','Signal propagation in oblique dendrites of CA1 pyramidal cells',''),(6000069,'pubmed/16293591','Signal propagation in oblique dendrites of CA1 pyramidal cells',''),(6000073,'pubmed/16293591','Signal propagation in oblique dendrites of CA1 pyramidal cells',''),(6000077,'pubmed/16293591','Signal propagation in oblique dendrites of CA1 pyramidal cells',''),(6000081,'pubmed/16293591','Signal propagation in oblique dendrites of CA1 pyramidal cells',''),(6000085,'pubmed/16293591','Signal propagation in oblique dendrites of CA1 pyramidal cells',''),(6000089,'pubmed/16293591','Signal propagation in oblique dendrites of CA1 pyramidal cells',''),(6000100,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed Network model of the cerebellar granule cell layer',''),(6000104,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000108,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000112,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000116,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000120,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000124,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000128,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000132,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000136,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000140,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000144,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000148,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000152,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000157,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000161,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000165,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000169,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000176,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network ',NULL),(6000177,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network',NULL),(6000178,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network',NULL),(6000179,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network',NULL),(6000180,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network',NULL),(6000181,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network',NULL),(6000182,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network',NULL),(6000183,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network',NULL),(6000184,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network',NULL),(6000185,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network',NULL),(6000186,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network',NULL),(6000187,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network',NULL),(6000188,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network',NULL),(6000189,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network',NULL),(6000193,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network',''),(6000195,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network',''),(6000200,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network',''),(6000217,'pubmed/7512629','An active membrane model of the cerebellar Purkinje cell. I. Simulation of current clamps in slice',''),(6000223,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network',''),(6000226,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network','');
/*!40000 ALTER TABLE `publications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `queries`
--

DROP TABLE IF EXISTS `queries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `queries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  `filters` text,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `is_public` tinyint(1) NOT NULL DEFAULT '0',
  `column_names` text,
  `sort_criteria` text,
  `group_by` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_queries_on_project_id` (`project_id`),
  KEY `index_queries_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `queries`
--

LOCK TABLES `queries` WRITE;
/*!40000 ALTER TABLE `queries` DISABLE KEYS */;
/*!40000 ALTER TABLE `queries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `query_results`
--

DROP TABLE IF EXISTS `query_results`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `query_results` (
  `Model_ID` varchar(45) NOT NULL,
  PRIMARY KEY (`Model_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `query_results`
--

LOCK TABLES `query_results` WRITE;
/*!40000 ALTER TABLE `query_results` DISABLE KEYS */;
INSERT INTO `query_results` VALUES ('NMLCH000001'),('NMLCH000002'),('NMLCH000003'),('NMLCH000004'),('NMLCH000005'),('NMLCH000006'),('NMLCH000007'),('NMLCH000008'),('NMLCH000009'),('NMLCH000010'),('NMLCH000011'),('NMLCH000012'),('NMLCH000013'),('NMLCH000014'),('NMLCH000015'),('NMLCH000016'),('NMLCH000017'),('NMLCH000018'),('NMLCH000019'),('NMLCH000020'),('NMLCH000021'),('NMLCH000022'),('NMLCH000023'),('NMLCH000024'),('NMLCH000025'),('NMLCH000026'),('NMLCH000027'),('NMLCH000028'),('NMLCH000029'),('NMLCH000030'),('NMLCH000031'),('NMLCH000032'),('NMLCH000033'),('NMLCH000034'),('NMLCH000035'),('NMLCH000036'),('NMLCH000037'),('NMLCH000048'),('NMLCH000049'),('NMLCH000050'),('NMLCH000051'),('NMLCH000052'),('NMLCH000053'),('NMLCH000055'),('NMLCH000056'),('NMLCH000057'),('NMLCH000058'),('NMLCH000059'),('NMLCH000066'),('NMLCH000067'),('NMLCH000068'),('NMLCH000069'),('NMLCH000086'),('NMLCH000087'),('NMLCH000088'),('NMLCH000089'),('NMLCH000090'),('NMLCH000091'),('NMLCH000092'),('NMLCH000093'),('NMLCH000094'),('NMLCH000095'),('NMLCH000096'),('NMLCH000097'),('NMLCH000098'),('NMLCL000001'),('NMLCL000002'),('NMLCL000003'),('NMLCL000004'),('NMLCL000005'),('NMLCL000054'),('NMLCL000060'),('NMLCL000061'),('NMLCL000073'),('NMLCL000077'),('NMLCL000078'),('NMLCL000085'),('NMLNT000001'),('NMLNT000070'),('NMLSY000065'),('NMLSY000080'),('NMLSY000081'),('NMLSY000082'),('NMLSY000083'),('NMLSY000084'),('NMLSY000099'),('NMLSY000100');
/*!40000 ALTER TABLE `query_results` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `references`
--

DROP TABLE IF EXISTS `references`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `references` (
  `Reference_ID` int(11) NOT NULL,
  `Reference_Resource` varchar(100) NOT NULL COMMENT 'ModelDB, NeuroDB, OSB',
  `Reference_URI` varchar(500) NOT NULL,
  `Comments` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`Reference_ID`),
  KEY `FK_Meta_Reference_idx` (`Reference_ID`),
  CONSTRAINT `FK_Meta_Reference` FOREIGN KEY (`Reference_ID`) REFERENCES `metadatas` (`Metadata_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `references`
--

LOCK TABLES `references` WRITE;
/*!40000 ALTER TABLE `references` DISABLE KEYS */;
INSERT INTO `references` VALUES (5000001,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=55035',NULL),(5000002,'OpenSourceBrain','http://www.opensourcebrain.org/projects/ca1pyramidalcell',NULL),(5000003,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',NULL),(5000004,'OpenSourceBrain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000005,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=7176',NULL),(5000006,'OpenSourceBrain','http://www.opensourcebrain.org/projects/purkinjecell',NULL),(5000020,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=20756',NULL),(5000021,'neuronDB','http://senselab.med.yale.edu/senselab/NeuronDB/channelGene2.htm#table3',NULL),(5000022,'ModelDB','http://senselab.med.yale.edu/ModelDb/ShowModel.asp?model=45539',NULL),(5000023,'ModelDB','http://senselab.med.yale.edu/ModelDb/ShowModel.asp?model=45539',NULL),(5000024,'neuronDB','http://senselab.med.yale.edu/senselab/NeuronDB/channelGene2.htm#table3',NULL),(5000025,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=20756',NULL),(5000026,'ModelDB','http://senselab.med.yale.edu/ModelDb/ShowModel.asp?model=45539',NULL),(5000027,'neuronDB','http://senselab.med.yale.edu/senselab/NeuronDB/channelGene2.htm#table3',NULL),(5000030,'neuronDB','http://senselab.med.yale.edu/senselab/NeuronDB/channelGene2.htm#table2',NULL),(5000032,'ModelDB','http://senselab.med.yale.edu/ModelDb/ShowModel.asp?model=45539',NULL),(5000033,'ModelDB','http://senselab.med.yale.edu/ModelDb/ShowModel.asp?model=45539',NULL),(5000035,'neuronDB','http://senselab.med.yale.edu/senselab/NeuronDB/receptors2.asp',NULL),(5000036,'neuronDB','http://senselab.med.yale.edu/senselab/NeuronDB/receptors2.asp',NULL),(5000037,'ModelDB','http://senselab.med.yale.edu/modeldb/showmodel.asp?model=127996',''),(5000038,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=127996',''),(5000041,'ModelDB','http://senselab.med.yale.edu/modeldb/showmodel.asp?model=127996',NULL),(5000044,'ModelDB',' http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=139653',NULL),(5000045,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=45539',NULL),(5000046,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=45539',NULL),(5000049,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000050,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000053,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000054,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000057,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000058,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000066,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=55035',''),(5000067,'Open Source Brain','http://www.opensourcebrain.org/projects/ca1pyramidalcell',''),(5000070,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=55035',''),(5000071,'Open Source Brain','http://www.opensourcebrain.org/projects/ca1pyramidalcell',''),(5000074,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=55035',''),(5000075,'Open Source Brain','http://www.opensourcebrain.org/projects/ca1pyramidalcell',''),(5000078,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000079,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000082,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=55035',''),(5000083,'Open Source Brain','http://www.opensourcebrain.org/projects/ca1pyramidalcell',''),(5000086,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=55035',''),(5000087,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000090,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=55035',''),(5000091,'Open Source Brain','http://www.opensourcebrain.org/projects/ca1pyramidalcell',''),(5000093,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000094,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000095,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000096,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000097,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000098,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000101,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000102,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000105,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000106,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000109,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000110,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000113,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000114,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000117,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000118,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000121,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000122,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000125,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000126,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000129,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000130,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000133,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000134,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000137,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000138,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000141,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000142,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000145,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000146,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000149,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000150,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000153,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000154,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000158,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000159,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000162,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000163,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000166,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000167,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000170,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000171,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000172,'Open Source Brain','http://www.opensourcebrain.org/projects/vervaekeetalgolgicellnetwork',''),(5000174,'Open Source Brain','http://www.opensourcebrain.org/projects/thalamocortical',''),(5000175,'Open Source Brain','h',''),(5000176,'ModelDB','http://senselab.med.yale.edu/modeldb/showmodel.asp?model=127996',NULL),(5000177,'ModelDB','http://senselab.med.yale.edu/modeldb/showmodel.asp?model=127996',NULL),(5000178,'ModelDB','http://senselab.med.yale.edu/modeldb/showmodel.asp?model=127996',NULL),(5000179,'ModelDB','http://senselab.med.yale.edu/modeldb/showmodel.asp?model=127996',NULL),(5000180,'ModelDB','http://senselab.med.yale.edu/modeldb/showmodel.asp?model=127996',NULL),(5000181,'ModelDB','http://senselab.med.yale.edu/modeldb/showmodel.asp?model=127996',NULL),(5000182,'ModelDB','http://senselab.med.yale.edu/modeldb/showmodel.asp?model=127996',NULL),(5000183,'ModelDB','http://senselab.med.yale.edu/modeldb/showmodel.asp?model=127996',NULL),(5000184,'ModelDB','http://senselab.med.yale.edu/modeldb/showmodel.asp?model=127996',NULL),(5000185,'ModelDB','http://senselab.med.yale.edu/modeldb/showmodel.asp?model=127996',NULL),(5000186,'ModelDB','http://senselab.med.yale.edu/modeldb/showmodel.asp?model=127996',NULL),(5000187,'ModelDB','http://senselab.med.yale.edu/modeldb/showmodel.asp?model=127996',NULL),(5000188,'ModelDB','http://senselab.med.yale.edu/modeldb/showmodel.asp?model=127996',NULL),(5000189,'ModelDB','http://senselab.med.yale.edu/modeldb/showmodel.asp?model=127996',NULL),(5000190,'Open Source Brain','http://www.opensourcebrain.org/projects/vervaekeetalgolgicellnetwork',''),(5000191,'Open Source Brain','h',''),(5000192,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=127996',''),(5000194,'Open Source Brain','http://www.opensourcebrain.org/projects/vervaekeetalgolgicellnetwork',''),(5000196,'ModelDB','http://senselab.med.yale.edu/modeldb/showmodel.asp?model=127996',''),(5000197,'Open Source Brain','http://www.opensourcebrain.org/projects/vervaekeetalgolgicellnetwork',''),(5000199,'Open Source Brain','http://www.opensourcebrain.org/projects/vervaekeetalgolgicellnetwork',''),(5000201,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=127996',''),(5000202,'Open Source Brain','http://www.opensourcebrain.org/projects/vervaekeetalgolgicellnetwork',''),(5000204,'Open Source Brain','http://www.opensourcebrain.org/projects/vervaekeetalgolgicellnetwork',''),(5000205,'Open Source Brain','http://www.opensourcebrain.org/projects/vervaekeetalgolgicellnetwork',''),(5000206,'Open Source Brain','http://www.opensourcebrain.org/projects/vervaekeetalgolgicellnetwork',''),(5000207,'Open Source Brain','http://www.opensourcebrain.org/projects/vervaekeetalgolgicellnetwork',''),(5000208,'Open Source Brain','http://www.opensourcebrain.org/projects/vervaekeetalgolgicellnetwork',''),(5000209,'Open Source Brain','http://www.opensourcebrain.org/projects/vervaekeetalgolgicellnetwork',''),(5000210,'Open Source Brain','http://www.opensourcebrain.org/projects/vervaekeetalgolgicellnetwork',''),(5000211,'Open Source Brain','http://www.opensourcebrain.org/projects/vervaekeetalgolgicellnetwork',''),(5000212,'Open Source Brain','http://www.opensourcebrain.org/projects/vervaekeetalgolgicellnetwork',''),(5000213,'Open Source Brain','http://www.opensourcebrain.org/projects/vervaekeetalgolgicellnetwork',''),(5000214,'Open Source Brain','http://www.opensourcebrain.org/projects/vervaekeetalgolgicellnetwork',''),(5000215,'Open Source Brain','http://www.opensourcebrain.org/projects/vervaekeetalgolgicellnetwork',''),(5000216,'Open Source Brain','http://www.opensourcebrain.org/projects/vervaekeetalgolgicellnetwork',''),(5000218,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=7176',''),(5000219,'Open Source Brain','http://www.opensourcebrain.org/projects/purkinjecell',''),(5000224,'ModelDB','http://senselab.med.yale.edu/modeldb/showmodel.asp?model=127996',''),(5000225,'Open Source Brain','http://www.opensourcebrain.org/projects/vervaekeetalgolgicellnetwork',''),(5000227,'ModelDB','http://senselab.med.yale.edu/modeldb/showmodel.asp?model=127996',''),(5000228,'Open Source Brain','http://www.opensourcebrain.org/projects/vervaekeetalgolgicellnetwork','');
/*!40000 ALTER TABLE `references` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `repositories`
--

DROP TABLE IF EXISTS `repositories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `repositories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL DEFAULT '0',
  `url` varchar(255) NOT NULL DEFAULT '',
  `login` varchar(60) DEFAULT '',
  `password` varchar(255) DEFAULT '',
  `root_url` varchar(255) DEFAULT '',
  `type` varchar(255) DEFAULT NULL,
  `path_encoding` varchar(64) DEFAULT NULL,
  `log_encoding` varchar(64) DEFAULT NULL,
  `extra_info` text,
  `identifier` varchar(255) DEFAULT NULL,
  `is_default` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_repositories_on_project_id` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `repositories`
--

LOCK TABLES `repositories` WRITE;
/*!40000 ALTER TABLE `repositories` DISABLE KEYS */;
/*!40000 ALTER TABLE `repositories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `results_pocs`
--

DROP TABLE IF EXISTS `results_pocs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `results_pocs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `results_pocs`
--

LOCK TABLES `results_pocs` WRITE;
/*!40000 ALTER TABLE `results_pocs` DISABLE KEYS */;
/*!40000 ALTER TABLE `results_pocs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL DEFAULT '',
  `position` int(11) DEFAULT '1',
  `assignable` tinyint(1) DEFAULT '1',
  `builtin` int(11) NOT NULL DEFAULT '0',
  `permissions` text,
  `issues_visibility` varchar(30) NOT NULL DEFAULT 'default',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'Non member',1,1,1,'---\n- :view_issues\n- :add_issues\n- :add_issue_notes\n- :save_queries\n- :view_gantt\n- :view_calendar\n- :view_time_entries\n- :comment_news\n- :view_documents\n- :view_wiki_pages\n- :view_wiki_edits\n- :add_messages\n- :view_files\n- :browse_repository\n- :view_changesets\n','default'),(2,'Anonymous',2,1,2,'---\n- :view_issues\n- :view_gantt\n- :view_calendar\n- :view_time_entries\n- :view_documents\n- :view_wiki_pages\n- :view_wiki_edits\n- :view_files\n- :browse_repository\n- :view_changesets\n','default'),(3,'Manager',3,1,0,'---\n- :add_project\n- :edit_project\n- :close_project\n- :select_project_modules\n- :manage_members\n- :manage_versions\n- :add_subprojects\n- :manage_categories\n- :view_issues\n- :add_issues\n- :edit_issues\n- :manage_issue_relations\n- :manage_subtasks\n- :set_issues_private\n- :set_own_issues_private\n- :add_issue_notes\n- :edit_issue_notes\n- :edit_own_issue_notes\n- :view_private_notes\n- :set_notes_private\n- :move_issues\n- :delete_issues\n- :manage_public_queries\n- :save_queries\n- :view_issue_watchers\n- :add_issue_watchers\n- :delete_issue_watchers\n- :log_time\n- :view_time_entries\n- :edit_time_entries\n- :edit_own_time_entries\n- :manage_project_activities\n- :manage_news\n- :comment_news\n- :add_documents\n- :edit_documents\n- :delete_documents\n- :view_documents\n- :manage_files\n- :view_files\n- :manage_wiki\n- :rename_wiki_pages\n- :delete_wiki_pages\n- :view_wiki_pages\n- :export_wiki_pages\n- :view_wiki_edits\n- :edit_wiki_pages\n- :delete_wiki_pages_attachments\n- :protect_wiki_pages\n- :manage_repository\n- :browse_repository\n- :view_changesets\n- :commit_access\n- :manage_related_issues\n- :manage_boards\n- :add_messages\n- :edit_messages\n- :edit_own_messages\n- :delete_messages\n- :delete_own_messages\n- :view_calendar\n- :view_gantt\n','all'),(4,'Developer',4,1,0,'---\n- :manage_versions\n- :manage_categories\n- :view_issues\n- :add_issues\n- :edit_issues\n- :view_private_notes\n- :set_notes_private\n- :manage_issue_relations\n- :manage_subtasks\n- :add_issue_notes\n- :save_queries\n- :view_gantt\n- :view_calendar\n- :log_time\n- :view_time_entries\n- :comment_news\n- :view_documents\n- :view_wiki_pages\n- :view_wiki_edits\n- :edit_wiki_pages\n- :delete_wiki_pages\n- :add_messages\n- :edit_own_messages\n- :view_files\n- :manage_files\n- :browse_repository\n- :view_changesets\n- :commit_access\n- :manage_related_issues\n','default'),(5,'Reporter',5,1,0,'---\n- :view_issues\n- :add_issues\n- :add_issue_notes\n- :save_queries\n- :view_gantt\n- :view_calendar\n- :log_time\n- :view_time_entries\n- :comment_news\n- :view_documents\n- :view_wiki_pages\n- :view_wiki_edits\n- :add_messages\n- :edit_own_messages\n- :view_files\n- :browse_repository\n- :view_changesets\n','default');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('1'),('10'),('100'),('101'),('102'),('103'),('104'),('105'),('106'),('107'),('108'),('11'),('12'),('13'),('14'),('15'),('16'),('17'),('18'),('19'),('2'),('20'),('20090214190337'),('20090312172426'),('20090312194159'),('20090318181151'),('20090323224724'),('20090401221305'),('20090401231134'),('20090403001910'),('20090406161854'),('20090425161243'),('20090503121501'),('20090503121505'),('20090503121510'),('20090614091200'),('20090704172350'),('20090704172355'),('20090704172358'),('20091010093521'),('20091017212227'),('20091017212457'),('20091017212644'),('20091017212938'),('20091017213027'),('20091017213113'),('20091017213151'),('20091017213228'),('20091017213257'),('20091017213332'),('20091017213444'),('20091017213536'),('20091017213642'),('20091017213716'),('20091017213757'),('20091017213835'),('20091017213910'),('20091017214015'),('20091017214107'),('20091017214136'),('20091017214236'),('20091017214308'),('20091017214336'),('20091017214406'),('20091017214440'),('20091017214519'),('20091017214611'),('20091017214644'),('20091017214720'),('20091017214750'),('20091025163651'),('20091108092559'),('20091114105931'),('20091123212029'),('20091205124427'),('20091220183509'),('20091220183727'),('20091220184736'),('20091225164732'),('20091227112908'),('20100129193402'),('20100129193813'),('20100221100219'),('20100313132032'),('20100313171051'),('20100705164950'),('20100819172912'),('20101104182107'),('20101107130441'),('20101114115114'),('20101114115359'),('20110220160626'),('20110223180944'),('20110223180953'),('20110224000000'),('20110226120112'),('20110226120132'),('20110227125750'),('20110228000000'),('20110228000100'),('20110401192910'),('20110408103312'),('20110412065600'),('20110511000000'),('20110902000000'),('20111201201315'),('20120115143024'),('20120115143100'),('20120115143126'),('20120127174243'),('20120205111326'),('20120223110929'),('20120301153455'),('20120422150750'),('20120705074331'),('20120707064544'),('20120714122000'),('20120714122100'),('20120714122200'),('20120731164049'),('20120930112914'),('20121026002032'),('20121026003537'),('20121209123234'),('20121209123358'),('20121213084931'),('20130110122628'),('20130201184705'),('20130202090625'),('20130206194314'),('20130207175206'),('20130207181455'),('20130215073721'),('20130215111127'),('20130215111141'),('20130217094251'),('20130419200444'),('20130419200535'),('20140315003358'),('21'),('22'),('23'),('24'),('25'),('26'),('27'),('28'),('29'),('3'),('30'),('31'),('32'),('33'),('34'),('35'),('36'),('37'),('38'),('39'),('4'),('40'),('41'),('42'),('43'),('44'),('45'),('46'),('47'),('48'),('49'),('5'),('50'),('51'),('52'),('53'),('54'),('55'),('56'),('57'),('58'),('59'),('6'),('60'),('61'),('62'),('63'),('64'),('65'),('66'),('67'),('68'),('69'),('7'),('70'),('71'),('72'),('73'),('74'),('75'),('76'),('77'),('78'),('79'),('8'),('80'),('81'),('82'),('83'),('84'),('85'),('86'),('87'),('88'),('89'),('9'),('90'),('91'),('92'),('93'),('94'),('95'),('96'),('97'),('98'),('99');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sequences`
--

DROP TABLE IF EXISTS `sequences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sequences` (
  `Seq_Nbr` int(11) NOT NULL,
  `Attr_Name` varchar(45) NOT NULL,
  PRIMARY KEY (`Attr_Name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sequences`
--

LOCK TABLES `sequences` WRITE;
/*!40000 ALTER TABLE `sequences` DISABLE KEYS */;
INSERT INTO `sequences` VALUES (230,'Metadata_ID'),(101,'Model_ID'),(41,'Person_ID');
/*!40000 ALTER TABLE `sequences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `value` text,
  `updated_on` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_settings_on_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings`
--

LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
INSERT INTO `settings` VALUES (1,'login_required','0','2013-04-19 02:42:46'),(2,'autologin','0','2013-04-19 02:42:46'),(3,'self_registration','3','2013-04-19 02:42:46'),(4,'unsubscribe','1','2013-04-19 02:42:46'),(5,'password_min_length','8','2013-04-19 02:42:46'),(6,'lost_password','1','2013-04-19 02:42:46'),(7,'openid','0','2013-04-19 02:42:46'),(8,'rest_api_enabled','0','2013-04-19 02:42:46'),(9,'jsonp_enabled','0','2013-04-19 02:42:46'),(10,'session_lifetime','0','2013-04-19 02:42:46'),(11,'session_timeout','0','2013-04-19 02:42:46');
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `synapses`
--

DROP TABLE IF EXISTS `synapses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `synapses` (
  `Synapse_ID` varchar(45) NOT NULL,
  `Synapse_Name` varchar(250) DEFAULT NULL,
  `Synapse_File` varchar(250) NOT NULL,
  `Upload_Time` datetime NOT NULL,
  `Comments` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`Synapse_ID`),
  KEY `FK_Model_Synapse_idx` (`Synapse_ID`),
  CONSTRAINT `FK_Model_Synapse` FOREIGN KEY (`Synapse_ID`) REFERENCES `models` (`Model_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `synapses`
--

LOCK TABLES `synapses` WRITE;
/*!40000 ALTER TABLE `synapses` DISABLE KEYS */;
INSERT INTO `synapses` VALUES ('NMLSY000064','Exc_Pyr_Int','','2013-10-17 06:34:27','Simple example of a synaptic mechanism, which consists of a postsynaptic conductance which changes as double exponential function of time.'),('NMLSY000065','Exc_Pyr_Pyr','','2013-10-17 06:55:59','Simple example of a synaptic mechanism, which consists of a postsynaptic conductance which changes as double exponential function of time.'),('NMLSY000079','Double Exponential Synapse','/var/www/NeuroMLmodels/NMLSY000079/DoubExpSyn.xml','2014-07-07 05:30:08','updated 2014'),('NMLSY000080','AMPA_GranGol','/var/www/NeuroMLmodels/NMLSY000080/AMPA_GranGol.xml','2014-07-22 06:15:05',''),('NMLSY000081','GABAA','/var/www/NeuroMLmodels/NMLSY000081/GABAA.xml','2014-07-22 06:22:25',''),('NMLSY000082','MF_AMPA','/var/www/NeuroMLmodels/NMLSY000082/MF_AMPA.xml','2014-07-22 06:26:14',''),('NMLSY000083','NMDA','/var/www/NeuroMLmodels/NMLSY000083/NMDA.xml','2014-07-22 06:30:23',''),('NMLSY000084','GapJuncCML','/var/www/NeuroMLmodels/NMLSY000084/GapJuncCML.xml','2014-07-22 07:29:30',''),('NMLSY000099','ApicalSyn','/var/www/NeuroMLmodels/NMLSY000099/ApicalSyn.xml','2014-07-24 02:08:33',''),('NMLSY000100','MultiDecaySyn','/var/www/NeuroMLmodels/NMLSY000100/MultiDecaySyn.xml','2014-07-24 02:09:34','');
/*!40000 ALTER TABLE `synapses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `temp_later_keyword_query_results`
--

DROP TABLE IF EXISTS `temp_later_keyword_query_results`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `temp_later_keyword_query_results` (
  `Model_ID` varchar(45) NOT NULL,
  PRIMARY KEY (`Model_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `temp_later_keyword_query_results`
--

LOCK TABLES `temp_later_keyword_query_results` WRITE;
/*!40000 ALTER TABLE `temp_later_keyword_query_results` DISABLE KEYS */;
INSERT INTO `temp_later_keyword_query_results` VALUES ('NMLCL000004');
/*!40000 ALTER TABLE `temp_later_keyword_query_results` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `temp_query_results`
--

DROP TABLE IF EXISTS `temp_query_results`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `temp_query_results` (
  `Model_ID` varchar(45) NOT NULL,
  PRIMARY KEY (`Model_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `temp_query_results`
--

LOCK TABLES `temp_query_results` WRITE;
/*!40000 ALTER TABLE `temp_query_results` DISABLE KEYS */;
INSERT INTO `temp_query_results` VALUES ('NMLCH000025'),('NMLCH000026'),('NMLCH000027'),('NMLCH000028'),('NMLCH000029'),('NMLCH000030'),('NMLCH000031'),('NMLCH000032'),('NMLCH000033'),('NMLCH000034'),('NMLCH000035'),('NMLCH000036'),('NMLCH000037'),('NMLCL000005');
/*!40000 ALTER TABLE `temp_query_results` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `time_entries`
--

DROP TABLE IF EXISTS `time_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `time_entries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `issue_id` int(11) DEFAULT NULL,
  `hours` float NOT NULL,
  `comments` varchar(255) DEFAULT NULL,
  `activity_id` int(11) NOT NULL,
  `spent_on` date NOT NULL,
  `tyear` int(11) NOT NULL,
  `tmonth` int(11) NOT NULL,
  `tweek` int(11) NOT NULL,
  `created_on` datetime NOT NULL,
  `updated_on` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `time_entries_project_id` (`project_id`),
  KEY `time_entries_issue_id` (`issue_id`),
  KEY `index_time_entries_on_activity_id` (`activity_id`),
  KEY `index_time_entries_on_user_id` (`user_id`),
  KEY `index_time_entries_on_created_on` (`created_on`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `time_entries`
--

LOCK TABLES `time_entries` WRITE;
/*!40000 ALTER TABLE `time_entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `time_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tokens`
--

DROP TABLE IF EXISTS `tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `action` varchar(30) NOT NULL DEFAULT '',
  `value` varchar(40) NOT NULL DEFAULT '',
  `created_on` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tokens_value` (`value`),
  KEY `index_tokens_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tokens`
--

LOCK TABLES `tokens` WRITE;
/*!40000 ALTER TABLE `tokens` DISABLE KEYS */;
INSERT INTO `tokens` VALUES (1,1,'feeds','9a7b8cc01b4fa070d432f4d81ffda1f3f066f433','2013-04-15 12:16:29'),(2,5,'feeds','fe725476ffb3de9943ca0dc3734301191a3e7ec9','2013-04-19 10:25:18');
/*!40000 ALTER TABLE `tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trackers`
--

DROP TABLE IF EXISTS `trackers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trackers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL DEFAULT '',
  `is_in_chlog` tinyint(1) NOT NULL DEFAULT '0',
  `position` int(11) DEFAULT '1',
  `is_in_roadmap` tinyint(1) NOT NULL DEFAULT '1',
  `fields_bits` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trackers`
--

LOCK TABLES `trackers` WRITE;
/*!40000 ALTER TABLE `trackers` DISABLE KEYS */;
INSERT INTO `trackers` VALUES (1,'Bug',1,1,0,0),(2,'Feature',1,2,1,0),(3,'Support',0,3,0,0);
/*!40000 ALTER TABLE `trackers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_preferences`
--

DROP TABLE IF EXISTS `user_preferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_preferences` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `others` text,
  `hide_mail` tinyint(1) DEFAULT '0',
  `time_zone` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_user_preferences_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_preferences`
--

LOCK TABLES `user_preferences` WRITE;
/*!40000 ALTER TABLE `user_preferences` DISABLE KEYS */;
INSERT INTO `user_preferences` VALUES (1,1,'---\n:comments_sorting: asc\n:warn_on_leaving_unsaved: \'1\'\n:no_self_notified: false\n',0,''),(2,3,'--- {}\n',0,NULL),(3,4,'--- {}\n',0,NULL),(4,5,'--- {}\n',0,NULL),(5,6,'---\n:gantt_zoom: 4\n:gantt_months: 6\n',0,NULL);
/*!40000 ALTER TABLE `user_preferences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `login` varchar(255) NOT NULL DEFAULT '',
  `hashed_password` varchar(40) NOT NULL DEFAULT '',
  `firstname` varchar(30) NOT NULL DEFAULT '',
  `lastname` varchar(255) NOT NULL DEFAULT '',
  `mail` varchar(60) NOT NULL DEFAULT '',
  `admin` tinyint(1) NOT NULL DEFAULT '0',
  `status` int(11) NOT NULL DEFAULT '1',
  `last_login_on` datetime DEFAULT NULL,
  `language` varchar(5) DEFAULT '',
  `auth_source_id` int(11) DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `identity_url` varchar(255) DEFAULT NULL,
  `mail_notification` varchar(255) NOT NULL DEFAULT '',
  `salt` varchar(64) DEFAULT NULL,
  `remember_token` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_users_on_id_and_type` (`id`,`type`),
  KEY `index_users_on_auth_source_id` (`auth_source_id`),
  KEY `index_users_on_type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','179d10c29f5c8a2d0188549a627b2c309483adab','Curator','Admin','admin@example.net',1,1,'2015-01-27 15:00:20','en',NULL,'2013-02-23 13:19:49','2014-03-21 13:03:51','User',NULL,'all','b5e2628884ce5fe6f911c2cd23391ab8',NULL),(2,'','','','Anonymous','',0,0,NULL,'',NULL,'2013-02-23 13:21:20','2013-02-23 13:21:20','AnonymousUser',NULL,'only_my_events',NULL,NULL),(3,'akon','1bc9df0e7590e0979da0d32601f50a72c670ffe9','akon','akon','akon@akon.com',0,2,NULL,'en',NULL,'2013-04-15 12:19:16','2013-04-15 12:19:16','User',NULL,'only_my_events','c60052c1ed04447f162eb7533bf2b7b9',NULL),(4,'veer','78a81b59b83349c34e37b4a60832436537dd0b6d','veer','veer','veer@veer.com',0,2,NULL,'en',NULL,'2013-04-15 12:36:46','2013-04-15 12:36:46','User',NULL,'only_my_events','6a1bdaf708426a866f1d391988ab356f',NULL),(5,'invincible','03a5db2b3e50a0a03a2df3cbc0c31560db86619f','invincible','veer','veer@invincibles.com',0,1,'2013-04-19 10:25:06','en',NULL,'2013-04-19 02:43:36','2013-04-19 02:43:36','User',NULL,'only_my_events','b313f942f2e876246d77cd4deac1ab5e',NULL),(6,'123123123','f349438f02301b3006d4cb592f35fecc3a7f07af','YwKNSqvsmK','YwKNSqvsmK','wu.w.uwu.wu.w.u.w55.5.n.ihao@gmail.com',0,1,'2014-11-15 04:16:18','en',NULL,'2014-11-15 04:16:18','2014-11-15 04:16:18','User',NULL,'only_my_events','87336fab82b2bbeaa883e7def70e2ac4',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `versions`
--

DROP TABLE IF EXISTS `versions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `versions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(255) NOT NULL DEFAULT '',
  `description` varchar(255) DEFAULT '',
  `effective_date` date DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `wiki_page_title` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT 'open',
  `sharing` varchar(255) NOT NULL DEFAULT 'none',
  PRIMARY KEY (`id`),
  KEY `versions_project_id` (`project_id`),
  KEY `index_versions_on_sharing` (`sharing`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `versions`
--

LOCK TABLES `versions` WRITE;
/*!40000 ALTER TABLE `versions` DISABLE KEYS */;
/*!40000 ALTER TABLE `versions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `watchers`
--

DROP TABLE IF EXISTS `watchers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `watchers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `watchable_type` varchar(255) NOT NULL DEFAULT '',
  `watchable_id` int(11) NOT NULL DEFAULT '0',
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `watchers_user_id_type` (`user_id`,`watchable_type`),
  KEY `index_watchers_on_user_id` (`user_id`),
  KEY `index_watchers_on_watchable_id_and_watchable_type` (`watchable_id`,`watchable_type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `watchers`
--

LOCK TABLES `watchers` WRITE;
/*!40000 ALTER TABLE `watchers` DISABLE KEYS */;
/*!40000 ALTER TABLE `watchers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wiki_content_versions`
--

DROP TABLE IF EXISTS `wiki_content_versions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wiki_content_versions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `wiki_content_id` int(11) NOT NULL,
  `page_id` int(11) NOT NULL,
  `author_id` int(11) DEFAULT NULL,
  `data` longblob,
  `compression` varchar(6) DEFAULT '',
  `comments` varchar(255) DEFAULT '',
  `updated_on` datetime NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `wiki_content_versions_wcid` (`wiki_content_id`),
  KEY `index_wiki_content_versions_on_updated_on` (`updated_on`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wiki_content_versions`
--

LOCK TABLES `wiki_content_versions` WRITE;
/*!40000 ALTER TABLE `wiki_content_versions` DISABLE KEYS */;
/*!40000 ALTER TABLE `wiki_content_versions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wiki_contents`
--

DROP TABLE IF EXISTS `wiki_contents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wiki_contents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `page_id` int(11) NOT NULL,
  `author_id` int(11) DEFAULT NULL,
  `text` longtext,
  `comments` varchar(255) DEFAULT '',
  `updated_on` datetime NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `wiki_contents_page_id` (`page_id`),
  KEY `index_wiki_contents_on_author_id` (`author_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wiki_contents`
--

LOCK TABLES `wiki_contents` WRITE;
/*!40000 ALTER TABLE `wiki_contents` DISABLE KEYS */;
/*!40000 ALTER TABLE `wiki_contents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wiki_pages`
--

DROP TABLE IF EXISTS `wiki_pages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wiki_pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `wiki_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `created_on` datetime NOT NULL,
  `protected` tinyint(1) NOT NULL DEFAULT '0',
  `parent_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `wiki_pages_wiki_id_title` (`wiki_id`,`title`),
  KEY `index_wiki_pages_on_wiki_id` (`wiki_id`),
  KEY `index_wiki_pages_on_parent_id` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wiki_pages`
--

LOCK TABLES `wiki_pages` WRITE;
/*!40000 ALTER TABLE `wiki_pages` DISABLE KEYS */;
/*!40000 ALTER TABLE `wiki_pages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wiki_redirects`
--

DROP TABLE IF EXISTS `wiki_redirects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wiki_redirects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `wiki_id` int(11) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `redirects_to` varchar(255) DEFAULT NULL,
  `created_on` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `wiki_redirects_wiki_id_title` (`wiki_id`,`title`),
  KEY `index_wiki_redirects_on_wiki_id` (`wiki_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wiki_redirects`
--

LOCK TABLES `wiki_redirects` WRITE;
/*!40000 ALTER TABLE `wiki_redirects` DISABLE KEYS */;
/*!40000 ALTER TABLE `wiki_redirects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wikis`
--

DROP TABLE IF EXISTS `wikis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wikis` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `start_page` varchar(255) NOT NULL,
  `status` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `wikis_project_id` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wikis`
--

LOCK TABLES `wikis` WRITE;
/*!40000 ALTER TABLE `wikis` DISABLE KEYS */;
/*!40000 ALTER TABLE `wikis` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `workflows`
--

DROP TABLE IF EXISTS `workflows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `workflows` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tracker_id` int(11) NOT NULL DEFAULT '0',
  `old_status_id` int(11) NOT NULL DEFAULT '0',
  `new_status_id` int(11) NOT NULL DEFAULT '0',
  `role_id` int(11) NOT NULL DEFAULT '0',
  `assignee` tinyint(1) NOT NULL DEFAULT '0',
  `author` tinyint(1) NOT NULL DEFAULT '0',
  `type` varchar(30) DEFAULT NULL,
  `field_name` varchar(30) DEFAULT NULL,
  `rule` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `wkfs_role_tracker_old_status` (`role_id`,`tracker_id`,`old_status_id`),
  KEY `index_workflows_on_old_status_id` (`old_status_id`),
  KEY `index_workflows_on_role_id` (`role_id`),
  KEY `index_workflows_on_new_status_id` (`new_status_id`)
) ENGINE=InnoDB AUTO_INCREMENT=145 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workflows`
--

LOCK TABLES `workflows` WRITE;
/*!40000 ALTER TABLE `workflows` DISABLE KEYS */;
INSERT INTO `workflows` VALUES (1,1,1,2,3,0,0,'WorkflowTransition',NULL,NULL),(2,1,1,3,3,0,0,'WorkflowTransition',NULL,NULL),(3,1,1,4,3,0,0,'WorkflowTransition',NULL,NULL),(4,1,1,5,3,0,0,'WorkflowTransition',NULL,NULL),(5,1,1,6,3,0,0,'WorkflowTransition',NULL,NULL),(6,1,2,1,3,0,0,'WorkflowTransition',NULL,NULL),(7,1,2,3,3,0,0,'WorkflowTransition',NULL,NULL),(8,1,2,4,3,0,0,'WorkflowTransition',NULL,NULL),(9,1,2,5,3,0,0,'WorkflowTransition',NULL,NULL),(10,1,2,6,3,0,0,'WorkflowTransition',NULL,NULL),(11,1,3,1,3,0,0,'WorkflowTransition',NULL,NULL),(12,1,3,2,3,0,0,'WorkflowTransition',NULL,NULL),(13,1,3,4,3,0,0,'WorkflowTransition',NULL,NULL),(14,1,3,5,3,0,0,'WorkflowTransition',NULL,NULL),(15,1,3,6,3,0,0,'WorkflowTransition',NULL,NULL),(16,1,4,1,3,0,0,'WorkflowTransition',NULL,NULL),(17,1,4,2,3,0,0,'WorkflowTransition',NULL,NULL),(18,1,4,3,3,0,0,'WorkflowTransition',NULL,NULL),(19,1,4,5,3,0,0,'WorkflowTransition',NULL,NULL),(20,1,4,6,3,0,0,'WorkflowTransition',NULL,NULL),(21,1,5,1,3,0,0,'WorkflowTransition',NULL,NULL),(22,1,5,2,3,0,0,'WorkflowTransition',NULL,NULL),(23,1,5,3,3,0,0,'WorkflowTransition',NULL,NULL),(24,1,5,4,3,0,0,'WorkflowTransition',NULL,NULL),(25,1,5,6,3,0,0,'WorkflowTransition',NULL,NULL),(26,1,6,1,3,0,0,'WorkflowTransition',NULL,NULL),(27,1,6,2,3,0,0,'WorkflowTransition',NULL,NULL),(28,1,6,3,3,0,0,'WorkflowTransition',NULL,NULL),(29,1,6,4,3,0,0,'WorkflowTransition',NULL,NULL),(30,1,6,5,3,0,0,'WorkflowTransition',NULL,NULL),(31,2,1,2,3,0,0,'WorkflowTransition',NULL,NULL),(32,2,1,3,3,0,0,'WorkflowTransition',NULL,NULL),(33,2,1,4,3,0,0,'WorkflowTransition',NULL,NULL),(34,2,1,5,3,0,0,'WorkflowTransition',NULL,NULL),(35,2,1,6,3,0,0,'WorkflowTransition',NULL,NULL),(36,2,2,1,3,0,0,'WorkflowTransition',NULL,NULL),(37,2,2,3,3,0,0,'WorkflowTransition',NULL,NULL),(38,2,2,4,3,0,0,'WorkflowTransition',NULL,NULL),(39,2,2,5,3,0,0,'WorkflowTransition',NULL,NULL),(40,2,2,6,3,0,0,'WorkflowTransition',NULL,NULL),(41,2,3,1,3,0,0,'WorkflowTransition',NULL,NULL),(42,2,3,2,3,0,0,'WorkflowTransition',NULL,NULL),(43,2,3,4,3,0,0,'WorkflowTransition',NULL,NULL),(44,2,3,5,3,0,0,'WorkflowTransition',NULL,NULL),(45,2,3,6,3,0,0,'WorkflowTransition',NULL,NULL),(46,2,4,1,3,0,0,'WorkflowTransition',NULL,NULL),(47,2,4,2,3,0,0,'WorkflowTransition',NULL,NULL),(48,2,4,3,3,0,0,'WorkflowTransition',NULL,NULL),(49,2,4,5,3,0,0,'WorkflowTransition',NULL,NULL),(50,2,4,6,3,0,0,'WorkflowTransition',NULL,NULL),(51,2,5,1,3,0,0,'WorkflowTransition',NULL,NULL),(52,2,5,2,3,0,0,'WorkflowTransition',NULL,NULL),(53,2,5,3,3,0,0,'WorkflowTransition',NULL,NULL),(54,2,5,4,3,0,0,'WorkflowTransition',NULL,NULL),(55,2,5,6,3,0,0,'WorkflowTransition',NULL,NULL),(56,2,6,1,3,0,0,'WorkflowTransition',NULL,NULL),(57,2,6,2,3,0,0,'WorkflowTransition',NULL,NULL),(58,2,6,3,3,0,0,'WorkflowTransition',NULL,NULL),(59,2,6,4,3,0,0,'WorkflowTransition',NULL,NULL),(60,2,6,5,3,0,0,'WorkflowTransition',NULL,NULL),(61,3,1,2,3,0,0,'WorkflowTransition',NULL,NULL),(62,3,1,3,3,0,0,'WorkflowTransition',NULL,NULL),(63,3,1,4,3,0,0,'WorkflowTransition',NULL,NULL),(64,3,1,5,3,0,0,'WorkflowTransition',NULL,NULL),(65,3,1,6,3,0,0,'WorkflowTransition',NULL,NULL),(66,3,2,1,3,0,0,'WorkflowTransition',NULL,NULL),(67,3,2,3,3,0,0,'WorkflowTransition',NULL,NULL),(68,3,2,4,3,0,0,'WorkflowTransition',NULL,NULL),(69,3,2,5,3,0,0,'WorkflowTransition',NULL,NULL),(70,3,2,6,3,0,0,'WorkflowTransition',NULL,NULL),(71,3,3,1,3,0,0,'WorkflowTransition',NULL,NULL),(72,3,3,2,3,0,0,'WorkflowTransition',NULL,NULL),(73,3,3,4,3,0,0,'WorkflowTransition',NULL,NULL),(74,3,3,5,3,0,0,'WorkflowTransition',NULL,NULL),(75,3,3,6,3,0,0,'WorkflowTransition',NULL,NULL),(76,3,4,1,3,0,0,'WorkflowTransition',NULL,NULL),(77,3,4,2,3,0,0,'WorkflowTransition',NULL,NULL),(78,3,4,3,3,0,0,'WorkflowTransition',NULL,NULL),(79,3,4,5,3,0,0,'WorkflowTransition',NULL,NULL),(80,3,4,6,3,0,0,'WorkflowTransition',NULL,NULL),(81,3,5,1,3,0,0,'WorkflowTransition',NULL,NULL),(82,3,5,2,3,0,0,'WorkflowTransition',NULL,NULL),(83,3,5,3,3,0,0,'WorkflowTransition',NULL,NULL),(84,3,5,4,3,0,0,'WorkflowTransition',NULL,NULL),(85,3,5,6,3,0,0,'WorkflowTransition',NULL,NULL),(86,3,6,1,3,0,0,'WorkflowTransition',NULL,NULL),(87,3,6,2,3,0,0,'WorkflowTransition',NULL,NULL),(88,3,6,3,3,0,0,'WorkflowTransition',NULL,NULL),(89,3,6,4,3,0,0,'WorkflowTransition',NULL,NULL),(90,3,6,5,3,0,0,'WorkflowTransition',NULL,NULL),(91,1,1,2,4,0,0,'WorkflowTransition',NULL,NULL),(92,1,1,3,4,0,0,'WorkflowTransition',NULL,NULL),(93,1,1,4,4,0,0,'WorkflowTransition',NULL,NULL),(94,1,1,5,4,0,0,'WorkflowTransition',NULL,NULL),(95,1,2,3,4,0,0,'WorkflowTransition',NULL,NULL),(96,1,2,4,4,0,0,'WorkflowTransition',NULL,NULL),(97,1,2,5,4,0,0,'WorkflowTransition',NULL,NULL),(98,1,3,2,4,0,0,'WorkflowTransition',NULL,NULL),(99,1,3,4,4,0,0,'WorkflowTransition',NULL,NULL),(100,1,3,5,4,0,0,'WorkflowTransition',NULL,NULL),(101,1,4,2,4,0,0,'WorkflowTransition',NULL,NULL),(102,1,4,3,4,0,0,'WorkflowTransition',NULL,NULL),(103,1,4,5,4,0,0,'WorkflowTransition',NULL,NULL),(104,2,1,2,4,0,0,'WorkflowTransition',NULL,NULL),(105,2,1,3,4,0,0,'WorkflowTransition',NULL,NULL),(106,2,1,4,4,0,0,'WorkflowTransition',NULL,NULL),(107,2,1,5,4,0,0,'WorkflowTransition',NULL,NULL),(108,2,2,3,4,0,0,'WorkflowTransition',NULL,NULL),(109,2,2,4,4,0,0,'WorkflowTransition',NULL,NULL),(110,2,2,5,4,0,0,'WorkflowTransition',NULL,NULL),(111,2,3,2,4,0,0,'WorkflowTransition',NULL,NULL),(112,2,3,4,4,0,0,'WorkflowTransition',NULL,NULL),(113,2,3,5,4,0,0,'WorkflowTransition',NULL,NULL),(114,2,4,2,4,0,0,'WorkflowTransition',NULL,NULL),(115,2,4,3,4,0,0,'WorkflowTransition',NULL,NULL),(116,2,4,5,4,0,0,'WorkflowTransition',NULL,NULL),(117,3,1,2,4,0,0,'WorkflowTransition',NULL,NULL),(118,3,1,3,4,0,0,'WorkflowTransition',NULL,NULL),(119,3,1,4,4,0,0,'WorkflowTransition',NULL,NULL),(120,3,1,5,4,0,0,'WorkflowTransition',NULL,NULL),(121,3,2,3,4,0,0,'WorkflowTransition',NULL,NULL),(122,3,2,4,4,0,0,'WorkflowTransition',NULL,NULL),(123,3,2,5,4,0,0,'WorkflowTransition',NULL,NULL),(124,3,3,2,4,0,0,'WorkflowTransition',NULL,NULL),(125,3,3,4,4,0,0,'WorkflowTransition',NULL,NULL),(126,3,3,5,4,0,0,'WorkflowTransition',NULL,NULL),(127,3,4,2,4,0,0,'WorkflowTransition',NULL,NULL),(128,3,4,3,4,0,0,'WorkflowTransition',NULL,NULL),(129,3,4,5,4,0,0,'WorkflowTransition',NULL,NULL),(130,1,1,5,5,0,0,'WorkflowTransition',NULL,NULL),(131,1,2,5,5,0,0,'WorkflowTransition',NULL,NULL),(132,1,3,5,5,0,0,'WorkflowTransition',NULL,NULL),(133,1,4,5,5,0,0,'WorkflowTransition',NULL,NULL),(134,1,3,4,5,0,0,'WorkflowTransition',NULL,NULL),(135,2,1,5,5,0,0,'WorkflowTransition',NULL,NULL),(136,2,2,5,5,0,0,'WorkflowTransition',NULL,NULL),(137,2,3,5,5,0,0,'WorkflowTransition',NULL,NULL),(138,2,4,5,5,0,0,'WorkflowTransition',NULL,NULL),(139,2,3,4,5,0,0,'WorkflowTransition',NULL,NULL),(140,3,1,5,5,0,0,'WorkflowTransition',NULL,NULL),(141,3,2,5,5,0,0,'WorkflowTransition',NULL,NULL),(142,3,3,5,5,0,0,'WorkflowTransition',NULL,NULL),(143,3,4,5,5,0,0,'WorkflowTransition',NULL,NULL),(144,3,3,4,5,0,0,'WorkflowTransition',NULL,NULL);
/*!40000 ALTER TABLE `workflows` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `all_metadata_view`
--

/*!50001 DROP TABLE IF EXISTS `all_metadata_view`*/;
/*!50001 DROP VIEW IF EXISTS `all_metadata_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`neuromldb2`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `all_metadata_view` AS (select `model_metadata_associations`.`Model_ID` AS `Model_ID`,`model_metadata_associations`.`Metadata_ID` AS `Metadata_id`,'author person' AS `Metadata_type`,`people`.`Person_Last_Name` AS `Metadata_value` from (((`model_metadata_associations` join `author_lists` `al` on((`model_metadata_associations`.`Metadata_ID` = `al`.`AuthorList_ID`))) join `author_list_associations` `ala` on((`al`.`AuthorList_ID` = `ala`.`AuthorList_ID`))) join `people` on((`ala`.`Person_ID` = `people`.`Person_ID`)))) union (select `model_metadata_associations`.`Model_ID` AS `model_id`,`model_metadata_associations`.`Metadata_ID` AS `metadata_id`,'neurolex' AS `metadata_type`,`neurolexes`.`NeuroLex_URI` AS `metadata_value` from (`model_metadata_associations` join `neurolexes` on((`model_metadata_associations`.`Metadata_ID` = `neurolexes`.`NeuroLex_ID`)))) union (select `model_metadata_associations`.`Model_ID` AS `model_id`,`model_metadata_associations`.`Metadata_ID` AS `metadata_id`,'keyword' AS `metadata_type`,`other_keywords`.`Other_Keyword_term` AS `metadata_value` from (`model_metadata_associations` join `other_keywords` on((`model_metadata_associations`.`Metadata_ID` = `other_keywords`.`Other_Keyword_ID`)))) union (select `model_metadata_associations`.`Model_ID` AS `model_id`,`model_metadata_associations`.`Metadata_ID` AS `metadata_id`,'references' AS `metadata_type`,`references`.`Reference_URI` AS `metadata_value` from (`model_metadata_associations` join `references` on((`model_metadata_associations`.`Metadata_ID` = `references`.`Reference_ID`)))) union (select `model_metadata_associations`.`Model_ID` AS `model_id`,`model_metadata_associations`.`Metadata_ID` AS `metadata_id`,'publication' AS `metadata_type`,`publications`.`Pubmed_Ref` AS `metadata_value` from (`model_metadata_associations` join `publications` on((`model_metadata_associations`.`Metadata_ID` = `publications`.`Publication_ID`)))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `all_models_view`
--

/*!50001 DROP TABLE IF EXISTS `all_models_view`*/;
/*!50001 DROP VIEW IF EXISTS `all_models_view`*/;
/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`neuromldb2`@`localhost` SQL SECURITY DEFINER VIEW `all_models_view` AS (select `channels`.`Channel_ID` AS `Model_ID`,`channels`.`Channel_Name` AS `Model_Name`,`channels`.`ChannelML_File` AS `Model_File`,`channels`.`Upload_Time` AS `upload_time`,`channels`.`Comments` AS `comments` from `channels`) union (select `cells`.`Cell_ID` AS `Cell_ID`,`cells`.`Cell_Name` AS `Cell_Name`,`cells`.`MorphML_File` AS `MorphML_File`,`cells`.`Upload_Time` AS `upload_time`,`cells`.`Comments` AS `comments` from `cells`) union (select `synapses`.`Synapse_ID` AS `Synapse_ID`,`synapses`.`Synapse_Name` AS `Synapse_Name`,`synapses`.`Synapse_File` AS `Synapse_File`,`synapses`.`Upload_Time` AS `upload_time`,`synapses`.`Comments` AS `comments` from `synapses`) union (select `networks`.`Network_ID` AS `network_ID`,`networks`.`Network_Name` AS `Network_Name`,`networks`.`NetworkML_File` AS `NetworkML_File`,`networks`.`Upload_Time` AS `upload_time`,`networks`.`Comments` AS `comments` from `networks`) */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-01-31 12:02:28
