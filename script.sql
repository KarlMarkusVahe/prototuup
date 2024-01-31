-- MySQL dump 10.13  Distrib 8.0.31, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: prototuup
-- ------------------------------------------------------
-- Server version	8.0.31

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `dokument`
--

DROP TABLE IF EXISTS `dokument`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dokument` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `DOKUMENT_TYYP` varchar(20) NOT NULL,
  `PEALKIRI` varchar(50) NOT NULL,
  `METAANDMED` varchar(255) DEFAULT NULL,
  `REGISTREERITUD` tinyint(1) NOT NULL DEFAULT '0',
  `REGISTREERIMISE_AEG` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `FOLDER_ID` int DEFAULT NULL,
  `omanik_id` int NOT NULL,
  `file_path` varchar(255) NOT NULL COMMENT 'Relative path to the file',
  PRIMARY KEY (`ID`),
  KEY `FOLDER_ID` (`FOLDER_ID`),
  KEY `omanik` (`omanik_id`),
  CONSTRAINT `dokument_ibfk_1` FOREIGN KEY (`FOLDER_ID`) REFERENCES `folder` (`ID`),
  CONSTRAINT `omanik` FOREIGN KEY (`omanik_id`) REFERENCES `kasutaja` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dokument`
--

LOCK TABLES `dokument` WRITE;
/*!40000 ALTER TABLE `dokument` DISABLE KEYS */;
INSERT INTO `dokument` VALUES (1,'pdf','Elu surm',NULL,0,'2024-01-24 11:04:56',1,1,'/1'),(2,'pdf','Surm',NULL,0,'2024-01-24 11:06:16',1,2,'/2'),(3,'excel','Valik',NULL,0,'2024-01-24 11:51:05',2,1,'/3');
/*!40000 ALTER TABLE `dokument` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dokument_privileegid`
--

DROP TABLE IF EXISTS `dokument_privileegid`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dokument_privileegid` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `DOKUMENT_ID` int NOT NULL,
  `KASUTAJA_ID` int NOT NULL,
  `READ_PRIVILEEG` tinyint(1) NOT NULL DEFAULT '0',
  `WRITE_PRIVILEEG` tinyint(1) NOT NULL DEFAULT '0',
  `DELETE_PRIVILEEG` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `KASUTAJA_ID` (`KASUTAJA_ID`),
  KEY `DOKUMENT_ID` (`DOKUMENT_ID`),
  CONSTRAINT `dokument_privileegid_ibfk_1` FOREIGN KEY (`KASUTAJA_ID`) REFERENCES `kasutaja` (`ID`),
  CONSTRAINT `dokument_privileegid_ibfk_2` FOREIGN KEY (`DOKUMENT_ID`) REFERENCES `dokument` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dokument_privileegid`
--

LOCK TABLES `dokument_privileegid` WRITE;
/*!40000 ALTER TABLE `dokument_privileegid` DISABLE KEYS */;
INSERT INTO `dokument_privileegid` VALUES (1,2,1,1,0,0),(10,3,1,1,0,0);
/*!40000 ALTER TABLE `dokument_privileegid` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `folder`
--

DROP TABLE IF EXISTS `folder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `folder` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `_ID` int DEFAULT NULL,
  `OMANIK_ID` int NOT NULL,
  `PEALKIRI` varchar(50) NOT NULL,
  `KATEGOORIA` varchar(50) NOT NULL DEFAULT 'ÜLDINE',
  PRIMARY KEY (`ID`),
  KEY `_ID` (`_ID`),
  KEY `OMANIK_ID` (`OMANIK_ID`),
  CONSTRAINT `folder_ibfk_1` FOREIGN KEY (`_ID`) REFERENCES `folder` (`ID`),
  CONSTRAINT `folder_ibfk_2` FOREIGN KEY (`OMANIK_ID`) REFERENCES `kasutaja` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `folder`
--

LOCK TABLES `folder` WRITE;
/*!40000 ALTER TABLE `folder` DISABLE KEYS */;
INSERT INTO `folder` VALUES (1,NULL,1,'Asjad','ÜLDINE'),(2,1,1,'Temp','ÜLDINE'),(3,NULL,2,'Oluline','OLULINE');
/*!40000 ALTER TABLE `folder` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `folder_privileegid`
--

DROP TABLE IF EXISTS `folder_privileegid`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `folder_privileegid` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `FOLDER_ID` int NOT NULL,
  `KASUTAJA_ID` int NOT NULL,
  `READ_PRIVILEEG` tinyint(1) NOT NULL DEFAULT '0',
  `WRITE_PRIVILEEG` tinyint(1) NOT NULL DEFAULT '0',
  `DELETE_PRIVILEEG` tinyint(1) NOT NULL DEFAULT '0',
  `CREATE_PRIVILEEG` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `KASUTAJA_ID` (`KASUTAJA_ID`),
  KEY `FOLDER_ID` (`FOLDER_ID`),
  CONSTRAINT `folder_privileegid_ibfk_1` FOREIGN KEY (`KASUTAJA_ID`) REFERENCES `kasutaja` (`ID`),
  CONSTRAINT `folder_privileegid_ibfk_2` FOREIGN KEY (`FOLDER_ID`) REFERENCES `folder` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `folder_privileegid`
--

LOCK TABLES `folder_privileegid` WRITE;
/*!40000 ALTER TABLE `folder_privileegid` DISABLE KEYS */;
INSERT INTO `folder_privileegid` VALUES (1,3,1,0,0,0,0);
/*!40000 ALTER TABLE `folder_privileegid` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `kasutaja`
--

DROP TABLE IF EXISTS `kasutaja`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kasutaja` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `EMAIL` varchar(100) NOT NULL,
  `PAROOL` varchar(255) NOT NULL,
  `OPETAJA` tinyint(1) NOT NULL DEFAULT '0',
  `LOODUD` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `MUUDETUD` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `KOOSKOLASTAJA` tinyint(1) NOT NULL DEFAULT '0',
  `administraator` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'diagnostic availability',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `EMAIL` (`EMAIL`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kasutaja`
--

LOCK TABLES `kasutaja` WRITE;
/*!40000 ALTER TABLE `kasutaja` DISABLE KEYS */;
INSERT INTO `kasutaja` VALUES (1,'admin@voco.ee','$2a$10$V32s3A8ddIykp1BHZMWE8ulPfomHxj04z8uokUzTl64thNQqRqXuW',0,'2024-01-16 08:56:49','2024-01-24 10:00:08',0,1),(2,'test@voco.ee','$2a$10$RCwVw6xEBa99Povsc3H0i.br0oyVh9AbVXHlTMQ5l0rtDTWFIiVY.',0,'2024-01-24 11:05:44','2024-01-24 11:05:44',0,0);
/*!40000 ALTER TABLE `kasutaja` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logid`
--

DROP TABLE IF EXISTS `logid`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logid` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `DOKUMENDI_ID` int NOT NULL,
  `KASUTAJA_ID` int NOT NULL,
  `TEGEVUS` varchar(255) NOT NULL,
  `AEG` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `DOKUMENDI_ID` (`DOKUMENDI_ID`),
  KEY `KASUTAJA_ID` (`KASUTAJA_ID`),
  CONSTRAINT `logid_ibfk_1` FOREIGN KEY (`DOKUMENDI_ID`) REFERENCES `dokument` (`ID`),
  CONSTRAINT `logid_ibfk_2` FOREIGN KEY (`KASUTAJA_ID`) REFERENCES `kasutaja` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logid`
--

LOCK TABLES `logid` WRITE;
/*!40000 ALTER TABLE `logid` DISABLE KEYS */;
/*!40000 ALTER TABLE `logid` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `session_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `expires` int unsigned NOT NULL,
  `data` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  PRIMARY KEY (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
INSERT INTO `sessions` VALUES ('1wJOca2RI53U4eMedrB3uIHqJiJG-63D',1707826358,'{\"cookie\":{\"originalMaxAge\":1209600000,\"expires\":\"2024-02-13T12:12:37.866Z\",\"secure\":true,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"None\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('2hxAaOn6D2pmjpWaUMGDb27exHXX7oC8',1707826124,'{\"cookie\":{\"originalMaxAge\":1209600000,\"expires\":\"2024-02-13T12:08:43.769Z\",\"secure\":true,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"None\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('2rT_nLNRxCOZOfvibsxQV5MmYE4O64XE',1707828163,'{\"cookie\":{\"originalMaxAge\":1209600000,\"expires\":\"2024-02-13T12:42:42.827Z\",\"secure\":false,\"httpOnly\":false,\"path\":\"/\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('3DEvVjiGyA1D7fjpednfTjVS4kbToPHG',1706700681,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('4AhNFO0GCqrkRKdEPAm4Riy2bgc8eCii',1707826537,'{\"cookie\":{\"originalMaxAge\":1209600000,\"expires\":\"2024-02-13T12:15:37.419Z\",\"secure\":false,\"httpOnly\":false,\"path\":\"/\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('4J2U4rGYxg6tgv2y9oN4S6L1rx2CxuSB',1707824076,'{\"cookie\":{\"originalMaxAge\":1209600000,\"expires\":\"2024-02-13T11:34:35.557Z\",\"secure\":false,\"httpOnly\":false,\"path\":\"/\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('4kF3zWh3K6i4K-ZtMm45avG5jQvbJBIc',1707825674,'{\"cookie\":{\"originalMaxAge\":1209600000,\"expires\":\"2024-02-13T12:01:13.813Z\",\"secure\":true,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"None\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('5Kg8xX5dZW-1q8oKMYJjwTfwvbM2zarl',1707829554,'{\"cookie\":{\"originalMaxAge\":1209600000,\"expires\":\"2024-02-13T13:05:53.958Z\",\"secure\":false,\"httpOnly\":false,\"path\":\"/\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('5Lrr7jb41gUaAc-no3kgShm3I0y3hHY1',1706700056,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('5aOCHSJYfBSZ-MdLWJIf03sfW3yzFzVB',1707826364,'{\"cookie\":{\"originalMaxAge\":1209600000,\"expires\":\"2024-02-13T12:12:44.495Z\",\"secure\":true,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"None\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('7Cnct4rVVexaf4mns5MaSnMaZc6PBa-n',1707830446,'{\"cookie\":{\"originalMaxAge\":1209600000,\"expires\":\"2024-02-13T13:11:09.047Z\",\"secure\":false,\"httpOnly\":false,\"path\":\"/\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('7i4jw60DPfb7nDpGuWfBi08JWlgkYG1l',1707825150,'{\"cookie\":{\"originalMaxAge\":1209599999,\"expires\":\"2024-02-13T11:52:30.264Z\",\"secure\":true,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"None\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('87ZPcHoXEBhkVEJjOarly5nxAIfuJ2tR',1706700114,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('8UrxnpZF3FxIu--0uATFXEZ2s8xd-99S',1706699045,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('8xeDubERi37Z11AmjcuLRyeWpzPPioEm',1706700643,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('93mAypv9DWEBQOizpZDtl6Useul5pynd',1707826549,'{\"cookie\":{\"originalMaxAge\":1209600000,\"expires\":\"2024-02-13T12:15:48.612Z\",\"secure\":false,\"httpOnly\":false,\"path\":\"/\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('AGRo3alZw7jsGnANmwCMRXJO_PuharFJ',1707829669,'{\"cookie\":{\"originalMaxAge\":1209600000,\"expires\":\"2024-02-13T13:07:48.627Z\",\"secure\":false,\"httpOnly\":false,\"path\":\"/\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('DySGZ_t8lMkZoJHFv4w4BVjkIAlqi_Y_',1706700691,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('EVKX4HEXWNpLc2yyN6QvqYLlG94Ndv7-',1707826219,'{\"cookie\":{\"originalMaxAge\":1209600000,\"expires\":\"2024-02-13T12:10:18.902Z\",\"secure\":true,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"None\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('EXvUWJg5XptoTtkbsqGB2wIX6gxirXrx',1706699131,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('GoBXDRZhT4diBmpYW2Mqt8HXzJmgJsDM',1707824819,'{\"cookie\":{\"originalMaxAge\":1209600000,\"expires\":\"2024-02-13T11:46:59.078Z\",\"secure\":false,\"httpOnly\":false,\"path\":\"/\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('GrbD95y0ty9va_dI04KzX92nB3XKGjw6',1707824943,'{\"cookie\":{\"originalMaxAge\":1209600000,\"expires\":\"2024-02-13T11:49:02.556Z\",\"secure\":false,\"httpOnly\":false,\"path\":\"/\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('H-wykwmVmg0XncZmLfvXef4LWWUK4KOK',1707825525,'{\"cookie\":{\"originalMaxAge\":1209600000,\"expires\":\"2024-02-13T11:58:44.777Z\",\"secure\":true,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"None\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('HZusdw9K-QVoLdxUkxLa-CR-Q0Mlj_5-',1706700779,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('I_sLS4qjGTSvtlu6vZUSqz-NMpcE4Oh9',1706698459,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('JYwBQiJM5xnqyQ9W8fxpxW3dum-9uPdT',1707826339,'{\"cookie\":{\"originalMaxAge\":1209600000,\"expires\":\"2024-02-13T12:12:19.410Z\",\"secure\":true,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"None\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('K0MyXX-0VKWa3huVDndRas9YrchlyilF',1707828132,'{\"cookie\":{\"originalMaxAge\":1209600000,\"expires\":\"2024-02-13T12:42:11.837Z\",\"secure\":false,\"httpOnly\":false,\"path\":\"/\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('K6qP2PAdE5otcBpwlkgqU0TeFdfhg6Oh',1706695257,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('Kb9TjxSLchZskCv1jNtVfYskHzQg218k',1707826430,'{\"cookie\":{\"originalMaxAge\":1209600000,\"expires\":\"2024-02-13T12:13:49.736Z\",\"secure\":false,\"httpOnly\":false,\"path\":\"/\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('LV_NqMD4i_XmP4IHKXheJjNAFJ3YFzDh',1707824110,'{\"cookie\":{\"originalMaxAge\":1209600000,\"expires\":\"2024-02-13T11:35:09.843Z\",\"secure\":false,\"httpOnly\":false,\"path\":\"/\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('LyGFsIA43Y2ayv8lhbppvLjpL6hN6knL',1707826359,'{\"cookie\":{\"originalMaxAge\":1209600000,\"expires\":\"2024-02-13T12:12:38.705Z\",\"secure\":true,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"None\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('M4Q9NZYsZjcM6h-bb8jMayfN7S7EvtJ-',1707826360,'{\"cookie\":{\"originalMaxAge\":1209600000,\"expires\":\"2024-02-13T12:12:39.658Z\",\"secure\":true,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"None\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('P7ErQD0aXFIrbPDTdGxTNM49p7m_pIIL',1707829311,'{\"cookie\":{\"originalMaxAge\":1209600000,\"expires\":\"2024-02-13T13:01:50.969Z\",\"secure\":false,\"httpOnly\":false,\"path\":\"/\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('RbI205ccyoo81cTJZlkGYNbZxx5StPlI',1707828909,'{\"cookie\":{\"originalMaxAge\":1209600000,\"expires\":\"2024-02-13T12:55:08.982Z\",\"secure\":false,\"httpOnly\":false,\"path\":\"/\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('RozYWbkkf0727DtF082ItOn_RkB5pUfU',1707828791,'{\"cookie\":{\"originalMaxAge\":1209600000,\"expires\":\"2024-02-13T12:53:11.150Z\",\"secure\":false,\"httpOnly\":false,\"path\":\"/\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('UT27UQXMR0YhIJeFbB8O0_MckH8gu3Dc',1707826184,'{\"cookie\":{\"originalMaxAge\":1209600000,\"expires\":\"2024-02-13T12:09:44.341Z\",\"secure\":true,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"None\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('VEl5mVLkRsKWrLU56s7aBPgEcMiQtcnV',1706700663,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('VWROe5ORn9SqDMHviSn75i9SuqWGgbNt',1706696085,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('VxjE4vrNPihoBdPGfJ_rUv5Fi_b5T8-s',1706699928,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('X9JBR7UIa9Pn0Cx9_XoKWXWWXgOHQl67',1707824719,'{\"cookie\":{\"originalMaxAge\":1209600000,\"expires\":\"2024-02-13T11:45:19.099Z\",\"secure\":false,\"httpOnly\":false,\"path\":\"/\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('XStEwAlq3xWDyVoIZKL36URIeYBmXhOG',1707825882,'{\"cookie\":{\"originalMaxAge\":1209600000,\"expires\":\"2024-02-13T12:04:41.953Z\",\"secure\":true,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"None\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('YN9oSARtjN9wuPhqbGKBk0y7bWqpGc3_',1707826393,'{\"cookie\":{\"originalMaxAge\":1209600000,\"expires\":\"2024-02-13T12:13:13.426Z\",\"secure\":false,\"httpOnly\":false,\"path\":\"/\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('YTcTHOBBS0_SJJAIA52kcH2N0pZxsnNI',1706695565,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('bhhnaFIZajM95MT7XJfJaNLd4hEguQfE',1707826140,'{\"cookie\":{\"originalMaxAge\":1209600000,\"expires\":\"2024-02-13T12:09:00.135Z\",\"secure\":true,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"None\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('bja7PKwgG4PeSxUMCBlT5efI1G7cL6no',1707825246,'{\"cookie\":{\"originalMaxAge\":1209600000,\"expires\":\"2024-02-13T11:54:05.857Z\",\"secure\":true,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"None\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('ijWLM9JHxnM8sO4iCznPNmUdUSP0ZtMm',1707826361,'{\"cookie\":{\"originalMaxAge\":1209600000,\"expires\":\"2024-02-13T12:12:40.630Z\",\"secure\":true,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"None\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('kcUzN2LwH59Hb9AwDXlz0gATDCN1tZVT',1707826158,'{\"cookie\":{\"originalMaxAge\":1209600000,\"expires\":\"2024-02-13T12:09:17.881Z\",\"secure\":true,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"None\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('lR6YehRvohRQ4dMiGwnJfUteV02DQ7z8',1706700801,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('mXpx3X3ottKILd6m4yO5KUWKjueC9BuN',1707826165,'{\"cookie\":{\"originalMaxAge\":1209600000,\"expires\":\"2024-02-13T12:09:24.970Z\",\"secure\":true,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"None\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('n1D4fkRKWYn6da0kEQMWnJ1cq_3AzqFd',1707826167,'{\"cookie\":{\"originalMaxAge\":1209600000,\"expires\":\"2024-02-13T12:09:26.766Z\",\"secure\":true,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"None\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('o0ixhHJzToeLzfRtAxul2j2Soh-ojRx8',1707828678,'{\"cookie\":{\"originalMaxAge\":1209600000,\"expires\":\"2024-02-13T12:51:17.865Z\",\"secure\":false,\"httpOnly\":false,\"path\":\"/\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('om5l6Yan-2kf8uNo7qdPhfmHaxhaSfrC',1706698355,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('qA_puBWEddcmK0XrCq1Y-YRVFe2N9Eow',1706696547,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('tARXs_YiRPlPmGWlK7wV-sDuTl-NKKq1',1706699909,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('wP8gu0Uo2o2xfZm_0QvZt1CcW3tsMWF6',1707829236,'{\"cookie\":{\"originalMaxAge\":1209600000,\"expires\":\"2024-02-13T13:00:35.776Z\",\"secure\":false,\"httpOnly\":false,\"path\":\"/\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('xXIrJQyhkl7x7u4GrXITd7lqFNMVvOy5',1706698663,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('yOCvc736Tq_pxYE8zWzEidXpAG6pkf3G',1706700750,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('yiGHTHS8WuAi5ve1FPwQwS8ByXIJU8Uu',1706700619,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}'),('zWUqU29wjL_Y4tfXS1KHpBevZ3z1wx2J',1706698592,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"},\"user\":{\"userId\":1,\"email\":\"admin@voco.ee\",\"powerLevel\":2},\"loggedIn\":true}');
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-01-30 16:43:02
