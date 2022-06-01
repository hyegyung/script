-- MySQL dump 10.9
--
-- Host: localhost    Database: tmap_service
-- ------------------------------------------------------
-- Server version	5.1.53

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `TMAP_MAP_DOWN_QI_FROM_BUILD_VERSION`
--

DROP TABLE IF EXISTS `TMAP_MAP_DOWN_QI_FROM_BUILD_VERSION`;
CREATE TABLE `TMAP_MAP_DOWN_QI_FROM_BUILD_VERSION` (
  `date` char(12) NOT NULL,
  `tnapp_id` char(2) NOT NULL,
  `build_version` char(10) NOT NULL,
  `map_download_attempt` char(6) NOT NULL,
  `map_download_failcode` varchar(150) DEFAULT NULL,
  `map_download_time` char(20) NOT NULL,
  `app_working_time` char(20) NOT NULL,
  PRIMARY KEY (`date`,`build_version`,`tnapp_id`)
) ENGINE=MyISAM DEFAULT CHARSET=euckr;

--
-- Table structure for table `TMAP_MAP_DOWN_QI_FROM_MOBILE`
--

DROP TABLE IF EXISTS `TMAP_MAP_DOWN_QI_FROM_MOBILE`;
CREATE TABLE `TMAP_MAP_DOWN_QI_FROM_MOBILE` (
  `date` char(12) NOT NULL,
  `tnapp_id` char(2) NOT NULL,
  `mobile` char(10) NOT NULL,
  `map_download_attempt` char(6) NOT NULL,
  `map_download_failcode` varchar(150) DEFAULT NULL,
  `map_download_time` char(20) NOT NULL,
  `app_working_time` char(20) NOT NULL,
  PRIMARY KEY (`date`,`mobile`,`tnapp_id`)
) ENGINE=MyISAM DEFAULT CHARSET=euckr;

--
-- Table structure for table `TMAP_MAP_DOWN_QI_FROM_OS_NAME`
--

DROP TABLE IF EXISTS `TMAP_MAP_DOWN_QI_FROM_OS_NAME`;
CREATE TABLE `TMAP_MAP_DOWN_QI_FROM_OS_NAME` (
  `date` char(12) NOT NULL,
  `tnapp_id` char(2) NOT NULL,
  `os_name` char(2) NOT NULL,
  `map_download_attempt` char(6) NOT NULL,
  `map_download_failcode` varchar(150) DEFAULT NULL,
  `map_download_time` char(20) NOT NULL,
  `app_working_time` char(20) NOT NULL,
  PRIMARY KEY (`date`,`os_name`,`tnapp_id`)
) ENGINE=MyISAM DEFAULT CHARSET=euckr;

--
-- Table structure for table `TMAP_MAP_DOWN_QI_FROM_OS_VERSION`
--

DROP TABLE IF EXISTS `TMAP_MAP_DOWN_QI_FROM_OS_VERSION`;
CREATE TABLE `TMAP_MAP_DOWN_QI_FROM_OS_VERSION` (
  `date` char(12) NOT NULL,
  `tnapp_id` char(2) NOT NULL,
  `os_version` char(10) NOT NULL,
  `map_download_attempt` char(6) NOT NULL,
  `map_download_failcode` varchar(150) DEFAULT NULL,
  `map_download_time` char(20) NOT NULL,
  `app_working_time` char(20) NOT NULL,
  PRIMARY KEY (`date`,`os_version`,`tnapp_id`)
) ENGINE=MyISAM DEFAULT CHARSET=euckr;

--
-- Table structure for table `TMAP_MAP_DOWN_QI_FROM_TMAP_VERSION`
--

DROP TABLE IF EXISTS `TMAP_MAP_DOWN_QI_FROM_TMAP_VERSION`;
CREATE TABLE `TMAP_MAP_DOWN_QI_FROM_TMAP_VERSION` (
  `date` char(12) NOT NULL,
  `tnapp_id` char(2) NOT NULL,
  `tmap_version` char(10) NOT NULL,
  `map_download_attempt` char(6) NOT NULL,
  `map_download_failcode` varchar(150) DEFAULT NULL,
  `map_download_time` char(20) NOT NULL,
  `app_working_time` char(20) NOT NULL,
  PRIMARY KEY (`date`,`tmap_version`,`tnapp_id`)
) ENGINE=MyISAM DEFAULT CHARSET=euckr;

--
-- Table structure for table `TMAP_MAP_DOWN_QI_FROM_TOTAL`
--

DROP TABLE IF EXISTS `TMAP_MAP_DOWN_QI_FROM_TOTAL`;
CREATE TABLE `TMAP_MAP_DOWN_QI_FROM_TOTAL` (
  `date` char(12) NOT NULL,
  `tnapp_id` char(2) NOT NULL,
  `map_download_attempt` char(6) NOT NULL,
  `map_download_failcode` varchar(150) DEFAULT NULL,
  `map_download_time` char(20) NOT NULL,
  `app_working_time` char(20) NOT NULL,
  PRIMARY KEY (`date`,`tnapp_id`)
) ENGINE=MyISAM DEFAULT CHARSET=euckr;

