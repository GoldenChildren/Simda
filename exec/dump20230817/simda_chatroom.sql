-- MySQL dump 10.13  Distrib 8.0.33, for Win64 (x86_64)
--
-- Host: i9a709.p.ssafy.io    Database: simda
-- ------------------------------------------------------
-- Server version	8.0.34

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
-- Table structure for table `chatroom`
--

DROP TABLE IF EXISTS `chatroom`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chatroom` (
  `chatroom_id` int NOT NULL AUTO_INCREMENT,
  `l_chat_id` int DEFAULT NULL,
  `user1_id` int DEFAULT NULL,
  `user2_id` int DEFAULT NULL,
  PRIMARY KEY (`chatroom_id`),
  KEY `FK2icg0meouvctn5wwy267oice0` (`l_chat_id`),
  KEY `FKefjmq3pqi2sjukgt6vffuam5i` (`user1_id`),
  KEY `FKdd98htgsdi29ygt6wgha4bp2n` (`user2_id`),
  CONSTRAINT `FK2icg0meouvctn5wwy267oice0` FOREIGN KEY (`l_chat_id`) REFERENCES `chat` (`chat_id`),
  CONSTRAINT `FKdd98htgsdi29ygt6wgha4bp2n` FOREIGN KEY (`user2_id`) REFERENCES `user` (`user_id`),
  CONSTRAINT `FKefjmq3pqi2sjukgt6vffuam5i` FOREIGN KEY (`user1_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chatroom`
--

LOCK TABLES `chatroom` WRITE;
/*!40000 ALTER TABLE `chatroom` DISABLE KEYS */;
INSERT INTO `chatroom` VALUES (3,4,4,5),(4,2,4,8),(5,NULL,5,8),(6,NULL,6,8),(7,NULL,7,8),(8,NULL,5,6);
/*!40000 ALTER TABLE `chatroom` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-08-17  8:48:31
