CREATE DATABASE  IF NOT EXISTS `inventarioia` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `inventarioia`;
-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: inventarioia
-- ------------------------------------------------------
-- Server version	8.0.44

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
-- Table structure for table `categorias`
--

DROP TABLE IF EXISTS `categorias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categorias` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categorias`
--

LOCK TABLES `categorias` WRITE;
/*!40000 ALTER TABLE `categorias` DISABLE KEYS */;
INSERT INTO `categorias` VALUES (1,'Electrónica'),(2,'Accesorios'),(3,'Redes'),(4,'Almacenamiento'),(5,'Audio');
/*!40000 ALTER TABLE `categorias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `operaciones`
--

DROP TABLE IF EXISTS `operaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `operaciones` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_usuario` int DEFAULT NULL,
  `accion` text NOT NULL,
  `modulo` varchar(50) DEFAULT NULL,
  `fecha` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_usuario_operacion` (`id_usuario`),
  CONSTRAINT `fk_usuario_operacion` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `operaciones`
--

LOCK TABLES `operaciones` WRITE;
/*!40000 ALTER TABLE `operaciones` DISABLE KEYS */;
INSERT INTO `operaciones` VALUES (1,6,'Inició sesión en el sistema','AUTH','2026-04-27 22:44:03'),(2,6,'Cerró sesión','AUTH','2026-04-27 22:53:21'),(3,6,'Inició sesión en el sistema','AUTH','2026-04-27 22:53:31'),(4,6,'Inició sesión en el sistema','AUTH','2026-04-30 23:29:22'),(5,6,'Inició sesión en el sistema','AUTH','2026-04-30 23:35:06'),(6,6,'Realizó venta (ID Prod: 6 - Cant: 6)','VENTAS','2026-04-30 23:36:57'),(7,6,'Inició sesión en el sistema','AUTH','2026-05-01 08:08:28'),(8,6,'Inició sesión en el sistema','AUTH','2026-05-01 08:15:45'),(9,6,'Inició sesión en el sistema','AUTH','2026-05-01 08:20:40'),(10,6,'Inició sesión en el sistema','AUTH','2026-05-01 08:28:12'),(11,6,'Inició sesión en el sistema','AUTH','2026-05-01 08:33:11'),(12,6,'Inició sesión en el sistema','AUTH','2026-05-01 08:43:39'),(13,6,'Inició sesión en el sistema','AUTH','2026-05-05 21:04:43'),(14,6,'Realizó venta (ID Prod: 13 - Cant: 3)','VENTAS','2026-05-05 21:10:20'),(15,6,'Realizó venta (ID Prod: 2 - Cant: 1)','VENTAS','2026-05-05 21:10:49'),(16,6,'Realizó venta (ID Prod: 6 - Cant: 2)','VENTAS','2026-05-05 21:11:25'),(17,6,'Realizó venta (ID Prod: 5 - Cant: 1)','VENTAS','2026-05-05 21:11:54'),(18,6,'Realizó venta (ID Prod: 1 - Cant: 3)','VENTAS','2026-05-05 21:21:27');
/*!40000 ALTER TABLE `operaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productos`
--

DROP TABLE IF EXISTS `productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `productos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `codigo` varchar(50) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `id_categoria` int DEFAULT NULL,
  `precio_compra` decimal(10,2) NOT NULL,
  `precio_venta` decimal(10,2) NOT NULL,
  `stock_actual` int NOT NULL DEFAULT '0',
  `stock_minimo` int DEFAULT '5',
  `fecha_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_categoria` (`id_categoria`),
  CONSTRAINT `fk_categoria` FOREIGN KEY (`id_categoria`) REFERENCES `categorias` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productos`
--

