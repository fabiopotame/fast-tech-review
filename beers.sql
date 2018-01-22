# ************************************************************
# Sequel Pro SQL dump
# Versão 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 127.0.0.1 (MySQL 5.7.20)
# Base de Dados: beers
# Tempo de Geração: 2018-01-22 05:02:27 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump da tabela beers
# ------------------------------------------------------------

DROP TABLE IF EXISTS `beers`;

CREATE TABLE `beers` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `tagline` varchar(100) DEFAULT NULL,
  `first_brewed` date DEFAULT NULL,
  `description` varchar(500) DEFAULT NULL,
  `image_url` varchar(50) DEFAULT NULL,
  `abv` float(3,1) DEFAULT NULL,
  `ibu` int(11) DEFAULT NULL,
  `target_fg` int(11) DEFAULT NULL,
  `target_og` int(11) DEFAULT NULL,
  `ebc` int(11) DEFAULT NULL,
  `srm` int(11) DEFAULT NULL,
  `ph` float(3,1) DEFAULT NULL,
  `attenuation_level` int(11) DEFAULT NULL,
  `volume` varchar(50) DEFAULT NULL,
  `boil_volume` varchar(50) DEFAULT NULL,
  `brewers_tips` varchar(255) DEFAULT NULL,
  `contributed_by` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `beers` WRITE;
/*!40000 ALTER TABLE `beers` DISABLE KEYS */;

INSERT INTO `beers` (`id`, `name`, `tagline`, `first_brewed`, `description`, `image_url`, `abv`, `ibu`, `target_fg`, `target_og`, `ebc`, `srm`, `ph`, `attenuation_level`, `volume`, `boil_volume`, `brewers_tips`, `contributed_by`, `created_at`, `updated_at`)
VALUES
	(1,'Buzz','A Real Bitter Experience.','2017-09-01','A light, crisp and bitter IPA brewed with English and American hops. A small batch brewed only once.','https://images.punkapi.com/v2/keg.png',4.5,60,1010,1044,20,10,4.4,75,'{\"value\":20,\"unit\":\"liters\"}','{\"value\":25,\"unit\":\"liters\"}','The earthy and floral aromas from the hops can be overpowering. Drop a little Cascade in at the end of the boil to lift the profile with a bit of citrus.','Sam Mason <samjbmason>',NULL,NULL);

/*!40000 ALTER TABLE `beers` ENABLE KEYS */;
UNLOCK TABLES;


# Dump da tabela food_pairings
# ------------------------------------------------------------

DROP TABLE IF EXISTS `food_pairings`;

CREATE TABLE `food_pairings` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `beer_id` int(11) unsigned NOT NULL,
  `text` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `beer_id` (`beer_id`),
  CONSTRAINT `food_pairings_ibfk_1` FOREIGN KEY (`beer_id`) REFERENCES `beers` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `food_pairings` WRITE;
/*!40000 ALTER TABLE `food_pairings` DISABLE KEYS */;

INSERT INTO `food_pairings` (`id`, `beer_id`, `text`)
VALUES
	(1,1,'Spicy chicken tikka masala'),
	(2,1,'Grilled chicken quesadilla'),
	(3,1,'Caramel toffee cake');

/*!40000 ALTER TABLE `food_pairings` ENABLE KEYS */;
UNLOCK TABLES;


# Dump da tabela ingredients
# ------------------------------------------------------------

DROP TABLE IF EXISTS `ingredients`;

CREATE TABLE `ingredients` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `beer_id` int(11) unsigned NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `beer_id` (`beer_id`),
  CONSTRAINT `ingredients_ibfk_1` FOREIGN KEY (`beer_id`) REFERENCES `beers` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `ingredients` WRITE;
/*!40000 ALTER TABLE `ingredients` DISABLE KEYS */;

INSERT INTO `ingredients` (`id`, `beer_id`, `name`)
VALUES
	(1,1,'malt'),
	(2,1,'hops'),
	(3,1,'yeast');

/*!40000 ALTER TABLE `ingredients` ENABLE KEYS */;
UNLOCK TABLES;


# Dump da tabela ingredients_attributes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `ingredients_attributes`;

CREATE TABLE `ingredients_attributes` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ingredients_content_id` int(11) unsigned NOT NULL,
  `title` varchar(50) DEFAULT NULL,
  `value` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ingredients_content_id` (`ingredients_content_id`),
  CONSTRAINT `ingredients_attributes_ibfk_1` FOREIGN KEY (`ingredients_content_id`) REFERENCES `ingredients_contents` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `ingredients_attributes` WRITE;
/*!40000 ALTER TABLE `ingredients_attributes` DISABLE KEYS */;

