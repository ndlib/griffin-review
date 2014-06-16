-- MySQL dump 10.13  Distrib 5.5.29, for osx10.6 (i386)
--
-- Host: localhost    Database: open_reserves_test
-- ------------------------------------------------------
-- Server version	5.5.29

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
-- Table structure for table `admin_users`
--

DROP TABLE IF EXISTS `admin_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin_users` (
  `ip_address` char(20) DEFAULT NULL,
  `userid` char(10) NOT NULL,
  `firstname` char(35) NOT NULL,
  `lastname` char(35) NOT NULL,
  `group_name` char(75) NOT NULL,
  `role` char(45) NOT NULL DEFAULT 'None',
  PRIMARY KEY (`userid`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_users`
--

LOCK TABLES `admin_users` WRITE;
/*!40000 ALTER TABLE `admin_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `admin_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course`
--

DROP TABLE IF EXISTS `course`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course` (
  `term` char(6) NOT NULL,
  `course_prefix` char(10) NOT NULL,
  `course_number` char(6) NOT NULL,
  `course_name` char(80) NOT NULL,
  `section_number` char(5) NOT NULL,
  `instructor_lastname` char(40) NOT NULL,
  `instructor_firstname` char(40) NOT NULL,
  `password` char(12) DEFAULT NULL,
  `modified_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `course_id` char(40) NOT NULL,
  `activation` char(1) NOT NULL DEFAULT '0',
  `group_name` char(75) NOT NULL DEFAULT 'Admin',
  `syncSystem` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`course_id`) USING BTREE,
  KEY `course` (`term`,`course_prefix`,`course_number`,`section_number`,`instructor_lastname`,`instructor_firstname`) USING BTREE,
  KEY `activation` (`activation`),
  KEY `course_number` (`course_number`),
  KEY `section_number` (`section_number`),
  KEY `group_name` (`group_name`),
  KEY `syncsystem` (`syncSystem`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course`
--

LOCK TABLES `course` WRITE;
/*!40000 ALTER TABLE `course` DISABLE KEYS */;
/*!40000 ALTER TABLE `course` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `crosslist`
--

DROP TABLE IF EXISTS `crosslist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `crosslist` (
  `crosslist_id` int(12) NOT NULL AUTO_INCREMENT,
  `course_id_parent` char(40) NOT NULL,
  `term_parent` char(6) NOT NULL,
  `course_id_child` char(40) NOT NULL,
  `term_child` char(6) NOT NULL,
  `course_prefix_child` char(10) NOT NULL,
  `course_number_child` char(6) NOT NULL,
  `course_name_child` char(80) NOT NULL,
  `section_number_child` char(5) NOT NULL,
  `instructor_lastname_child` char(40) NOT NULL,
  `instructor_firstname_child` char(40) NOT NULL,
  `modified_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `group_name` char(75) DEFAULT NULL,
  PRIMARY KEY (`crosslist_id`) USING BTREE,
  KEY `course_id_parent` (`course_id_parent`),
  KEY `term_parent` (`term_parent`),
  KEY `course_id_child` (`course_id_child`),
  KEY `term_child` (`term_child`),
  KEY `course_prefix_child` (`course_prefix_child`),
  KEY `course_number_child` (`course_number_child`),
  KEY `course_name_child` (`course_name_child`),
  KEY `section_number_child` (`section_number_child`),
  KEY `group_name` (`group_name`)
) ENGINE=MyISAM AUTO_INCREMENT=2628 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `crosslist`
--

LOCK TABLES `crosslist` WRITE;
/*!40000 ALTER TABLE `crosslist` DISABLE KEYS */;
/*!40000 ALTER TABLE `crosslist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doc_stats`
--

DROP TABLE IF EXISTS `doc_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `doc_stats` (
  `id` int(12) NOT NULL AUTO_INCREMENT,
  `ip_address` char(80) DEFAULT NULL,
  `access_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `course_id` char(40) DEFAULT NULL,
  `item_id` int(10) unsigned DEFAULT NULL,
  `filename` char(120) NOT NULL,
  `url` char(200) NOT NULL,
  `title` char(200) NOT NULL,
  `role` char(50) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=641468 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doc_stats`
--

LOCK TABLES `doc_stats` WRITE;
/*!40000 ALTER TABLE `doc_stats` DISABLE KEYS */;
/*!40000 ALTER TABLE `doc_stats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `groups`
--

DROP TABLE IF EXISTS `groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `groups` (
  `group_name` char(75) NOT NULL,
  PRIMARY KEY (`group_name`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groups`
--

LOCK TABLES `groups` WRITE;
/*!40000 ALTER TABLE `groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item`
--

DROP TABLE IF EXISTS `item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `item` (
  `item_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` char(150) NOT NULL,
  `author_firstname` char(35) DEFAULT NULL,
  `author_lastname` char(40) DEFAULT NULL,
  `author_middle_initial` char(25) DEFAULT NULL,
  `location` char(100) CHARACTER SET latin1 DEFAULT NULL,
  `url` varchar(1000) CHARACTER SET latin1 DEFAULT NULL,
  `size` varchar(20) CHARACTER SET latin1 DEFAULT NULL,
  `journal_name` char(100) DEFAULT NULL,
  `journal_volume` varchar(8) CHARACTER SET latin1 DEFAULT NULL,
  `journal_number` varchar(8) CHARACTER SET latin1 DEFAULT NULL,
  `journal_month` char(12) CHARACTER SET latin1 DEFAULT NULL,
  `year` char(9) CHARACTER SET latin1 DEFAULT NULL,
  `other_authors` char(128) DEFAULT NULL,
  `pages` char(50) CHARACTER SET latin1 DEFAULT NULL,
  `edition` char(25) DEFAULT NULL,
  `publisher` char(100) DEFAULT NULL,
  `display_note` text,
  `internal_note` text,
  `item_type` set('article','chapter','book','video','music','map','journal','mixed','computer file') NOT NULL,
  `book_title` char(120) DEFAULT NULL,
  `doc_type` varchar(45) DEFAULT NULL,
  `group_name` char(75) DEFAULT 'Admin',
  `sourceId` varchar(45) DEFAULT NULL,
  `syncSystem` varchar(45) DEFAULT NULL,
  `syncSystemAvailKey` varchar(45) DEFAULT NULL,
  `modifiedDate` datetime DEFAULT NULL,
  `physicalLocation` text,
  `issn` varchar(9) DEFAULT NULL,
  `isbn` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`item_id`) USING BTREE,
  KEY `location` (`location`),
  KEY `title` (`title`,`journal_name`) USING BTREE,
  KEY `doc_type` (`doc_type`)
) ENGINE=MyISAM AUTO_INCREMENT=87831 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item`
--

LOCK TABLES `item` WRITE;
/*!40000 ALTER TABLE `item` DISABLE KEYS */;
/*!40000 ALTER TABLE `item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_course_link`
--

DROP TABLE IF EXISTS `item_course_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `item_course_link` (
  `item_id` int(1) unsigned NOT NULL DEFAULT '0',
  `active` char(1) NOT NULL DEFAULT 'Y',
  `modified_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `course_id` char(40) NOT NULL,
  `item_sort` int(10) unsigned NOT NULL DEFAULT '0',
  `item_course_link_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `segment_id` int(10) unsigned DEFAULT NULL,
  `syncSystem` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`item_course_link_id`) USING BTREE,
  KEY `item_id` (`item_id`),
  KEY `course_id` (`course_id`)
) ENGINE=MyISAM AUTO_INCREMENT=110361 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_course_link`
--

LOCK TABLES `item_course_link` WRITE;
/*!40000 ALTER TABLE `item_course_link` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_course_link` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mime_type`
--

DROP TABLE IF EXISTS `mime_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mime_type` (
  `doc_type` char(10) NOT NULL,
  `mime_type` char(60) NOT NULL,
  PRIMARY KEY (`doc_type`),
  KEY `mime_type` (`mime_type`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mime_type`
--

LOCK TABLES `mime_type` WRITE;
/*!40000 ALTER TABLE `mime_type` DISABLE KEYS */;
/*!40000 ALTER TABLE `mime_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles` (
  `role` varchar(40) NOT NULL,
  `home` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `courses_add` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `courses_crosslist_add` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `courses_copy` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `courses_manage_content_add` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `courses_manage_content_create_section` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `courses_manage_content_delete_section` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `courses_search` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `courses_special_functions` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `courses_edit` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `courses_delete` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `items_add` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `items_copy` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `items_edit` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `items_delete` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `items_upload` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `items_copy_from_course` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `items_search` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `users_add` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `users_edit` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `users_delete` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `users_load` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `users_search` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `users_view_list` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `statistics` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `system_configuration` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `system_options` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `system_utilities` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `system_user_profiles` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `system_role_permissions` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `system_groups` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `system` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `courses` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `items` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `users` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `courses_crosslist_delete` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`role`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `segment`
--

DROP TABLE IF EXISTS `segment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `segment` (
  `segment_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `course_id` char(45) NOT NULL,
  `segment_name` char(100) DEFAULT NULL,
  `segment_sort` int(10) unsigned DEFAULT '0',
  PRIMARY KEY (`segment_id`)
) ENGINE=MyISAM AUTO_INCREMENT=646 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `segment`
--

LOCK TABLES `segment` WRITE;
/*!40000 ALTER TABLE `segment` DISABLE KEYS */;
/*!40000 ALTER TABLE `segment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `session`
--

DROP TABLE IF EXISTS `session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `session` (
  `session_id` varchar(30) NOT NULL,
  `userid` varchar(45) NOT NULL,
  `time_stamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`session_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `session`
--

LOCK TABLES `session` WRITE;
/*!40000 ALTER TABLE `session` DISABLE KEYS */;
/*!40000 ALTER TABLE `session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system`
--

DROP TABLE IF EXISTS `system`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `system` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `current_semester` char(6) DEFAULT NULL,
  `ui_bg_color` char(6) DEFAULT NULL,
  `ui_match_color1` char(6) DEFAULT NULL,
  `ui_match_color2` char(6) DEFAULT NULL,
  `auth_type` char(45) DEFAULT NULL,
  `system_status` char(10) DEFAULT NULL,
  `system_status_note` text,
  `file_access_path` varchar(120) DEFAULT NULL,
  `open_url_base` varchar(100) DEFAULT NULL,
  `open_url_image` varchar(100) DEFAULT NULL,
  `open_url_text` varchar(35) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 ROW_FORMAT=FIXED;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system`
--

LOCK TABLES `system` WRITE;
/*!40000 ALTER TABLE `system` DISABLE KEYS */;
/*!40000 ALTER TABLE `system` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system_stats`
--

DROP TABLE IF EXISTS `system_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `system_stats` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system_stats`
--

LOCK TABLES `system_stats` WRITE;
/*!40000 ALTER TABLE `system_stats` DISABLE KEYS */;
/*!40000 ALTER TABLE `system_stats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `userid_key` int(12) NOT NULL AUTO_INCREMENT,
  `course_id` char(40) NOT NULL DEFAULT '',
  `userid` char(10) DEFAULT NULL,
  `firstname` char(35) NOT NULL DEFAULT '',
  `lastname` char(35) NOT NULL DEFAULT '',
  `role` char(35) NOT NULL DEFAULT '',
  `status` char(35) DEFAULT 'Enrolled',
  `override` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`userid_key`) USING BTREE,
  KEY `course_id` (`userid`,`course_id`) USING BTREE,
  KEY `userid` (`userid`)
) ENGINE=MyISAM AUTO_INCREMENT=1629036 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-05-07 10:24:54
