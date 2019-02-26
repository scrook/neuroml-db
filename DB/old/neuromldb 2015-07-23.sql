-- MySQL dump 10.13  Distrib 5.6.17, for Win32 (x86)
--
-- Host: localhost    Database: neuromldb
-- ------------------------------------------------------
-- Server version	5.5.43-0ubuntu0.14.04.1

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
INSERT INTO `author_list_associations` VALUES (1000003,2000004,'1',NULL),(1000003,2000006,'0',NULL),(1000003,2000007,'0',NULL),(1000003,2000041,'1',NULL),(1000003,2000042,'1',NULL),(1000044,2000004,'1',NULL),(1000044,2000010,'1',NULL),(1000044,2000020,'0',NULL),(1000044,2000043,'1',NULL),(1000044,2000044,'0',NULL),(1000044,2000045,'0',NULL),(1000044,2000046,'0',NULL),(1000044,2000047,'0',NULL),(1000047,2000004,'1',NULL),(1000051,2000004,'1',NULL),(1000051,2000005,'0',NULL),(1000051,2000006,'0',NULL),(1000068,2000001,'0',NULL),(1000068,2000002,'0',NULL),(1000068,2000003,'0',NULL),(1000068,2000004,'1',NULL),(1000176,2000004,'2',NULL),(1000176,2000009,'0',NULL),(1000176,2000010,'0',NULL),(1000176,2000014,'1',NULL),(1000176,2000015,'1',NULL),(1000176,2000036,'0',NULL),(1000176,2000038,'0',NULL),(1000176,2000039,'0',NULL),(1000177,2000004,'1',NULL),(1000177,2000014,'1',NULL),(1000177,2000021,'1',NULL),(1000177,2000025,'1',NULL),(1000177,2000026,'1',NULL),(1000177,2000027,'0',NULL),(1000177,2000048,'0',NULL),(1000177,2000049,'0',NULL),(1000177,2000050,'0',NULL),(1000177,2000051,'0',NULL),(1000177,2000052,'0',NULL),(1000177,2000053,'0',NULL),(1000177,2000054,'0',NULL),(1000177,2000055,'0',NULL),(1000177,2000056,'0',NULL),(1000177,2000057,'1',NULL),(1000177,2000058,'1',NULL),(1000177,2000059,'1',NULL),(1000177,2000060,'1',NULL),(1000177,2000061,'1',NULL),(1000178,2000004,'1',NULL),(1000178,2000018,'1',NULL),(1000178,2000019,'1',NULL),(1000178,2000062,'0',NULL);
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
INSERT INTO `author_lists` VALUES (1000003),(1000044),(1000047),(1000051),(1000068),(1000176),(1000177),(1000178);
/*!40000 ALTER TABLE `author_lists` ENABLE KEYS */;
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
INSERT INTO `cell_channel_associations` VALUES ('NMLCL000001','NMLCH000001',NULL),('NMLCL000001','NMLCH000002',NULL),('NMLCL000001','NMLCH000003',NULL),('NMLCL000001','NMLCH000004',NULL),('NMLCL000001','NMLCH000005',NULL),('NMLCL000001','NMLCH000006',NULL),('NMLCL000001','NMLCH000007',NULL),('NMLCL000002','NMLCH000008',NULL),('NMLCL000002','NMLCH000009',NULL),('NMLCL000002','NMLCH000010',NULL),('NMLCL000002','NMLCH000011',NULL),('NMLCL000002','NMLCH000012',NULL),('NMLCL000002','NMLCH000013',NULL),('NMLCL000002','NMLCH000014',NULL),('NMLCL000002','NMLCH000015',NULL),('NMLCL000003','NMLCH000016',NULL),('NMLCL000004','NMLCH000017',NULL),('NMLCL000004','NMLCH000018',NULL),('NMLCL000004','NMLCH000019',NULL),('NMLCL000004','NMLCH000020',NULL),('NMLCL000004','NMLCH000021',NULL),('NMLCL000004','NMLCH000022',NULL),('NMLCL000004','NMLCH000023',NULL),('NMLCL000004','NMLCH000024',NULL),('NMLCL000005','NMLCH000025',NULL),('NMLCL000005','NMLCH000026',NULL),('NMLCL000005','NMLCH000027',NULL),('NMLCL000005','NMLCH000028',NULL),('NMLCL000005','NMLCH000029',NULL),('NMLCL000005','NMLCH000030',NULL),('NMLCL000005','NMLCH000031',NULL),('NMLCL000005','NMLCH000032',NULL),('NMLCL000005','NMLCH000033',NULL),('NMLCL000005','NMLCH000034',NULL),('NMLCL000005','NMLCH000035',NULL),('NMLCL000005','NMLCH000036',NULL),('NMLCL000005','NMLCH000037',NULL),('NMLCL000054','NMLCH000048',NULL),('NMLCL000054','NMLCH000049',NULL),('NMLCL000054','NMLCH000050',NULL),('NMLCL000054','NMLCH000051',NULL),('NMLCL000054','NMLCH000052',NULL),('NMLCL000054','NMLCH000053',NULL),('NMLCL000060','NMLCH000048',NULL),('NMLCL000060','NMLCH000049',NULL),('NMLCL000060','NMLCH000050',NULL),('NMLCL000060','NMLCH000051',NULL),('NMLCL000060','NMLCH000053',NULL),('NMLCL000060','NMLCH000055',NULL),('NMLCL000060','NMLCH000056',NULL),('NMLCL000060','NMLCH000057',NULL),('NMLCL000060','NMLCH000058',NULL),('NMLCL000060','NMLCH000059',NULL),('NMLCL000061','NMLCH000048',NULL),('NMLCL000061','NMLCH000049',NULL),('NMLCL000061','NMLCH000050',NULL),('NMLCL000061','NMLCH000051',NULL),('NMLCL000061','NMLCH000053',NULL),('NMLCL000061','NMLCH000055',NULL),('NMLCL000061','NMLCH000056',NULL),('NMLCL000061','NMLCH000057',NULL),('NMLCL000061','NMLCH000058',NULL),('NMLCL000061','NMLCH000059',NULL),('NMLCL000061','NMLCH000099',NULL),('NMLCL000061','NMLCH000100',NULL),('NMLCL000077','NMLCH000048',NULL),('NMLCL000077','NMLCH000049',NULL),('NMLCL000077','NMLCH000051',NULL),('NMLCL000077','NMLCH000053',NULL),('NMLCL000077','NMLCH000055',NULL),('NMLCL000077','NMLCH000056',NULL),('NMLCL000077','NMLCH000058',NULL),('NMLCL000077','NMLCH000059',NULL),('NMLCL000078','NMLCH000048',NULL),('NMLCL000078','NMLCH000049',NULL),('NMLCL000078','NMLCH000051',NULL),('NMLCL000078','NMLCH000052',NULL),('NMLCL000078','NMLCH000053',NULL),('NMLCL000085','NMLCH000066',NULL),('NMLCL000085','NMLCH000067',NULL),('NMLCL000085','NMLCH000068',NULL),('NMLCL000085','NMLCH000069',NULL),('NMLCL000085','NMLCH000086',NULL),('NMLCL000085','NMLCH000087',NULL),('NMLCL000085','NMLCH000088',NULL),('NMLCL000085','NMLCH000089',NULL),('NMLCL000085','NMLCH000090',NULL),('NMLCL000085','NMLCH000091',NULL),('NMLCL000085','NMLCH000092',NULL),('NMLCL000085','NMLCH000093',NULL),('NMLCL000085','NMLCH000094',NULL),('NMLCL000085','NMLCH000095',NULL),('NMLCL000085','NMLCH000096',NULL),('NMLCL000085','NMLCH000097',NULL),('NMLCL000085','NMLCH000098',NULL);
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
INSERT INTO `cell_synapse_associations` VALUES ('NMLCL000002','NMLSY000080',NULL),('NMLCL000002','NMLSY000081',NULL),('NMLCL000002','NMLSY000082',NULL),('NMLCL000002','NMLSY000083',NULL),('NMLCL000003','NMLSY000082',NULL),('NMLCL000003','NMLSY000083',NULL),('NMLCL000004','NMLSY000080',NULL),('NMLCL000004','NMLSY000081',NULL),('NMLCL000085','NMLSY000084',NULL),('NMLCL000085','NMLSY000099',NULL),('NMLCL000085','NMLSY000100',NULL);
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
INSERT INTO `cells` VALUES ('NMLCL000001','CA1 Pyramidal Cell','/var/www/NeuroMLmodels/NMLCL000001/CA1.morph.xml','2012-12-21 00:00:00','updated July 2014'),('NMLCL000002','Granule Cell','/var/www/NeuroMLmodels/NMLCL000002/Granule_98.morph.xml','2014-01-10 00:00:00','updated July 2014'),('NMLCL000003','Granule Input Mossy Fiber','/var/www/NeuroMLmodels/NMLCL000003/MossyFiber.morph.xml','2013-01-10 00:00:00','Updated July 2014'),('NMLCL000004','Golgi Cell','/var/www/NeuroMLmodels/NMLCL000004/Golgi_98.morph.xml','2013-12-12 00:00:00','updated July 2014'),('NMLCL000005','Purkinje Cell','/var/www/NeuroMLmodels/NMLCL000005/purk2.nml','2013-01-26 00:00:00',''),('NMLCL000054','Layer 2/3 Pyramidal Cell with Regular Spiking','/var/www/NeuroMLmodels/NMLCL000054/L23PyrRS.nml','2013-10-22 06:19:07',''),('NMLCL000060','Superficial Pyramidal Cells AxoAxonic Connectivity','/var/www/NeuroMLmodels/NMLCL000060/SupAxA.xml','2013-10-17 07:16:59',''),('NMLCL000061','Superficial Low Threshold Spiking Interneurons','/var/www/NeuroMLmodels/NMLCL000061/SupLTSInter.xml','2013-12-08 10:24:18','Cell: supLTS_0 exported from NEURON ModelView'),('NMLCL000073','Layer 5b Pyramidal cell ','/var/www/NeuroMLmodels/NMLCL000073/L5PC.cell.nml','2013-10-30 06:02:54','Layer 5b Pyramidal cell constrained by experimental data on perisomatic firing properties as well as dendritic activity during backpropagation of the action potential.'),('NMLCL000077','Nucleus Reticularis Thalami Cell','/var/www/NeuroMLmodels/NMLCL000077/nRT.nml','2013-10-31 07:10:15',''),('NMLCL000078','Layer 2/3 Pyramidal Fast Rhythmic Bursting','/var/www/NeuroMLmodels/NMLCL000078/L23PyrFRB.nml','2013-10-30 07:31:23','This is a project implementing cells from the thalamocortical network model of Traub et al 2005 in NeuroML.'),('NMLCL000085','Golgi_Cell','/var/www/NeuroMLmodels/NMLCL000085/Golgi_NeuroML.morph.xml','2014-07-23 02:24:31',''),('NMLCL000086','Izhikevich Spiking Neuron Model','/var/www/NeuroMLmodels/NMLCL000086/WhichModel.nml','2015-04-10 11:40:00',NULL);
/*!40000 ALTER TABLE `cells` ENABLE KEYS */;
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
INSERT INTO `channels` VALUES ('NMLCH000001','hd Channel','/var/www/NeuroMLmodels/NMLCH000001/hd.xml','2012-12-21 00:00:00','updated July 2014'),('NMLCH000002','kad Channel','/var/www/NeuroMLmodels/NMLCH000002/kad.xml','2012-12-21 00:00:00','updated July 2014'),('NMLCH000003','kap Channel','/var/www/NeuroMLmodels/NMLCH000003/kap.xml','2013-12-21 00:00:00','updated July 2014'),('NMLCH000004','kdr Channel','/var/www/NeuroMLmodels/NMLCH000004/kdr.xml','2012-12-21 00:00:00','updated July 2014'),('NMLCH000005','Na3 Channel','/var/www/NeuroMLmodels/NMLCH000005/na3.xml','2012-12-21 00:00:00','updated July 2014'),('NMLCH000006','nax Channel','/var/www/NeuroMLmodels/NMLCH000006/nax.xml','2012-12-21 00:00:00','updated July 2014'),('NMLCH000007','pas Channel','/var/www/NeuroMLmodels/NMLCH000007/pas.xml','2012-12-21 00:00:00','updated July 2014'),('NMLCH000008','Gran_NaF_98 Channel','/var/www/NeuroMLmodels/NMLCH000008/Gran_NaF_98.xml','2013-01-10 00:00:00','updated July 2014'),('NMLCH000009','Gran_KDr_98 Channel','/var/www/NeuroMLmodels/NMLCH000009/Gran_KDr_98.xml','2013-01-10 00:00:00','updated July 2014'),('NMLCH000010','Gran_KCa_98 Channel','/var/www/NeuroMLmodels/NMLCH000010/Gran_KCa_98.xml','2013-01-10 00:00:00','updated July 2014'),('NMLCH000011','Gran_KA_98 Channel','/var/www/NeuroMLmodels/NMLCH000011/Gran_KA_98.xml','2013-01-10 00:00:00','updated July 2014'),('NMLCH000012','Gran_H_98 Channel','/var/www/NeuroMLmodels/NMLCH000012/Gran_H_98.xml','2013-01-10 00:00:00','updated July 2014'),('NMLCH000013','Gran_CaPool_98 Channel','/var/www/NeuroMLmodels/NMLCH000013/Gran_CaPool_98.xml','2013-01-10 00:00:00','updated July 2014'),('NMLCH000014','Gran_CaHVA_98 Channel','/var/www/NeuroMLmodels/NMLCH000014/Gran_CaHVA_98.xml','2013-01-10 00:00:00','updated July 2014'),('NMLCH000015','GranPassiveCond Channel','/var/www/NeuroMLmodels/NMLCH000015/GranPassiveCond.xml','2013-01-10 00:00:00','updated July 2014'),('NMLCH000016','MFFastLeakCond Channel','/var/www/NeuroMLmodels/NMLCH000016/MFFastLeakCond.xml','2013-01-10 00:00:00',''),('NMLCH000017','Golgi_CaHVA_CML Channel','/var/www/NeuroMLmodels/NMLCH000017/Golgi_CaHVA_CML.xml','2013-01-10 00:00:00',''),('NMLCH000018','Golgi_CaPool_CML Channel','/var/www/NeuroMLmodels/NMLCH000018/Golgi_CaPool_CML.xml','2013-01-10 00:00:00',''),('NMLCH000019','Golgi_H_CML Channel','/var/www/NeuroMLmodels/NMLCH000019/Golgi_H_CML.xml','2013-01-10 00:00:00',''),('NMLCH000020','Golgi_KA_CML Channel','/var/www/NeuroMLmodels/NMLCH000020/Golgi_KA_CML.xml','2013-01-10 00:00:00',''),('NMLCH000021','Golgi_KCa_CML Channel','/var/www/NeuroMLmodels/NMLCH000021/Golgi_KCa_CML.xml','2013-01-10 00:00:00',''),('NMLCH000022','Golgi_KDr_CML Channel','/var/www/NeuroMLmodels/NMLCH000022/Golgi_KDr_CML.xml','2013-01-10 00:00:00',''),('NMLCH000023','Golgi_NaF_CML Channel','/var/www/NeuroMLmodels/NMLCH000023/Golgi_NaF_CML.xml','2013-01-10 00:00:00',''),('NMLCH000024','GolgiPassiveCond Channel','/var/www/NeuroMLmodels/NMLCH000024/GolgiPassiveCond.xml','2013-01-10 00:00:00',''),('NMLCH000025','NaP Channel','/var/www/NeuroMLmodels/NMLCH000025/NaP_Chan.xml','2013-01-31 00:00:00',''),('NMLCH000026','NaF Channel','/var/www/NeuroMLmodels/NMLCH000026/NaF_Chan.xml','2013-01-31 00:00:00',''),('NMLCH000027','Leak Channel','/var/www/NeuroMLmodels/NMLCH000027/LeakConductance.xml','2013-01-31 00:00:00',''),('NMLCH000028','KM Channel','/var/www/NeuroMLmodels/NMLCH000028/KMnew2_Chan.xml','2013-01-31 00:00:00',''),('NMLCH000029','Kh2 Channel','/var/www/NeuroMLmodels/NMLCH000029/Kh2_Chan.xml','2013-01-31 00:00:00',''),('NMLCH000030','Kh1 Channel','/var/www/NeuroMLmodels/NMLCH000030/Kh1_Chan.xml','2013-01-31 00:00:00',''),('NMLCH000031','Kdr Channel','/var/www/NeuroMLmodels/NMLCH000031/Kdr_Chan.xml','2013-01-31 00:00:00',''),('NMLCH000032','Kc Channel','/var/www/NeuroMLmodels/NMLCH000032/Kc_Chan.xml','2013-01-31 00:00:00',''),('NMLCH000033','KA Channel','/var/www/NeuroMLmodels/NMLCH000033/KA_Chan.xml','2013-01-31 00:00:00',''),('NMLCH000034','K2 Channel','/var/www/NeuroMLmodels/NMLCH000034/K2_Chan.xml','2013-01-31 00:00:00',''),('NMLCH000035','CaT Channel','/var/www/NeuroMLmodels/NMLCH000035/CaT_Chan.xml','2013-01-31 00:00:00',''),('NMLCH000036','Calcium Pool','/var/www/NeuroMLmodels/NMLCH000036/CaPool.xml','2013-01-31 00:00:00',''),('NMLCH000037','CaP_Channel','/var/www/NeuroMLmodels/NMLCH000037/CaP_Chan.xml','2013-01-31 00:00:00',''),('NMLCH000048','ar','/var/www/NeuroMLmodels/NMLCH000048/ar.xml','2013-10-11 05:13:39','Anomalous Rectifier conductance, also known as h-conductance (hyperpolarizing).'),('NMLCH000049','km','/var/www/NeuroMLmodels/NMLCH000049/km.xml','2013-10-15 05:41:17','Potasium M type current (muscarinic receptor-suppressed).'),('NMLCH000050','nap Channel','/var/www/NeuroMLmodels/NMLCH000050/nap.xml','2013-10-15 05:46:45','Persistent (non inactivating) Sodium channel'),('NMLCH000051','Cad Channel','/var/www/NeuroMLmodels/NMLCH000051/cad.xml','2013-10-15 05:52:08','An expontially decaying pool of calcium, with a ceiling concentration'),('NMLCH000052','Kahp Channel','/var/www/NeuroMLmodels/NMLCH000052/kahp.xml','2013-10-15 05:54:03','[Ca2+] dependent K AHP (afterhyperpolarization) conductance.'),('NMLCH000053','Cal Channel','/var/www/NeuroMLmodels/NMLCH000053/cal.xml','2013-10-15 05:56:06','High threshold, long lasting Calcium L-type current.'),('NMLCH000055','kdr_fs Channel','/var/www/NeuroMLmodels/NMLCH000055/kdr_fs.xml','2013-10-15 06:39:37','Potasium delayed rectifier type conductance for fast-spiking (FS) interneurons for RD Traub et al 2005'),('NMLCH000056','kahp_slower','/var/www/NeuroMLmodels/NMLCH000056/kahp_slower.xml','2013-10-15 06:51:41','Slow [Ca2+] dependent K AHP (afterhyperpolarization) conductance. Slower version of kahp from Trau'),('NMLCH000057','kc_fast Channel','/var/www/NeuroMLmodels/NMLCH000057/kc_fast.xml','2013-10-15 06:53:44','Fast voltage and [Ca2+] dependent K conductance (BK channel).'),('NMLCH000058','naf2 Channel','/var/www/NeuroMLmodels/NMLCH000058/naf2.xml','2013-10-15 07:01:26','Fast Sodium transient (inactivating) current. Channel used in Traub et al 2005, slight modification of naf from Traub et al 2003'),('NMLCH000059','k2 Channel','/var/www/NeuroMLmodels/NMLCH000059/k2.xml','2013-10-15 07:02:53','Potasium K2-type current (slowly activating and inactivating).'),('NMLCH000066','CaHVA_CML','/var/www/NeuroMLmodels/NMLCH000066/CaHVA_CML.xml','2013-10-18 05:40:39',''),('NMLCH000067','CaLVA_CML','/var/www/NeuroMLmodels/NMLCH000067/CaLVA_CML.xml','2013-10-18 06:58:56',''),('NMLCH000068','Golgi_CALC_CML ','/var/www/NeuroMLmodels/NMLCH000068/Golgi_CALC_CML.xml','2013-10-18 07:02:48',''),('NMLCH000069','Golgi_CALC_ca2_CML ','/var/www/NeuroMLmodels/NMLCH000069/Golgi_CALC_ca2_CML.xml','2013-10-18 07:48:54',''),('NMLCH000086','hcn1f_CML','/var/www/NeuroMLmodels/NMLCH000086/hcn1f_CML.xml','2014-07-23 02:29:53',''),('NMLCH000087','hcn1s_CML','/var/www/NeuroMLmodels/NMLCH000087/hcn1s_CML.xml','2014-07-23 02:31:19',''),('NMLCH000088','hcn2f_CML','/var/www/NeuroMLmodels/NMLCH000088/hcn2f_CML.xml','2014-07-23 02:32:21',''),('NMLCH000089','hcn2s_CML','/var/www/NeuroMLmodels/NMLCH000089/hcn2s_CML.xml','2014-07-23 02:33:27',''),('NMLCH000090','KA_CML','/var/www/NeuroMLmodels/NMLCH000090/KA_CML.xml','2014-07-23 02:34:25',''),('NMLCH000091','KAHP_CML','/var/www/NeuroMLmodels/NMLCH000091/KAHP_CML.xml','2014-07-23 02:35:23',''),('NMLCH000092','KC_CML','/var/www/NeuroMLmodels/NMLCH000092/KC_CML.xml','2014-07-23 02:36:14',''),('NMLCH000093','Kslow_CML','/var/www/NeuroMLmodels/NMLCH000093/Kslow_CML.xml','2014-07-23 02:37:08',''),('NMLCH000094','KV_CML','/var/www/NeuroMLmodels/NMLCH000094/KV_CML.xml','2014-07-23 02:37:48',''),('NMLCH000095','LeakConductance','/var/www/NeuroMLmodels/NMLCH000095/LeakConductance.xml','2014-07-23 02:38:30',''),('NMLCH000096','NaP_CML','/var/www/NeuroMLmodels/NMLCH000096/NaP_CML.xml','2014-07-23 02:39:10',''),('NMLCH000097','NaR_CML','/var/www/NeuroMLmodels/NMLCH000097/NaR_CML.xml','2014-07-23 02:39:51',''),('NMLCH000098','NaT_CML','/var/www/NeuroMLmodels/NMLCH000098/NaT_CML.xml','2014-07-23 02:40:31',''),('NMLCH000099','ka Channel','/var/www/NeuroMLmodels/NMLCH000099/ka.xml','2015-05-21 02:40:31',NULL),('NMLCH000100','cat_a Channel','/var/www/NeuroMLmodels/NMLCH000100/cat_a.xml','2014-05-21 02:40:31',NULL);
/*!40000 ALTER TABLE `channels` ENABLE KEYS */;
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
INSERT INTO `metadatas` VALUES (1000003),(1000044),(1000047),(1000051),(1000068),(1000176),(1000177),(1000178),(3000001),(3000002),(3000003),(3000004),(3000005),(3000006),(3000007),(3000008),(3000009),(3000010),(3000011),(3000041),(3000044),(3000045),(3000046),(4000001),(4000002),(4000003),(4000004),(4000005),(4000006),(4000007),(4000008),(4000020),(4000021),(4000022),(4000023),(4000024),(4000025),(4000026),(4000027),(4000028),(4000029),(4000030),(4000031),(4000032),(4000033),(4000037),(4000038),(4000039),(4000040),(4000044),(4000045),(4000046),(4000203),(4000229),(5000001),(5000002),(5000003),(5000004),(5000005),(5000006),(5000020),(5000021),(5000022),(5000023),(5000024),(5000025),(5000026),(5000027),(5000030),(5000032),(5000033),(5000037),(5000038),(5000041),(5000044),(5000045),(5000046),(5000049),(5000050),(5000053),(5000054),(5000057),(5000058),(5000066),(5000067),(5000070),(5000071),(5000074),(5000075),(5000078),(5000079),(5000082),(5000083),(5000086),(5000087),(5000090),(5000091),(5000093),(5000094),(5000095),(5000096),(5000097),(5000098),(5000101),(5000102),(5000105),(5000106),(5000109),(5000110),(5000113),(5000114),(5000117),(5000118),(5000121),(5000122),(5000125),(5000126),(5000129),(5000130),(5000133),(5000134),(5000137),(5000138),(5000141),(5000142),(5000145),(5000146),(5000149),(5000150),(5000153),(5000154),(5000158),(5000159),(5000162),(5000163),(5000166),(5000167),(5000170),(5000171),(5000172),(5000174),(5000176),(5000177),(5000178),(5000179),(5000180),(5000181),(5000182),(5000183),(5000184),(5000185),(5000186),(5000187),(5000188),(5000189),(5000190),(5000192),(5000194),(5000196),(5000197),(5000199),(5000201),(5000202),(5000204),(5000205),(5000206),(5000207),(5000208),(5000209),(5000210),(5000211),(5000212),(5000213),(5000214),(5000215),(5000216),(5000218),(5000219),(5000224),(5000225),(5000227),(5000228),(5000229),(5000230),(5000231),(6000001),(6000002),(6000003),(6000020),(6000021),(6000022),(6000023),(6000026),(6000032),(6000033),(6000037),(6000038),(6000041),(6000044),(6000045),(6000046),(6000048),(6000052),(6000056),(6000060),(6000062),(6000064),(6000065),(6000069),(6000073),(6000077),(6000081),(6000085),(6000089),(6000100),(6000104),(6000108),(6000112),(6000116),(6000120),(6000124),(6000128),(6000132),(6000136),(6000140),(6000144),(6000148),(6000152),(6000157),(6000161),(6000165),(6000169),(6000176),(6000177),(6000178),(6000179),(6000180),(6000181),(6000182),(6000183),(6000184),(6000185),(6000186),(6000187),(6000188),(6000189),(6000193),(6000195),(6000200),(6000217),(6000223),(6000226),(6000227);
/*!40000 ALTER TABLE `metadatas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `model_counts`
--

DROP TABLE IF EXISTS `model_counts`;
/*!50001 DROP VIEW IF EXISTS `model_counts`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `model_counts` (
  `Type` tinyint NOT NULL,
  `Count` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

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
INSERT INTO `model_metadata_associations` VALUES (1000003,'NMLCH000025',NULL),(1000003,'NMLCH000026','Inherited author_list metadata from parent NMLCL000005'),(1000003,'NMLCH000027','Inherited author_list metadata from parent NMLCL000005'),(1000003,'NMLCH000028','Inherited author_list metadata from parent NMLCL000005'),(1000003,'NMLCH000029','Inherited author_list metadata from parent NMLCL000005'),(1000003,'NMLCH000030','Inherited author_list metadata from parent NMLCL000005'),(1000003,'NMLCH000031','Inherited author_list metadata from parent NMLCL000005'),(1000003,'NMLCH000032','Inherited author_list metadata from parent NMLCL000005'),(1000003,'NMLCH000033','Inherited author_list metadata from parent NMLCL000005'),(1000003,'NMLCH000034','Inherited author_list metadata from parent NMLCL000005'),(1000003,'NMLCH000035','Inherited author_list metadata from parent NMLCL000005'),(1000003,'NMLCH000036','Inherited author_list metadata from parent NMLCL000005'),(1000003,'NMLCH000037','Inherited author_list metadata from parent NMLCL000005'),(1000003,'NMLCL000005',NULL),(1000044,'NMLCL000073',NULL),(1000047,'NMLSY000079',NULL),(1000051,'NMLCH000008','Inherited author_list metadata from parent NMLCL000002'),(1000051,'NMLCH000009','Inherited author_list metadata from parent NMLCL000002'),(1000051,'NMLCH000010','Inherited author_list metadata from parent NMLCL000002'),(1000051,'NMLCH000011','Inherited author_list metadata from parent NMLCL000002'),(1000051,'NMLCH000012','Inherited author_list metadata from parent NMLCL000002'),(1000051,'NMLCH000013','Inherited author_list metadata from parent NMLCL000002'),(1000051,'NMLCH000014','Inherited author_list metadata from parent NMLCL000002'),(1000051,'NMLCH000015','Inherited author_list metadata from parent NMLCL000002'),(1000051,'NMLCH000016','Inherited author_list metadata from parent NMLCL000003'),(1000051,'NMLCH000017','Inherited author_list metadata from parent NMLCL000004'),(1000051,'NMLCH000018','Inherited author_list metadata from parent NMLCL000004'),(1000051,'NMLCH000019','Inherited author_list metadata from parent NMLCL000004'),(1000051,'NMLCH000020','Inherited author_list metadata from parent NMLCL000004'),(1000051,'NMLCH000021','Inherited author_list metadata from parent NMLCL000004'),(1000051,'NMLCH000022','Inherited author_list metadata from parent NMLCL000004'),(1000051,'NMLCH000023','Inherited author_list metadata from parent NMLCL000004'),(1000051,'NMLCH000024','Inherited author_list metadata from parent NMLCL000004'),(1000051,'NMLCL000002',NULL),(1000051,'NMLCL000003',NULL),(1000051,'NMLCL000004',NULL),(1000051,'NMLNT000001',NULL),(1000051,'NMLSY000080',NULL),(1000051,'NMLSY000081',NULL),(1000051,'NMLSY000082',NULL),(1000051,'NMLSY000083',NULL),(1000068,'NMLCH000001',NULL),(1000068,'NMLCH000002',NULL),(1000068,'NMLCH000003',NULL),(1000068,'NMLCH000004',NULL),(1000068,'NMLCH000005',NULL),(1000068,'NMLCH000006',NULL),(1000068,'NMLCH000007',NULL),(1000068,'NMLCL000001',NULL),(1000176,'NMLCH000066',NULL),(1000176,'NMLCH000067',NULL),(1000176,'NMLCH000068',NULL),(1000176,'NMLCH000069',NULL),(1000176,'NMLCH000086','Inherited author_list metadata from parent NMLCL000085'),(1000176,'NMLCH000087','Inherited author_list metadata from parent NMLCL000085'),(1000176,'NMLCH000088','Inherited author_list metadata from parent NMLCL000085'),(1000176,'NMLCH000089','Inherited author_list metadata from parent NMLCL000085'),(1000176,'NMLCH000090','Inherited author_list metadata from parent NMLCL000085'),(1000176,'NMLCH000091','Inherited author_list metadata from parent NMLCL000085'),(1000176,'NMLCH000092','Inherited author_list metadata from parent NMLCL000085'),(1000176,'NMLCH000093','Inherited author_list metadata from parent NMLCL000085'),(1000176,'NMLCH000094','Inherited author_list metadata from parent NMLCL000085'),(1000176,'NMLCH000095','Inherited author_list metadata from parent NMLCL000085'),(1000176,'NMLCH000096','Inherited author_list metadata from parent NMLCL000085'),(1000176,'NMLCH000097','Inherited author_list metadata from parent NMLCL000085'),(1000176,'NMLCH000098','Inherited author_list metadata from parent NMLCL000085'),(1000176,'NMLCL000085',NULL),(1000176,'NMLNT000070',NULL),(1000176,'NMLSY000084',NULL),(1000176,'NMLSY000099',NULL),(1000176,'NMLSY000100',NULL),(1000177,'NMLCH000048',NULL),(1000177,'NMLCH000049',NULL),(1000177,'NMLCH000050',NULL),(1000177,'NMLCH000051',NULL),(1000177,'NMLCH000052',NULL),(1000177,'NMLCH000053',NULL),(1000177,'NMLCH000055',NULL),(1000177,'NMLCH000056',NULL),(1000177,'NMLCH000057',NULL),(1000177,'NMLCH000058',NULL),(1000177,'NMLCH000059',NULL),(1000177,'NMLCH000099',NULL),(1000177,'NMLCH000100',NULL),(1000177,'NMLCL000054',NULL),(1000177,'NMLCL000060',NULL),(1000177,'NMLCL000061',NULL),(1000177,'NMLCL000077',NULL),(1000177,'NMLCL000078',NULL),(1000178,'NMLCL000086',NULL),(3000001,'NMLCL000001',NULL),(3000002,'NMLCH000002',NULL),(3000002,'NMLCH000003',NULL),(3000002,'NMLCH000004',NULL),(3000002,'NMLCH000009',NULL),(3000002,'NMLCH000011',NULL),(3000002,'NMLCH000020',NULL),(3000002,'NMLCH000022',NULL),(3000002,'NMLCH000028',NULL),(3000002,'NMLCH000029',NULL),(3000002,'NMLCH000030',NULL),(3000002,'NMLCH000031',NULL),(3000002,'NMLCH000033',NULL),(3000003,'NMLCH000005',NULL),(3000003,'NMLCH000006',NULL),(3000003,'NMLCH000008',NULL),(3000003,'NMLCH000023',NULL),(3000003,'NMLCH000025',NULL),(3000003,'NMLCH000026',NULL),(3000004,'NMLCH000001',NULL),(3000004,'NMLCH000012',NULL),(3000004,'NMLCH000019',NULL),(3000005,'NMLNT000001',NULL),(3000006,'NMLCL000002',NULL),(3000007,'NMLCL000003',NULL),(3000008,'NMLCL000004',NULL),(3000009,'NMLCH000010',NULL),(3000009,'NMLCH000021',NULL),(3000009,'NMLCH000032',NULL),(3000009,'NMLCH000034',NULL),(3000010,'NMLCH000013',NULL),(3000010,'NMLCH000014',NULL),(3000010,'NMLCH000017',NULL),(3000010,'NMLCH000018',NULL),(3000010,'NMLCH000035',NULL),(3000010,'NMLCH000036',NULL),(3000010,'NMLCH000037',NULL),(3000011,'NMLCL000005',NULL),(3000041,'NMLNT000070',NULL),(3000044,'NMLCL000073',NULL),(3000045,'NMLCL000077',NULL),(3000046,'NMLCL000078',NULL),(4000001,'NMLCH000013',NULL),(4000001,'NMLCH000018',NULL),(4000001,'NMLCH000036',NULL),(4000002,'NMLCH000007',NULL),(4000002,'NMLCH000015',NULL),(4000002,'NMLCH000016',NULL),(4000002,'NMLCH000024',NULL),(4000002,'NMLCH000027',NULL),(4000003,'NMLNT000001',NULL),(4000004,'NMLNT000001',NULL),(4000005,'NMLCL000001',NULL),(4000006,'NMLCL000001',NULL),(4000007,'NMLCL000001',NULL),(4000008,'NMLCL000005',NULL),(4000020,'NMLCH000048',NULL),(4000021,'NMLCH000049',NULL),(4000022,'NMLCH000050',NULL),(4000023,'NMLCH000051',NULL),(4000024,'NMLCH000052',NULL),(4000025,'NMLCH000053',NULL),(4000026,'NMLCL000054',NULL),(4000027,'NMLCH000055',NULL),(4000028,'NMLCH000056',NULL),(4000029,'NMLCH000057',NULL),(4000030,'NMLCH000058',NULL),(4000031,'NMLCH000059',NULL),(4000032,'NMLCL000060',NULL),(4000033,'NMLCL000061',NULL),(4000037,'NMLCH000066',NULL),(4000038,'NMLCH000067',NULL),(4000039,'NMLCH000068',NULL),(4000040,'NMLCH000069',NULL),(4000044,'NMLCL000073',NULL),(4000045,'NMLCL000077',NULL),(4000046,'NMLCL000078',NULL),(4000203,'NMLSY000084',NULL),(4000229,'NMLNT000070',NULL),(5000001,'NMLCL000001',NULL),(5000002,'NMLCL000001',NULL),(5000003,'NMLNT000001',NULL),(5000004,'NMLNT000001',NULL),(5000005,'NMLCH000026','Inherited references metadata from parent NMLCL000005'),(5000005,'NMLCH000027','Inherited references metadata from parent NMLCL000005'),(5000005,'NMLCH000028','Inherited references metadata from parent NMLCL000005'),(5000005,'NMLCH000029','Inherited references metadata from parent NMLCL000005'),(5000005,'NMLCH000030','Inherited references metadata from parent NMLCL000005'),(5000005,'NMLCH000031','Inherited references metadata from parent NMLCL000005'),(5000005,'NMLCH000032','Inherited references metadata from parent NMLCL000005'),(5000005,'NMLCH000033','Inherited references metadata from parent NMLCL000005'),(5000005,'NMLCH000034','Inherited references metadata from parent NMLCL000005'),(5000005,'NMLCH000035','Inherited references metadata from parent NMLCL000005'),(5000005,'NMLCH000036','Inherited references metadata from parent NMLCL000005'),(5000005,'NMLCH000037','Inherited references metadata from parent NMLCL000005'),(5000005,'NMLCL000005',NULL),(5000006,'NMLCH000026','Inherited references metadata from parent NMLCL000005'),(5000006,'NMLCH000027','Inherited references metadata from parent NMLCL000005'),(5000006,'NMLCH000028','Inherited references metadata from parent NMLCL000005'),(5000006,'NMLCH000029','Inherited references metadata from parent NMLCL000005'),(5000006,'NMLCH000030','Inherited references metadata from parent NMLCL000005'),(5000006,'NMLCH000031','Inherited references metadata from parent NMLCL000005'),(5000006,'NMLCH000032','Inherited references metadata from parent NMLCL000005'),(5000006,'NMLCH000033','Inherited references metadata from parent NMLCL000005'),(5000006,'NMLCH000034','Inherited references metadata from parent NMLCL000005'),(5000006,'NMLCH000035','Inherited references metadata from parent NMLCL000005'),(5000006,'NMLCH000036','Inherited references metadata from parent NMLCL000005'),(5000006,'NMLCH000037','Inherited references metadata from parent NMLCL000005'),(5000006,'NMLCL000005',NULL),(5000020,'NMLCH000048',NULL),(5000021,'NMLCH000049',NULL),(5000021,'NMLCH000099',NULL),(5000021,'NMLCH000100',NULL),(5000022,'NMLCH000050',NULL),(5000023,'NMLCH000051',NULL),(5000024,'NMLCH000052',NULL),(5000025,'NMLCH000053',NULL),(5000026,'NMLCL000054',NULL),(5000027,'NMLCH000055',NULL),(5000030,'NMLCH000058',NULL),(5000032,'NMLCL000060',NULL),(5000033,'NMLCL000061',NULL),(5000037,'NMLCH000066',NULL),(5000038,'NMLCH000067',NULL),(5000041,'NMLNT000070',NULL),(5000044,'NMLCL000073',NULL),(5000045,'NMLCL000077',NULL),(5000046,'NMLCL000078',NULL),(5000049,'NMLCL000002',NULL),(5000050,'NMLCL000002',NULL),(5000053,'NMLCL000003',NULL),(5000054,'NMLCL000003',NULL),(5000057,'NMLCL000004',NULL),(5000058,'NMLCL000004',NULL),(5000066,'NMLCH000001',NULL),(5000067,'NMLCH000001',NULL),(5000070,'NMLCH000002',NULL),(5000071,'NMLCH000002',NULL),(5000074,'NMLCH000003',NULL),(5000075,'NMLCH000003',NULL),(5000078,'NMLCH000004',NULL),(5000079,'NMLCH000004',NULL),(5000082,'NMLCH000005',NULL),(5000083,'NMLCH000005',NULL),(5000086,'NMLCH000006',NULL),(5000087,'NMLCH000006',NULL),(5000090,'NMLCH000007',NULL),(5000091,'NMLCH000007',NULL),(5000093,'NMLCH000008',NULL),(5000094,'NMLCH000008',NULL),(5000095,'NMLCH000009',NULL),(5000096,'NMLCH000009',NULL),(5000097,'NMLCH000010',NULL),(5000098,'NMLCH000010',NULL),(5000101,'NMLCH000011',NULL),(5000102,'NMLCH000011',NULL),(5000105,'NMLCH000012',NULL),(5000106,'NMLCH000012',NULL),(5000109,'NMLCH000013',NULL),(5000110,'NMLCH000013',NULL),(5000113,'NMLCH000014',NULL),(5000114,'NMLCH000014',NULL),(5000117,'NMLCH000015',NULL),(5000118,'NMLCH000015',NULL),(5000121,'NMLCH000017',NULL),(5000122,'NMLCH000017',NULL),(5000125,'NMLCH000018',NULL),(5000126,'NMLCH000018',NULL),(5000129,'NMLCH000019',NULL),(5000130,'NMLCH000019',NULL),(5000133,'NMLCH000020',NULL),(5000134,'NMLCH000020',NULL),(5000137,'NMLCH000021',NULL),(5000138,'NMLCH000021',NULL),(5000141,'NMLCH000022',NULL),(5000142,'NMLCH000022',NULL),(5000145,'NMLCH000023',NULL),(5000146,'NMLCH000023',NULL),(5000149,'NMLCH000024',NULL),(5000150,'NMLCH000024',NULL),(5000153,'NMLCH000016',NULL),(5000154,'NMLCH000016',NULL),(5000158,'NMLSY000080',NULL),(5000159,'NMLSY000080',NULL),(5000162,'NMLSY000081',NULL),(5000163,'NMLSY000081',NULL),(5000166,'NMLSY000082',NULL),(5000167,'NMLSY000082',NULL),(5000170,'NMLSY000083',NULL),(5000171,'NMLSY000083',NULL),(5000172,'NMLNT000070',NULL),(5000174,'NMLCH000048',NULL),(5000174,'NMLCH000049',NULL),(5000174,'NMLCH000050',NULL),(5000174,'NMLCH000051',NULL),(5000174,'NMLCH000052',NULL),(5000174,'NMLCH000053',NULL),(5000174,'NMLCH000055',NULL),(5000174,'NMLCH000056',NULL),(5000174,'NMLCH000057',NULL),(5000174,'NMLCH000058',NULL),(5000174,'NMLCH000059',NULL),(5000174,'NMLCH000099',NULL),(5000174,'NMLCH000100',NULL),(5000174,'NMLCL000054',NULL),(5000174,'NMLCL000060',NULL),(5000174,'NMLCL000061',NULL),(5000174,'NMLCL000077',NULL),(5000174,'NMLCL000078',NULL),(5000176,'NMLCL000085',NULL),(5000177,'NMLCH000086',NULL),(5000178,'NMLCH000087',NULL),(5000179,'NMLCH000088',NULL),(5000180,'NMLCH000089',NULL),(5000181,'NMLCH000090',NULL),(5000182,'NMLCH000091',NULL),(5000183,'NMLCH000092',NULL),(5000184,'NMLCH000093',NULL),(5000185,'NMLCH000094',NULL),(5000186,'NMLCH000095',NULL),(5000187,'NMLCH000096',NULL),(5000188,'NMLCH000097',NULL),(5000189,'NMLCH000098',NULL),(5000190,'NMLCH000066',NULL),(5000190,'NMLCH000067',NULL),(5000192,'NMLCH000068',NULL),(5000194,'NMLCH000068',NULL),(5000196,'NMLCH000069',NULL),(5000197,'NMLCH000069',NULL),(5000199,'NMLCL000085',NULL),(5000201,'NMLSY000084',NULL),(5000202,'NMLSY000084',NULL),(5000204,'NMLCH000086',NULL),(5000205,'NMLCH000087',NULL),(5000206,'NMLCH000088',NULL),(5000207,'NMLCH000089',NULL),(5000208,'NMLCH000090',NULL),(5000209,'NMLCH000091',NULL),(5000210,'NMLCH000092',NULL),(5000211,'NMLCH000093',NULL),(5000212,'NMLCH000094',NULL),(5000213,'NMLCH000095',NULL),(5000214,'NMLCH000096',NULL),(5000215,'NMLCH000097',NULL),(5000216,'NMLCH000098',NULL),(5000218,'NMLCH000025',NULL),(5000219,'NMLCH000025',NULL),(5000224,'NMLSY000099',NULL),(5000225,'NMLSY000099',NULL),(5000227,'NMLSY000100',NULL),(5000228,'NMLSY000100',NULL),(5000229,'NMLCL000073',NULL),(5000230,'NMLCL000086',NULL),(5000231,'NMLCL000086',NULL),(6000001,'NMLCL000001',NULL),(6000002,'NMLNT000001',NULL),(6000003,'NMLCH000026','Inherited publications metadata from parent NMLCL000005'),(6000003,'NMLCH000027','Inherited publications metadata from parent NMLCL000005'),(6000003,'NMLCH000028','Inherited publications metadata from parent NMLCL000005'),(6000003,'NMLCH000029','Inherited publications metadata from parent NMLCL000005'),(6000003,'NMLCH000030','Inherited publications metadata from parent NMLCL000005'),(6000003,'NMLCH000031','Inherited publications metadata from parent NMLCL000005'),(6000003,'NMLCH000032','Inherited publications metadata from parent NMLCL000005'),(6000003,'NMLCH000033','Inherited publications metadata from parent NMLCL000005'),(6000003,'NMLCH000034','Inherited publications metadata from parent NMLCL000005'),(6000003,'NMLCH000035','Inherited publications metadata from parent NMLCL000005'),(6000003,'NMLCH000036','Inherited publications metadata from parent NMLCL000005'),(6000003,'NMLCH000037','Inherited publications metadata from parent NMLCL000005'),(6000003,'NMLCL000005',NULL),(6000020,'NMLCH000052',NULL),(6000026,'NMLCL000054',NULL),(6000032,'NMLCL000060',NULL),(6000037,'NMLCH000066',NULL),(6000038,'NMLCH000067',NULL),(6000041,'NMLNT000070',NULL),(6000044,'NMLCL000073',NULL),(6000045,'NMLCL000077',NULL),(6000046,'NMLCH000048',NULL),(6000046,'NMLCH000049',NULL),(6000046,'NMLCH000050',NULL),(6000046,'NMLCH000051',NULL),(6000046,'NMLCH000053',NULL),(6000046,'NMLCH000055',NULL),(6000046,'NMLCH000056',NULL),(6000046,'NMLCH000057',NULL),(6000046,'NMLCH000058',NULL),(6000046,'NMLCH000059',NULL),(6000046,'NMLCH000099',NULL),(6000046,'NMLCH000100',NULL),(6000046,'NMLCL000061',NULL),(6000046,'NMLCL000078',NULL),(6000048,'NMLCL000002',NULL),(6000052,'NMLCL000003',NULL),(6000056,'NMLCL000004',NULL),(6000060,'NMLCH000008',NULL),(6000062,'NMLCH000009',NULL),(6000064,'NMLCH000010',NULL),(6000065,'NMLCH000001',NULL),(6000069,'NMLCH000002',NULL),(6000073,'NMLCH000003',NULL),(6000077,'NMLCH000004',NULL),(6000081,'NMLCH000005',NULL),(6000085,'NMLCH000006',NULL),(6000089,'NMLCH000007',NULL),(6000100,'NMLCH000011',NULL),(6000104,'NMLCH000012',NULL),(6000108,'NMLCH000013',NULL),(6000112,'NMLCH000014',NULL),(6000116,'NMLCH000015',NULL),(6000120,'NMLCH000017',NULL),(6000124,'NMLCH000018',NULL),(6000128,'NMLCH000019',NULL),(6000132,'NMLCH000020',NULL),(6000136,'NMLCH000021',NULL),(6000140,'NMLCH000022',NULL),(6000144,'NMLCH000023',NULL),(6000148,'NMLCH000024',NULL),(6000152,'NMLCH000016',NULL),(6000157,'NMLSY000080',NULL),(6000161,'NMLSY000081',NULL),(6000165,'NMLSY000082',NULL),(6000169,'NMLSY000083',NULL),(6000176,'NMLCL000085',NULL),(6000177,'NMLCH000086',NULL),(6000178,'NMLCH000087',NULL),(6000179,'NMLCH000088',NULL),(6000180,'NMLCH000089',NULL),(6000181,'NMLCH000090',NULL),(6000182,'NMLCH000091',NULL),(6000183,'NMLCH000092',NULL),(6000184,'NMLCH000093',NULL),(6000185,'NMLCH000094',NULL),(6000186,'NMLCH000095',NULL),(6000187,'NMLCH000096',NULL),(6000188,'NMLCH000097',NULL),(6000189,'NMLCH000098',NULL),(6000193,'NMLCH000068',NULL),(6000195,'NMLCH000069',NULL),(6000200,'NMLSY000084',NULL),(6000217,'NMLCH000025',NULL),(6000223,'NMLSY000099',NULL),(6000226,'NMLSY000100',NULL),(6000227,'NMLCL000086',NULL);
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
INSERT INTO `models` VALUES ('NMLCH000001'),('NMLCH000002'),('NMLCH000003'),('NMLCH000004'),('NMLCH000005'),('NMLCH000006'),('NMLCH000007'),('NMLCH000008'),('NMLCH000009'),('NMLCH000010'),('NMLCH000011'),('NMLCH000012'),('NMLCH000013'),('NMLCH000014'),('NMLCH000015'),('NMLCH000016'),('NMLCH000017'),('NMLCH000018'),('NMLCH000019'),('NMLCH000020'),('NMLCH000021'),('NMLCH000022'),('NMLCH000023'),('NMLCH000024'),('NMLCH000025'),('NMLCH000026'),('NMLCH000027'),('NMLCH000028'),('NMLCH000029'),('NMLCH000030'),('NMLCH000031'),('NMLCH000032'),('NMLCH000033'),('NMLCH000034'),('NMLCH000035'),('NMLCH000036'),('NMLCH000037'),('NMLCH000048'),('NMLCH000049'),('NMLCH000050'),('NMLCH000051'),('NMLCH000052'),('NMLCH000053'),('NMLCH000055'),('NMLCH000056'),('NMLCH000057'),('NMLCH000058'),('NMLCH000059'),('NMLCH000066'),('NMLCH000067'),('NMLCH000068'),('NMLCH000069'),('NMLCH000086'),('NMLCH000087'),('NMLCH000088'),('NMLCH000089'),('NMLCH000090'),('NMLCH000091'),('NMLCH000092'),('NMLCH000093'),('NMLCH000094'),('NMLCH000095'),('NMLCH000096'),('NMLCH000097'),('NMLCH000098'),('NMLCH000099'),('NMLCH000100'),('NMLCL000001'),('NMLCL000002'),('NMLCL000003'),('NMLCL000004'),('NMLCL000005'),('NMLCL000054'),('NMLCL000060'),('NMLCL000061'),('NMLCL000073'),('NMLCL000077'),('NMLCL000078'),('NMLCL000085'),('NMLCL000086'),('NMLNT000001'),('NMLNT000070'),('NMLSY000079'),('NMLSY000080'),('NMLSY000081'),('NMLSY000082'),('NMLSY000083'),('NMLSY000084'),('NMLSY000099'),('NMLSY000100');
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `modeluploads`
--

LOCK TABLES `modeluploads` WRITE;
/*!40000 ALTER TABLE `modeluploads` DISABLE KEYS */;
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
-- Temporary table structure for view `nif_helper_authors`
--

