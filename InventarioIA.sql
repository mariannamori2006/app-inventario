CREATE DATABASE  IF NOT EXISTS `inventarioia` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `inventarioia`;
-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: inventarioia
-- ------------------------------------------------------
-- Server version	5.5.5-10.4.32-MariaDB

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
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
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
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_usuario` int(11) DEFAULT NULL,
  `accion` text NOT NULL,
  `modulo` varchar(50) DEFAULT NULL,
  `fecha` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fk_usuario_operacion` (`id_usuario`),
  CONSTRAINT `fk_usuario_operacion` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=78 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `operaciones`
--

LOCK TABLES `operaciones` WRITE;
/*!40000 ALTER TABLE `operaciones` DISABLE KEYS */;
INSERT INTO `operaciones` VALUES (1,6,'Inició sesión en el sistema','AUTH','2026-04-27 22:44:03'),(2,6,'Cerró sesión','AUTH','2026-04-27 22:53:21'),(3,6,'Inició sesión en el sistema','AUTH','2026-04-27 22:53:31'),(4,6,'Inició sesión en el sistema','AUTH','2026-04-30 23:29:22'),(5,6,'Inició sesión en el sistema','AUTH','2026-04-30 23:35:06'),(6,6,'Realizó venta (ID Prod: 6 - Cant: 6)','VENTAS','2026-04-30 23:36:57'),(7,6,'Inició sesión en el sistema','AUTH','2026-05-01 08:08:28'),(8,6,'Inició sesión en el sistema','AUTH','2026-05-01 08:15:45'),(9,6,'Inició sesión en el sistema','AUTH','2026-05-01 08:20:40'),(10,6,'Inició sesión en el sistema','AUTH','2026-05-01 08:28:12'),(11,6,'Inició sesión en el sistema','AUTH','2026-05-01 08:33:11'),(12,6,'Inició sesión en el sistema','AUTH','2026-05-01 08:43:39'),(13,6,'Inició sesión en el sistema','AUTH','2026-05-05 21:04:43'),(14,6,'Realizó venta (ID Prod: 13 - Cant: 3)','VENTAS','2026-05-05 21:10:20'),(15,6,'Realizó venta (ID Prod: 2 - Cant: 1)','VENTAS','2026-05-05 21:10:49'),(16,6,'Realizó venta (ID Prod: 6 - Cant: 2)','VENTAS','2026-05-05 21:11:25'),(17,6,'Realizó venta (ID Prod: 5 - Cant: 1)','VENTAS','2026-05-05 21:11:54'),(18,6,'Realizó venta (ID Prod: 1 - Cant: 3)','VENTAS','2026-05-05 21:21:27'),(19,6,'Inició sesión en el sistema','AUTH','2026-05-18 23:10:54'),(20,6,'Inició sesión en el sistema','AUTH','2026-05-20 17:57:01'),(21,6,'Editó producto ID 5: Audífonos Sony WH-1000XM4','INVENTARIO','2026-05-20 19:19:01'),(22,6,'Subió imagen para producto ID 5','INVENTARIO','2026-05-20 19:19:04'),(23,6,'Editó producto ID 5: Audífonos Sony WH-1000XM4','INVENTARIO','2026-05-20 19:19:19'),(24,6,'Editó producto ID 5: Audífonos Sony WH-1000XM4','INVENTARIO','2026-05-20 19:28:24'),(25,6,'Subió imagen para producto ID 5','INVENTARIO','2026-05-20 19:28:24'),(26,6,'Editó producto ID 5: Audífonos Sony WH-1000XM4','INVENTARIO','2026-05-20 19:31:13'),(27,6,'Editó producto ID 10: Cable HDMI 4K 2m','INVENTARIO','2026-05-20 19:33:37'),(28,6,'Subió imagen para producto ID 10','INVENTARIO','2026-05-20 19:33:37'),(29,6,'Editó producto ID 8: Disco SSD Kingston 480GB','INVENTARIO','2026-05-20 19:34:59'),(30,6,'Subió imagen para producto ID 8','INVENTARIO','2026-05-20 19:34:59'),(31,6,'Editó producto ID 11: Hub USB-C 7 en 1','INVENTARIO','2026-05-20 19:36:31'),(32,6,'Subió imagen para producto ID 11','INVENTARIO','2026-05-20 19:36:31'),(33,6,'Editó producto ID 2: Laptop Lenovo IdeaPad 3','INVENTARIO','2026-05-20 19:37:17'),(34,6,'Subió imagen para producto ID 2','INVENTARIO','2026-05-20 19:37:17'),(35,6,'Editó producto ID 13: Memoria RAM DDR4 8GB','INVENTARIO','2026-05-20 19:38:04'),(36,6,'Subió imagen para producto ID 13','INVENTARIO','2026-05-20 19:38:04'),(37,6,'Editó producto ID 12: Monitor LG 24\" Full HD','INVENTARIO','2026-05-20 19:38:57'),(38,6,'Subió imagen para producto ID 12','INVENTARIO','2026-05-20 19:38:57'),(39,6,'Editó producto ID 3: Mouse Inalámbrico Logitech M185','INVENTARIO','2026-05-20 19:40:29'),(40,6,'Subió imagen para producto ID 3','INVENTARIO','2026-05-20 19:40:29'),(41,6,'Editó producto ID 7: Router TP-Link Archer AX23','INVENTARIO','2026-05-20 19:41:26'),(42,6,'Subió imagen para producto ID 7','INVENTARIO','2026-05-20 19:41:26'),(43,6,'Editó producto ID 1: Smartphone Samsung Galaxy A14','INVENTARIO','2026-05-20 19:42:39'),(44,6,'Subió imagen para producto ID 1','INVENTARIO','2026-05-20 19:42:39'),(45,6,'Editó producto ID 4: Tablet Lenovo Tab M10','INVENTARIO','2026-05-20 19:43:37'),(46,6,'Subió imagen para producto ID 4','INVENTARIO','2026-05-20 19:43:37'),(47,6,'Editó producto ID 6: Teclado Mecánico Redragon K552','INVENTARIO','2026-05-20 19:44:30'),(48,6,'Subió imagen para producto ID 6','INVENTARIO','2026-05-20 19:44:30'),(49,6,'Editó producto ID 9: Webcam Logitech C920','INVENTARIO','2026-05-20 19:45:05'),(50,6,'Subió imagen para producto ID 9','INVENTARIO','2026-05-20 19:45:05'),(51,6,'Editó producto ID 5: Audífonos Sony WH-1000XM4','INVENTARIO','2026-05-20 19:45:13'),(52,6,'Realizó venta (ID Prod: 9 - Cant: 1)','VENTAS','2026-05-22 19:42:05'),(53,6,'Inició sesión en el sistema','AUTH','2026-05-22 22:35:40'),(54,6,'Inició sesión en el sistema','AUTH','2026-05-23 00:22:45'),(55,6,'Inició sesión en el sistema','AUTH','2026-05-23 00:22:54'),(56,6,'Editó producto ID 16: Auriculares Gamer HyperX Cloud II','INVENTARIO','2026-05-23 00:23:27'),(57,6,'Subió imagen para producto ID 16','INVENTARIO','2026-05-23 00:23:27'),(58,6,'Editó producto ID 15: Cámara IP Tapo C200 360°','INVENTARIO','2026-05-23 00:23:36'),(59,6,'Editó producto ID 15: Cámara IP Tapo C200 360°','INVENTARIO','2026-05-23 00:23:47'),(60,6,'Subió imagen para producto ID 15','INVENTARIO','2026-05-23 00:23:47'),(61,6,'Inició sesión en el sistema','AUTH','2026-05-23 07:33:58'),(62,6,'Editó producto ID 18: Disco Duro Externo Seagate 1TB','INVENTARIO','2026-05-23 07:36:12'),(63,6,'Subió imagen para producto ID 18','INVENTARIO','2026-05-23 07:36:12'),(64,6,'Editó producto ID 14: Impresora HP LaserJet M110we','INVENTARIO','2026-05-23 07:36:59'),(65,6,'Subió imagen para producto ID 14','INVENTARIO','2026-05-23 07:36:59'),(66,6,'Editó producto ID 21: Memoria USB Kingston 64GB USB 3.2','INVENTARIO','2026-05-23 07:46:13'),(67,6,'Subió imagen para producto ID 21','INVENTARIO','2026-05-23 07:46:13'),(68,6,'Editó producto ID 23: Parlante Bluetooth JBL Go 3','INVENTARIO','2026-05-23 07:47:30'),(69,6,'Subió imagen para producto ID 23','INVENTARIO','2026-05-23 07:47:30'),(70,6,'Editó producto ID 22: Soporte Articulado para Monitor','INVENTARIO','2026-05-23 07:48:12'),(71,6,'Subió imagen para producto ID 22','INVENTARIO','2026-05-23 07:48:12'),(72,6,'Editó producto ID 20: Switch TP-Link 8 Puertos TL-SG108','INVENTARIO','2026-05-23 07:48:57'),(73,6,'Subió imagen para producto ID 20','INVENTARIO','2026-05-23 07:48:57'),(74,6,'Editó producto ID 17: Teclado Inalámbrico Logitech K380','INVENTARIO','2026-05-23 07:49:48'),(75,6,'Subió imagen para producto ID 17','INVENTARIO','2026-05-23 07:49:48'),(76,6,'Editó producto ID 19: UPS APC BX700U-LM 700VA','INVENTARIO','2026-05-23 07:50:25'),(77,6,'Subió imagen para producto ID 19','INVENTARIO','2026-05-23 07:50:25');
/*!40000 ALTER TABLE `operaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productos`
--

DROP TABLE IF EXISTS `productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `productos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `codigo` varchar(50) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `id_categoria` int(11) DEFAULT NULL,
  `precio_compra` decimal(10,2) NOT NULL,
  `precio_venta` decimal(10,2) NOT NULL,
  `stock_actual` int(11) NOT NULL DEFAULT 0,
  `stock_minimo` int(11) DEFAULT 5,
  `fecha_registro` datetime DEFAULT current_timestamp(),
  `imagen` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_categoria` (`id_categoria`),
  CONSTRAINT `fk_categoria` FOREIGN KEY (`id_categoria`) REFERENCES `categorias` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productos`
--

LOCK TABLES `productos` WRITE;
/*!40000 ALTER TABLE `productos` DISABLE KEYS */;
INSERT INTO `productos` VALUES (1,'PROD-0001','Smartphone Samsung Galaxy A14',1,600.00,750.00,30,5,'2026-04-11 00:32:14','producto_1.jpg'),(2,'PROD-0002','Laptop Lenovo IdeaPad 3',1,1500.00,1900.00,29,5,'2026-04-11 00:33:15','producto_2.webp'),(3,'PROD-0003','Mouse Inalámbrico Logitech M185',2,25.00,45.00,145,5,'2026-04-11 00:33:46','producto_3.webp'),(4,'PROD-0004','Tablet Lenovo Tab M10',1,450.00,580.00,18,5,'2026-04-30 22:19:40','producto_4.jpg'),(5,'PROD-0005','Audífonos Sony WH-1000XM4',5,280.00,420.00,39,5,'2026-04-30 22:19:40','producto_5.webp'),(6,'PROD-0006','Teclado Mecánico Redragon K552',2,55.00,95.00,52,5,'2026-04-30 22:19:40','producto_6.webp'),(7,'PROD-0007','Router TP-Link Archer AX23',3,110.00,175.00,2,5,'2026-04-30 22:19:40','producto_7.webp'),(8,'PROD-0008','Disco SSD Kingston 480GB',4,90.00,145.00,50,5,'2026-04-30 22:19:40','producto_8.webp'),(9,'PROD-0009','Webcam Logitech C920',1,130.00,210.00,1,5,'2026-04-30 22:19:40','producto_9.jpg'),(10,'PROD-0010','Cable HDMI 4K 2m',2,8.00,22.00,200,10,'2026-04-30 22:19:40','producto_10.webp'),(11,'PROD-0011','Hub USB-C 7 en 1',2,35.00,75.00,25,5,'2026-04-30 22:19:40','producto_11.webp'),(12,'PROD-0012','Monitor LG 24\" Full HD',1,480.00,680.00,8,3,'2026-04-30 22:19:40','producto_12.webp'),(13,'PROD-0013','Memoria RAM DDR4 8GB',4,55.00,95.00,32,5,'2026-04-30 22:19:40','producto_13.webp'),(14,'PROD-0014','Impresora HP LaserJet M110we',1,320.00,480.00,3,3,'2026-01-10 09:00:00','producto_14.webp'),(15,'PROD-0015','Cámara IP Tapo C200 360°',3,55.00,99.00,4,5,'2026-01-10 09:05:00','producto_15.jpg'),(16,'PROD-0016','Auriculares Gamer HyperX Cloud II',5,85.00,150.00,35,5,'2026-01-10 09:10:00','producto_16.jpg'),(17,'PROD-0017','Teclado Inalámbrico Logitech K380',2,38.00,70.00,60,5,'2026-01-10 09:15:00','producto_17.webp'),(18,'PROD-0018','Disco Duro Externo Seagate 1TB',4,95.00,155.00,45,5,'2026-01-10 09:20:00','producto_18.webp'),(19,'PROD-0019','UPS APC BX700U-LM 700VA',1,180.00,290.00,20,3,'2026-01-10 09:25:00','producto_19.webp'),(20,'PROD-0020','Switch TP-Link 8 Puertos TL-SG108',3,28.00,55.00,50,5,'2026-01-10 09:30:00','producto_20.webp'),(21,'PROD-0021','Memoria USB Kingston 64GB USB 3.2',4,8.00,22.00,120,10,'2026-01-10 09:35:00','producto_21.jpg'),(22,'PROD-0022','Soporte Articulado para Monitor',2,22.00,50.00,30,5,'2026-01-10 09:40:00','producto_22.jpg'),(23,'PROD-0023','Parlante Bluetooth JBL Go 3',5,35.00,75.00,55,5,'2026-01-10 09:45:00','producto_23.webp');
/*!40000 ALTER TABLE `productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `rol` enum('Jefe','Administrador','Vendedor') NOT NULL DEFAULT 'Vendedor',
  `estado` enum('Activo','Inactivo') NOT NULL DEFAULT 'Activo',
  `fecha_creacion` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
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
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_producto` int(11) DEFAULT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_venta_historico` decimal(10,2) NOT NULL,
  `fecha_venta` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fk_producto_venta` (`id_producto`),
  CONSTRAINT `fk_producto_venta` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=298 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ventas`
--

LOCK TABLES `ventas` WRITE;
/*!40000 ALTER TABLE `ventas` DISABLE KEYS */;
INSERT INTO `ventas` VALUES (1,1,1,750.00,'2026-04-11 11:31:40'),(2,3,3,45.00,'2026-04-11 11:40:56'),(3,1,1,750.00,'2026-04-11 11:42:49'),(4,1,13,750.00,'2026-04-11 11:44:52'),(5,3,2,45.00,'2026-04-11 15:16:46'),(6,1,3,750.00,'2026-04-06 14:30:00'),(7,2,1,1900.00,'2026-04-08 10:15:00'),(8,1,2,750.00,'2026-04-10 18:45:00'),(9,1,2,750.00,'2026-04-13 08:51:55'),(10,1,1,750.00,'2026-04-11 11:31:40'),(11,3,3,45.00,'2026-04-11 11:40:56'),(12,1,1,750.00,'2026-04-11 11:42:49'),(13,1,13,750.00,'2026-04-11 11:44:52'),(14,3,2,45.00,'2026-04-11 15:16:46'),(15,1,3,750.00,'2026-04-06 14:30:00'),(16,2,1,1900.00,'2026-04-08 10:15:00'),(17,1,2,750.00,'2026-04-10 18:45:00'),(18,1,2,750.00,'2026-04-13 08:51:55'),(19,1,2,750.00,'2026-03-01 22:19:41'),(20,1,3,750.00,'2026-03-04 22:19:41'),(21,1,2,750.00,'2026-03-07 22:19:41'),(22,1,4,750.00,'2026-03-10 22:19:41'),(23,1,3,750.00,'2026-03-13 22:19:41'),(24,1,2,750.00,'2026-03-16 22:19:41'),(25,1,3,750.00,'2026-03-19 22:19:41'),(26,1,4,750.00,'2026-03-22 22:19:41'),(27,1,2,750.00,'2026-03-25 22:19:41'),(28,1,3,750.00,'2026-03-28 22:19:41'),(29,1,3,750.00,'2026-03-31 22:19:41'),(30,1,2,750.00,'2026-04-03 22:19:41'),(31,1,4,750.00,'2026-04-06 22:19:41'),(32,1,3,750.00,'2026-04-09 22:19:41'),(33,1,2,750.00,'2026-04-12 22:19:41'),(34,1,3,750.00,'2026-04-15 22:19:41'),(35,1,4,750.00,'2026-04-18 22:19:41'),(36,1,3,750.00,'2026-04-21 22:19:41'),(37,1,2,750.00,'2026-04-24 22:19:41'),(38,1,3,750.00,'2026-04-27 22:19:41'),(39,1,2,750.00,'2026-04-29 22:19:41'),(40,2,1,1900.00,'2026-03-06 22:19:41'),(41,2,1,1900.00,'2026-03-21 22:19:41'),(42,2,1,1900.00,'2026-04-05 22:19:41'),(43,2,1,1900.00,'2026-04-20 22:19:41'),(44,3,2,45.00,'2026-03-11 22:19:41'),(45,3,3,45.00,'2026-03-23 22:19:41'),(46,3,2,45.00,'2026-04-05 22:19:41'),(47,3,4,45.00,'2026-04-16 22:19:41'),(48,3,2,45.00,'2026-04-25 22:19:41'),(49,4,1,580.00,'2026-03-06 22:19:41'),(50,4,1,580.00,'2026-03-16 22:19:41'),(51,4,1,580.00,'2026-03-26 22:19:41'),(52,4,2,580.00,'2026-04-10 22:19:41'),(53,4,2,580.00,'2026-04-20 22:19:41'),(54,4,3,580.00,'2026-04-25 22:19:41'),(55,4,2,580.00,'2026-04-28 22:19:41'),(56,5,3,420.00,'2026-03-03 22:19:41'),(57,5,2,420.00,'2026-03-11 22:19:41'),(58,5,4,420.00,'2026-03-19 22:19:41'),(59,5,2,420.00,'2026-03-26 22:19:41'),(60,6,3,95.00,'2026-03-03 22:19:41'),(61,6,2,95.00,'2026-03-09 22:19:41'),(62,6,4,95.00,'2026-03-15 22:19:41'),(63,6,3,95.00,'2026-03-21 22:19:41'),(64,6,2,95.00,'2026-03-27 22:19:41'),(65,6,4,95.00,'2026-04-02 22:19:41'),(66,6,3,95.00,'2026-04-08 22:19:41'),(67,6,2,95.00,'2026-04-14 22:19:41'),(68,6,3,95.00,'2026-04-20 22:19:41'),(69,6,4,95.00,'2026-04-26 22:19:41'),(70,7,1,175.00,'2026-03-05 22:19:41'),(71,7,1,175.00,'2026-03-12 22:19:41'),(72,7,2,175.00,'2026-03-19 22:19:41'),(73,7,1,175.00,'2026-03-26 22:19:41'),(74,7,1,175.00,'2026-04-09 22:19:41'),(75,7,1,175.00,'2026-04-23 22:19:41'),(76,8,2,145.00,'2026-03-06 22:19:41'),(77,8,3,145.00,'2026-03-17 22:19:41'),(78,8,2,145.00,'2026-03-28 22:19:41'),(79,8,3,145.00,'2026-04-08 22:19:41'),(80,8,2,145.00,'2026-04-19 22:19:41'),(81,8,3,145.00,'2026-04-27 22:19:41'),(82,9,2,210.00,'2026-03-05 22:19:41'),(83,9,1,210.00,'2026-03-13 22:19:41'),(84,9,2,210.00,'2026-03-21 22:19:41'),(85,9,1,210.00,'2026-03-29 22:19:41'),(86,9,2,210.00,'2026-04-06 22:19:41'),(87,9,1,210.00,'2026-04-14 22:19:41'),(88,9,2,210.00,'2026-04-22 22:19:41'),(89,9,1,210.00,'2026-04-28 22:19:41'),(90,10,10,22.00,'2026-03-02 22:19:41'),(91,10,8,22.00,'2026-03-11 22:19:41'),(92,10,12,22.00,'2026-03-20 22:19:41'),(93,10,9,22.00,'2026-03-29 22:19:41'),(94,10,11,22.00,'2026-04-07 22:19:41'),(95,10,8,22.00,'2026-04-16 22:19:41'),(96,10,10,22.00,'2026-04-25 22:19:41'),(97,11,5,75.00,'2026-03-08 22:19:41'),(98,11,1,75.00,'2026-03-23 22:19:41'),(99,11,4,75.00,'2026-04-10 22:19:41'),(100,11,1,75.00,'2026-04-22 22:19:41'),(101,12,1,680.00,'2026-03-16 22:19:41'),(102,12,1,680.00,'2026-04-10 22:19:41'),(103,13,5,95.00,'2026-03-03 22:19:41'),(104,13,6,95.00,'2026-03-11 22:19:41'),(105,13,4,95.00,'2026-03-19 22:19:41'),(106,13,3,95.00,'2026-03-27 22:19:41'),(107,13,2,95.00,'2026-04-04 22:19:41'),(108,13,1,95.00,'2026-04-12 22:19:41'),(109,13,1,95.00,'2026-04-21 22:19:41'),(110,6,6,95.00,'2026-04-30 23:36:57'),(111,13,3,95.00,'2026-05-05 21:10:20'),(112,2,1,1900.00,'2026-05-05 21:10:49'),(113,6,2,95.00,'2026-05-05 21:11:25'),(114,5,1,420.00,'2026-05-05 21:11:54'),(115,1,3,750.00,'2026-05-05 21:21:27'),(116,1,2,750.00,'2026-04-18 18:49:04'),(117,1,3,750.00,'2026-04-22 18:49:04'),(118,1,2,750.00,'2026-04-26 18:49:04'),(119,1,3,750.00,'2026-04-30 18:49:04'),(120,1,2,750.00,'2026-05-04 18:49:04'),(121,1,3,750.00,'2026-05-08 18:49:04'),(122,1,2,750.00,'2026-05-12 18:49:04'),(123,1,3,750.00,'2026-05-15 18:49:04'),(124,1,2,750.00,'2026-05-16 18:49:04'),(125,9,1,210.00,'2026-04-19 18:49:04'),(126,9,1,210.00,'2026-04-27 18:49:04'),(127,9,1,210.00,'2026-05-05 18:49:04'),(128,9,1,210.00,'2026-05-13 18:49:04'),(129,6,3,95.00,'2026-04-20 18:49:04'),(130,6,2,95.00,'2026-04-27 18:49:04'),(131,6,4,95.00,'2026-05-04 18:49:04'),(132,6,3,95.00,'2026-05-11 18:49:04'),(133,6,2,95.00,'2026-05-16 18:49:04'),(134,10,8,22.00,'2026-04-21 18:49:04'),(135,10,10,22.00,'2026-04-29 18:49:04'),(136,10,7,22.00,'2026-05-07 18:49:04'),(137,10,9,22.00,'2026-05-14 18:49:04'),(138,8,2,145.00,'2026-04-22 18:49:04'),(139,8,3,145.00,'2026-05-02 18:49:04'),(140,8,2,145.00,'2026-05-12 18:49:04'),(141,3,3,45.00,'2026-04-23 18:49:04'),(142,3,2,45.00,'2026-05-05 18:49:04'),(143,3,3,45.00,'2026-05-15 18:49:04'),(144,4,1,580.00,'2026-04-19 18:49:04'),(145,4,2,580.00,'2026-04-29 18:49:04'),(146,4,2,580.00,'2026-05-09 18:49:04'),(147,4,3,580.00,'2026-05-15 18:49:04'),(148,13,2,95.00,'2026-04-25 18:49:04'),(149,13,1,95.00,'2026-05-09 18:49:04'),(150,11,3,75.00,'2026-04-27 18:49:04'),(151,11,1,75.00,'2026-05-12 18:49:04'),(152,12,1,680.00,'2026-05-02 18:49:04'),(153,1,2,750.00,'2026-05-17 18:49:04'),(154,6,1,95.00,'2026-05-17 18:49:04'),(155,10,5,22.00,'2026-05-17 18:49:04'),(156,3,2,45.00,'2026-05-17 18:49:04'),(159,14,1,480.00,'2025-11-04 11:00:00'),(160,15,2,99.00,'2025-11-05 09:30:00'),(161,16,3,150.00,'2025-11-06 14:00:00'),(162,17,5,70.00,'2025-11-07 15:30:00'),(163,18,2,155.00,'2025-11-08 10:45:00'),(164,21,10,22.00,'2025-11-10 08:00:00'),(165,23,4,75.00,'2025-11-10 16:00:00'),(166,6,3,95.00,'2025-11-12 11:00:00'),(167,20,3,55.00,'2025-11-13 13:00:00'),(168,8,2,145.00,'2025-11-14 10:00:00'),(169,19,1,290.00,'2025-11-15 09:00:00'),(170,22,2,50.00,'2025-11-17 14:30:00'),(171,1,3,750.00,'2025-11-18 11:00:00'),(172,13,4,95.00,'2025-11-19 10:00:00'),(173,10,12,22.00,'2025-11-20 09:30:00'),(174,15,1,99.00,'2025-11-21 12:00:00'),(175,16,2,150.00,'2025-11-22 15:00:00'),(176,14,1,480.00,'2025-11-24 10:00:00'),(177,17,4,70.00,'2025-11-25 11:30:00'),(178,21,8,22.00,'2025-11-26 09:00:00'),(179,5,2,420.00,'2025-11-27 14:00:00'),(180,23,3,75.00,'2025-11-28 16:30:00'),(181,18,1,155.00,'2025-11-29 10:00:00'),(182,1,2,750.00,'2025-12-01 10:00:00'),(183,14,2,480.00,'2025-12-02 11:00:00'),(184,15,3,99.00,'2025-12-03 09:30:00'),(185,16,4,150.00,'2025-12-04 14:00:00'),(186,17,6,70.00,'2025-12-05 15:00:00'),(187,21,15,22.00,'2025-12-06 08:30:00'),(188,23,5,75.00,'2025-12-07 16:00:00'),(189,19,2,290.00,'2025-12-08 10:00:00'),(190,20,4,55.00,'2025-12-09 13:00:00'),(191,22,3,50.00,'2025-12-10 12:00:00'),(192,5,3,420.00,'2025-12-11 11:00:00'),(193,6,4,95.00,'2025-12-12 10:30:00'),(194,8,3,145.00,'2025-12-13 09:00:00'),(195,13,5,95.00,'2025-12-15 11:00:00'),(196,10,10,22.00,'2025-12-16 08:00:00'),(197,3,5,45.00,'2025-12-17 14:00:00'),(198,2,1,1900.00,'2025-12-18 10:00:00'),(199,18,3,155.00,'2025-12-19 11:30:00'),(200,16,2,150.00,'2025-12-20 15:00:00'),(201,14,1,480.00,'2025-12-22 09:00:00'),(202,17,5,70.00,'2025-12-22 14:00:00'),(203,21,12,22.00,'2025-12-23 10:00:00'),(204,1,3,750.00,'2025-12-24 11:00:00'),(205,23,6,75.00,'2025-12-26 16:00:00'),(206,4,2,580.00,'2025-12-27 10:30:00'),(207,15,2,99.00,'2025-12-29 12:00:00'),(208,22,4,50.00,'2025-12-30 14:00:00'),(209,1,2,750.00,'2026-01-02 10:00:00'),(210,14,1,480.00,'2026-01-05 11:00:00'),(211,15,2,99.00,'2026-01-06 09:30:00'),(212,16,3,150.00,'2026-01-07 14:00:00'),(213,17,4,70.00,'2026-01-08 15:00:00'),(214,18,2,155.00,'2026-01-09 10:45:00'),(215,21,10,22.00,'2026-01-10 08:00:00'),(216,23,3,75.00,'2026-01-11 16:00:00'),(217,20,2,55.00,'2026-01-12 13:00:00'),(218,19,1,290.00,'2026-01-13 09:00:00'),(219,22,2,50.00,'2026-01-14 14:30:00'),(220,6,3,95.00,'2026-01-15 11:00:00'),(221,10,15,22.00,'2026-01-16 09:30:00'),(222,8,2,145.00,'2026-01-19 10:00:00'),(223,13,3,95.00,'2026-01-20 11:00:00'),(224,3,4,45.00,'2026-01-21 14:00:00'),(225,5,2,420.00,'2026-01-23 15:00:00'),(226,4,1,580.00,'2026-01-25 10:00:00'),(227,16,2,150.00,'2026-01-27 12:00:00'),(228,23,4,75.00,'2026-01-29 16:00:00'),(229,1,3,750.00,'2026-02-02 10:00:00'),(230,14,1,480.00,'2026-02-04 11:00:00'),(231,17,5,70.00,'2026-02-05 15:00:00'),(232,21,12,22.00,'2026-02-06 08:30:00'),(233,15,2,99.00,'2026-02-07 09:30:00'),(234,23,3,75.00,'2026-02-08 16:00:00'),(235,18,2,155.00,'2026-02-10 10:45:00'),(236,20,3,55.00,'2026-02-11 13:00:00'),(237,22,2,50.00,'2026-02-12 14:30:00'),(238,6,4,95.00,'2026-02-13 11:00:00'),(239,10,8,22.00,'2026-02-14 09:30:00'),(240,8,3,145.00,'2026-02-16 10:00:00'),(241,13,4,95.00,'2026-02-17 11:00:00'),(242,2,1,1900.00,'2026-02-18 10:00:00'),(243,16,2,150.00,'2026-02-19 14:00:00'),(244,5,3,420.00,'2026-02-21 15:00:00'),(245,19,1,290.00,'2026-02-22 09:00:00'),(246,4,2,580.00,'2026-02-24 10:30:00'),(247,3,3,45.00,'2026-02-26 14:00:00'),(248,23,5,75.00,'2026-02-28 16:30:00'),(249,14,2,480.00,'2026-03-03 09:00:00'),(250,15,3,99.00,'2026-03-06 10:30:00'),(251,16,4,150.00,'2026-03-09 14:00:00'),(252,17,5,70.00,'2026-03-12 15:00:00'),(253,18,3,155.00,'2026-03-15 10:45:00'),(254,19,2,290.00,'2026-03-17 09:00:00'),(255,20,4,55.00,'2026-03-20 13:00:00'),(256,21,15,22.00,'2026-03-22 08:30:00'),(257,22,3,50.00,'2026-03-25 14:30:00'),(258,23,4,75.00,'2026-03-28 16:00:00'),(259,14,1,480.00,'2026-04-02 11:00:00'),(260,15,2,99.00,'2026-04-05 09:30:00'),(261,16,3,150.00,'2026-04-08 14:00:00'),(262,17,4,70.00,'2026-04-11 15:00:00'),(263,18,2,155.00,'2026-04-14 10:45:00'),(264,19,1,290.00,'2026-04-16 09:00:00'),(265,20,3,55.00,'2026-04-19 13:00:00'),(266,21,10,22.00,'2026-04-21 08:30:00'),(267,22,2,50.00,'2026-04-24 14:30:00'),(268,23,5,75.00,'2026-04-27 16:00:00'),(269,14,2,480.00,'2026-04-30 11:00:00'),(270,15,2,99.00,'2026-05-02 09:30:00'),(272,17,4,70.00,'2026-05-06 15:00:00'),(273,18,2,155.00,'2026-05-08 10:45:00'),(274,19,1,290.00,'2026-05-09 09:00:00'),(275,20,3,55.00,'2026-05-11 13:00:00'),(276,21,12,22.00,'2026-05-12 08:30:00'),(277,22,2,50.00,'2026-05-13 14:30:00'),(278,23,4,75.00,'2026-05-14 16:00:00'),(279,14,1,480.00,'2026-05-16 11:00:00'),(280,15,3,99.00,'2026-05-17 09:30:00'),(282,17,5,70.00,'2026-05-19 15:00:00'),(283,18,3,155.00,'2026-05-20 10:45:00'),(284,23,6,75.00,'2026-05-21 16:00:00'),(285,21,20,22.00,'2026-05-22 08:30:00'),(286,1,2,750.00,'2026-05-22 10:15:00'),(287,3,4,45.00,'2026-05-22 10:20:00'),(288,9,1,210.00,'2026-05-22 19:42:05'),(289,9,1,210.00,'2026-05-20 07:54:30'),(290,9,1,210.00,'2026-05-22 07:54:30'),(291,14,2,480.00,'2026-05-18 07:54:30'),(292,14,2,480.00,'2026-05-21 07:54:30'),(293,14,1,480.00,'2026-05-22 07:54:30'),(294,7,2,175.00,'2026-05-19 07:54:30'),(295,7,1,175.00,'2026-05-22 07:54:30'),(296,19,2,290.00,'2026-05-20 07:54:30'),(297,19,3,290.00,'2026-05-22 07:54:30');
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

-- Dump completed on 2026-05-23  8:12:16
