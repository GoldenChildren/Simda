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
-- Table structure for table `comment`
--

DROP TABLE IF EXISTS `comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comment` (
  `cmt_id` int NOT NULL AUTO_INCREMENT,
  `content` text NOT NULL,
  `feed_id` int DEFAULT NULL,
  `p_cmt_id` int DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `reg_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`cmt_id`),
  KEY `FKmq57ocw5jrw8rd2lot1g8t0v2` (`feed_id`),
  KEY `FK9yv3kagbwysr5n6jpn8fg0mrl` (`p_cmt_id`),
  KEY `FK8kcum44fvpupyw6f5baccx25c` (`user_id`),
  CONSTRAINT `FK8kcum44fvpupyw6f5baccx25c` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
  CONSTRAINT `FK9yv3kagbwysr5n6jpn8fg0mrl` FOREIGN KEY (`p_cmt_id`) REFERENCES `comment` (`cmt_id`),
  CONSTRAINT `FKmq57ocw5jrw8rd2lot1g8t0v2` FOREIGN KEY (`feed_id`) REFERENCES `feed` (`feed_id`)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment`
--

LOCK TABLES `comment` WRITE;
/*!40000 ALTER TABLE `comment` DISABLE KEYS */;
INSERT INTO `comment` VALUES (2,'이게 댓글이지',163,NULL,NULL,'2023-08-10 09:00:17'),(3,'이게 댓글이지',163,2,NULL,'2023-08-10 09:00:26'),(4,'good',165,NULL,5,'2023-08-11 09:59:40'),(5,'good',165,NULL,5,'2023-08-11 09:59:41'),(6,'good',165,NULL,5,'2023-08-11 09:59:42'),(7,'good',165,NULL,5,'2023-08-11 09:59:42'),(8,'good',165,NULL,5,'2023-08-11 09:59:43'),(9,'have a good day :)',164,NULL,5,'2023-08-11 10:01:24'),(10,'wow',167,NULL,5,'2023-08-11 10:32:57'),(11,'ㅁㅈㄷㄹ',168,NULL,NULL,'2023-08-11 10:39:41'),(12,'hello~',168,11,5,'2023-08-11 11:11:02'),(13,'hi^^',168,NULL,5,'2023-08-11 13:06:53'),(14,'안녕하세요~',168,11,5,'2023-08-11 13:24:18'),(15,'ㅎㅎㅎㅎㅎ',168,NULL,5,'2023-08-11 13:24:31'),(16,'ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ',168,13,5,'2023-08-11 13:24:49'),(17,'힘들다...',168,13,5,'2023-08-11 13:44:00'),(18,'왜 안되는걸까요',168,11,5,'2023-08-11 13:44:29'),(19,'답글 달기 테스트',168,11,5,'2023-08-11 14:13:50'),(20,'답글이 달리나요?',168,15,5,'2023-08-11 14:14:08'),(21,'댓글과 답글이 잘 달립니다.',168,NULL,5,'2023-08-11 14:14:24'),(22,'된다!!!!!!!!!!!!!!!',167,NULL,5,'2023-08-11 14:15:08'),(23,'긴 댓글을 달아봅시다. 긴 댓글을 등록했을 때, 등록이 정상적으로 되는지도 확인해 봅시다. 제발 오버플로우가 나지 않았으면 좋겠는데... 자동완성 짜증난당',166,NULL,5,'2023-08-11 14:36:20'),(24,'답글도 길게 달았을 때 정상적으로 올라가나요? 제발제발제발제발제발제발제발!!!!ㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠ',166,NULL,5,'2023-08-11 14:37:01'),(25,'답글도 길게 달았을 때 정상적으로 올라가나요? 제발제발제발제발제발제발제발!!!!ㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠ',166,NULL,5,'2023-08-11 14:37:03'),(26,'왜 답글로 안달리지... 덜덜덜더러덛러ㅓㄹ더ㅓ더러ㅓ 제발 잘 올라가라고~~~ㅠㅠㅠㅠㅠㅠ',166,NULL,5,'2023-08-11 14:37:44'),(27,'하하 수정을 잘못해서 그런거였다 정말 다행이다 이건 제대로 달리겠지?',166,26,5,'2023-08-11 14:39:56'),(28,'나는 댓글을 달고 있다',168,NULL,NULL,'2023-08-11 15:16:48'),(29,'나는 댓글을 달고 있다',168,NULL,NULL,'2023-08-11 15:16:52'),(30,'미드차이',168,NULL,4,'2023-08-11 15:19:15'),(31,'악플입니다',164,NULL,NULL,'2023-08-11 15:28:07'),(32,'나는 곰이다',168,30,4,'2023-08-11 15:32:24'),(33,'나는 곰이다',168,30,4,'2023-08-11 15:32:26'),(34,'나는 곰이다',168,30,4,'2023-08-11 15:32:26'),(35,'나는 곰이다',168,30,4,'2023-08-11 15:32:27'),(36,'나는 곰이다',168,30,4,'2023-08-11 15:32:27'),(37,'나는 곰이다',168,30,4,'2023-08-11 15:32:27'),(38,'등록됐으면 알려줘야죠',168,30,4,'2023-08-11 15:32:55'),(39,'댓글이 달아질까요?',169,NULL,5,'2023-08-11 15:53:15'),(40,'답글아 달려라ㅠㅠ',169,39,5,'2023-08-11 15:56:26'),(45,'신도림 조기축구회 끝나고 한 컷',173,NULL,4,'2023-08-12 17:42:37'),(47,'ㅎㅎ',178,NULL,4,'2023-08-14 11:13:15'),(48,'ㄹㄹㄹㄹㄹㄹ',179,NULL,NULL,'2023-08-14 12:28:25'),(49,'ㄹㄹㄹㄹㄹㄹ',179,48,NULL,'2023-08-14 12:28:32'),(51,'댓글 달아야쥥',179,NULL,5,'2023-08-14 13:29:46'),(52,'왤케 사람같지...',180,NULL,5,'2023-08-14 14:13:06'),(53,'누워있고 싶다',180,NULL,5,'2023-08-14 14:14:36'),(54,'짱구로 댓글달기',180,NULL,5,'2023-08-14 14:19:50'),(55,'악플달고 탈퇴하러갑니다',178,NULL,NULL,'2023-08-14 16:16:10'),(56,'탈퇴하러갑니다',178,NULL,NULL,'2023-08-14 16:16:22'),(57,'내 닉네임이 보인다면 무언가 문제가 있는것',178,47,NULL,'2023-08-14 16:18:14'),(62,'탈퇴한 사용자가 진짜로 탈퇴를 한건지 닉네임이 탈퇴한 사용자인지 모르겠네',178,55,5,'2023-08-14 17:31:25'),(67,'test',193,NULL,16,'2023-08-16 12:30:11'),(69,'사 주고나 말하지...?',208,NULL,19,'2023-08-16 19:48:44'),(70,'아직 안 먹었으면서',210,NULL,19,'2023-08-16 20:24:43');
/*!40000 ALTER TABLE `comment` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-08-17  8:48:33