--
-- Table structure for table `TMAP_QI_FROM_BUILD_VERSION`
--

DROP TABLE IF EXISTS `TMAP_QI_FROM_BUILD_VERSION`;
CREATE TABLE `TMAP_QI_FROM_BUILD_VERSION` (
  `date` char(12) NOT NULL,
  `service_code` char(2) NOT NULL,
  `attempt` char(6) NOT NULL,
  `failcode` varchar(150) DEFAULT NULL,
  `tnapp_id` char(2) NOT NULL,
  `build_version` char(10) NOT NULL,
  `lead_time` char(20) NOT NULL,
  `app_working_time` char(20) NOT NULL,
  PRIMARY KEY (`date`,`service_code`,`build_version`,`tnapp_id`)
) ENGINE=MyISAM DEFAULT CHARSET=euckr;

--
-- Table structure for table `TMAP_QI_FROM_MOBILE`
--

DROP TABLE IF EXISTS `TMAP_QI_FROM_MOBILE`;
CREATE TABLE `TMAP_QI_FROM_MOBILE` (
  `date` char(12) NOT NULL,
  `service_code` char(2) NOT NULL,
  `attempt` char(6) NOT NULL,
  `failcode` varchar(150) DEFAULT NULL,
  `tnapp_id` char(2) NOT NULL,
  `mobile` char(10) NOT NULL,
  `lead_time` char(20) NOT NULL,
  `app_working_time` char(20) NOT NULL,
  PRIMARY KEY (`date`,`service_code`,`mobile`,`tnapp_id`)
) ENGINE=MyISAM DEFAULT CHARSET=euckr;

--
-- Table structure for table `TMAP_QI_FROM_OS_NAME`
--

DROP TABLE IF EXISTS `TMAP_QI_FROM_OS_NAME`;
CREATE TABLE `TMAP_QI_FROM_OS_NAME` (
  `date` char(12) NOT NULL,
  `service_code` char(2) NOT NULL,
  `attempt` char(6) NOT NULL,
  `failcode` varchar(150) DEFAULT NULL,
  `tnapp_id` char(2) NOT NULL,
  `os_name` char(2) NOT NULL,
  `lead_time` char(20) NOT NULL,
  `app_working_time` char(20) NOT NULL,
  PRIMARY KEY (`date`,`service_code`,`os_name`,`tnapp_id`)
) ENGINE=MyISAM DEFAULT CHARSET=euckr;

--
-- Table structure for table `TMAP_QI_FROM_OS_VERSION`
--

DROP TABLE IF EXISTS `TMAP_QI_FROM_OS_VERSION`;
CREATE TABLE `TMAP_QI_FROM_OS_VERSION` (
  `date` char(12) NOT NULL,
  `service_code` char(2) NOT NULL,
  `attempt` char(6) NOT NULL,
  `failcode` varchar(150) DEFAULT NULL,
  `tnapp_id` char(2) NOT NULL,
  `os_version` char(10) NOT NULL,
  `lead_time` char(20) NOT NULL,
  `app_working_time` char(20) NOT NULL,
  PRIMARY KEY (`date`,`service_code`,`os_version`,`tnapp_id`)
) ENGINE=MyISAM DEFAULT CHARSET=euckr;

--
-- Table structure for table `TMAP_QI_FROM_TMAP_VERSION`
--

DROP TABLE IF EXISTS `TMAP_QI_FROM_TMAP_VERSION`;
CREATE TABLE `TMAP_QI_FROM_TMAP_VERSION` (
  `date` char(12) NOT NULL,
  `service_code` char(2) NOT NULL,
  `attempt` char(6) NOT NULL,
  `failcode` varchar(150) DEFAULT NULL,
  `tnapp_id` char(2) NOT NULL,
  `tmap_version` char(10) NOT NULL,
  `lead_time` char(20) NOT NULL,
  `app_working_time` char(20) NOT NULL,
  PRIMARY KEY (`date`,`service_code`,`tmap_version`,`tnapp_id`)
) ENGINE=MyISAM DEFAULT CHARSET=euckr;

--
-- Table structure for table `TMAP_QI_FROM_TOTAL`
--

DROP TABLE IF EXISTS `TMAP_QI_FROM_TOTAL`;
CREATE TABLE `TMAP_QI_FROM_TOTAL` (
  `date` char(12) NOT NULL,
  `service_code` char(2) NOT NULL,
  `attempt` char(6) NOT NULL,
  `failcode` varchar(150) DEFAULT NULL,
  `tnapp_id` char(2) NOT NULL,
  `lead_time` char(20) NOT NULL,
  `app_working_time` char(20) NOT NULL,
  PRIMARY KEY (`date`,`service_code`,`tnapp_id`)
) ENGINE=MyISAM DEFAULT CHARSET=euckr;

