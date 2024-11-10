-- MySQL dump 10.13  Distrib 8.0.39, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: picadosya
-- ------------------------------------------------------
-- Server version	8.0.40

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
-- Current Database: `picadosya`
--

/*!40000 DROP DATABASE IF EXISTS `picadosya`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `picadosya` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `picadosya`;

--
-- Table structure for table `export_logs`
--

DROP TABLE IF EXISTS `export_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `export_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `owner_id` int NOT NULL,
  `export_type` enum('csv','other') NOT NULL,
  `export_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `owner_id` (`owner_id`),
  CONSTRAINT `export_logs_ibfk_1` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `export_logs`
--

LOCK TABLES `export_logs` WRITE;
/*!40000 ALTER TABLE `export_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `export_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `field_availability`
--

DROP TABLE IF EXISTS `field_availability`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `field_availability` (
  `id` int NOT NULL AUTO_INCREMENT,
  `field_id` int NOT NULL,
  `day_of_week` enum('monday','tuesday','wednesday','thursday','friday','saturday','sunday') NOT NULL,
  `start_time` timestamp NOT NULL,
  `end_time` timestamp NOT NULL,
  `available` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `idx_availability_field_day` (`field_id`,`day_of_week`),
  CONSTRAINT `field_availability_ibfk_1` FOREIGN KEY (`field_id`) REFERENCES `fields` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `field_availability`
--

LOCK TABLES `field_availability` WRITE;
/*!40000 ALTER TABLE `field_availability` DISABLE KEYS */;
INSERT INTO `field_availability` VALUES (1,1,'monday','2024-09-23 00:00:00','2024-12-24 00:00:00',1);
/*!40000 ALTER TABLE `field_availability` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `field_photos`
--

DROP TABLE IF EXISTS `field_photos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `field_photos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `field_id` int NOT NULL,
  `photo_url` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `field_id` (`field_id`),
  CONSTRAINT `field_photos_ibfk_1` FOREIGN KEY (`field_id`) REFERENCES `fields` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `field_photos`
--

LOCK TABLES `field_photos` WRITE;
/*!40000 ALTER TABLE `field_photos` DISABLE KEYS */;
INSERT INTO `field_photos` VALUES (1,1,'https://canchea.com/uy/wp-content/uploads/sites/2/2013/05/Aguada-Fútbol-5-Montevideo.jpg'),(2,1,'https://canchea.com/uy/wp-content/uploads/sites/2/2013/05/Aguada-Fútbol-5-Montevideo-1.jpg'),(3,2,'https://canchea.com/uy/wp-content/uploads/sites/2/2013/05/Aguada-Fútbol-5-Montevideo-1.jpg'),(4,2,'https://canchea.com/uy/wp-content/uploads/sites/2/2013/05/Aguada-Fútbol-5-Montevideo.jpg'),(5,2,'https://canchea.com/uy/wp-content/uploads/sites/2/2013/05/Aguada-Fútbol-5-Montevideo1.jpg'),(6,3,'photo1.jpg'),(7,3,'photo2.jpg');
/*!40000 ALTER TABLE `field_photos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `field_ratings`
--

DROP TABLE IF EXISTS `field_ratings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `field_ratings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `field_id` int NOT NULL,
  `user_id` int NOT NULL,
  `rating` int NOT NULL,
  `comment` text,
  `rating_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `idx_ratings_field` (`field_id`),
  CONSTRAINT `field_ratings_ibfk_1` FOREIGN KEY (`field_id`) REFERENCES `fields` (`id`) ON DELETE CASCADE,
  CONSTRAINT `field_ratings_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `field_ratings_chk_1` CHECK ((`rating` between 1 and 5))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `field_ratings`
--

LOCK TABLES `field_ratings` WRITE;
/*!40000 ALTER TABLE `field_ratings` DISABLE KEYS */;
/*!40000 ALTER TABLE `field_ratings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fields`
--

DROP TABLE IF EXISTS `fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fields` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `address` varchar(255) NOT NULL,
  `neighborhood` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `type` enum('5','7','11') NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `description` text,
  `logo_url` varchar(255) DEFAULT NULL,
  `average_rating` decimal(3,2) DEFAULT '0.00',
  `creation_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `available_days` varchar(14) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '1,2,3,4,5,6,7',
  PRIMARY KEY (`id`),
  KEY `idx_fields_location` (`latitude`,`longitude`),
  KEY `idx_fields_type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fields`
--

LOCK TABLES `fields` WRITE;
/*!40000 ALTER TABLE `fields` DISABLE KEYS */;
INSERT INTO `fields` VALUES (1,'Aguada Fútbol 5','Av. Gral. San Martín 2261','Aguada','2201 0927',0.00000000,0.00000000,'5',1500.00,'Aguada Fútbol 5 es un complejo con dos canchas de césped artificial con caucho de última generación.Tiene las dimensiones reglamentarias (15,5 m X 30 m ).Escuela de fútbol de 5 a 13 años y espacio para que festejar tu cumpleaños o evento.El complejo cuenta con vestuarios, baños y duchas; bebidas frías.Excelente atención.','https://canchea.com/uy/wp-content/uploads/sites/2/2013/05/aguada.png',0.00,'2024-10-23 00:00:00','1,2,3,4,5,6,7'),(2,'Aguada Fútbol 5','Av. Gral. San Martín 2261','Aguada','2201 0927',0.00000000,0.00000000,'5',1500.00,'Aguada Fútbol 5 es un complejo con dos canchas de césped artificial con caucho de última generación.Tiene las dimensiones reglamentarias (15,5 m X 30 m ).Escuela de fútbol de 5 a 13 años y espacio para que festejar tu cumpleaños o evento.El complejo cuenta con vestuarios, baños y duchas; bebidas frías.Excelente atención.','https://canchea.com/uy/wp-content/uploads/sites/2/2013/05/aguada.png',0.00,'2024-10-23 00:00:00','1,2,3,4,5,6,7'),(3,'Cancha Test','','','',0.00000000,0.00000000,'5',0.00,'','',0.00,'2024-10-24 00:00:00','1,4,7');
/*!40000 ALTER TABLE `fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `type` enum('reservation_confirmed','reservation_canceled','other') NOT NULL,
  `message` text NOT NULL,
  `sent_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `read_status` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_notifications_user` (`user_id`,`read_status`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `reservation_id` int NOT NULL,
  `user_id` int NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_method` enum('mercadopago') NOT NULL,
  `status` enum('pending','completed','failed') DEFAULT 'pending',
  `payment_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `mercadopago_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `reservation_id` (`reservation_id`),
  KEY `user_id` (`user_id`),
  KEY `idx_payments_status` (`status`),
  CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`reservation_id`) REFERENCES `reservations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `payments_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reservations`
--

DROP TABLE IF EXISTS `reservations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reservations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `field_id` int NOT NULL,
  `user_id` int NOT NULL,
  `date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `status` enum('reserved','canceled','completed') DEFAULT 'reserved',
  `reservation_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_unique_reservations` (`field_id`,`date`,`start_time`,`end_time`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `reservations_ibfk_1` FOREIGN KEY (`field_id`) REFERENCES `fields` (`id`) ON DELETE CASCADE,
  CONSTRAINT `reservations_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservations`
--

LOCK TABLES `reservations` WRITE;
/*!40000 ALTER TABLE `reservations` DISABLE KEYS */;
INSERT INTO `reservations` VALUES (1,2,2,'2024-10-15','19:00:00','23:00:00','reserved','2024-10-24 18:34:33'),(2,2,2,'2024-12-15','19:00:00','23:00:00','reserved','2024-10-24 19:04:41');
/*!40000 ALTER TABLE `reservations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales_statistics`
--

DROP TABLE IF EXISTS `sales_statistics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sales_statistics` (
  `id` int NOT NULL AUTO_INCREMENT,
  `owner_id` int NOT NULL,
  `month` int NOT NULL,
  `year` int NOT NULL,
  `total_reservations` int DEFAULT '0',
  `income` decimal(10,2) DEFAULT '0.00',
  PRIMARY KEY (`id`),
  KEY `idx_statistics_owner_date` (`owner_id`,`year`,`month`),
  CONSTRAINT `sales_statistics_ibfk_1` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `sales_statistics_chk_1` CHECK ((`month` between 1 and 12))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_statistics`
--

LOCK TABLES `sales_statistics` WRITE;
/*!40000 ALTER TABLE `sales_statistics` DISABLE KEYS */;
/*!40000 ALTER TABLE `sales_statistics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `services`
--

DROP TABLE IF EXISTS `services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `services` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `icon` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `services`
--

LOCK TABLES `services` WRITE;
/*!40000 ALTER TABLE `services` DISABLE KEYS */;
INSERT INTO `services` VALUES (1,'Bebidas',NULL),(2,'Cantina',NULL);
/*!40000 ALTER TABLE `services` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `services_fields`
--

DROP TABLE IF EXISTS `services_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `services_fields` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_field` int NOT NULL,
  `id_service` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_field` (`id_field`),
  KEY `id_service` (`id_service`),
  CONSTRAINT `services_fields_ibfk_1` FOREIGN KEY (`id_field`) REFERENCES `fields` (`id`) ON DELETE CASCADE,
  CONSTRAINT `services_fields_ibfk_2` FOREIGN KEY (`id_service`) REFERENCES `services` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `services_fields`
--

LOCK TABLES `services_fields` WRITE;
/*!40000 ALTER TABLE `services_fields` DISABLE KEYS */;
INSERT INTO `services_fields` VALUES (1,1,1),(2,1,2),(3,2,1),(4,2,2),(5,3,1),(6,3,2);
/*!40000 ALTER TABLE `services_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `token` varchar(255) NOT NULL,
  `creation_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `expiration_date` timestamp NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `sessions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `profile_picture_url` varchar(255) DEFAULT NULL,
  `role` enum('client','field','admin') NOT NULL,
  `position_player` varchar(100) NOT NULL,
  `age` int NOT NULL,
  `registration_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES 
(1, 'Admin', 'Admin', 'admin@picadosya.com', 'hashed_password', NULL, NULL, 'admin', 'mediocampista', 30, '2024-10-23 22:48:12'),
(2, 'User', 'User', 'user@gmail.com', 'hashed_password', NULL, NULL, 'client', 'delantero', 25, '2024-10-24 18:33:15');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'picadosya'
--

--
-- Dumping routines for database 'picadosya'
--
/*!50003 DROP PROCEDURE IF EXISTS `GetFieldReservationsByMonthAndId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `GetFieldReservationsByMonthAndId`(
    IN p_field_id INT,
    IN p_month VARCHAR(7) -- formato 'YYYY-MM'
)
BEGIN
    SELECT 
        f.id,
        f.name,
        f.address,
        COALESCE (f.neighborhood, ""),
        COALESCE (f.phone, ""),
        f.latitude,
        f.longitude,
        COALESCE (f.type, "5"),
        f.price,
        COALESCE (f.description, ""),
        COALESCE (f.logo_url, ""),
        f.average_rating,
        f.creation_date,
        f.available_days,
        COALESCE (GROUP_CONCAT(DISTINCT fp.photo_url), "") AS photos,
        COALESCE (GROUP_CONCAT(DISTINCT s.name), "") AS services,
        COALESCE (GROUP_CONCAT(DISTINCT CONCAT(fa.start_time, '-', fa.end_time)), "") AS unavailable_dates,
        COALESCE (GROUP_CONCAT(DISTINCT CONCAT('{date: ', r.date, ', start_time: ', r.start_time, ', end_time: ', r.end_time, '}')), "") AS reservations
    FROM 
        fields f
    LEFT JOIN 
        field_photos fp ON f.id = fp.field_id
    LEFT JOIN 
        services_fields sf ON f.id = sf.id_field
    LEFT JOIN 
        services s ON sf.id_service = s.id
    LEFT JOIN 
        field_availability fa ON f.id = fa.field_id 
        AND fa.end_time >= CONCAT(p_month, '-01')
    LEFT JOIN
        reservations r ON f.id = r.field_id
        AND r.date >= CONCAT(p_month, '-01')  -- Reservas desde el primer día del mes especificado en adelante
    WHERE 
        f.id = p_field_id
    GROUP BY 
        f.id, f.name, f.address, f.neighborhood, f.phone, f.type, f.price, f.description, f.logo_url, f.creation_date;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetFieldsByMonthWithLimitOffset` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `GetFieldsByMonthWithLimitOffset`(
    IN p_month VARCHAR(7), -- formato 'YYYY-MM'
    IN p_limit INT, -- Número de registros a devolver
    IN p_offset INT -- Registro desde donde empezar
)
BEGIN
    SELECT 
        f.id,
        f.name,
        f.address,
        COALESCE (f.neighborhood, ""),
        COALESCE (f.phone, ""),
        f.latitude,
        f.longitude,
        COALESCE (f.type, "5"),
        f.price,
        COALESCE (f.description, ""),
        COALESCE (f.logo_url, ""),
        f.average_rating,
        f.creation_date,
        f.available_days,
        COALESCE (GROUP_CONCAT(DISTINCT fp.photo_url), "") AS photos,
        COALESCE (GROUP_CONCAT(DISTINCT s.name), "") AS services,
        COALESCE (GROUP_CONCAT(DISTINCT CONCAT(fa.start_time, '-', fa.end_time)), "") AS unavailable_dates,
        COALESCE (GROUP_CONCAT(DISTINCT CONCAT('{date: ', r.date, ', start_time: ', r.start_time, ', end_time: ', r.end_time, '}')), "") AS reservations
    FROM 
        fields f
    LEFT JOIN 
        field_photos fp ON f.id = fp.field_id
    LEFT JOIN 
        services_fields sf ON f.id = sf.id_field
    LEFT JOIN 
        services s ON sf.id_service = s.id
    LEFT JOIN 
        field_availability fa ON f.id = fa.field_id 
        AND fa.end_time >= CONCAT(p_month, '-01')
    LEFT JOIN
        reservations r ON f.id = r.field_id
        AND r.date >= CONCAT(p_month, '-01') -- Reservas a partir del mes especificado
    GROUP BY 
        f.id, f.name, f.address, f.neighborhood, f.phone, f.type, f.price, f.description, f.logo_url, f.creation_date
    LIMIT p_limit OFFSET p_offset;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `InsertField` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `InsertField`(
    IN p_name VARCHAR(255),
    IN p_address VARCHAR(255),
    IN p_neighborhood VARCHAR(255),
    IN p_phone VARCHAR(50),
    IN p_latitude DECIMAL(10, 8),
    IN p_longitude DECIMAL(11, 8),
    IN p_type VARCHAR(50),
    IN p_price DECIMAL(10, 2),
    IN p_description TEXT,
    IN p_logo_url VARCHAR(255),
    IN p_creation_date DATE,
    IN p_available_days VARCHAR(14),
    IN p_photos TEXT,         -- Coma separada de URLs de fotos
    IN p_service_ids TEXT     -- Coma separada de IDs de servicios
)
BEGIN
    -- Insertar en la tabla 'fields'
    INSERT INTO fields (name, address, neighborhood, phone, latitude, longitude, type, price, description, logo_url, creation_date, available_days)
    VALUES (p_name, p_address, p_neighborhood, p_phone, p_latitude, p_longitude, p_type, p_price, p_description, p_logo_url, p_creation_date, p_available_days);
    
    -- Obtener el último id insertado (el id del campo)
    SET @field_id = LAST_INSERT_ID();
    
    -- Insertar en la tabla 'field_photos'
    -- Separar las fotos por comas y agregarlas
    WHILE LOCATE(',', p_photos) > 0 DO
        SET @photo_url = SUBSTRING_INDEX(p_photos, ',', 1);
        INSERT INTO field_photos (field_id, photo_url) VALUES (@field_id, @photo_url);
        SET p_photos = SUBSTRING(p_photos, LOCATE(',', p_photos) + 1);
    END WHILE;
    INSERT INTO field_photos (field_id, photo_url) VALUES (@field_id, p_photos); -- Última foto
    
    -- Insertar en la tabla 'services_fields' (asociar los IDs de servicios existentes)
    -- Separar los IDs de servicios por comas y agregarlos
    WHILE LOCATE(',', p_service_ids) > 0 DO
        SET @service_id = SUBSTRING_INDEX(p_service_ids, ',', 1);
        INSERT INTO services_fields (id_field, id_service) VALUES (@field_id, @service_id);
        SET p_service_ids = SUBSTRING(p_service_ids, LOCATE(',', p_service_ids) + 1);
    END WHILE;
    -- Insertar el último ID de servicio
    INSERT INTO services_fields (id_field, id_service) VALUES (@field_id, p_service_ids);
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-10-26 18:20:28
