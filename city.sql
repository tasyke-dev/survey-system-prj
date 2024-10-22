-- MySQL dump 10.13  Distrib 8.0.33, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: new_schema
-- ------------------------------------------------------
-- Server version	8.0.27

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `comment` text NOT NULL,
  `date` datetime NOT NULL,
  `user_id` int NOT NULL,
  `survey_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `comments_user_FK_idx` (`user_id`),
  KEY `comments_survey_FK_idx` (`survey_id`),
  CONSTRAINT `comments_survey_FK` FOREIGN KEY (`survey_id`) REFERENCES `survey` (`id`),
  CONSTRAINT `comments_user_FK` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
INSERT INTO `comments` VALUES (1,'test\n','2023-06-05 14:42:55',1,11);
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `media`
--

DROP TABLE IF EXISTS `media`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `media` (
  `id` int NOT NULL AUTO_INCREMENT,
  `link` varchar(45) DEFAULT NULL,
  `survey_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `media_survey_FK_idx` (`survey_id`),
  CONSTRAINT `media_survey_FK` FOREIGN KEY (`survey_id`) REFERENCES `survey` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media`
--

LOCK TABLES `media` WRITE;
/*!40000 ALTER TABLE `media` DISABLE KEYS */;
INSERT INTO `media` VALUES (1,'1_18.png',1),(2,'1_19.png',1),(3,'1_20.png',1),(4,'1_13.png',2),(5,'1_14.png',3),(6,'1_14.png',7),(7,'1_14.png',8),(8,'1_14.png',8),(9,'1_14.png',9),(10,'1_14.png',10),(11,'1_14.png',10),(12,'1_14.png',10),(13,'1_14.png',10),(14,'1_14.jpg',11),(15,'1_15.jpg',11),(16,'1_16.jpg',12),(17,'1_17.jpg',13),(18,'1_18.jpg',14),(19,'1_19.jpg',15),(20,'1_20.jpg',16),(21,'1_21.jpg',17),(22,'1_22.jpg',18),(23,'1_23.jpg',19);
/*!40000 ALTER TABLE `media` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rate`
--

DROP TABLE IF EXISTS `rate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rate` (
  `id` int NOT NULL AUTO_INCREMENT,
  `rate` int NOT NULL,
  `user_id` int NOT NULL,
  `survey_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `rate_user_id_idx` (`user_id`),
  KEY `rate_survey_id_idx` (`survey_id`),
  CONSTRAINT `rate_survey_id` FOREIGN KEY (`survey_id`) REFERENCES `survey` (`id`),
  CONSTRAINT `rate_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rate`
--

LOCK TABLES `rate` WRITE;
/*!40000 ALTER TABLE `rate` DISABLE KEYS */;
/*!40000 ALTER TABLE `rate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `survey`
--

DROP TABLE IF EXISTS `survey`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `survey` (
  `id` int NOT NULL AUTO_INCREMENT,
  `x` varchar(45) NOT NULL,
  `y` varchar(45) NOT NULL,
  `category` varchar(45) NOT NULL,
  `raiting` int NOT NULL,
  `comment` text,
  `date` datetime NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `survey_user_FK_idx` (`user_id`),
  CONSTRAINT `survey_user_FK` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `survey`
--

LOCK TABLES `survey` WRITE;
/*!40000 ALTER TABLE `survey` DISABLE KEYS */;
INSERT INTO `survey` VALUES (1,'51.5376276619903','-0.19082139401503054','Крыша | сосульки',10,'asdas','2023-06-05 06:18:17',1),(2,'48.68664750061867','44.44382583287284','Лестницы',10,'Круто!','2023-06-05 07:58:46',1),(3,'48.68664750061867','44.44382583287284','Лестницы',10,'Круто!','2023-06-05 07:58:55',1),(7,'48.75716475268262','44.37873242800281','Лестницы',4,'','2023-06-05 08:31:51',1),(8,'48.74308805477515','44.534098517212136','Крыша | сосульки',6,'sdas','2023-06-05 08:35:26',1),(9,'48.747998370982515','44.57638688629379','Крыша | сосульки',10,'123','2023-06-05 10:43:44',1),(10,'48.68319398762442','44.59034558842168','Лестницы',5,'1231','2023-06-05 12:00:09',1),(11,'48.728196238451744','44.58519739764492','Автобус',10,'asda','2023-06-05 12:03:06',1),(12,'48.71480467658473','44.51181296583725','Рельсы',3,'Плохие дороги','2023-06-06 13:20:49',1),(13,'48.7128236330052','44.51748074795648','Рельсы',3,'Плохие дороги','2023-06-06 13:20:58',1),(14,'48.70846778079215','44.51262494878517','Рельсы',3,'Плохие дороги','2023-06-06 13:21:02',1),(15,'48.70688275255823','44.51966673869087','Рельсы',3,'Плохие дороги','2023-06-06 13:21:06',1),(16,'48.68420396253203','44.478841791116395','Автобус',3,'','2023-06-06 13:24:30',1),(17,'48.68839427867576','44.48354917785481','Бар | клуб',3,'','2023-06-06 13:24:44',1),(18,'48.68644051137907','44.48805764090418','Снег | лед',3,'','2023-06-06 13:24:54',1),(19,'48.68964011969038','44.4864260066577','Кошка',10,'','2023-06-06 13:25:09',1);
/*!40000 ALTER TABLE `survey` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tags`
--

DROP TABLE IF EXISTS `tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tags` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tags` varchar(45) DEFAULT NULL,
  `survey_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tags_survey_FK_idx` (`survey_id`),
  CONSTRAINT `tags_survey_FK` FOREIGN KEY (`survey_id`) REFERENCES `survey` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tags`
--

LOCK TABLES `tags` WRITE;
/*!40000 ALTER TABLE `tags` DISABLE KEYS */;
INSERT INTO `tags` VALUES (1,'asd',1),(2,'zxc',1),(3,'zxc',1),(4,'Море',2),(5,'чилл',2),(6,'Море',3),(7,'чилл',3),(8,'asafa',8),(9,'asd',9),(10,'asda',9),(11,'asda',9),(12,'asd',10),(13,'ggs',10),(14,'adas',10),(15,'87',11),(16,'3',11),(17,'дороги',12),(18,'дороги',13),(19,'дороги',14),(20,'дороги',15);
/*!40000 ALTER TABLE `tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `login` varchar(30) NOT NULL,
  `password` varchar(32) NOT NULL,
  `name` varchar(45) NOT NULL,
  `priority` int NOT NULL,
  `mail` varchar(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `login_UNIQUE` (`login`),
  UNIQUE KEY `mail_UNIQUE` (`mail`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'root','root','root',1,'root@example.com'),(3,'root2','root','root',1,'root2@example.com'),(4,'root0','root0','root0',0,'root0@example.com'),(5,'root3','root3','root3',0,'root3@example.com'),(7,'root4','root4','root4',0,'root4@example.com');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-09-12 13:15:48
