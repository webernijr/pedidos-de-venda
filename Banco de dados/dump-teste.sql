-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: localhost    Database: teste
-- ------------------------------------------------------
-- Server version	5.5.5-10.4.25-MariaDB

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
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `CODIGO` int(11) NOT NULL AUTO_INCREMENT,
  `NOME` varchar(100) DEFAULT NULL,
  `CIDADE` varchar(100) DEFAULT NULL,
  `UF` char(2) DEFAULT NULL,
  PRIMARY KEY (`CODIGO`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (1,'NOME 1','CIDADE 1','01'),(2,'NOME 2','CIDADE 2','02'),(3,'NOME 3','CIDADE 3','03'),(4,'NOME 4','CIDADE 4','04'),(5,'NOME 5','CIDADE 5','05'),(6,'NOME 6','CIDADE 6','06'),(7,'NOME 7','CIDADE 7','07'),(8,'NOME 8','CIDADE 8','08'),(9,'NOME 9','CIDADE 9','09'),(10,'NOME 10','CIDADE 10','10'),(11,'NOME 11','CIDADE 11','11'),(12,'NOME 12','CIDADE 12','12'),(13,'NOME 13','CIDADE 13','13'),(14,'NOME 14','CIDADE 14','14'),(15,'NOME 15','CIDADE 15','15'),(16,'NOME 16','CIDADE 16','16'),(17,'NOME 17','CIDADE 17','17'),(18,'NOME 18','CIDADE 18','18'),(19,'NOME 19','CIDADE 19','19'),(20,'NOME 20','CIDADE 20','20');
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedidos_dados_gerais`
--

DROP TABLE IF EXISTS `pedidos_dados_gerais`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidos_dados_gerais` (
  `NUMERO_PEDIDO` int(11) NOT NULL AUTO_INCREMENT,
  `DATA_EMISSAO` datetime NOT NULL,
  `CODIGO` int(11) NOT NULL,
  `VALOR_TOTAL` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`NUMERO_PEDIDO`),
  KEY `pedidos_dados_gerais_FK` (`CODIGO`),
  CONSTRAINT `pedidos_dados_gerais_FK` FOREIGN KEY (`CODIGO`) REFERENCES `clientes` (`CODIGO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos_dados_gerais`
--

LOCK TABLES `pedidos_dados_gerais` WRITE;
/*!40000 ALTER TABLE `pedidos_dados_gerais` DISABLE KEYS */;
/*!40000 ALTER TABLE `pedidos_dados_gerais` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedidos_produtos`
--

DROP TABLE IF EXISTS `pedidos_produtos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidos_produtos` (
  `AUTOINCREM` int(11) NOT NULL AUTO_INCREMENT,
  `NUMERO_PEDIDO` int(11) NOT NULL,
  `CODIGO` int(11) NOT NULL,
  `QUANTIDADE` decimal(10,2) DEFAULT NULL,
  `VALOR_UNITARIO` decimal(10,2) DEFAULT NULL,
  `VALOR_TOTAL` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`AUTOINCREM`),
  KEY `pedidos_produtos_FK` (`CODIGO`),
  KEY `pedidos_produtos_FK_1` (`NUMERO_PEDIDO`),
  CONSTRAINT `pedidos_produtos_FK` FOREIGN KEY (`CODIGO`) REFERENCES `produtos` (`CODIGO`),
  CONSTRAINT `pedidos_produtos_FK_1` FOREIGN KEY (`NUMERO_PEDIDO`) REFERENCES `pedidos_dados_gerais` (`NUMERO_PEDIDO`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos_produtos`
--

LOCK TABLES `pedidos_produtos` WRITE;
/*!40000 ALTER TABLE `pedidos_produtos` DISABLE KEYS */;
/*!40000 ALTER TABLE `pedidos_produtos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produtos`
--

DROP TABLE IF EXISTS `produtos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produtos` (
  `CODIGO` int(11) NOT NULL AUTO_INCREMENT,
  `DESCRICAO` text DEFAULT NULL,
  `PRECO_VENDA` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`CODIGO`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produtos`
--

LOCK TABLES `produtos` WRITE;
/*!40000 ALTER TABLE `produtos` DISABLE KEYS */;
INSERT INTO `produtos` VALUES (1,'PRODUCO 1',1.00),(2,'PRODUCO 2',2.00),(3,'PRODUCO 3',3.00),(4,'PRODUCO 4',4.00),(5,'PRODUCO 5',5.00),(6,'PRODUCO 6',6.00),(7,'PRODUCO 7',7.00),(8,'PRODUCO 8',8.00),(9,'PRODUCO 9',9.00),(10,'PRODUCO 10',10.00),(11,'PRODUCO 11',11.00),(12,'PRODUCO 12',12.00),(13,'PRODUCO 13',13.00),(14,'PRODUCO 14',14.00),(15,'PRODUCO 15',15.00),(16,'PRODUCO 16',16.00),(17,'PRODUCO 17',17.00),(18,'PRODUCO 18',18.00),(19,'PRODUCO 19',19.00),(20,'PRODUCO 20',20.00);
/*!40000 ALTER TABLE `produtos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'teste'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-12-04 19:58:19