--
-- Table structure for table `TMAP_SAFE_QI_FROM_BUILD_VERSION`
--

DROP TABLE IF EXISTS `TMAP_SAFE_QI_FROM_BUILD_VERSION`;
CREATE TABLE `TMAP_SAFE_QI_FROM_BUILD_VERSION` (
  `date` char(12) NOT NULL,
  `tnapp_id` char(2) NOT NULL,
  `build_version` char(10) NOT NULL,
  `safe_guide_attempt` char(6) NOT NULL,
  `safe_guide_failcode` varchar(150) DEFAULT NULL,
  `safe_guide_download_time` char(20) NOT NULL,
  `app_working_time` char(20) NOT NULL,
  PRIMARY KEY (`date`,`build_version`,`tnapp_id`)
) ENGINE=MyISAM DEFAULT CHARSET=euckr;

--
-- Table structure for table `TMAP_SAFE_QI_FROM_MOBILE`
--

DROP TABLE IF EXISTS `TMAP_SAFE_QI_FROM_MOBILE`;
CREATE TABLE `TMAP_SAFE_QI_FROM_MOBILE` (
  `date` char(12) NOT NULL,
  `tnapp_id` char(2) NOT NULL,
  `mobile` char(10) NOT NULL,
  `safe_guide_attempt` char(6) NOT NULL,
  `safe_guide_failcode` varchar(150) DEFAULT NULL,
  `safe_guide_download_time` char(20) NOT NULL,
  `app_working_time` char(20) NOT NULL,
  PRIMARY KEY (`date`,`mobile`,`tnapp_id`)
) ENGINE=MyISAM DEFAULT CHARSET=euckr;

--
-- Table structure for table `TMAP_SAFE_QI_FROM_OS_NAME`
--

DROP TABLE IF EXISTS `TMAP_SAFE_QI_FROM_OS_NAME`;
CREATE TABLE `TMAP_SAFE_QI_FROM_OS_NAME` (
  `date` char(12) NOT NULL,
  `tnapp_id` char(2) NOT NULL,
  `os_name` char(2) NOT NULL,
  `safe_guide_attempt` char(6) NOT NULL,
  `safe_guide_failcode` varchar(150) DEFAULT NULL,
  `safe_guide_download_time` char(20) NOT NULL,
  `app_working_time` char(20) NOT NULL,
  PRIMARY KEY (`date`,`os_name`,`tnapp_id`)
) ENGINE=MyISAM DEFAULT CHARSET=euckr;

--
-- Table structure for table `TMAP_SAFE_QI_FROM_OS_VERSION`
--

DROP TABLE IF EXISTS `TMAP_SAFE_QI_FROM_OS_VERSION`;
CREATE TABLE `TMAP_SAFE_QI_FROM_OS_VERSION` (
  `date` char(12) NOT NULL,
  `tnapp_id` char(2) NOT NULL,
  `os_version` char(10) NOT NULL,
  `safe_guide_attempt` char(6) NOT NULL,
  `safe_guide_failcode` varchar(150) DEFAULT NULL,
  `safe_guide_download_time` char(20) NOT NULL,
  `app_working_time` char(20) NOT NULL,
  PRIMARY KEY (`date`,`os_version`,`tnapp_id`)
) ENGINE=MyISAM DEFAULT CHARSET=euckr;

--
-- Table structure for table `TMAP_SAFE_QI_FROM_TMAP_VERSION`
--

DROP TABLE IF EXISTS `TMAP_SAFE_QI_FROM_TMAP_VERSION`;
CREATE TABLE `TMAP_SAFE_QI_FROM_TMAP_VERSION` (
  `date` char(12) NOT NULL,
  `tnapp_id` char(2) NOT NULL,
  `tmap_version` char(10) NOT NULL,
  `safe_guide_attempt` char(6) NOT NULL,
  `safe_guide_failcode` varchar(150) DEFAULT NULL,
  `safe_guide_download_time` char(20) NOT NULL,
  `app_working_time` char(20) NOT NULL,
  PRIMARY KEY (`date`,`tmap_version`,`tnapp_id`)
) ENGINE=MyISAM DEFAULT CHARSET=euckr;

--
-- Table structure for table `TMAP_SAFE_QI_FROM_TOTAL`
--

DROP TABLE IF EXISTS `TMAP_SAFE_QI_FROM_TOTAL`;
CREATE TABLE `TMAP_SAFE_QI_FROM_TOTAL` (
  `date` char(12) NOT NULL,
  `tnapp_id` char(2) NOT NULL,
  `safe_guide_attempt` char(6) NOT NULL,
  `safe_guide_failcode` varchar(150) DEFAULT NULL,
  `safe_guide_download_time` char(20) NOT NULL,
  `app_working_time` char(20) NOT NULL,
  PRIMARY KEY (`date`,`tnapp_id`)
) ENGINE=MyISAM DEFAULT CHARSET=euckr;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

