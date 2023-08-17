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
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(100) NOT NULL,
  `nickname` varchar(50) NOT NULL,
  `profile_img` varchar(200) DEFAULT NULL,
  `user_role` int NOT NULL DEFAULT '1',
  `bio` text,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `UK_ob8kqyqqgmefl0aco34akdtpe` (`email`),
  UNIQUE KEY `UK_n4swgcf30j6bmtb4l4cjryuym` (`nickname`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (4,'dbtjq1592000@naver.com','덕뱁니다','https://s3.ap-northeast-2.amazonaws.com/simda/img/profile/1697e34d-fa30-4440-be31-8bef2adde09a-profile.jpg',1,'hello'),(5,'emmajane@naver.com','짱구','https://s3.ap-northeast-2.amazonaws.com/simda/img/profile/fdd40af4-4493-4357-bbc3-7eaad7e0a3a5-profile.jpg',1,'맨덜리사는김짱구인데요'),(6,'wcyang8@kakao.com','wcy','https://s3.ap-northeast-2.amazonaws.com/simda/img/profile/fa1e8746-104d-40ee-b2dc-55b844a6f1e7-profile.jpg',1,'안녕하세요 반가워'),(7,'ababgusdk@daum.net','A709금쪽이들','https://s3.ap-northeast-2.amazonaws.com/simda/img/profile/12e78d7f-18d4-4e36-9a0c-0ab81e6fe313-profile.jpg',1,'^^심다 너무 재밌다^^'),(8,'qudcks2695@naver.com','하힘들다','https://s3.ap-northeast-2.amazonaws.com/simda/img/profile/1f789f54-549f-4367-b413-d79f0af6c9c1-profile.jpg',1,'null'),(9,'test@test','test123','test',2,'test입니다'),(14,'jeonht043@gmail.com','전현태','https://s3.ap-northeast-2.amazonaws.com/simda/img/profile/8330e9b5-ccc4-46a0-a7b1-8ed6b8703e9a-profile.jpg',1,'null'),(15,'jeonht97@naver.com','lsk','https://s3.ap-northeast-2.amazonaws.com/simda/img/profile/7dff4e85-da01-4af0-b1e6-7f7058ad08dc-profile.jpg',1,NULL),(16,'simda709@gmail.com','jht','https://s3.ap-northeast-2.amazonaws.com/simda/img/profile/461f9aac-76e7-4175-8288-74c26cf5e764-profile.jpg',1,NULL),(17,'qudcks8749@gmail.com','치킨맛','https://s3.ap-northeast-2.amazonaws.com/simda/img/profile/ff0da245-6252-4f91-a9e3-b66605da634d-profile.jpg',1,NULL),(18,'','jht043','https://s3.ap-northeast-2.amazonaws.com/simda/img/profile/ec947672-142c-470c-bbd0-fa014f6e57ab-profile.jpg',1,NULL),(19,'anorak@hanmail.net','김네다','https://s3.ap-northeast-2.amazonaws.com/simda/img/profile/dfe77816-f90d-4adf-8b18-288fa5711397-profile.jpg',1,'인리타 말고 김네다'),(20,'dohee4251@naver.com','또잉','https://s3.ap-northeast-2.amazonaws.com/simda/img/profile/50daeb38-6424-494d-b09b-2916f017771d-profile.jpg',1,'신기하네요'),(21,'hy020321@naver.com','강백호','https://s3.ap-northeast-2.amazonaws.com/simda/img/profile/e4f69c0f-e4ea-4bcc-a5b0-c91b4ce4e0bf-profile.jpg',1,'');
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

-- Dump completed on 2023-08-17  8:48:32