DROP TABLE IF EXISTS `nif_helper_authors`;
/*!50001 DROP VIEW IF EXISTS `nif_helper_authors`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `nif_helper_authors` (
  `Model_ID` tinyint NOT NULL,
  `Authors` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `nif_helper_cells`
--

DROP TABLE IF EXISTS `nif_helper_cells`;
/*!50001 DROP VIEW IF EXISTS `nif_helper_cells`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `nif_helper_cells` (
  `Model_ID` tinyint NOT NULL,
  `Model_Name` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `nif_helper_channels`
--

DROP TABLE IF EXISTS `nif_helper_channels`;
/*!50001 DROP VIEW IF EXISTS `nif_helper_channels`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `nif_helper_channels` (
  `Model_ID` tinyint NOT NULL,
  `Model_Name` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `nif_helper_keywords`
--

DROP TABLE IF EXISTS `nif_helper_keywords`;
/*!50001 DROP VIEW IF EXISTS `nif_helper_keywords`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `nif_helper_keywords` (
  `Model_ID` tinyint NOT NULL,
  `keywords` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `nif_helper_networks`
--

DROP TABLE IF EXISTS `nif_helper_networks`;
/*!50001 DROP VIEW IF EXISTS `nif_helper_networks`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `nif_helper_networks` (
  `Model_ID` tinyint NOT NULL,
  `Model_Name` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `nif_helper_neurolexes`
--

DROP TABLE IF EXISTS `nif_helper_neurolexes`;
/*!50001 DROP VIEW IF EXISTS `nif_helper_neurolexes`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `nif_helper_neurolexes` (
  `Model_ID` tinyint NOT NULL,
  `NeuroLex_URI` tinyint NOT NULL,
  `NeuroLex_Term` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `nif_helper_publications`
--

DROP TABLE IF EXISTS `nif_helper_publications`;
/*!50001 DROP VIEW IF EXISTS `nif_helper_publications`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `nif_helper_publications` (
  `Model_ID` tinyint NOT NULL,
  `Pubmed_Ref` tinyint NOT NULL,
  `Full_Title` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `nif_helper_synapses`
--

DROP TABLE IF EXISTS `nif_helper_synapses`;
/*!50001 DROP VIEW IF EXISTS `nif_helper_synapses`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `nif_helper_synapses` (
  `Model_ID` tinyint NOT NULL,
  `Model_Name` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `nif_model_ID_Name_Type`
--

DROP TABLE IF EXISTS `nif_model_ID_Name_Type`;
/*!50001 DROP VIEW IF EXISTS `nif_model_ID_Name_Type`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `nif_model_ID_Name_Type` (
  `Model_ID` tinyint NOT NULL,
  `Model_Name` tinyint NOT NULL,
  `Model_Type` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `nif_model_associations`
--

DROP TABLE IF EXISTS `nif_model_associations`;
/*!50001 DROP VIEW IF EXISTS `nif_model_associations`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `nif_model_associations` (
  `Model_ID` tinyint NOT NULL,
  `Associated_Models` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `nif_model_authors`
--

DROP TABLE IF EXISTS `nif_model_authors`;
/*!50001 DROP VIEW IF EXISTS `nif_model_authors`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `nif_model_authors` (
  `Model_ID` tinyint NOT NULL,
  `Authors` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `nif_model_info`
--

DROP TABLE IF EXISTS `nif_model_info`;
/*!50001 DROP VIEW IF EXISTS `nif_model_info`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `nif_model_info` (
  `Model_ID` tinyint NOT NULL,
  `Model_Name` tinyint NOT NULL,
  `Model_Type` tinyint NOT NULL,
  `Authors` tinyint NOT NULL,
  `Pubmed_Ref` tinyint NOT NULL,
  `Pubmed_Title` tinyint NOT NULL,
  `NeuroLex_URI` tinyint NOT NULL,
  `NeuroLex_Term` tinyint NOT NULL,
  `Keywords` tinyint NOT NULL,
  `Associated_Models` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `nif_model_keywords`
--

DROP TABLE IF EXISTS `nif_model_keywords`;
/*!50001 DROP VIEW IF EXISTS `nif_model_keywords`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `nif_model_keywords` (
  `Model_ID` tinyint NOT NULL,
  `Keywords` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `nif_model_neurolexes`
--

DROP TABLE IF EXISTS `nif_model_neurolexes`;
/*!50001 DROP VIEW IF EXISTS `nif_model_neurolexes`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `nif_model_neurolexes` (
  `Model_ID` tinyint NOT NULL,
  `NeuroLex_URI` tinyint NOT NULL,
  `NeuroLex_Term` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `nif_model_publications`
--

DROP TABLE IF EXISTS `nif_model_publications`;
/*!50001 DROP VIEW IF EXISTS `nif_model_publications`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `nif_model_publications` (
  `Model_ID` tinyint NOT NULL,
  `Pubmed_Ref` tinyint NOT NULL,
  `Pubmed_Title` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

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
INSERT INTO `other_keywords` VALUES (4000001,'Calcium Pool',NULL),(4000002,'Leak Passive',NULL),(4000003,'Cerebellum, Synchronization, Nerve Fibers, Nerve Net, Neural Inhibition, Rat ','publication keywords'),(4000004,'GABAA, AMPA, NMDA','Receptors'),(4000005,'Age Factors, Dendrites, Hippocampus, Imaging, Three-Dimensional, Pyramidal Cell, Rat CA1, Oblique Branches, Back-propagation','publish keywords'),(4000006,'AMPA','Receptor'),(4000007,'Glutamate','Transmitter '),(4000008,'Rat, Active Dendrites, Purkinje  Cell,  Fast Somatic Spikes, Dendritic Calcium Spikes, Plateau Potentials','publication keywords'),(4000020,'Anomalous Rectifier conductance,  h-conductance (hyperpolarizing).fast rhythmic bursting,cortical neuron',NULL),(4000021,'Potasium M type current,muscarinic receptor suppressed,Single-column thalamocortical network,gamma oscillations, sleep spindles,epileptogenic bursts',NULL),(4000022,'Persistent non inactivating Sodium channel, Na ,',NULL),(4000023,'expontially decaying pool  calcium,  ceiling concentration',NULL),(4000024,'[Ca2+] dependent K AHP afterhyperpolarization conductance,calcium dependence table',NULL),(4000025,'High threshold, long lasting Calcium L-type current',NULL),(4000026,'thalamocortical neuronal, persistent gamma oscillations,thalamocortical sleep spindles,series of synchronized population bursts',NULL),(4000027,'Potasium delayed rectifier type conductance, fast-spiking ',NULL),(4000028,'Slow Ca2+ dependent K AHP afterhyperpolarization conductance',NULL),(4000029,'Fast voltage, Ca2+ dependent K conductance, BK channel',NULL),(4000030,'Fast Sodium transient inactivating current',NULL),(4000031,'Potasium K2-type current slowly activating inactivating',NULL),(4000032,'isolated double population bursts, superimposed very fast oscillations, persistent gamma oscillations, thalamocortical sleep spindles ',NULL),(4000033,'isolated double population bursts, superimposed very fast oscillations, persistent gamma oscillations, thalamocortical sleep spindles, epileptiform bursts, kainate',NULL),(4000037,'High voltage Activated Ca2+ channel,',NULL),(4000038,'Low voltage Activated Ca2+ channel,Ca++ current responsible  low threshold spikes',NULL),(4000039,'Calcium first order kinetics',NULL),(4000040,'Calcium first order kinetics',NULL),(4000044,'mammalian Neocortical,neocortex pyramidal , layer 5b,perisomatic Na+ dendritic Ca2+ ','The thick-tufted layer 5b pyramidal cell extends its dendritic tree to all six layers of the mammalian neocortex and serves as a major building block for the cortical column. L5b pyramidal cells have been the subject of extensive experimental and modeling studies, yet conductance-based models of these cells that faithfully reproduce both their perisomatic Na(+)-spiking behavior as well as key dendritic active properties, including Ca(2+) spikes and back-propagating action potentials, are still lacking. Based on a large body of experimental recordings from both the soma and dendrites of L5b pyramidal cells in adult rats, we characterized key features of the somatic and dendritic firing and quantified their statistics. We used these features to constrain the density of a set of ion channels over the soma and dendritic surface via multi-objective optimization with an evolutionary algorithm, thus generating a set of detailed conductance-based models that faithfully replicate the back-propagating action potential activated Ca(2+) spike firing and the perisomatic firing response to current steps, as well as the experimental variability of the properties. Furthermore, we show a useful way to analyze model parameters with our sets of models, which enabled us to identify some of the mechanisms responsible for the dynamic properties of L5b pyramidal cells as well as mechanisms that are sensitive to morphological changes. This automated framework can be used to develop a database of faithful models for other neuron types. The models we present provide several experimentally-testable predictions and can serve as a powerful tool for theoretical investigations of the contribution of single-cell dynamics to network activity and its computational capabilities'),(4000045,'nucleus reticularis','To better understand population phenomena in thalamocortical neuronal ensembles, we have constructed a preliminary network model with 3,560 multicompartment neurons (containing soma, branching dendrites, and a portion of axon). Types of neurons included superficial pyramids (with regular spiking [RS] and fast rhythmic bursting [FRB] firing behaviors); RS spiny stellates; fast spiking (FS) interneurons, with basket-type and axoaxonic types of connectivity, and located in superficial and deep cortical layers; low threshold spiking (LTS) interneurons, which contacted principal cell dendrites; deep pyramids, which could have RS or intrinsic bursting (IB) firing behaviors, and endowed either with nontufted apical dendrites or with long tufted apical dendrites; thalamocortical relay (TCR) cells; and nucleus reticularis (nRT) cells. To the extent possible, both electrophysiology and synaptic connectivity were based on published data, although many arbitrary choices were necessary. In addition to synaptic connectivity (by AMPA/kainate, NMDA, and GABA(A) receptors), we also included electrical coupling between dendrites of interneurons, nRT cells, and TCR cells, and--in various combinations--electrical coupling between the proximal axons of certain cortical principal neurons. Our network model replicates several observed population phenomena, including 1) persistent gamma oscillations; 2) thalamocortical sleep spindles; 3) series of synchronized population bursts, resembling electrographic seizures; 4) isolated double population bursts with superimposed very fast oscillations (>100 Hz, \"VFO\"); 5) spike-wave, polyspike-wave, and fast runs (about 10 Hz). We show that epileptiform bursts, including double and multiple bursts, containing VFO occur in rat auditory cortex in vitro, in the presence of kainate, when both GABA(A) and GABA(B) receptors are blocked. Electrical coupling between axons appears necessary (as reported previously) for persistent gamma and additionally plays a role in the detailed shaping of epileptogenic events. The degree of recurrent synaptic excitation between spiny stellate cells, and their tendency to fire throughout multiple bursts, also appears critical in shaping epileptogenic events.'),(4000046,' fast rhythmic bursting [FRB] firing behaviors',''),(4000203,'gap junction',''),(4000229,'cerebellum Golgi cell gap junctions','');
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
INSERT INTO `out_query_results` VALUES ('NMLCH000008'),('NMLCH000009'),('NMLCH000010'),('NMLCH000011'),('NMLCH000012'),('NMLCH000013'),('NMLCH000014'),('NMLCH000015'),('NMLCH000017'),('NMLCH000018'),('NMLCH000019'),('NMLCH000020'),('NMLCH000021'),('NMLCH000022'),('NMLCH000023'),('NMLCH000024'),('NMLCH000025'),('NMLCH000026'),('NMLCH000027'),('NMLCH000028'),('NMLCH000029'),('NMLCH000030'),('NMLCH000031'),('NMLCH000032'),('NMLCH000033'),('NMLCH000034'),('NMLCH000035'),('NMLCH000036'),('NMLCH000037'),('NMLCL000002'),('NMLCL000003'),('NMLCL000004'),('NMLCL000005'),('NMLCL000085'),('NMLNT000001'),('NMLNT000070'),('NMLSY000080'),('NMLSY000081'),('NMLSY000082'),('NMLSY000083'),('NMLSY000084'),('NMLSY000099'),('NMLSY000100');
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
INSERT INTO `people` VALUES (2000001,'Michele','','Migliore','Yale University','michele.migliore@yale.edu ',''),(2000002,'Michele','','Ferrante','George Mason University','mferran1@gmu.edu',''),(2000003,'Giorgio',' A. ','Ascoli','George Mason University','ascoli@gmu.edu',NULL),(2000004,'Padraig ',NULL,'Gleeson','UCL','p.gleeson@ucl.ac.uk',NULL),(2000005,'Reinoud',NULL,'Maex','University of Antwerp','reinoud@tnb.ua.ac.be',NULL),(2000006,'Erik',NULL,'De Schutter','University of Antwerp','Erik@tnb.ua.ac.be',NULL),(2000007,'James','M','Bower','UTSA','bower@uthscsa.edu',NULL),(2000009,'K','','Vervaeke','','',''),(2000010,'Matteo','','Farinella','UCL','m.farinella@ucl.ac.uk',NULL),(2000014,'Eugenio','','Piasini','','e.piasini@ucl.ac.uk',NULL),(2000015,'Miklos','','Szoboszlay','','szoboszlay.miklos@tdk.koki.mta.hu',NULL),(2000018,'Andrew','','Davison','','andrew.davison@unic.cnrs-gif.fr',NULL),(2000019,'Vitor','','Chaud','','chaudvm@gmail.com',NULL),(2000020,'Idan','','Segev','','idan@lobster.ls.huji.ac.il',NULL),(2000021,'Chaitanya','','Chintaluri','','',NULL),(2000025,'Daniel','','Wojcik','','',NULL),(2000026,'Helena','','Glabska','','',NULL),(2000027,'RD','','Traub','','',NULL),(2000036,'A','','Lorincz','','',NULL),(2000038,'Z','','Nusser','','',NULL),(2000039,'RA','','Silver','','',NULL),(2000041,'Arnd',NULL,'Roth',NULL,NULL,NULL),(2000042,'David',NULL,'Beeman',NULL,NULL,NULL),(2000043,'Guy',NULL,'Eyal',NULL,NULL,NULL),(2000044,'E',NULL,'Hay',NULL,NULL,NULL),(2000045,'S',NULL,'Hill',NULL,NULL,NULL),(2000046,'F',NULL,'Schürmann',NULL,NULL,NULL),(2000047,'H',NULL,'Markram',NULL,NULL,NULL),(2000048,'D',NULL,'Contreras',NULL,NULL,NULL),(2000049,'MO',NULL,'Cunningham',NULL,NULL,NULL),(2000050,'H',NULL,'Murray',NULL,NULL,NULL),(2000051,'FE',NULL,'LeBeau',NULL,NULL,NULL),(2000052,'A',NULL,'Roopun',NULL,NULL,NULL),(2000053,'A',NULL,'Bibbig',NULL,NULL,NULL),(2000054,'WB',NULL,'Wilent',NULL,NULL,NULL),(2000055,'MJ',NULL,'Higley',NULL,NULL,NULL),(2000056,'MA',NULL,'Whittington',NULL,NULL,NULL),(2000057,'Jacek',NULL,'Rogala',NULL,NULL,NULL),(2000058,'Michael',NULL,'Hines',NULL,NULL,NULL),(2000059,'Subhasis',NULL,'Ray',NULL,NULL,NULL),(2000060,'Tomás','Fernández','Alfonso',NULL,NULL,NULL),(2000061,'Yates',NULL,'Buckley',NULL,NULL,NULL),(2000062,'EM',NULL,'Izhikevich',NULL,NULL,NULL);
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
INSERT INTO `publications` VALUES (6000001,'pubmed/16293591','Signal propagation in oblique dendrites of CA1 pyramidal cells',''),(6000002,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000003,'pubmed/7512629','An active membrane model of the cerebellar Purkinje cell. I. Simulation of current clamps in slice',NULL),(6000020,'pubmed/12574468','Fast rhythmic bursting can be induced in layer 2/3 cortical neurons by enhancing persistent Na+ conductance or by blocking BK channels',NULL),(6000021,'pubmed/15525801','Single-column thalamocortical network model exhibiting gamma oscillations, sleep spindles, and epileptogenic bursts.',NULL),(6000022,'pubmed/15525801','Single-column thalamocortical network model exhibiting gamma oscillations, sleep spindles, and epileptogenic bursts.',NULL),(6000023,'pubmed/15525801','Single-column thalamocortical network model exhibiting gamma oscillations, sleep spindles, and epileptogenic bursts.',NULL),(6000026,'pubmed/15525801','Single-column thalamocortical network model exhibiting gamma oscillations, sleep spindles, and epileptogenic bursts. J. Neurophysiol. 93, 2194-2232, 2005',NULL),(6000032,'pubmed/15525801','A single-column thalamocortical network model exhibiting gamma oscillations, sleep spindles and epileptogenic bursts',''),(6000033,'pubmed/12574468','Fast Rhythmic Bursting Can Be Induced in Layer 2/3 Cortical Neurons by Enhancing Persistent Na+ Conductance or by Blocking BK Channels J Neurophysiol 89: 909-921, 2003',NULL),(6000037,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network ',''),(6000038,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network',''),(6000041,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network (Vervaeke et al. 2010)',NULL),(6000044,'pubmed/21829333','Models of Neocortical Layer 5b Pyramidal Cells Capturing a Wide Range of Dendritic and Perisomatic Active Properties, Etay Hay, Sean Hill, Felix Schürmann, Henry Markram and Idan Segev',NULL),(6000045,'pubmed/15525801','Single-column thalamocortical network model exhibiting gamma oscillations, sleep spindles, and epileptogenic bursts.',NULL),(6000046,'pubmed/15525801','Single-column thalamocortical network model exhibiting gamma oscillations, sleep spindles, and epileptogenic bursts.',NULL),(6000048,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000052,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000056,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000060,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000062,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000064,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000065,'pubmed/16293591','Signal propagation in oblique dendrites of CA1 pyramidal cells',''),(6000069,'pubmed/16293591','Signal propagation in oblique dendrites of CA1 pyramidal cells',''),(6000073,'pubmed/16293591','Signal propagation in oblique dendrites of CA1 pyramidal cells',''),(6000077,'pubmed/16293591','Signal propagation in oblique dendrites of CA1 pyramidal cells',''),(6000081,'pubmed/16293591','Signal propagation in oblique dendrites of CA1 pyramidal cells',''),(6000085,'pubmed/16293591','Signal propagation in oblique dendrites of CA1 pyramidal cells',''),(6000089,'pubmed/16293591','Signal propagation in oblique dendrites of CA1 pyramidal cells',''),(6000100,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed Network model of the cerebellar granule cell layer',''),(6000104,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000108,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000112,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000116,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000120,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000124,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000128,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000132,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000136,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000140,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000144,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000148,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000152,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000157,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000161,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000165,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000169,'pubmed/9819260','Synchronization of Golgi and granule cell firing in a detailed network model of the cerebellar granule cell layer',''),(6000176,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network ',NULL),(6000177,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network',NULL),(6000178,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network',NULL),(6000179,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network',NULL),(6000180,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network',NULL),(6000181,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network',NULL),(6000182,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network',NULL),(6000183,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network',NULL),(6000184,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network',NULL),(6000185,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network',NULL),(6000186,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network',NULL),(6000187,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network',NULL),(6000188,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network',NULL),(6000189,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network',NULL),(6000193,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network',''),(6000195,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network',''),(6000200,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network',''),(6000217,'pubmed/7512629','An active membrane model of the cerebellar Purkinje cell. I. Simulation of current clamps in slice',''),(6000223,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network',''),(6000226,'pubmed/20696381','Rapid desynchronization of an electrically coupled Golgi cell network',''),(6000227,'pubmed/18244602','Simple model of spiking neurons',NULL);
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
INSERT INTO `query_results` VALUES ('NMLCH000008'),('NMLCH000009'),('NMLCH000010'),('NMLCH000011'),('NMLCH000012'),('NMLCH000013'),('NMLCH000014'),('NMLCH000015'),('NMLCH000017'),('NMLCH000018'),('NMLCH000019'),('NMLCH000020'),('NMLCH000021'),('NMLCH000022'),('NMLCH000023'),('NMLCH000024'),('NMLCH000025'),('NMLCH000026'),('NMLCH000027'),('NMLCH000028'),('NMLCH000029'),('NMLCH000030'),('NMLCH000031'),('NMLCH000032'),('NMLCH000033'),('NMLCH000034'),('NMLCH000035'),('NMLCH000036'),('NMLCH000037'),('NMLCL000002'),('NMLCL000003'),('NMLCL000004'),('NMLCL000005'),('NMLCL000085'),('NMLNT000001'),('NMLNT000070'),('NMLSY000080'),('NMLSY000081'),('NMLSY000082'),('NMLSY000083'),('NMLSY000084'),('NMLSY000099'),('NMLSY000100');
/*!40000 ALTER TABLE `query_results` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `refers`
--

DROP TABLE IF EXISTS `refers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `refers` (
  `Reference_ID` int(11) NOT NULL,
  `Reference_Resource_ID` int(11) DEFAULT '1',
  `Reference_Resource` varchar(100) NOT NULL COMMENT 'ModelDB, NeuroDB, OSB',
  `Reference_URI` varchar(500) NOT NULL,
  `Comments` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`Reference_ID`),
  KEY `FK_Meta_Reference_idx` (`Reference_ID`),
  KEY `FK_refers_resources_idx` (`Reference_Resource_ID`),
  CONSTRAINT `FK_Meta_Reference` FOREIGN KEY (`Reference_ID`) REFERENCES `metadatas` (`Metadata_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `refers`
--

LOCK TABLES `refers` WRITE;
/*!40000 ALTER TABLE `refers` DISABLE KEYS */;
INSERT INTO `refers` VALUES (5000001,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=55035',NULL),(5000002,1,'Open Source Brain','http://www.opensourcebrain.org/projects/ca1pyramidalcell',NULL),(5000003,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',NULL),(5000004,1,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000005,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=7176',NULL),(5000006,1,'Open Source Brain','http://www.opensourcebrain.org/projects/purkinjecell',NULL),(5000020,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=20756',NULL),(5000021,3,'neuronDB','http://senselab.med.yale.edu/NeuronDB/channelGene2.aspx#table3',NULL),(5000022,2,'ModelDB','http://senselab.med.yale.edu/ModelDb/ShowModel.asp?model=45539',NULL),(5000023,2,'ModelDB','http://senselab.med.yale.edu/ModelDb/ShowModel.asp?model=45539',NULL),(5000024,3,'neuronDB','http://senselab.med.yale.edu/NeuronDB/channelGene2.aspx#table3',NULL),(5000025,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=20756',NULL),(5000026,2,'ModelDB','http://senselab.med.yale.edu/ModelDb/ShowModel.asp?model=45539',NULL),(5000027,3,'neuronDB','http://senselab.med.yale.edu/NeuronDB/channelGene2.aspx#table3',NULL),(5000030,3,'neuronDB','http://senselab.med.yale.edu/NeuronDB/channelGene2.aspx#table2',NULL),(5000032,2,'ModelDB','http://senselab.med.yale.edu/ModelDb/ShowModel.asp?model=45539',NULL),(5000033,2,'ModelDB','http://senselab.med.yale.edu/ModelDb/ShowModel.asp?model=45539',NULL),(5000037,2,'ModelDB','http://senselab.med.yale.edu/modeldb/showmodel.asp?model=127996',''),(5000038,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=127996',''),(5000041,2,'ModelDB','http://senselab.med.yale.edu/modeldb/showmodel.asp?model=127996',NULL),(5000044,2,'ModelDB',' http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=139653',NULL),(5000045,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=45539',NULL),(5000046,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=45539',NULL),(5000049,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000050,1,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000053,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000054,1,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000057,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000058,1,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000066,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=55035',''),(5000067,1,'Open Source Brain','http://www.opensourcebrain.org/projects/ca1pyramidalcell',''),(5000070,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=55035',''),(5000071,1,'Open Source Brain','http://www.opensourcebrain.org/projects/ca1pyramidalcell',''),(5000074,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=55035',''),(5000075,1,'Open Source Brain','http://www.opensourcebrain.org/projects/ca1pyramidalcell',''),(5000078,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000079,1,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000082,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=55035',''),(5000083,1,'Open Source Brain','http://www.opensourcebrain.org/projects/ca1pyramidalcell',''),(5000086,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=55035',''),(5000087,1,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000090,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=55035',''),(5000091,1,'Open Source Brain','http://www.opensourcebrain.org/projects/ca1pyramidalcell',''),(5000093,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000094,1,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000095,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000096,1,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000097,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000098,1,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000101,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000102,1,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000105,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000106,1,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000109,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000110,1,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000113,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000114,1,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000117,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000118,1,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000121,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000122,1,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000125,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000126,1,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000129,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000130,1,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000133,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000134,1,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000137,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000138,1,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000141,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000142,1,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000145,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000146,1,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000149,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000150,1,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000153,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000154,1,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000158,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000159,1,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000162,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000163,1,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000166,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000167,1,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000170,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=50219',''),(5000171,1,'Open Source Brain','http://www.opensourcebrain.org/projects/grancelllayer',''),(5000172,1,'Open Source Brain','http://www.opensourcebrain.org/projects/vervaekeetalgolgicellnetwork',''),(5000174,1,'Open Source Brain','http://www.opensourcebrain.org/projects/thalamocortical',''),(5000176,2,'ModelDB','http://senselab.med.yale.edu/modeldb/showmodel.asp?model=127996',NULL),(5000177,2,'ModelDB','http://senselab.med.yale.edu/modeldb/showmodel.asp?model=127996',NULL),(5000178,2,'ModelDB','http://senselab.med.yale.edu/modeldb/showmodel.asp?model=127996',NULL),(5000179,2,'ModelDB','http://senselab.med.yale.edu/modeldb/showmodel.asp?model=127996',NULL),(5000180,2,'ModelDB','http://senselab.med.yale.edu/modeldb/showmodel.asp?model=127996',NULL),(5000181,2,'ModelDB','http://senselab.med.yale.edu/modeldb/showmodel.asp?model=127996',NULL),(5000182,2,'ModelDB','http://senselab.med.yale.edu/modeldb/showmodel.asp?model=127996',NULL),(5000183,2,'ModelDB','http://senselab.med.yale.edu/modeldb/showmodel.asp?model=127996',NULL),(5000184,2,'ModelDB','http://senselab.med.yale.edu/modeldb/showmodel.asp?model=127996',NULL),(5000185,2,'ModelDB','http://senselab.med.yale.edu/modeldb/showmodel.asp?model=127996',NULL),(5000186,2,'ModelDB','http://senselab.med.yale.edu/modeldb/showmodel.asp?model=127996',NULL),(5000187,2,'ModelDB','http://senselab.med.yale.edu/modeldb/showmodel.asp?model=127996',NULL),(5000188,2,'ModelDB','http://senselab.med.yale.edu/modeldb/showmodel.asp?model=127996',NULL),(5000189,2,'ModelDB','http://senselab.med.yale.edu/modeldb/showmodel.asp?model=127996',NULL),(5000190,1,'Open Source Brain','http://www.opensourcebrain.org/projects/vervaekeetalgolgicellnetwork',''),(5000192,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=127996',''),(5000194,1,'Open Source Brain','http://www.opensourcebrain.org/projects/vervaekeetalgolgicellnetwork',''),(5000196,2,'ModelDB','http://senselab.med.yale.edu/modeldb/showmodel.asp?model=127996',''),(5000197,1,'Open Source Brain','http://www.opensourcebrain.org/projects/vervaekeetalgolgicellnetwork',''),(5000199,1,'Open Source Brain','http://www.opensourcebrain.org/projects/vervaekeetalgolgicellnetwork',''),(5000201,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=127996',''),(5000202,1,'Open Source Brain','http://www.opensourcebrain.org/projects/vervaekeetalgolgicellnetwork',''),(5000204,1,'Open Source Brain','http://www.opensourcebrain.org/projects/vervaekeetalgolgicellnetwork',''),(5000205,1,'Open Source Brain','http://www.opensourcebrain.org/projects/vervaekeetalgolgicellnetwork',''),(5000206,1,'Open Source Brain','http://www.opensourcebrain.org/projects/vervaekeetalgolgicellnetwork',''),(5000207,1,'Open Source Brain','http://www.opensourcebrain.org/projects/vervaekeetalgolgicellnetwork',''),(5000208,1,'Open Source Brain','http://www.opensourcebrain.org/projects/vervaekeetalgolgicellnetwork',''),(5000209,1,'Open Source Brain','http://www.opensourcebrain.org/projects/vervaekeetalgolgicellnetwork',''),(5000210,1,'Open Source Brain','http://www.opensourcebrain.org/projects/vervaekeetalgolgicellnetwork',''),(5000211,1,'Open Source Brain','http://www.opensourcebrain.org/projects/vervaekeetalgolgicellnetwork',''),(5000212,1,'Open Source Brain','http://www.opensourcebrain.org/projects/vervaekeetalgolgicellnetwork',''),(5000213,1,'Open Source Brain','http://www.opensourcebrain.org/projects/vervaekeetalgolgicellnetwork',''),(5000214,1,'Open Source Brain','http://www.opensourcebrain.org/projects/vervaekeetalgolgicellnetwork',''),(5000215,1,'Open Source Brain','http://www.opensourcebrain.org/projects/vervaekeetalgolgicellnetwork',''),(5000216,1,'Open Source Brain','http://www.opensourcebrain.org/projects/vervaekeetalgolgicellnetwork',''),(5000218,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=7176',''),(5000219,1,'Open Source Brain','http://www.opensourcebrain.org/projects/purkinjecell',''),(5000224,2,'ModelDB','http://senselab.med.yale.edu/modeldb/showmodel.asp?model=127996',''),(5000225,1,'Open Source Brain','http://www.opensourcebrain.org/projects/vervaekeetalgolgicellnetwork',''),(5000227,2,'ModelDB','http://senselab.med.yale.edu/modeldb/showmodel.asp?model=127996',''),(5000228,1,'Open Source Brain','http://www.opensourcebrain.org/projects/vervaekeetalgolgicellnetwork',''),(5000229,1,'Open Source Brain','http://www.opensourcebrain.org/projects/l5bpyrcellhayetal2011',NULL),(5000230,1,'Open Source Brain','http://www.opensourcebrain.org/projects/izhikevichmodel/',NULL),(5000231,2,'ModelDB','http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=39948',NULL);
/*!40000 ALTER TABLE `refers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `resources`
--

DROP TABLE IF EXISTS `resources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `resources` (
  `Resource_ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL,
  `LogoUrl` varchar(5000) NOT NULL,
  `HomePageUrl` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`Resource_ID`),
  UNIQUE KEY `Name_UNIQUE` (`Name`),
  CONSTRAINT `FK_refers_resources` FOREIGN KEY (`Resource_ID`) REFERENCES `refers` (`Reference_Resource_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resources`
--

LOCK TABLES `resources` WRITE;
/*!40000 ALTER TABLE `resources` DISABLE KEYS */;
INSERT INTO `resources` VALUES (1,'Open Source Brain','/images/OSBLogo.png','http://www.opensourcebrain.org/'),(2,'ModelDB','/images/modeldblogo.gif','http://senselab.med.yale.edu/ModelDB/default.cshtml'),(3,'NeuronDB','/images/neurondblogo.gif','https://senselab.med.yale.edu/neurondb/');
/*!40000 ALTER TABLE `resources` ENABLE KEYS */;
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
INSERT INTO `synapses` VALUES ('NMLSY000079','Double Exponential Synapse','/var/www/NeuroMLmodels/NMLSY000079/DoubExpSyn.xml','2014-07-07 05:30:08','updated 2014'),('NMLSY000080','AMPA_GranGol','/var/www/NeuroMLmodels/NMLSY000080/AMPA_GranGol.xml','2014-07-22 06:15:05',''),('NMLSY000081','GABAA','/var/www/NeuroMLmodels/NMLSY000081/GABAA.xml','2014-07-22 06:22:25',''),('NMLSY000082','MF_AMPA','/var/www/NeuroMLmodels/NMLSY000082/MF_AMPA.xml','2014-07-22 06:26:14',''),('NMLSY000083','NMDA','/var/www/NeuroMLmodels/NMLSY000083/NMDA.xml','2014-07-22 06:30:23',''),('NMLSY000084','GapJuncCML','/var/www/NeuroMLmodels/NMLSY000084/GapJuncCML.xml','2014-07-22 07:29:30',''),('NMLSY000099','ApicalSyn','/var/www/NeuroMLmodels/NMLSY000099/ApicalSyn.xml','2014-07-24 02:08:33',''),('NMLSY000100','MultiDecaySyn','/var/www/NeuroMLmodels/NMLSY000100/MultiDecaySyn.xml','2014-07-24 02:09:34','');
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
INSERT INTO `temp_query_results` VALUES ('NMLCL000002'),('NMLCL000004'),('NMLCL000005'),('NMLNT000001'),('NMLNT000070');
/*!40000 ALTER TABLE `temp_query_results` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_preferences`
--

LOCK TABLES `user_preferences` WRITE;
/*!40000 ALTER TABLE `user_preferences` DISABLE KEYS */;
INSERT INTO `user_preferences` VALUES (1,1,'---\n:comments_sorting: asc\n:warn_on_leaving_unsaved: \'1\'\n:no_self_notified: false\n',0,''),(2,3,'--- {}\n',0,NULL),(3,4,'--- {}\n',0,NULL),(4,5,'--- {}\n',0,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','179d10c29f5c8a2d0188549a627b2c309483adab','Curator','Admin','admin@example.net',1,1,'2014-09-24 10:17:10','en',NULL,'2013-02-23 13:19:49','2014-03-21 13:03:51','User',NULL,'all','b5e2628884ce5fe6f911c2cd23391ab8',NULL),(2,'','','','Anonymous','',0,0,NULL,'',NULL,'2013-02-23 13:21:20','2013-02-23 13:21:20','AnonymousUser',NULL,'only_my_events',NULL,NULL),(3,'akon','1bc9df0e7590e0979da0d32601f50a72c670ffe9','akon','akon','akon@akon.com',0,2,NULL,'en',NULL,'2013-04-15 12:19:16','2013-04-15 12:19:16','User',NULL,'only_my_events','c60052c1ed04447f162eb7533bf2b7b9',NULL),(4,'veer','78a81b59b83349c34e37b4a60832436537dd0b6d','veer','veer','veer@veer.com',0,2,NULL,'en',NULL,'2013-04-15 12:36:46','2013-04-15 12:36:46','User',NULL,'only_my_events','6a1bdaf708426a866f1d391988ab356f',NULL),(5,'invincible','03a5db2b3e50a0a03a2df3cbc0c31560db86619f','invincible','veer','veer@invincibles.com',0,1,'2013-04-19 10:25:06','en',NULL,'2013-04-19 02:43:36','2013-04-19 02:43:36','User',NULL,'only_my_events','b313f942f2e876246d77cd4deac1ab5e',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'neuromldb'
--
/*!50003 DROP PROCEDURE IF EXISTS `delete_author_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_author_list`(IN al_ID INT(11) )
BEGIN 

     DECLARE cnt int;

	 SELECT COUNT(*) into cnt 
	 FROM author_lists 
	 WHERE authorlist_id = al_ID;

	 IF cnt = 1 THEN
        DELETE FROM author_list_associations where authorlist_id = al_id;
		DELETE FROM author_lists where authorlist_id = al_id;
		DELETE FROM model_metadata_associations where metadata_id = al_id;
		DELETE FROM metadatas where metadata_id = al_id;

		SELECT concat('DELETED: ', al_ID) as response;
	 ELSE
		SELECT concat(al_ID, ' DOES NOT EXIST ') as response;
	 END IF;

     END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `inherit_author_metadata` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `inherit_author_metadata`(IN parent_ID VARCHAR(45), IN child_ID VARCHAR(45))
BEGIN 

     DECLARE cnt int;

	 SELECT COUNT(*) into cnt 
	 FROM partof_tables 
	 WHERE parent = parent_ID and child = child_ID;

	 IF cnt = 1 THEN
        INSERT INTO model_metadata_associations(Metadata_ID, Model_ID, Comments) 
        SELECT metadata_ID, child_ID, concat('Inherited author_list metadata from parent ', parent_ID)
        FROM model_metadata_associations join author_lists on metadata_id = AuthorList_ID
		WHERE model_ID = parent_ID;

		SELECT concat(child_ID, ' INHERITED AUTHOR METADATA OF ', parent_ID) as response;
	 ELSE
		SELECT concat(parent_ID, ' IS NOT THE PARENT OF ', child_ID) as response;
	 END IF;

     END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `inherit_metadata` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `inherit_metadata`(IN parent_ID VARCHAR(45), IN child_ID VARCHAR(45))
BEGIN 

     DECLARE cnt int;

	 SELECT COUNT(*) into cnt 
	 FROM partof_tables 
	 WHERE parent = parent_ID and child = child_ID;

	 IF cnt = 1 THEN
        INSERT INTO model_metadata_associations(Metadata_ID, Model_ID, Comments) 
        SELECT metadata_ID, child_ID, concat('Inherited author_list metadata from parent ', parent_ID)
        FROM model_metadata_associations join author_lists on metadata_id = AuthorList_ID
		WHERE model_ID = parent_ID;
		
		INSERT INTO model_metadata_associations(Metadata_ID, Model_ID, Comments) 
		SELECT metadata_ID, child_ID, concat('Inherited references metadata from parent ', parent_ID)
        FROM model_metadata_associations join refers on metadata_id = reference_ID
		WHERE model_ID = parent_ID;

		INSERT INTO model_metadata_associations(Metadata_ID, Model_ID, Comments) 
		SELECT metadata_ID, child_ID, concat('Inherited publications metadata from parent ', parent_ID)
        FROM model_metadata_associations join publications on metadata_id = publication_id
		WHERE model_ID = parent_ID;

		SELECT concat(child_ID, ' INHERITED METADATA OF ', parent_ID) as response;
	 ELSE
		SELECT concat(parent_ID, ' IS NOT THE PARENT OF ', child_ID) as response;
	 END IF;

     END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `keyword_search` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`neuromldb2`@`localhost` PROCEDURE `keyword_search`(IN keywords_list varchar(100),IN keywords_cnt integer)
begin
DECLARE Kword varchar(25);
DECLARE  it INT DEFAULT 1;
TRUNCATE table temp_query_results;
TRUNCATE table out_query_results;
WHILE keywords_cnt != 0 AND keywords_list IS NOT NULL DO
SELECT substring_index(keywords_list,' ',it) into Kword;

SELECT REPLACE(keywords_list,Kword,'') INTO keywords_list;
SELECT REPLACE(Kword,' ','') INTO Kword;
SELECT CONCAT('%',Kword,'%') into Kword;



TRUNCATE table temp_query_results;
INSERT INTO temp_query_results (SELECT distinct(Model_ID) FROM keyword_view WHERE Keywords LIKE Kword);




TRUNCATE table query_results;
INSERT INTO query_results SELECT temp_query_results.model_ID FROM temp_query_results
UNION
SELECT distinct(partof_tables.Child) AS model_ID FROM partof_tables, temp_query_results WHERE temp_query_results.Model_ID = partof_tables.parent
UNION
SELECT distinct(partof_tables.parent) AS model_ID FROM partof_tables, temp_query_results WHERE temp_query_results.Model_ID = partof_tables.child;



IF it = 1 THEN 
TRUNCATE table out_query_results;
INSERT INTO out_query_results SELECT distinct(a.Model_ID) FROM query_results a;


ELSE
TRUNCATE table temp_query_results;
INSERT INTO temp_query_results(SELECT a.Model_ID FROM out_query_results a);
TRUNCATE TABLE out_query_results;
INSERT INTO out_query_results SELECT a.Model_ID FROM temp_query_results a INNER JOIN query_results USING (Model_ID);
END IF;

SET keywords_cnt = keywords_cnt-1;
SET it = it+1;

END WHILE;                                                  
SELECT * FROM out_query_results ORDER BY Model_ID desc;

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

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
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `all_metadata_view` AS (select `model_metadata_associations`.`Model_ID` AS `Model_ID`,`model_metadata_associations`.`Metadata_ID` AS `Metadata_id`,'author person' AS `Metadata_type`,`people`.`Person_Last_Name` AS `Metadata_value` from (((`model_metadata_associations` join `author_lists` `al` on((`model_metadata_associations`.`Metadata_ID` = `al`.`AuthorList_ID`))) join `author_list_associations` `ala` on((`al`.`AuthorList_ID` = `ala`.`AuthorList_ID`))) join `people` on((`ala`.`Person_ID` = `people`.`Person_ID`)))) union (select `model_metadata_associations`.`Model_ID` AS `model_id`,`model_metadata_associations`.`Metadata_ID` AS `metadata_id`,'neurolex' AS `metadata_type`,`neurolexes`.`NeuroLex_URI` AS `metadata_value` from (`model_metadata_associations` join `neurolexes` on((`model_metadata_associations`.`Metadata_ID` = `neurolexes`.`NeuroLex_ID`)))) union (select `model_metadata_associations`.`Model_ID` AS `model_id`,`model_metadata_associations`.`Metadata_ID` AS `metadata_id`,'keyword' AS `metadata_type`,`other_keywords`.`Other_Keyword_term` AS `metadata_value` from (`model_metadata_associations` join `other_keywords` on((`model_metadata_associations`.`Metadata_ID` = `other_keywords`.`Other_Keyword_ID`)))) union (select `model_metadata_associations`.`Model_ID` AS `model_id`,`model_metadata_associations`.`Metadata_ID` AS `metadata_id`,'references' AS `metadata_type`,`refers`.`Reference_URI` AS `metadata_value` from (`model_metadata_associations` join `refers` on((`model_metadata_associations`.`Metadata_ID` = `refers`.`Reference_ID`)))) union (select `model_metadata_associations`.`Model_ID` AS `model_id`,`model_metadata_associations`.`Metadata_ID` AS `metadata_id`,'publication' AS `metadata_type`,`publications`.`Pubmed_Ref` AS `metadata_value` from (`model_metadata_associations` join `publications` on((`model_metadata_associations`.`Metadata_ID` = `publications`.`Publication_ID`)))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `all_models_view`
--

/*!50001 DROP TABLE IF EXISTS `all_models_view`*/;
/*!50001 DROP VIEW IF EXISTS `all_models_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `all_models_view` AS (select `channels`.`Channel_ID` AS `Model_ID`,`channels`.`Channel_Name` AS `Model_Name`,`channels`.`ChannelML_File` AS `Model_File`,`channels`.`Upload_Time` AS `upload_time`,`channels`.`Comments` AS `comments` from `channels`) union (select `cells`.`Cell_ID` AS `Cell_ID`,`cells`.`Cell_Name` AS `Cell_Name`,`cells`.`MorphML_File` AS `MorphML_File`,`cells`.`Upload_Time` AS `upload_time`,`cells`.`Comments` AS `comments` from `cells`) union (select `synapses`.`Synapse_ID` AS `Synapse_ID`,`synapses`.`Synapse_Name` AS `Synapse_Name`,`synapses`.`Synapse_File` AS `Synapse_File`,`synapses`.`Upload_Time` AS `upload_time`,`synapses`.`Comments` AS `comments` from `synapses`) union (select `networks`.`Network_ID` AS `network_ID`,`networks`.`Network_Name` AS `Network_Name`,`networks`.`NetworkML_File` AS `NetworkML_File`,`networks`.`Upload_Time` AS `upload_time`,`networks`.`Comments` AS `comments` from `networks`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `keyword_view`
--

/*!50001 DROP TABLE IF EXISTS `keyword_view`*/;
/*!50001 DROP VIEW IF EXISTS `keyword_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `keyword_view` AS select `models`.`Model_ID` AS `Model_ID`,`models`.`Model_ID` AS `Keywords` from `models` union select `mma`.`Model_ID` AS `Model_ID`,`ok`.`Other_Keyword_term` AS `Keywords` from ((`model_metadata_associations` `mma` join `other_keywords` `ok`) join `refers` `ref`) where (`ok`.`Other_Keyword_ID` = `mma`.`Metadata_ID`) union select `mma`.`Model_ID` AS `Model_ID`,concat(' ',ifnull(`pub`.`Full_Title`,''),' ',ifnull(`pub`.`Pubmed_Ref`,''),' ',ifnull(`pub`.`Comments`,'')) AS `Keywords` from (`model_metadata_associations` `mma` join `publications` `pub`) where (`pub`.`Publication_ID` = `mma`.`Metadata_ID`) union select `mma`.`Model_ID` AS `Model_ID`,concat(' ',ifnull(`nlx`.`NeuroLex_Term`,''),' ',ifnull(`nlx`.`NeuroLex_URI`,''),' ',ifnull(`nlx`.`Comments`,'')) AS `Name_exp_8` from (`model_metadata_associations` `mma` join `neurolexes` `nlx`) where (`nlx`.`NeuroLex_ID` = `mma`.`Metadata_ID`) union select `cells`.`Cell_ID` AS `Cell_ID`,concat(' ',ifnull(`cells`.`Cell_Name`,''),' ',ifnull(`cells`.`Comments`,'')) AS `concat(' ', IFNULL(Cell_Name,''), ' ', IFNULL(Comments,''))` from `cells` union select `networks`.`Network_ID` AS `Network_ID`,concat(' ',ifnull(`networks`.`Network_Name`,''),' ',ifnull(`networks`.`Comments`,'')) AS `concat(' ', IFNULL(Network_Name,''), ' ', IFNULL(Comments,''))` from `networks` union select `channels`.`Channel_ID` AS `Channel_ID`,concat(' ',ifnull(`channels`.`Channel_Name`,''),' ',ifnull(`channels`.`Comments`,'')) AS `concat(' ', IFNULL(Channel_Name,''), ' ', IFNULL(Comments,''))` from `channels` union select `synapses`.`Synapse_ID` AS `Synapse_ID`,concat(' ',ifnull(`synapses`.`Synapse_Name`,''),' ',ifnull(`synapses`.`Comments`,'')) AS `concat(' ', IFNULL(Synapse_Name,''), ' ', IFNULL(Comments,''))` from `synapses` union select `mma`.`Model_ID` AS `Model_ID`,concat(' ',ifnull(`ppl`.`Person_First_Name`,''),' ',ifnull(`ppl`.`Person_Last_Name`,''),' ',ifnull(`ppl`.`Instituition`,''),' ',ifnull(`ppl`.`Comments`,'')) AS `Name_exp_18` from ((`people` `ppl` join `model_metadata_associations` `mma`) join `author_list_associations` `ala`) where ((`mma`.`Metadata_ID` = `ala`.`AuthorList_ID`) and (`ala`.`Person_ID` = `ppl`.`Person_ID`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `model_counts`
--

/*!50001 DROP TABLE IF EXISTS `model_counts`*/;
/*!50001 DROP VIEW IF EXISTS `model_counts`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `model_counts` AS select substr(`all_models_view`.`Model_ID`,4,2) AS `Type`,count(0) AS `Count` from `all_models_view` group by substr(`all_models_view`.`Model_ID`,4,2) order by count(0) desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `nif_helper_authors`
--

/*!50001 DROP TABLE IF EXISTS `nif_helper_authors`*/;
/*!50001 DROP VIEW IF EXISTS `nif_helper_authors`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `nif_helper_authors` AS select `mma`.`Model_ID` AS `Model_ID`,group_concat(concat(`p`.`Person_First_Name`,' ',`p`.`Person_Last_Name`) separator ', ') AS `Authors` from (((`model_metadata_associations` `mma` join `author_lists` `al` on((`mma`.`Metadata_ID` = `al`.`AuthorList_ID`))) join `author_list_associations` `ala` on((`al`.`AuthorList_ID` = `ala`.`AuthorList_ID`))) join `people` `p` on((`ala`.`Person_ID` = `p`.`Person_ID`))) where ((`ala`.`is_translator` = '0') or (`ala`.`is_translator` = '2')) group by `mma`.`Model_ID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `nif_helper_cells`
--

/*!50001 DROP TABLE IF EXISTS `nif_helper_cells`*/;
/*!50001 DROP VIEW IF EXISTS `nif_helper_cells`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `nif_helper_cells` AS select `p`.`Model_ID` AS `Model_ID`,`c`.`Model_Name` AS `Model_Name` from ((`all_models_view` `p` join `partof_tables` `po`) join `all_models_view` `c`) where ((`p`.`Model_ID` = `po`.`parent`) and (`c`.`Model_ID` = `po`.`child`) and `po`.`child` in (select `channels`.`Channel_ID` from `channels`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `nif_helper_channels`
--

/*!50001 DROP TABLE IF EXISTS `nif_helper_channels`*/;
/*!50001 DROP VIEW IF EXISTS `nif_helper_channels`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `nif_helper_channels` AS select `c`.`Model_ID` AS `Model_ID`,`p`.`Model_Name` AS `Model_Name` from ((`all_models_view` `p` join `partof_tables` `po`) join `all_models_view` `c`) where ((`p`.`Model_ID` = `po`.`parent`) and (`c`.`Model_ID` = `po`.`child`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `nif_helper_keywords`
--

/*!50001 DROP TABLE IF EXISTS `nif_helper_keywords`*/;
/*!50001 DROP VIEW IF EXISTS `nif_helper_keywords`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `nif_helper_keywords` AS select `mma`.`Model_ID` AS `Model_ID`,group_concat(`ok`.`Other_Keyword_term` separator ',') AS `keywords` from (`model_metadata_associations` `mma` join `other_keywords` `ok` on((`mma`.`Metadata_ID` = `ok`.`Other_Keyword_ID`))) group by `mma`.`Model_ID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `nif_helper_networks`
--

/*!50001 DROP TABLE IF EXISTS `nif_helper_networks`*/;
/*!50001 DROP VIEW IF EXISTS `nif_helper_networks`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `nif_helper_networks` AS select `p`.`Model_ID` AS `Model_ID`,`c`.`Model_Name` AS `Model_Name` from ((`all_models_view` `p` join `partof_tables` `po`) join `all_models_view` `c`) where ((`p`.`Model_ID` = `po`.`parent`) and (`c`.`Model_ID` = `po`.`child`) and `po`.`child` in (select `cells`.`Cell_ID` from `cells`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `nif_helper_neurolexes`
--

/*!50001 DROP TABLE IF EXISTS `nif_helper_neurolexes`*/;
/*!50001 DROP VIEW IF EXISTS `nif_helper_neurolexes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `nif_helper_neurolexes` AS select `mma`.`Model_ID` AS `Model_ID`,`n`.`NeuroLex_URI` AS `NeuroLex_URI`,`n`.`NeuroLex_Term` AS `NeuroLex_Term` from (`model_metadata_associations` `mma` join `neurolexes` `n` on((`mma`.`Metadata_ID` = `n`.`NeuroLex_ID`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `nif_helper_publications`
--

/*!50001 DROP TABLE IF EXISTS `nif_helper_publications`*/;
/*!50001 DROP VIEW IF EXISTS `nif_helper_publications`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `nif_helper_publications` AS select `mma`.`Model_ID` AS `Model_ID`,`p`.`Pubmed_Ref` AS `Pubmed_Ref`,`p`.`Full_Title` AS `Full_Title` from (`model_metadata_associations` `mma` join `publications` `p` on((`mma`.`Metadata_ID` = `p`.`Publication_ID`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `nif_helper_synapses`
--

/*!50001 DROP TABLE IF EXISTS `nif_helper_synapses`*/;
/*!50001 DROP VIEW IF EXISTS `nif_helper_synapses`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `nif_helper_synapses` AS select `c`.`Model_ID` AS `Model_ID`,`p`.`Model_Name` AS `Model_Name` from ((`all_models_view` `p` join `partof_tables` `po`) join `all_models_view` `c`) where ((`p`.`Model_ID` = `po`.`parent`) and (`c`.`Model_ID` = `po`.`child`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `nif_model_ID_Name_Type`
--

/*!50001 DROP TABLE IF EXISTS `nif_model_ID_Name_Type`*/;
/*!50001 DROP VIEW IF EXISTS `nif_model_ID_Name_Type`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `nif_model_ID_Name_Type` AS select `cells`.`Cell_ID` AS `Model_ID`,`cells`.`Cell_Name` AS `Model_Name`,'Cell' AS `Model_Type` from `cells` union select `channels`.`Channel_ID` AS `Model_ID`,`channels`.`Channel_Name` AS `Model_Name`,'Channel' AS `Model_Type` from `channels` union select `networks`.`Network_ID` AS `Model_ID`,`networks`.`Network_Name` AS `Model_Name`,'Network' AS `Model_Type` from `networks` union select `synapses`.`Synapse_ID` AS `Model_ID`,`synapses`.`Synapse_Name` AS `Model_Name`,'Synapse' AS `Model_Type` from `synapses` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `nif_model_associations`
--

/*!50001 DROP TABLE IF EXISTS `nif_model_associations`*/;
/*!50001 DROP VIEW IF EXISTS `nif_model_associations`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `nif_model_associations` AS select `cl`.`Cell_ID` AS `Model_ID`,group_concat(`a`.`Model_Name` separator ', ') AS `Associated_Models` from (`cells` `cl` left join `nif_helper_cells` `a` on((`cl`.`Cell_ID` = `a`.`Model_ID`))) group by `cl`.`Cell_ID` union select `ch`.`Channel_ID` AS `Model_ID`,group_concat(`a`.`Model_Name` separator ', ') AS `Associated_Models` from (`channels` `ch` left join `nif_helper_channels` `a` on((`ch`.`Channel_ID` = `a`.`Model_ID`))) group by `ch`.`Channel_ID` union select `n`.`Network_ID` AS `Model_ID`,group_concat(`a`.`Model_Name` separator ', ') AS `Associated_Models` from (`networks` `n` left join `nif_helper_networks` `a` on((`n`.`Network_ID` = `a`.`Model_ID`))) group by `n`.`Network_ID` union select `s`.`Synapse_ID` AS `Model_ID`,group_concat(`a`.`Model_Name` separator ', ') AS `Associated_Models` from (`synapses` `s` left join `nif_helper_synapses` `a` on((`s`.`Synapse_ID` = `a`.`Model_ID`))) group by `s`.`Synapse_ID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `nif_model_authors`
--

/*!50001 DROP TABLE IF EXISTS `nif_model_authors`*/;
/*!50001 DROP VIEW IF EXISTS `nif_model_authors`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `nif_model_authors` AS select `m`.`Model_ID` AS `Model_ID`,`aut`.`Authors` AS `Authors` from (`models` `m` left join `nif_helper_authors` `aut` on((`m`.`Model_ID` = `aut`.`Model_ID`))) order by `m`.`Model_ID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `nif_model_info`
--

/*!50001 DROP TABLE IF EXISTS `nif_model_info`*/;
/*!50001 DROP VIEW IF EXISTS `nif_model_info`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `nif_model_info` AS select `m`.`Model_ID` AS `Model_ID`,`m`.`Model_Name` AS `Model_Name`,`m`.`Model_Type` AS `Model_Type`,`a`.`Authors` AS `Authors`,`p`.`Pubmed_Ref` AS `Pubmed_Ref`,`p`.`Pubmed_Title` AS `Pubmed_Title`,`n`.`NeuroLex_URI` AS `NeuroLex_URI`,`n`.`NeuroLex_Term` AS `NeuroLex_Term`,`k`.`Keywords` AS `Keywords`,`ma`.`Associated_Models` AS `Associated_Models` from (((((`nif_model_ID_Name_Type` `m` join `nif_model_authors` `a` on((`m`.`Model_ID` = `a`.`Model_ID`))) join `nif_model_publications` `p` on((`m`.`Model_ID` = `p`.`Model_ID`))) join `nif_model_neurolexes` `n` on((`m`.`Model_ID` = `n`.`Model_ID`))) join `nif_model_keywords` `k` on((`m`.`Model_ID` = `k`.`Model_ID`))) join `nif_model_associations` `ma` on((`m`.`Model_ID` = `ma`.`Model_ID`))) order by `m`.`Model_ID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `nif_model_keywords`
--

/*!50001 DROP TABLE IF EXISTS `nif_model_keywords`*/;
/*!50001 DROP VIEW IF EXISTS `nif_model_keywords`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `nif_model_keywords` AS select `m`.`Model_ID` AS `Model_ID`,`k`.`keywords` AS `Keywords` from (`models` `m` left join `nif_helper_keywords` `k` on((`m`.`Model_ID` = `k`.`Model_ID`))) order by `m`.`Model_ID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `nif_model_neurolexes`
--

/*!50001 DROP TABLE IF EXISTS `nif_model_neurolexes`*/;
/*!50001 DROP VIEW IF EXISTS `nif_model_neurolexes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `nif_model_neurolexes` AS select `m`.`Model_ID` AS `Model_ID`,`nl`.`NeuroLex_URI` AS `NeuroLex_URI`,`nl`.`NeuroLex_Term` AS `NeuroLex_Term` from (`models` `m` left join `nif_helper_neurolexes` `nl` on((`m`.`Model_ID` = `nl`.`Model_ID`))) order by `m`.`Model_ID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `nif_model_publications`
--

/*!50001 DROP TABLE IF EXISTS `nif_model_publications`*/;
/*!50001 DROP VIEW IF EXISTS `nif_model_publications`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `nif_model_publications` AS select `m`.`Model_ID` AS `Model_ID`,`pub`.`Pubmed_Ref` AS `Pubmed_Ref`,`pub`.`Full_Title` AS `Pubmed_Title` from (`models` `m` left join `nif_helper_publications` `pub` on((`m`.`Model_ID` = `pub`.`Model_ID`))) order by `m`.`Model_ID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `partof_tables`
--

/*!50001 DROP TABLE IF EXISTS `partof_tables`*/;
/*!50001 DROP VIEW IF EXISTS `partof_tables`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `partof_tables` AS select `network_cell_associations`.`Network_ID` AS `parent`,`network_cell_associations`.`Cell_ID` AS `child` from `network_cell_associations` union select `cell_channel_associations`.`Cell_ID` AS `parent`,`cell_channel_associations`.`Channel_ID` AS `child` from `cell_channel_associations` union select `network_synapse_associations`.`Network_ID` AS `parent`,`network_synapse_associations`.`Synapse_ID` AS `child` from `network_synapse_associations` union select `cell_synapse_associations`.`Cell_ID` AS `parent`,`cell_synapse_associations`.`Synapse_ID` AS `child` from `cell_synapse_associations` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-07-23 10:57:08
