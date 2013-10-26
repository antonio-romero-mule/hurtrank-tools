CREATE DATABASE  IF NOT EXISTS `hurtrank` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `hurtrank`;
-- MySQL dump 10.13  Distrib 5.5.16, for Win32 (x86)
--
-- Host: hurtrankdb.cpk4jjb2mzwd.us-west-2.rds.amazonaws.com    Database: hurtrank
-- ------------------------------------------------------
-- Server version	5.5.31

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
-- Table structure for table `dim_date`
--

DROP TABLE IF EXISTS `dim_date`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dim_date` (
  `date_key` int(11) NOT NULL,
  `date_value` date DEFAULT NULL,
  `date_iso` char(10) DEFAULT NULL,
  `year` smallint(6) DEFAULT NULL,
  `quarter` tinyint(4) DEFAULT NULL,
  `quarter_name` char(2) DEFAULT NULL,
  `month` tinyint(4) DEFAULT NULL,
  `month_name` varchar(10) DEFAULT NULL,
  `month_abbreviation` varchar(10) DEFAULT NULL,
  `week` char(2) DEFAULT NULL,
  `day_of_month` tinyint(4) DEFAULT NULL,
  `day_of_year` smallint(6) DEFAULT NULL,
  `day_of_week` smallint(6) DEFAULT NULL,
  `day_name` varchar(10) DEFAULT NULL,
  `day_abbreviation` varchar(10) DEFAULT NULL,
  `is_weekend` tinyint(4) DEFAULT NULL,
  `is_weekday` tinyint(4) DEFAULT NULL,
  `is_today` tinyint(4) DEFAULT NULL,
  `is_yesterday` tinyint(4) DEFAULT NULL,
  `is_this_week` tinyint(4) DEFAULT NULL,
  `is_last_week` tinyint(4) DEFAULT NULL,
  `is_this_month` tinyint(4) DEFAULT NULL,
  `is_last_month` tinyint(4) DEFAULT NULL,
  `is_this_year` tinyint(4) DEFAULT NULL,
  `is_last_year` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`date_key`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AVG_ROW_LENGTH=103;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-10-25 12:48:53