LOCK TABLES `productos` WRITE;
/*!40000 ALTER TABLE `productos` DISABLE KEYS */;
INSERT INTO `productos` VALUES (1,'PROD-0001','Smartphone Samsung Galaxy A14',1,600.00,750.00,30,5,'2026-04-11 00:32:14'),(2,'PROD-0002','Laptop Lenovo IdeaPad 3',1,1500.00,1900.00,29,5,'2026-04-11 00:33:15'),(3,'PROD-0003','Mouse Inalámbrico Logitech M185',2,25.00,45.00,145,5,'2026-04-11 00:33:46'),(4,'PROD-0004','Tablet Lenovo Tab M10',1,450.00,580.00,18,5,'2026-04-30 22:19:40'),(5,'PROD-0005','Audífonos Sony WH-1000XM4',5,280.00,420.00,39,5,'2026-04-30 22:19:40'),(6,'PROD-0006','Teclado Mecánico Redragon K552',2,55.00,95.00,52,5,'2026-04-30 22:19:40'),(7,'PROD-0007','Router TP-Link Archer AX23',3,110.00,175.00,6,5,'2026-04-30 22:19:40'),(8,'PROD-0008','Disco SSD Kingston 480GB',4,90.00,145.00,50,5,'2026-04-30 22:19:40'),(9,'PROD-0009','Webcam Logitech C920',1,130.00,210.00,3,5,'2026-04-30 22:19:40'),(10,'PROD-0010','Cable HDMI 4K 2m',2,8.00,22.00,200,10,'2026-04-30 22:19:40'),(11,'PROD-0011','Hub USB-C 7 en 1',2,35.00,75.00,25,5,'2026-04-30 22:19:40'),(12,'PROD-0012','Monitor LG 24\" Full HD',1,480.00,680.00,8,3,'2026-04-30 22:19:40'),(13,'PROD-0013','Memoria RAM DDR4 8GB',4,55.00,95.00,32,5,'2026-04-30 22:19:40');
/*!40000 ALTER TABLE `productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `rol` enum('Jefe','Administrador','Vendedor') NOT NULL DEFAULT 'Vendedor',
  `estado` enum('Activo','Inactivo') NOT NULL DEFAULT 'Activo',
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,'Jhanok Leon','jhanok_jefe','scrypt:32768:8:1$Kcx0w8WI32AwU5CR$ed3e75871b695780598816f199042b08332145e39660233088b939527ecb822c954a6316279930f78f85f341b80f1464455589a19c6298e3b48f6540b6e9273c','Jefe','Activo','2026-04-12 18:50:17'),(2,'Marianna Mori','Mari_jefe','scrypt:32768:8:1$sdRkU0C3nwzDwePG$c75fe9871b695780598816f199042b08332145e39660233088b939527ecb822c954a6316279930f78f85f341b80f1464455589a19c6298e3b48f6540b6e9273c','Jefe','Activo','2026-04-14 17:12:56'),(3,'Oscar Piastri','oscar_admin','scrypt:32768:8:1$uSAJ5VLhbiOjSDHh$e333f8b3c94f57c858e38d789061099e078028776610787e9c5e3f4e3c3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f','Administrador','Activo','2026-04-13 00:34:13'),(4,'Lando Norris','norris_admin','scrypt:32768:8:1$fNUxtDKmXVJmC5tR$9365ea6216a69874e40283789061099e078028776610787e9c5e3f4e3c3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f','Administrador','Activo','2026-04-13 01:04:34'),(5,'Sergio Perez','perez_vendedor','scrypt:32768:8:1$qvJ7wAlRKFe6mwzk$414fba0f21469e3a6c17f16f393d254b83b9c7924d623230a133f9154f2427a9296e832962257d298f65879a95393962657876a91c12e841804108876c12e5f5','Vendedor','Activo','2026-04-12 21:56:44'),(6,'Marianna Mori','mari','scrypt:32768:8:1$WkMLdX19XFKOGYvr$5f4094a9011ae1aca13b5519a7d9d68df59821f44ba57d5a9e4e2735dbef7403527882e1f0409c08021328b64b2bf3ef885e2a009c27788c59f97892a6fff97e','Jefe','Activo','2026-04-27 22:42:52');
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ventas`
--

DROP TABLE IF EXISTS `ventas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ventas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_producto` int DEFAULT NULL,
  `cantidad` int NOT NULL,
  `precio_venta_historico` decimal(10,2) NOT NULL,
  `fecha_venta` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_producto_venta` (`id_producto`),
  CONSTRAINT `fk_producto_venta` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=116 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ventas`
--

LOCK TABLES `ventas` WRITE;
/*!40000 ALTER TABLE `ventas` DISABLE KEYS */;
INSERT INTO `ventas` VALUES (1,1,1,750.00,'2026-04-11 11:31:40'),(2,3,3,45.00,'2026-04-11 11:40:56'),(3,1,1,750.00,'2026-04-11 11:42:49'),(4,1,13,750.00,'2026-04-11 11:44:52'),(5,3,2,45.00,'2026-04-11 15:16:46'),(6,1,3,750.00,'2026-04-06 14:30:00'),(7,2,1,1900.00,'2026-04-08 10:15:00'),(8,1,2,750.00,'2026-04-10 18:45:00'),(9,1,2,750.00,'2026-04-13 08:51:55'),(10,1,1,750.00,'2026-04-11 11:31:40'),(11,3,3,45.00,'2026-04-11 11:40:56'),(12,1,1,750.00,'2026-04-11 11:42:49'),(13,1,13,750.00,'2026-04-11 11:44:52'),(14,3,2,45.00,'2026-04-11 15:16:46'),(15,1,3,750.00,'2026-04-06 14:30:00'),(16,2,1,1900.00,'2026-04-08 10:15:00'),(17,1,2,750.00,'2026-04-10 18:45:00'),(18,1,2,750.00,'2026-04-13 08:51:55'),(19,1,2,750.00,'2026-03-01 22:19:41'),(20,1,3,750.00,'2026-03-04 22:19:41'),(21,1,2,750.00,'2026-03-07 22:19:41'),(22,1,4,750.00,'2026-03-10 22:19:41'),(23,1,3,750.00,'2026-03-13 22:19:41'),(24,1,2,750.00,'2026-03-16 22:19:41'),(25,1,3,750.00,'2026-03-19 22:19:41'),(26,1,4,750.00,'2026-03-22 22:19:41'),(27,1,2,750.00,'2026-03-25 22:19:41'),(28,1,3,750.00,'2026-03-28 22:19:41'),(29,1,3,750.00,'2026-03-31 22:19:41'),(30,1,2,750.00,'2026-04-03 22:19:41'),(31,1,4,750.00,'2026-04-06 22:19:41'),(32,1,3,750.00,'2026-04-09 22:19:41'),(33,1,2,750.00,'2026-04-12 22:19:41'),(34,1,3,750.00,'2026-04-15 22:19:41'),(35,1,4,750.00,'2026-04-18 22:19:41'),(36,1,3,750.00,'2026-04-21 22:19:41'),(37,1,2,750.00,'2026-04-24 22:19:41'),(38,1,3,750.00,'2026-04-27 22:19:41'),(39,1,2,750.00,'2026-04-29 22:19:41'),(40,2,1,1900.00,'2026-03-06 22:19:41'),(41,2,1,1900.00,'2026-03-21 22:19:41'),(42,2,1,1900.00,'2026-04-05 22:19:41'),(43,2,1,1900.00,'2026-04-20 22:19:41'),(44,3,2,45.00,'2026-03-11 22:19:41'),(45,3,3,45.00,'2026-03-23 22:19:41'),(46,3,2,45.00,'2026-04-05 22:19:41'),(47,3,4,45.00,'2026-04-16 22:19:41'),(48,3,2,45.00,'2026-04-25 22:19:41'),(49,4,1,580.00,'2026-03-06 22:19:41'),(50,4,1,580.00,'2026-03-16 22:19:41'),(51,4,1,580.00,'2026-03-26 22:19:41'),(52,4,2,580.00,'2026-04-10 22:19:41'),(53,4,2,580.00,'2026-04-20 22:19:41'),(54,4,3,580.00,'2026-04-25 22:19:41'),(55,4,2,580.00,'2026-04-28 22:19:41'),(56,5,3,420.00,'2026-03-03 22:19:41'),(57,5,2,420.00,'2026-03-11 22:19:41'),(58,5,4,420.00,'2026-03-19 22:19:41'),(59,5,2,420.00,'2026-03-26 22:19:41'),(60,6,3,95.00,'2026-03-03 22:19:41'),(61,6,2,95.00,'2026-03-09 22:19:41'),(62,6,4,95.00,'2026-03-15 22:19:41'),(63,6,3,95.00,'2026-03-21 22:19:41'),(64,6,2,95.00,'2026-03-27 22:19:41'),(65,6,4,95.00,'2026-04-02 22:19:41'),(66,6,3,95.00,'2026-04-08 22:19:41'),(67,6,2,95.00,'2026-04-14 22:19:41'),(68,6,3,95.00,'2026-04-20 22:19:41'),(69,6,4,95.00,'2026-04-26 22:19:41'),(70,7,1,175.00,'2026-03-05 22:19:41'),(71,7,1,175.00,'2026-03-12 22:19:41'),(72,7,2,175.00,'2026-03-19 22:19:41'),(73,7,1,175.00,'2026-03-26 22:19:41'),(74,7,1,175.00,'2026-04-09 22:19:41'),(75,7,1,175.00,'2026-04-23 22:19:41'),(76,8,2,145.00,'2026-03-06 22:19:41'),(77,8,3,145.00,'2026-03-17 22:19:41'),(78,8,2,145.00,'2026-03-28 22:19:41'),(79,8,3,145.00,'2026-04-08 22:19:41'),(80,8,2,145.00,'2026-04-19 22:19:41'),(81,8,3,145.00,'2026-04-27 22:19:41'),(82,9,2,210.00,'2026-03-05 22:19:41'),(83,9,1,210.00,'2026-03-13 22:19:41'),(84,9,2,210.00,'2026-03-21 22:19:41'),(85,9,1,210.00,'2026-03-29 22:19:41'),(86,9,2,210.00,'2026-04-06 22:19:41'),(87,9,1,210.00,'2026-04-14 22:19:41'),(88,9,2,210.00,'2026-04-22 22:19:41'),(89,9,1,210.00,'2026-04-28 22:19:41'),(90,10,10,22.00,'2026-03-02 22:19:41'),(91,10,8,22.00,'2026-03-11 22:19:41'),(92,10,12,22.00,'2026-03-20 22:19:41'),(93,10,9,22.00,'2026-03-29 22:19:41'),(94,10,11,22.00,'2026-04-07 22:19:41'),(95,10,8,22.00,'2026-04-16 22:19:41'),(96,10,10,22.00,'2026-04-25 22:19:41'),(97,11,5,75.00,'2026-03-08 22:19:41'),(98,11,1,75.00,'2026-03-23 22:19:41'),(99,11,4,75.00,'2026-04-10 22:19:41'),(100,11,1,75.00,'2026-04-22 22:19:41'),(101,12,1,680.00,'2026-03-16 22:19:41'),(102,12,1,680.00,'2026-04-10 22:19:41'),(103,13,5,95.00,'2026-03-03 22:19:41'),(104,13,6,95.00,'2026-03-11 22:19:41'),(105,13,4,95.00,'2026-03-19 22:19:41'),(106,13,3,95.00,'2026-03-27 22:19:41'),(107,13,2,95.00,'2026-04-04 22:19:41'),(108,13,1,95.00,'2026-04-12 22:19:41'),(109,13,1,95.00,'2026-04-21 22:19:41'),(110,6,6,95.00,'2026-04-30 23:36:57'),(111,13,3,95.00,'2026-05-05 21:10:20'),(112,2,1,1900.00,'2026-05-05 21:10:49'),(113,6,2,95.00,'2026-05-05 21:11:25'),(114,5,1,420.00,'2026-05-05 21:11:54'),(115,1,3,750.00,'2026-05-05 21:21:27');
/*!40000 ALTER TABLE `ventas` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-05 22:02:53
