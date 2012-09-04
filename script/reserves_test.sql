/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
DROP TABLE IF EXISTS `assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assignments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `role_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `assignments` DISABLE KEYS */;
/*!40000 ALTER TABLE `assignments` ENABLE KEYS */;
DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
INSERT INTO `assignments` VALUES (0,4,1,'2012-08-31 15:12:41','2012-08-31 15:12:41');
CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
INSERT INTO `roles` VALUES (1,'Administrator','This role allows the user to create and update most objects in the system.','2012-06-25 15:43:44','2012-06-25 15:55:23');
INSERT INTO `roles` VALUES (2,'Reserves Technician','The reserves technician can add and update courses, items, and student permissions.','2012-06-25 15:44:45','2012-06-25 15:44:45');
INSERT INTO `roles` VALUES (3,'Faculty','A teaching or research faculty member of the university.','2012-07-31 19:37:44','2012-07-31 19:37:44');
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

INSERT INTO `schema_migrations` VALUES ('20120618210515');
INSERT INTO `schema_migrations` VALUES ('20120621182135');
INSERT INTO `schema_migrations` VALUES ('20120621185142');
INSERT INTO `schema_migrations` VALUES ('20120706195736');
INSERT INTO `schema_migrations` VALUES ('20120710151041');
INSERT INTO `schema_migrations` VALUES ('20120723202005');
INSERT INTO `schema_migrations` VALUES ('20120816162945');
INSERT INTO `schema_migrations` VALUES ('20120820183857');
INSERT INTO `schema_migrations` VALUES ('20120820184700');
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
DROP TABLE IF EXISTS `semesters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `semesters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `full_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_begin` date DEFAULT NULL,
  `date_end` date DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
INSERT INTO `semesters` VALUES (1,'FA123','Fall 2012','2012-07-29','2012-11-29','2012-07-29 23:58:34','2012-07-29 23:58:34');
INSERT INTO `semesters` VALUES (2,'SP13','Spring 2013','2012-07-29','2012-11-29','2012-07-30 00:12:54','2012-07-30 00:12:54');

/*!40000 ALTER TABLE `semesters` DISABLE KEYS */;
/*!40000 ALTER TABLE `semesters` ENABLE KEYS */;
DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `display_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `sign_in_count` int(11) DEFAULT '0',
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `username` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_email` (`email`),
  UNIQUE KEY `index_users_on_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
INSERT INTO `users` VALUES (4,'Robert','Fox','Robert Fox','rfox2@nd.edu',24,'2012-08-22 14:28:46','2012-08-17 18:26:22','127.0.0.1','127.0.0.1','rfox2','2012-06-20 18:16:36','2012-08-22 14:28:46');
INSERT INTO `users` VALUES (5,'Tom','Hanstra','Tom Hanstra','hanstra@nd.edu',0,NULL,NULL,NULL,NULL,'hanstra','2012-06-25 19:09:18','2012-06-25 19:09:18');

/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
DROP TABLE IF EXISTS `video_workflows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `video_workflows` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `needed_by` date DEFAULT NULL,
  `semester_id` int(11) DEFAULT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `course` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `repeat_request` tinyint(1) DEFAULT NULL,
  `library_owned` tinyint(1) DEFAULT NULL,
  `language` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `subtitles` tinyint(1) DEFAULT NULL,
  `note` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `workflow_state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `workflow_state_change_date` datetime DEFAULT NULL,
  `workflow_state_change_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
INSERT INTO `video_workflows` VALUES (10,4,'2012-08-24',1,'Bubba','FA12 BUS 3023 01',0,1,'',NULL,'Lorem ipsum','2012-08-01 21:10:27','2012-08-28 14:03:01','digitized',NULL,NULL);
INSERT INTO `video_workflows` VALUES (13,4,'2012-08-31',1,'Banana Republic','SP13 CHEM 2003 01',0,1,'English',NULL,'Hurrry Hurry Hurry!','2012-08-13 20:40:50','2012-08-28 15:18:54','awaiting_cataloging','2012-08-28 15:18:54',4);
INSERT INTO `video_workflows` VALUES (14,4,'2012-08-31',1,'My Video','FA12 BUS 3023 01',0,0,'',NULL,'blah blah','2012-08-17 18:58:25','2012-08-28 14:08:54','converted','2012-08-28 14:08:54',1);
INSERT INTO `video_workflows` VALUES (15,4,'2012-09-03',1,'Bubba Smith','FA12 BUS 1001 01',NULL,NULL,NULL,NULL,NULL,'2012-08-20 20:04:49','2012-08-28 16:52:11','converted','2012-08-28 16:52:11',4);
INSERT INTO `video_workflows` VALUES (16,5,'2012-09-11',1,'Another cool video','FA12 THEO 3001 01',NULL,NULL,NULL,NULL,NULL,'2012-08-28 14:59:39','2012-08-28 15:06:09','new',NULL,5);

/*!40000 ALTER TABLE `video_workflows` DISABLE KEYS */;
/*!40000 ALTER TABLE `video_workflows` ENABLE KEYS */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