INSERT INTO `ingredients_attributes` (`id`, `ingredients_content_id`, `title`, `value`)
VALUES
	(1,1,'name','Maris Otter Extra Pale'),
	(2,1,'amount','{\"value\":3.3,\"unit\":\"kilograms\"}'),
	(3,2,'name','Caramalt'),
	(4,2,'amount','{\"value\":0.2,\"unit\":\"kilograms\"}'),
	(5,3,'name','Munich'),
	(6,3,'amount','{\"value\":0.4,\"unit\":\"kilograms\"}'),
	(7,4,'name','Fuggles'),
	(8,4,'amount','{\"value\":25,\"unit\":\"grams\"}'),
	(9,4,'add','start'),
	(10,4,'attribute','bitter'),
	(11,5,'name','First Gold'),
	(12,5,'amount','{\"value\":25,\"unit\":\"grams\"}'),
	(13,5,'add','start'),
	(14,5,'attribute','bitter'),
	(15,6,'name','Fuggles'),
	(16,6,'amount','{\"value\":37.5,\"unit\":\"grams\"}'),
	(17,6,'add','middle'),
	(18,6,'attribute','flavour'),
	(19,7,'name','First Gold'),
	(20,7,'amount','{\"value\":37.5,\"unit\":\"grams\"}'),
	(21,7,'add','middle'),
	(22,7,'attribute','flavour'),
	(23,8,'yeast','Wyeast 1056 - American Ale™'),
	(24,9,'name','Cascade'),
	(25,9,'amount','{\"value\": 37.5,\"unit\": \"grams\"}\n                   '),
	(26,9,'add','end'),
	(27,9,'attribute','flavour');

/*!40000 ALTER TABLE `ingredients_attributes` ENABLE KEYS */;
UNLOCK TABLES;


# Dump da tabela ingredients_contents
# ------------------------------------------------------------

DROP TABLE IF EXISTS `ingredients_contents`;

CREATE TABLE `ingredients_contents` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ingredient_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ingredient_id` (`ingredient_id`),
  CONSTRAINT `ingredients_contents_ibfk_1` FOREIGN KEY (`ingredient_id`) REFERENCES `ingredients` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `ingredients_contents` WRITE;
/*!40000 ALTER TABLE `ingredients_contents` DISABLE KEYS */;

INSERT INTO `ingredients_contents` (`id`, `ingredient_id`)
VALUES
	(1,1),
	(2,1),
	(3,1),
	(4,2),
	(5,2),
	(6,2),
	(7,2),
	(9,2),
	(8,3);

/*!40000 ALTER TABLE `ingredients_contents` ENABLE KEYS */;
UNLOCK TABLES;


# Dump da tabela methods
# ------------------------------------------------------------

DROP TABLE IF EXISTS `methods`;

CREATE TABLE `methods` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `beer_id` int(11) unsigned NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `beer_id` (`beer_id`),
  CONSTRAINT `methods_ibfk_1` FOREIGN KEY (`beer_id`) REFERENCES `beers` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `methods` WRITE;
/*!40000 ALTER TABLE `methods` DISABLE KEYS */;

INSERT INTO `methods` (`id`, `beer_id`, `name`)
VALUES
	(1,1,'mash_temp'),
	(2,1,'fermentation'),
	(3,1,'twist');

/*!40000 ALTER TABLE `methods` ENABLE KEYS */;
UNLOCK TABLES;


# Dump da tabela methods_attributes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `methods_attributes`;

CREATE TABLE `methods_attributes` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `method_id` int(11) unsigned NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `content` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `method_id` (`method_id`),
  CONSTRAINT `methods_attributes_ibfk_1` FOREIGN KEY (`method_id`) REFERENCES `methods` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `methods_attributes` WRITE;
/*!40000 ALTER TABLE `methods_attributes` DISABLE KEYS */;

INSERT INTO `methods_attributes` (`id`, `method_id`, `name`, `content`)
VALUES
	(1,1,'temp','{\"value\":64,\"unit\":\"celsius\"}'),
	(2,1,'duration','75'),
	(3,2,'temp','{\"value\":19,\"unit\":\"celsius\"}'),
	(4,3,'twist',NULL);

/*!40000 ALTER TABLE `methods_attributes` ENABLE KEYS */;
UNLOCK TABLES;


# Dump da tabela units
# ------------------------------------------------------------

DROP TABLE IF EXISTS `units`;

CREATE TABLE `units` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `units` WRITE;
/*!40000 ALTER TABLE `units` DISABLE KEYS */;

INSERT INTO `units` (`id`, `name`)
VALUES
	(1,'liters'),
	(2,'kilograms'),
	(3,'grams'),
	(4,'celsius');

/*!40000 ALTER TABLE `units` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
