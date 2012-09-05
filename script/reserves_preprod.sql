DROP TABLE IF EXISTS `assignments`;
CREATE TABLE `assignments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `role_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
INSERT INTO `assignments` VALUES (1,1,1,'2012-07-09 20:52:23','2012-07-09 20:52:23'),(2,2,7,'2012-09-04 21:12:11','2012-09-04 21:12:11');
DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
INSERT INTO `roles` VALUES (1,'Administrator','This role allows the user to create and update most objects in the system.','2012-07-09 20:52:05','2012-07-09 20:52:05'),(2,'Reserves Technician','The reserves technician can add and update courses, items, and student permissions.','2012-09-04 21:07:24','2012-09-04 21:07:24'),(3,'Faculty','A teaching or research faculty member of the university.','2012-09-04 21:07:57','2012-09-04 21:07:57'),(4,'Staff','A person who works for the University as a staff person.','2012-09-04 21:08:26','2012-09-04 21:08:26'),(5,'Graduate Student','A student who is enrolled in a graduate course of studies at the University.','2012-09-04 21:09:00','2012-09-04 21:09:00'),(6,'Undergraduate Student','A student who is enrolled in an undergraduate course of studies at the University.','2012-09-04 21:09:33','2012-09-04 21:09:33'),(7,'Media Admin','A person responsible for the digitization of multimedia materials that are incorporated into the reserves system.','2012-09-04 21:11:57','2012-09-04 21:11:57');
DROP TABLE IF EXISTS `schema_migrations`;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
INSERT INTO `schema_migrations` VALUES ('20120618210515'),('20120621182135'),('20120621185142'),('20120706195736'),('20120710151041'),('20120723202005'),('20120816162945'),('20120820183857'),('20120820184700');
DROP TABLE IF EXISTS `semesters`;
CREATE TABLE `semesters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) DEFAULT NULL,
  `full_name` varchar(255) DEFAULT NULL,
  `date_begin` date DEFAULT NULL,
  `date_end` date DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `display_name` varchar(255) DEFAULT NULL,
  `email` varchar(255) NOT NULL DEFAULT '',
  `sign_in_count` int(11) DEFAULT '0',
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(255) DEFAULT NULL,
  `last_sign_in_ip` varchar(255) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_email` (`email`),
  UNIQUE KEY `index_users_on_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
INSERT INTO `users` VALUES (1,'Robert','Fox','Robert Fox','rfox2@nd.edu',11,'2012-09-04 19:10:12','2012-08-22 16:18:32','10.41.59.20','10.41.59.20','rfox2','2012-06-20 20:21:10','2012-09-04 19:10:12'),(2,'Patrick','Rader','Patrick Rader','prader@nd.edu',0,NULL,NULL,NULL,NULL,'prader','2012-09-04 21:03:05','2012-09-04 21:03:05');
DROP TABLE IF EXISTS `video_workflows`;
CREATE TABLE `video_workflows` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `needed_by` date DEFAULT NULL,
  `semester_id` int(11) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `course` varchar(255) DEFAULT NULL,
  `repeat_request` tinyint(1) DEFAULT NULL,
  `library_owned` tinyint(1) DEFAULT NULL,
  `language` varchar(255) DEFAULT NULL,
  `subtitles` tinyint(1) DEFAULT NULL,
  `note` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `workflow_state` varchar(255) DEFAULT NULL,
  `workflow_state_change_date` datetime DEFAULT NULL,
  `workflow_state_change_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
