-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.4.32-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             12.5.0.6677
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for kkf
CREATE DATABASE IF NOT EXISTS `kkf` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `kkf`;

-- Dumping structure for table kkf.baninfo
CREATE TABLE IF NOT EXISTS `baninfo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `license` varchar(50) DEFAULT NULL,
  `identifier` varchar(25) DEFAULT NULL,
  `liveid` varchar(21) DEFAULT NULL,
  `xblid` varchar(21) DEFAULT NULL,
  `discord` varchar(30) DEFAULT NULL,
  `playerip` varchar(25) DEFAULT NULL,
  `playername` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Dumping data for table kkf.baninfo: ~1 rows (approximately)
DELETE FROM `baninfo`;
INSERT INTO `baninfo` (`id`, `license`, `identifier`, `liveid`, `xblid`, `discord`, `playerip`, `playername`) VALUES
	(1, 'license:7bafe5b5a4df8506af69f7408d1ba7fdea558d8f', 'steam:11000010f74ea41', NULL, NULL, 'discord:371715037749837825', 'ip:127.0.0.1', 'Atu');

-- Dumping structure for table kkf.banking_logs
CREATE TABLE IF NOT EXISTS `banking_logs` (
  `id` int(64) NOT NULL AUTO_INCREMENT,
  `sender` varchar(50) NOT NULL,
  `reciever` varchar(50) DEFAULT NULL,
  `amount` int(64) DEFAULT NULL,
  `time` varchar(69) DEFAULT NULL,
  `type` varchar(50) NOT NULL DEFAULT 'out',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table kkf.banking_logs: ~9 rows (approximately)
DELETE FROM `banking_logs`;
INSERT INTO `banking_logs` (`id`, `sender`, `reciever`, `amount`, `time`, `type`) VALUES
	(1, 'Tyson Stonehead', 'Väljamakse', 1, '2024-11-23 11:30:31', 'out'),
	(2, 'Tyson Stonehead', 'Sissemakse', 2147483647, '2024-11-25 23:15:45', 'in'),
	(3, 'Tyson Stonehead', 'Sissemakse', 10, '2024-11-25 23:16:29', 'in'),
	(4, 'Tyson Stonehead', 'Sissemakse', 100, '2024-11-25 23:16:41', 'in'),
	(5, 'Tyson Stonehead', 'Väljamakse', 1000, '2024-11-25 23:17:08', 'out'),
	(6, 'Palgaleht', 'Tyson Stonehead', 1318917453, '2024-11-26 19:04:20', 'in'),
	(7, 'Tyson Stonehead', 'Väljamakse', 2, '2024-11-26 19:04:59', 'out'),
	(8, 'Tyson Stonehead', 'Väljamakse', 2, '2024-11-26 19:05:13', 'out'),
	(9, 'Tyson Stonehead', 'Väljamakse', 111, '2024-11-26 19:05:33', 'out');

-- Dumping structure for table kkf.banlist
CREATE TABLE IF NOT EXISTS `banlist` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `license` varchar(50) NOT NULL DEFAULT '1',
  `identifier` varchar(25) DEFAULT NULL,
  `liveid` varchar(21) DEFAULT NULL,
  `xblid` varchar(21) DEFAULT NULL,
  `discord` varchar(30) DEFAULT NULL,
  `playerip` varchar(25) DEFAULT NULL,
  `targetplayername` varchar(32) DEFAULT NULL,
  `sourceplayername` varchar(32) DEFAULT NULL,
  `reason` varchar(255) NOT NULL DEFAULT 'Adminite otsus.',
  `timeat` varchar(50) DEFAULT NULL,
  `expiration` varchar(50) NOT NULL DEFAULT '0',
  `permanent` int(1) NOT NULL DEFAULT 0,
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Dumping data for table kkf.banlist: ~0 rows (approximately)
DELETE FROM `banlist`;

-- Dumping structure for table kkf.billing
CREATE TABLE IF NOT EXISTS `billing` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) NOT NULL,
  `sender` varchar(60) NOT NULL,
  `target` varchar(60) NOT NULL,
  `label` varchar(255) NOT NULL,
  `amount` int(11) NOT NULL,
  `time` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table kkf.billing: ~2 rows (approximately)
DELETE FROM `billing`;
INSERT INTO `billing` (`id`, `identifier`, `sender`, `target`, `label`, `amount`, `time`) VALUES
	(1, '1', '1', 'ambulance', 'Kiirabi arve | Sveta', 5000, '2024-11-23 09:36:39'),
	(2, '1', '1', 'ambulance', 'Kiirabi arve | Sveta', 5000, '2024-11-24 15:01:35');

-- Dumping structure for table kkf.boombox_songs
CREATE TABLE IF NOT EXISTS `boombox_songs` (
  `identifier` varchar(64) DEFAULT NULL,
  `label` varchar(30) DEFAULT NULL,
  `link` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table kkf.boombox_songs: ~0 rows (approximately)
DELETE FROM `boombox_songs`;

-- Dumping structure for table kkf.boosting_data
CREATE TABLE IF NOT EXISTS `boosting_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pid` int(11) DEFAULT 0,
  `data` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table kkf.boosting_data: ~0 rows (approximately)
DELETE FROM `boosting_data`;

-- Dumping structure for table kkf.ems_bills
CREATE TABLE IF NOT EXISTS `ems_bills` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `label` varchar(255) DEFAULT NULL,
  `punishments` longtext NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table kkf.ems_bills: ~35 rows (approximately)
DELETE FROM `ems_bills`;
INSERT INTO `ems_bills` (`id`, `label`, `punishments`) VALUES
	(1, 'Tervisetõend', '{"max_fine":5000,"min_fine":5000}'),
	(2, 'Peatrauma', '{"max_fine":2000,"min_fine":1000}'),
	(3, '1. astme põletushaavad', '{"max_fine":2000,"min_fine":1000}'),
	(4, '2. astme põletushaavad', '{"max_fine":2000,"min_fine":1000}'),
	(5, '3. astme põletushaavad', '{"max_fine":2000,"min_fine":1000}'),
	(6, '4. astme põletuhaavad', '{"max_fine":2000,"min_fine":1000}'),
	(7, 'Šhokk', '{"max_fine":2000,"min_fine":1000}'),
	(8, 'Loomahammustus', '{"max_fine":2000,"min_fine":1000}'),
	(9, 'Lahtine luumurd', '{"max_fine":2000,"min_fine":1000}'),
	(10, 'Kinnine luumurd', '{"max_fine":2000,"min_fine":1000}'),
	(11, 'Mõranenud luu', '{"max_fine":2000,"min_fine":1000}'),
	(12, 'Ummistunud hingamisteed', '{"max_fine":2000,"min_fine":1000}'),
	(13, 'Lihasrebend', '{"max_fine":2000,"min_fine":1000}'),
	(14, 'Peapõrutus', '{"max_fine":2000,"min_fine":1000}'),
	(15, 'Väline verejooks', '{"max_fine":2000,"min_fine":1000}'),
	(16, 'Sisemine verejooks', '{"max_fine":2000,"min_fine":1000}'),
	(17, 'Roidemurd', '{"max_fine":2000,"min_fine":1000}'),
	(18, 'Peatrauma', '{"max_fine":2000,"min_fine":1000}'),
	(19, 'Minestus', '{"max_fine":2000,"min_fine":1000}'),
	(20, 'Kramp', '{"max_fine":2000,"min_fine":1000}'),
	(21, 'Külmakahjustused', '{"max_fine":2000,"min_fine":1000}'),
	(22, 'Uppumine', '{"max_fine":2000,"min_fine":1000}'),
	(23, 'Südamerütmihäired', '{"max_fine":2000,"min_fine":1000}'),
	(24, 'Nikastus', '{"max_fine":2000,"min_fine":1000}'),
	(25, 'Päikesepõletus', '{"max_fine":2000,"min_fine":1000}'),
	(26, 'Kuumarabandus', '{"max_fine":2000,"min_fine":1000}'),
	(27, 'Elektritrauma', '{"max_fine":2000,"min_fine":1000}'),
	(28, 'Teadvuse kaotus', '{"max_fine":2000,"min_fine":1000}'),
	(29, 'Marrastus', '{"max_fine":2000,"min_fine":1000}'),
	(30, 'Lõikehaav', '{"max_fine":2000,"min_fine":1000}'),
	(31, 'Allergiahoog', '{"max_fine":2000,"min_fine":1000}'),
	(32, 'Palavik', '{"max_fine":2000,"min_fine":1000}'),
	(33, 'Alkoholi mürgitus', '{"max_fine":2000,"min_fine":1000}'),
	(34, 'Mürgitus', '{"max_fine":2000,"min_fine":1000}'),
	(35, 'Narkootikumide üledoos', '{"max_fine":2000,"min_fine":1000}');

-- Dumping structure for table kkf.jobs
CREATE TABLE IF NOT EXISTS `jobs` (
  `name` varchar(64) NOT NULL,
  `label` varchar(64) DEFAULT NULL,
  `type` varchar(64) NOT NULL DEFAULT 'legal',
  `max_count` int(11) NOT NULL DEFAULT 7,
  `money` int(11) NOT NULL DEFAULT 0,
  `properties` longtext DEFAULT '{"stash":false}',
  `safe` int(11) DEFAULT 500,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table kkf.jobs: ~13 rows (approximately)
DELETE FROM `jobs`;
INSERT INTO `jobs` (`name`, `label`, `type`, `max_count`, `money`, `properties`, `safe`) VALUES
	('ambulance', 'Kiirabi', 'legal', 100, 55500, '{"stash":true}', 2500),
	('bean', 'Bean Machine', 'legal', 10, 0, '{"stash":false}', 500),
	('bubblegum', 'Bubblegum', 'legal', 10, 0, '{"stash":false}', 500),
	('burgershot', 'Burgershot', 'legal', 20, 877233, '{"stash":true}', 500),
	('doj', 'Õigusosakond', 'legal', 10, 2819256, '{"stash":true}', 500),
	('driftmotors', 'Drift Motors', 'legal', 15, 109421278, '{"stash":true}', 500),
	('ottos', 'Otto\'s auto', 'legal', 15, 106768476, '{"stash":true}', 500),
	('police', 'Politsei', 'legal', 150, 910961908, '{"stash":true}', 5000),
	('properties', 'Maakler', 'legal', 15, 42534872, '{"stash":true}', 500),
	('taxi', 'Takso', 'legal', 15, 716340, '{"stash":true}', 500),
	('tunershop', 'Tunershop', 'legal', 15, 0, '{"stash":false}', 500),
	('unemployed', 'Töötu', 'illegal', 2000000, 0, '{"stash":false}', 500),
	('uwucafe', 'UwU Cafe', 'legal', 20, 856275, '{"stash":true}', 500);

-- Dumping structure for table kkf.job_grades
CREATE TABLE IF NOT EXISTS `job_grades` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job_name` varchar(32) DEFAULT NULL,
  `grade` int(11) NOT NULL,
  `label` varchar(64) NOT NULL,
  `salary` int(11) NOT NULL,
  `permissions` varchar(550) NOT NULL DEFAULT '{"leaderMenu":false,"jobMenu":false,"banking":false,"stash":false,"garage":false,"members":false,"ranks":false}',
  PRIMARY KEY (`id`),
  KEY `job_name` (`job_name`),
  KEY `grade` (`grade`)
) ENGINE=InnoDB AUTO_INCREMENT=267 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table kkf.job_grades: ~30 rows (approximately)
DELETE FROM `job_grades`;
INSERT INTO `job_grades` (`id`, `job_name`, `grade`, `label`, `salary`, `permissions`) VALUES
	(95, 'properties', 99, 'Admin', 0, '{"banking":true,"garage":true,"members":true,"leaderMenu":true,"ranks":true,"stash":true,"jobMenu":true,"printer":true}'),
	(96, 'police', 99, 'Admin', 0, '{"banking":true,"garage":true,"members":true,"leaderMenu":true,"ranks":true,"stash":true,"jobMenu":true,"printer":true}'),
	(97, 'ambulance', 99, 'Admin', 0, '{"banking":true,"garage":true,"members":true,"leaderMenu":true,"ranks":true,"stash":true,"jobMenu":true,"printer":true}'),
	(98, 'ottos', 99, 'Admin', 0, '{"banking":true,"garage":true,"members":true,"leaderMenu":true,"ranks":true,"stash":true,"jobMenu":true,"printer":true}'),
	(100, 'taxi', 99, 'Admin', 0, '{"banking":true,"garage":true,"members":true,"leaderMenu":true,"ranks":true,"stash":true,"jobMenu":true,"printer":true}'),
	(101, 'tunershop', 99, 'Admin', 0, '{"banking":true,"garage":true,"members":true,"leaderMenu":true,"ranks":true,"stash":true,"jobMenu":true,"printer":true}'),
	(102, 'driftmotors', 99, 'Admin', 0, '{"banking":true,"garage":true,"members":true,"leaderMenu":true,"ranks":true,"stash":true,"jobMenu":true,"printer":true}'),
	(103, 'uwucafe', 99, 'Admin', 0, '{"banking":true,"garage":true,"members":true,"leaderMenu":true,"ranks":true,"stash":true,"jobMenu":true,"printer":true}'),
	(104, 'bubblegum', 99, 'Admin', 0, '{"banking":true,"garage":true,"members":true,"leaderMenu":true,"ranks":true,"stash":true,"jobMenu":true,"printer":true}'),
	(105, 'doj', 99, 'Admin', 0, '{"banking":true,"garage":true,"members":true,"leaderMenu":true,"ranks":true,"stash":true,"jobMenu":true,"printer":true}'),
	(106, 'burgershot', 99, 'Admin', 0, '{"banking":true,"garage":true,"members":true,"leaderMenu":true,"ranks":true,"stash":true,"jobMenu":true,"printer":true}'),
	(107, 'bean', 99, 'Admin', 0, '{"banking":true,"garage":true,"members":true,"leaderMenu":true,"ranks":true,"stash":true,"jobMenu":true,"printer":true}'),
	(118, 'unemployed', 0, 'Töötu', 250, '{"leaderMenu":false,"banking":false,"stash":false,"garage":false,"jobMenu":false,"ranks":false,"members":false,"printer":false}'),
	(229, 'ambulance', 100, 'Peadirektor', 8000, '{"leaderMenu":false,"banking":false,"stash":false,"garage":false,"jobMenu":false,"ranks":false,"members":false,"printer":false}'),
	(230, 'ambulance', 101, 'Asedirektor', 7500, '{"members":true,"banking":true,"garage":true,"ranks":true,"stash":true,"printer":true,"leaderMenu":true,"jobMenu":true}'),
	(231, 'police', 100, 'Peadirektor', 1, '{"members":true,"printer":true,"leaderMenu":true,"jobMenu":true,"garage":true,"ranks":true,"banking":true,"stash":true}'),
	(232, 'burgershot', 100, 'Omanik', 100, '{"leaderMenu":false,"banking":false,"stash":false,"garage":false,"jobMenu":false,"ranks":false,"members":false,"printer":false}'),
	(233, 'burgershot', 101, 'Juhataja', 75, '{"leaderMenu":false,"banking":false,"stash":false,"garage":false,"jobMenu":false,"ranks":false,"members":false,"printer":false}'),
	(234, 'burgershot', 102, 'Kokk', 50, '{"leaderMenu":false,"banking":false,"stash":false,"garage":false,"jobMenu":false,"ranks":false,"members":false,"printer":false}'),
	(236, 'burgershot', 103, 'Õpilane', 25, '{"leaderMenu":false,"banking":false,"stash":false,"garage":false,"jobMenu":false,"ranks":false,"members":false,"printer":false}'),
	(237, 'burgershot', 104, 'Peakokk', 60, '{"leaderMenu":false,"banking":false,"stash":false,"garage":false,"jobMenu":false,"ranks":false,"members":false,"printer":false}'),
	(247, 'properties', 100, 'Huinja', 1, '{"leaderMenu":false,"banking":false,"stash":false,"garage":false,"jobMenu":false,"ranks":false,"members":false,"printer":false}'),
	(255, 'police', 101, 'K9', 8000, '{"leaderMenu":false,"banking":false,"stash":false,"garage":false,"jobMenu":false,"ranks":false,"members":false,"printer":false}'),
	(256, 'doj', 100, 'Peadirektor', 1, '{"jobMenu":true,"leaderMenu":true,"ranks":true,"members":true,"garage":true,"printer":true,"stash":true,"banking":true}'),
	(257, 'police', 102, 'Ametnik', 10, '{"members":false,"printer":false,"banking":false,"garage":true,"jobMenu":true,"ranks":false,"leaderMenu":false,"stash":true}'),
	(259, 'taxi', 100, 'Takso Boss', 498, '{"ranks":true,"garage":true,"printer":true,"jobMenu":true,"members":true,"leaderMenu":true,"banking":true,"stash":true}'),
	(262, 'driftmotors', 100, 'Omanik', 1, '{"garage":true,"members":true,"ranks":true,"jobMenu":true,"printer":true,"banking":true,"stash":true,"leaderMenu":true}'),
	(263, 'police', 103, 'VICE UURIJA', 1, '{"jobMenu":true,"leaderMenu":true,"banking":true,"ranks":true,"garage":true,"printer":true,"stash":true,"members":true}'),
	(265, 'police', 104, 'LSPD Kadett', 1, '{"jobMenu":true,"banking":true,"leaderMenu":true,"garage":true,"stash":true,"members":true,"ranks":true,"printer":true}'),
	(266, 'police', 105, 'LSPD Kapten', 1000, '{"jobMenu":true,"banking":true,"leaderMenu":true,"garage":true,"stash":true,"members":true,"ranks":true,"printer":true}');

-- Dumping structure for table kkf.license_points
CREATE TABLE IF NOT EXISTS `license_points` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pid` int(11) NOT NULL,
  `license` varchar(22) DEFAULT NULL,
  `points` int(11) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table kkf.license_points: ~0 rows (approximately)
DELETE FROM `license_points`;

-- Dumping structure for table kkf.mechanic_deliveries
CREATE TABLE IF NOT EXISTS `mechanic_deliveries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `plate` varchar(8) DEFAULT NULL,
  `items` longtext DEFAULT '[]',
  `job` varchar(50) DEFAULT 'ottos',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Dumping data for table kkf.mechanic_deliveries: ~0 rows (approximately)
DELETE FROM `mechanic_deliveries`;

-- Dumping structure for table kkf.ox_inventory
CREATE TABLE IF NOT EXISTS `ox_inventory` (
  `owner` varchar(60) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `data` longtext DEFAULT NULL,
  `lastupdated` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  UNIQUE KEY `owner` (`owner`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table kkf.ox_inventory: ~1 rows (approximately)
DELETE FROM `ox_inventory`;
INSERT INTO `ox_inventory` (`owner`, `name`, `data`, `lastupdated`) VALUES
	('', 'burgershot_tray_4', NULL, '2024-11-24 15:30:00');

-- Dumping structure for table kkf.phone_messages
CREATE TABLE IF NOT EXISTS `phone_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pid` int(11) NOT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `messages` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `pid` (`pid`),
  KEY `phone` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table kkf.phone_messages: ~0 rows (approximately)
DELETE FROM `phone_messages`;

-- Dumping structure for table kkf.phone_tweets
CREATE TABLE IF NOT EXISTS `phone_tweets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pid` int(11) NOT NULL,
  `tweeter` varchar(25) DEFAULT NULL,
  `tweet` text DEFAULT NULL,
  `img` varchar(500) DEFAULT NULL,
  `time` varchar(125) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `pid` (`pid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table kkf.phone_tweets: ~0 rows (approximately)
DELETE FROM `phone_tweets`;

-- Dumping structure for table kkf.police_fines
CREATE TABLE IF NOT EXISTS `police_fines` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `label` varchar(255) DEFAULT NULL,
  `category` varchar(69) DEFAULT NULL,
  `points` longtext NOT NULL,
  `punishments` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table kkf.police_fines: ~103 rows (approximately)
DELETE FROM `police_fines`;
INSERT INTO `police_fines` (`id`, `label`, `category`, `points`, `punishments`) VALUES
	(1, 'Ebakorrektne parkimine', 'VtmS 102', '{"weapon":0,"dmv":1}', '{"max_fine":250,"min_fine":125,"min_jail":0,"max_jail":0}'),
	(2, 'Keelatud möödasõit', 'VtmS 103', '{"weapon":0,"dmv":1}', '{"max_fine":250,"min_fine":125,"min_jail":0,"max_jail":0}'),
	(3, 'STOP märgi eiramine', 'VtmS 104', '{"weapon":0,"dmv":1}', '{"max_fine":500,"min_fine":250,"min_jail":0,"max_jail":0}'),
	(4, 'Liikluseeskirjade rikkumine', 'VtmS 105', '{"weapon":0,"dmv":1}', '{"max_fine":500,"min_fine":250,"min_jail":0,"max_jail":0}'),
	(5, 'Liikluse takistamine', 'VtmS 106', '{"weapon":0,"dmv":1}', '{"max_fine":500,"min_fine":250,"min_jail":0,"max_jail":0}'),
	(6, 'Kiiruse ületamine 5-30 kmH', 'VtmS 107', '{"weapon":0,"dmv":2}', '{"max_fine":1000,"min_fine":500,"min_jail":0,"max_jail":0}'),
	(7, 'Kiiruse ületamine 31-60 kmH', 'VtmS 108', '{"weapon":0,"dmv":4}', '{"max_fine":2000,"min_fine":1000,"min_jail":0,"max_jail":0}'),
	(8, 'Illegaalne klaasitumedus', 'VtmS 109', '{"weapon":0,"dmv":1}', '{"max_fine":1000,"min_fine":500,"min_jail":0,"max_jail":0}'),
	(9, 'Kiivri mittekandmine', 'VtmS 110', '{"weapon":0,"dmv":1}', '{"max_fine":500,"min_fine":250,"min_jail":0,"max_jail":0}'),
	(10, 'Nõuetele mittevastav sõiduk', 'VtmS 111', '{"weapon":0,"dmv":1}', '{"max_fine":2000,"min_fine":1000,"min_jail":0,"max_jail":0}'),
	(11, 'Illegaalsed tuled', 'VtmS 112', '{"weapon":0,"dmv":1}', '{"max_fine":1000,"min_fine":500,"min_jail":0,"max_jail":0}'),
	(12, 'Sõidukis ohutusnõuete eiramine', 'VtmS 113', '{"weapon":0,"dmv":1}', '{"max_fine":250,"min_fine":125,"min_jail":0,"max_jail":0}'),
	(13, 'Avarii põhjustamine', 'VtmS 114', '{"weapon":0,"dmv":1}', '{"max_fine":250,"min_fine":125,"min_jail":0,"max_jail":0}'),
	(14, 'Tänavavõidusõit', 'KarS 115', '{"weapon":0,"dmv":10}', '{"max_fine":3000,"min_fine":1500,"min_jail":15,"max_jail":30}'),
	(15, 'Illegaalne numbrimärk', 'KarS 116', '{"weapon":0,"dmv":5}', '{"max_fine":2500,"min_fine":1250,"min_jail":7,"max_jail":15}'),
	(16, 'Joobeseisundis juhtimine', 'KarS 117', '{"weapon":0,"dmv":10}', '{"max_fine":2000,"min_fine":1000,"min_jail":15,"max_jail":30}'),
	(17, 'Kiiruse ületamine 61-100 kmH', 'VtmS 118', '{"weapon":0,"dmv":6}', '{"max_fine":3000,"min_fine":1500,"min_jail":0,"max_jail":0}'),
	(18, 'Kiiruse ületamine +100 kmH', 'KarS 119', '{"weapon":0,"dmv":10}', '{"max_fine":4000,"min_fine":2000,"min_jail":12,"max_jail": 25}'),
	(19, 'Juhilubadeta sõiduki juhtimine', 'KarS 120', '{"weapon":0,"dmv":1}', '{"max_fine":3000,"min_fine":1500,"min_jail":7,"max_jail":15}'),
	(20, 'Sõiduki vargus (klass A)', 'KarS 121', '{"weapon":0,"dmv":5}', '{"max_fine":4000,"min_fine":2000,"min_jail":12,"max_jail":25}'),
	(21, 'Sõiduki vargus (klass B)', 'KarS 122', '{"weapon":0,"dmv":5}', '{"max_fine":8000,"min_fine":4000,"min_jail":25,"max_jail":50}'),
	(22, 'Sõiduki varguskatse', 'VtmS 123', '{"weapon":0,"dmv":2}', '{"max_fine":1500,"min_fine":700,"min_jail":0,"max_jail":0}'),
	(23, 'Kriminaalne mittepeatumine', 'KarS 124', '{"weapon":0,"dmv":15}', '{"max_fine":5000,"min_fine":2500,"min_jail":18,"max_jail":35}'),
	(24, 'Avalikus kohas mõnuainete tarbimine', 'VtmS 201', '{"weapon":0,"dmv":0}', '{"max_fine":250,"min_fine":125,"min_jail":0,"max_jail":0}'),
	(25, 'Avaliku korra rikkumine', 'VtmS 202', '{"weapon":1,"dmv":0}', '{"max_fine":1000,"min_fine":500,"min_jail":0,"max_jail":0}'),
	(26, 'Vaenu õhutamine', 'VtmS 203', '{"weapon":0,"dmv":0}', '{"max_fine":1500,"min_fine":750,"min_jail":0,"max_jail":0}'),
	(27, 'Vara lõhkumine', 'VtmS 204', '{"weapon":3,"dmv":0}', '{"max_fine":3000,"min_fine":1500,"min_jail":0,"max_jail":0}'),
	(28, 'Rehvi põletamine', 'VtmS 205', '{"weapon":0,"dmv":1}', '{"max_fine":500,"min_fine":250,"min_jail":0,"max_jail":0}'),
	(29, 'Ametniku seadusliku käsu eiramine', 'VtmS 206', '{"weapon":1,"dmv":0}', '{"max_fine":500,"min_fine":250,"min_jail":0,"max_jail":0}'),
	(30, 'Maski kandmine avalikus kohas', 'KarS 207', '{"weapon":0,"dmv":0}', '{"max_fine":1000,"min_fine":500,"min_jail":7,"max_jail":15}'),
	(31, 'Kuulivesti kandmine avalikus kohas', 'KarS 208', '{"weapon":0,"dmv":0}', '{"max_fine":2000,"min_fine":1000,"min_jail":7,"max_jail":15}'),
	(32, 'Sündmuskohalt põgenemine', 'KarS 209', '{"weapon":0,"dmv":10}', '{"max_fine":2000,"min_fine":1000,"min_jail":10,"max_jail":20}'),
	(33, 'Vahi alt põgenemine', 'KarS 210', '{"weapon":2,"dmv":0}', '{"max_fine":4000,"min_fine":2000,"min_jail":15,"max_jail":30}'),
	(34, 'Vanglast põgenemine', 'KarS 211', '{"weapon":3,"dmv":0}', '{"max_fine":8000,"min_fine":4000,"min_jail":30,"max_jail":60}'),
	(35, 'Ametniku vormi imiteerimine', 'KarS 212', '{"weapon":5,"dmv":0}', '{"max_fine":3000,"min_fine":1500,"min_jail":10,"max_jail":20}'),
	(36, 'Kriminaalne joove', 'KarS 214', '{"weapon":0,"dmv":3}', '{"max_fine":750,"min_fine":350,"min_jail":5,"max_jail":10}'),
	(37, 'Relva avalik kandmine/näitamine', 'VtmS 301', '{"weapon":5,"dmv":0}', '{"max_fine":1500,"min_fine":700,"min_jail":0,"max_jail":0}'),
	(38, 'Ebaseadusliku külmrelva omamine', 'KarS 302', '{"weapon":7,"dmv":0}', '{"max_fine":1500,"min_fine":700,"min_jail":5,"max_jail":10}'),
	(39, 'Ebaseadusliku külmrelvaga kaubitsemine', 'KarS 303', '{"weapon":7,"dmv":0}', '{"max_fine":2000,"min_fine":1000,"min_jail":10,"max_jail":20}'),
	(40, 'Tulirelva lisaseadiste omamine', 'KarS 304', '{"weapon":3,"dmv":0}', '{"max_fine":2500,"min_fine":1250,"min_jail":5,"max_jail":10}'),
	(41, 'Tulirelva lisaseadiste müümine', 'KarS 305', '{"weapon":3,"dmv":0}', '{"max_fine":3000,"min_fine":1500,"min_jail":10,"max_jail":20}'),
	(42, 'Ebaseadusliku tulirelva omamine', 'KarS 306', '{"weapon":10,"dmv":0}', '{"max_fine":3000,"min_fine":1500,"min_jail":10,"max_jail":20}'),
	(43, 'Ebaseadusliku tulirelvaga kaubitsemine', 'KarS 307', '{"weapon":15,"dmv":0}', '{"max_fine":4000,"min_fine":2000,"min_jail":15,"max_jail":30}'),
	(44, 'Ebaseadusliku lõhkeaine omamine', 'KarS 308', '{"weapon":4,"dmv":0}', '{"max_fine":5000,"min_fine":2500,"min_jail":20,"max_jail":40}'),
	(45, 'Ebaseadusliku lõhkeaine kaubitsemine', 'KarS 309', '{"weapon":6,"dmv":0}', '{"max_fine":6000,"min_fine":3000,"min_jail":25,"max_jail":50}'),
	(46, 'Seadusliku relva/moona/muu kaubitsemine', 'KarS 310', '{"weapon":15,"dmv":0}', '{"max_fine":4000,"min_fine":2000,"min_jail":15,"max_jail":30}'),
	(47, 'Mõnuainete müümine', 'KarS 401', '{"weapon":0,"dmv":0}', '{"max_fine":2000,"min_fine":1000,"min_jail":10,"max_jail":20}'),
	(48, 'Mõnuainete valmistamine', 'KarS 402', '{"weapon":0,"dmv":0}', '{"max_fine":5000,"min_fine":2500,"min_jail":30,"max_jail":60}'),
	(49, 'Mõnuainete omamine 5-21G', 'KarS 403', '{"weapon":0,"dmv":0}', '{"max_fine":1250,"min_fine":785,"min_jail":5,"max_jail":10}'),
	(50, 'Mõnuainete omamine 21-60G', 'KarS 404', '{"weapon":0,"dmv":0}', '{"max_fine":2000,"min_fine":1000,"min_jail":10,"max_jail":20}'),
	(51, 'Mõnuainete omamine 60-80G', 'KarS 405', '{"weapon":0,"dmv":0}', '{"max_fine":3750,"min_fine":1650,"min_jail":20,"max_jail":40}'),
	(52, 'Mõnuainete omamine 80-100G', 'KarS 406', '{"weapon":0,"dmv":0}', '{"max_fine":5000,"min_fine":2500,"min_jail":25,"max_jail":50}'),
	(53, 'Mõnuainete omamine 100+G', 'KarS 407', '{"weapon":0,"dmv":0}', '{"max_fine":6000,"min_fine":3000,"min_jail":30,"max_jail":60}'),
	(54, 'Mõnuainete omamine 500+G', 'KarS 408', '{"weapon":0,"dmv":0}', '{"max_fine":7000,"min_fine":3500,"min_jail":50,"max_jail":100}'),
	(55, 'Salakauba omamine', 'KarS 409', '{"weapon":0,"dmv":0}', '{"max_fine":5000,"min_fine":2500,"min_jail":25,"max_jail":50}'),
	(56, 'Vargus I tase', 'KarS 501', '{"weapon":2,"dmv":0}', '{"max_fine":2000,"min_fine":1000,"min_jail":5,"max_jail":10}'),
	(57, 'Vargus II tase', 'KarS 502', '{"weapon":4,"dmv":0}', '{"max_fine":4000,"min_fine":2000,"min_jail":10,"max_jail":20}'),
	(58, 'Vargus III tase', 'KarS 503', '{"weapon":6,"dmv":0}', '{"max_fine":6000,"min_fine":3000,"min_jail":25,"max_jail":50}'),
	(59, 'Varastatud esemete omamine', 'KarS 504', '{"weapon":2,"dmv":0}', '{"max_fine":1500,"min_fine":750,"min_jail":7,"max_jail":15}'),
	(60, 'Võõra vara müümine', 'KarS 505', '{"weapon":0,"dmv":0}', '{"max_fine":1500,"min_fine":750,"min_jail":5,"max_jail":10}'),
	(61, 'Eluruumi sissemurdmine', 'KarS 506', '{"weapon":4,"dmv":0}', '{"max_fine":3000,"min_fine":1500,"min_jail":10,"max_jail":20}'),
	(62, 'Eluruumi sissemurdmise katse', 'KarS 507', '{"weapon":2,"dmv":0}', '{"max_fine":1500,"min_fine":750,"min_jail":5,"max_jail":10}'),
	(63, 'Pangaautomaadi rööv', 'KarS 508', '{"weapon":2,"dmv":0}', '{"max_fine":1000,"min_fine":500,"min_jail":5,"max_jail":10}'),
	(64, 'Rahaauto rööv', 'KarS 509', '{"weapon":15,"dmv":0}', '{"max_fine":5000,"min_fine":2500,"min_jail":25,"max_jail":50}'),
	(65, 'Relvastatud rahaauto rööv', 'KarS 510', '{"weapon":15,"dmv":0}', '{"max_fine":6000,"min_fine":3000,"min_jail":27,"max_jail":55}'),
	(66, 'Poerööv', 'KarS 511', '{"weapon":5,"dmv":0}', '{"max_fine":1000,"min_fine":500,"min_jail":5,"max_jail":10}'),
	(67, 'Relvastatud Poerööv', 'KarS 512', '{"weapon":15,"dmv":0}', '{"max_fine":2000,"min_fine":1000,"min_jail":10,"max_jail":20}'),
	(68, 'Juveelipoerööv', 'KarS 513', '{"weapon":15,"dmv":0}', '{"max_fine":6000,"min_fine":3000,"min_jail":25,"max_jail":50}'),
	(69, 'Relvastatud juveelipoerööv', 'KarS 514', '{"weapon":15,"dmv":0}', '{"max_fine":7000,"min_fine":3500,"min_jail":27,"max_jail":55}'),
	(70, 'Pangarööv', 'KarS 515', '{"weapon":15,"dmv":0}', '{"max_fine":6000,"min_fine":3000,"min_jail":27,"max_jail":45}'),
	(71, 'Relvastatud pangarööv', 'KarS 516', '{"weapon":15,"dmv":0}', '{"max_fine":7000,"min_fine":3500,"min_jail":25,"max_jail":50}'),
	(72, 'Relvastatud kasiinorööv', 'KarS 517', '{"weapon":20,"dmv":0}', '{"max_fine":9000,"min_fine":4500,"min_jail":40,"max_jail":80}'),
	(73, 'Ametniku solvamine', 'VtmS 601', '{"weapon":0,"dmv":0}', '{"max_fine":300,"min_fine":150,"min_jail":0,"max_jail":0}'),
	(74, 'Valeväljakutse', 'VtmS 602', '{"weapon":0,"dmv":0}', '{"max_fine":750,"min_fine":375,"min_jail":0,"max_jail":0}'),
	(75, 'Politsei siseruumides viibimine ilma loata', 'KarS 603', '{"weapon":0,"dmv":0}', '{"max_fine":1000,"min_fine":500,"min_jail":7,"max_jail":15}'),
	(76, 'Organiseeritud kuritegevuse juhtimine', 'KarS 604', '{"weapon":100,"dmv":0}', '{"max_fine":7500,"min_fine":1500,"min_jail":500,"max_jail":1000}'),
	(77, 'Mõrvakatse', 'KarS 605', '{"weapon":20,"dmv":0}', '{"max_fine":7000,"min_fine":3500,"min_jail":20,"max_jail":40}'),
	(78, 'Inimrööv', 'KarS 606', '{"weapon":20,"dmv":0}', '{"max_fine":3000,"min_fine":1500,"min_jail":15,"max_jail":30}'),
	(79, 'Prostitutsioon', 'KarS 607', '{"weapon":0,"dmv":0}', '{"max_fine":150,"min_fine":75,"min_jail":10,"max_jail":20}'),
	(80, 'Kodaniku ähvardamine', 'KarS 608', '{"weapon":2,"dmv":0}', '{"max_fine":1000,"min_fine":500,"min_jail":5,"max_jail":10}'),
	(81, 'Valeütluste/informatsiooni andmine', 'KarS 609', '{"weapon":0,"dmv":0}', '{"max_fine":1500,"min_fine":750,"min_jail":15,"max_jail":30}'),
	(82, 'Ametniku ähvardamine', 'KarS 610', '{"weapon":4,"dmv":0}', '{"max_fine":1500,"min_fine":750,"min_jail":15,"max_jail":30}'),
	(83, 'Ametniku ründamine', 'KarS 611', '{"weapon":25,"dmv":0}', '{"max_fine":1500,"min_fine":750,"min_jail":30,"max_jail":60}'),
	(84, 'Teise isiku pantvangistamine', 'KarS 612', '{"weapon":7,"dmv":0}', '{"max_fine":4500,"min_fine":2250,"min_jail":27,"max_jail":45}'),
	(85, 'Orjastamine', 'KarS 613', '{"weapon":5,"dmv":0}', '{"max_fine":4000,"min_fine":2000,"min_jail":17,"max_jail":35}'),
	(86, 'Inimkaubandus', 'KarS 614', '{"weapon":20,"dmv":0}', '{"max_fine":4000,"min_fine":2000,"min_jail":17,"max_jail":35}'),
	(87, 'Võitlusvõimetu isiku ründamine', 'KarS 615', '{"weapon":10,"dmv":0}', '{"max_fine":2000,"min_fine":1000,"min_jail":10,"max_jail":20}'),
	(88, 'Haavatud isikule abi mitte pakkumine', 'KarS 616', '{"weapon":5,"dmv":0}', '{"max_fine":2000,"min_fine":1000,"min_jail":20,"max_jail":40}'),
	(89, 'Identiteedi vargus', 'KarS 617', '{"weapon":5,"dmv":0}', '{"max_fine":2000,"min_fine":1000,"min_jail":15,"max_jail":30}'),
	(90, 'Kuritööle kaasaaitamine', 'KarS 618', '{"weapon":6,"dmv":0}', '{"max_fine":4000,"min_fine":2000,"min_jail":27,"max_jail":45}'),
	(91, 'Kuriteo varjamine', 'KarS 619', '{"weapon":5,"dmv":0}', '{"max_fine":3500,"min_fine":1700,"min_jail":20,"max_jail":40}'),
	(92, 'Kehavigastuste tekitamine', 'KarS 620', '{"weapon":20,"dmv":0}', '{"max_fine":5500,"min_fine":2700,"min_jail":25,"max_jail":50}'),
	(93, 'Surma põhjustamine ettevaatamatusest', 'KarS 621', '{"weapon":50,"dmv":0}', '{"max_fine":8000,"min_fine":4000,"min_jail":30,"max_jail":60}'),
	(94, 'Mõrv', 'KarS 622', '{"weapon":60,"dmv":0}', '{"max_fine":10000,"min_fine":5000,"min_jail":40,"max_jail":80}'),
	(95, 'Tule avamine relvast', 'KarS 623', '{"weapon":10,"dmv":0}', '{"max_fine":5000,"min_fine":2500,"min_jail":25,"max_jail":50}'),
	(96, 'Altkäemaksu pakkumine', 'VtmS 701', '{"weapon":1,"dmv":0}', '{"max_fine":500,"min_fine":250,"min_jail":0,"max_jail":0}'),
	(97, 'Altkäemaksu andmine', 'KarS 702', '{"weapon":2,"dmv":0}', '{"max_fine":5000,"min_fine":2500,"min_jail":25,"max_jail":50}'),
	(98, 'Altkäemaksu võtmine', 'KarS 703', '{"weapon":2,"dmv":0}', '{"max_fine":5000,"min_fine":2500,"min_jail":25,"max_jail":50}'),
	(99, 'Korruptsiooniga tegelemine', 'KarS 704', '{"weapon":20,"dmv":0}', '{"max_fine":5000,"min_fine":2500,"min_jail":50,"max_jail":100}'),
	(100, 'Võimu kuritarvitamine', 'KarS 705', '{"weapon":20,"dmv":0}', '{"max_fine":5000,"min_fine":2500,"min_jail":25,"max_jail":50}'),
	(101, 'Riigi reetmine', 'KarS 706', '{"weapon":0,"dmv":0}', '{"max_fine":0,"min_fine":0,"min_jail":5000,"max_jail":10000}'),
	(102, 'Trahvide mitte maksmine', 'KarS 707', '{"weapon":0,"dmv":0}', '{"max_fine":0,"min_fine":0,"min_jail":5000,"max_jail":10000}'),
	(103, 'Politsei distsiplinaar karistus', 'KarS 708', '{"weapon":0,"dmv":0}', '{"max_fine":0,"min_fine":0,"min_jail":60,"max_jail":120}');

-- Dumping structure for table kkf.race_tracks
CREATE TABLE IF NOT EXISTS `race_tracks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `checkpoints` text DEFAULT NULL,
  `records` text DEFAULT NULL,
  `creatorid` varchar(50) DEFAULT NULL,
  `creatorname` varchar(50) DEFAULT NULL,
  `distance` int(11) DEFAULT NULL,
  `raceid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table kkf.race_tracks: ~0 rows (approximately)
DELETE FROM `race_tracks`;

-- Dumping structure for table kkf.saved_coords
CREATE TABLE IF NOT EXISTS `saved_coords` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `coords` longtext DEFAULT NULL,
  `coords_vector3` longtext DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table kkf.saved_coords: ~0 rows (approximately)
DELETE FROM `saved_coords`;

-- Dumping structure for table kkf.server_logs
CREATE TABLE IF NOT EXISTS `server_logs` (
  `id` int(64) NOT NULL AUTO_INCREMENT,
  `pid` int(11) NOT NULL,
  `category` varchar(50) NOT NULL,
  `text` varchar(255) DEFAULT NULL,
  `time` varchar(69) DEFAULT NULL,
  `target` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=304 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table kkf.server_logs: ~287 rows (approximately)
DELETE FROM `server_logs`;
INSERT INTO `server_logs` (`id`, `pid`, `category`, `text`, `time`, `target`) VALUES
	(1, 1, 'INVENTUUR', '"false" eemaldatud 1x giftbox from "Tyson Stonehead"', '2024-11-23 11:27:03', 0),
	(2, 1, 'INVENTUUR', '"false" Lisatud 5x bandage to "Tyson Stonehead"', '2024-11-23 11:27:03', 0),
	(3, 1, 'INVENTUUR', '"false" Lisatud 2x lockpick to "Tyson Stonehead"', '2024-11-23 11:27:03', 0),
	(4, 1, 'INVENTUUR', '"false" lisatud 1x phone to "Tyson Stonehead"', '2024-11-23 11:27:03', 0),
	(5, 1, 'INVENTUUR', '"false" Lisatud 2x waffles to "Tyson Stonehead"', '2024-11-23 11:27:03', 0),
	(6, 1, 'INVENTUUR', '"false" Lisatud 2x hot_chocolate to "Tyson Stonehead"', '2024-11-23 11:27:03', 0),
	(7, 1, 'INVENTUUR', '"false" eemaldatud 1x waffles from "Tyson Stonehead"', '2024-11-23 11:27:19', 0),
	(8, 1, 'INVENTUUR', '"false" eemaldatud 1x hot_chocolate from "Tyson Stonehead"', '2024-11-23 11:27:29', 0),
	(9, 1, 'INVENTUUR', '"false" Lisatud 1x money to "Tyson Stonehead"', '2024-11-23 11:30:31', 0),
	(10, 1, 'PANGANDUS', 'Väljastas raha summas $1 oma pangakontolt.', '2024-11-23 11:30:31', 0),
	(11, 1, 'MUU', 'Lahkus serverist! Põhjus: Exiting.', '2024-11-23 11:32:37', 0),
	(12, 1, 'MUU', 'Liitub serveriga.', '2024-11-23 11:33:21', 0),
	(13, 1, 'MUU', 'Lahkus serverist! Põhjus: Exiting.', '2024-11-23 12:53:05', 0),
	(14, 1, 'MUU', 'Liitub serveriga.', '2024-11-23 12:57:23', 0),
	(15, 1, 'MUU', 'Lahkus serverist! Põhjus: Exiting.', '2024-11-23 13:04:06', 0),
	(16, 1, 'MUU', 'Liitub serveriga.', '2024-11-23 13:05:52', 0),
	(17, 1, 'MUU', 'Lahkus serverist! Põhjus: Exiting.', '2024-11-23 13:10:39', 0),
	(18, 1, 'MUU', 'Liitub serveriga.', '2024-11-23 16:23:58', 0),
	(19, 1, 'MUU', 'Liitub serveriga.', '2024-11-23 16:24:41', 0),
	(20, 1, 'MUU', 'Lahkus serverist! Põhjus: Exiting.', '2024-11-23 16:27:03', 0),
	(21, 1, 'MUU', 'Liitub serveriga.', '2024-11-23 16:28:13', 0),
	(22, 1, 'A-TEAM', 'Võttis sõiduki ZH729FYP võtme.', '2024-11-23 16:29:31', 0),
	(23, 1, 'MUU', 'Lahkus serverist! Põhjus: Exiting.', '2024-11-23 16:35:42', 0),
	(24, 1, 'MUU', 'Liitub serveriga.', '2024-11-23 16:36:15', 0),
	(25, 1, 'SURM', 'Sai surma.', '2024-11-23 19:08:11', 0),
	(26, 1, 'MUU', 'Lahkus serverist! Põhjus: Exiting.', '2024-11-23 19:19:00', 0),
	(27, 1, 'MUU', 'Liitub serveriga.', '2024-11-23 19:19:28', 0),
	(28, 1, 'A-TEAM', 'Elustas end.', '2024-11-23 19:20:31', 0),
	(29, 1, 'INVENTUUR', '"false" eemaldatud 1x waffles from "Tyson Stonehead"', '2024-11-23 19:20:50', 0),
	(30, 1, 'INVENTUUR', '"false" eemaldatud 1x hot_chocolate from "Tyson Stonehead"', '2024-11-23 19:21:03', 0),
	(31, 1, 'A-TEAM', 'Võttis sõiduki KO334TGN võtme.', '2024-11-23 19:22:03', 0),
	(32, 1, 'MUU', 'Liitub serveriga.', '2024-11-24 16:28:31', 0),
	(33, 1, 'INVENTUUR', '1x waffles viis eseme invist "Tyson Stonehead" invi "drop-980083"', '2024-11-24 16:33:12', 0),
	(34, 1, 'INVENTUUR', '1x hot_chocolate invist "Tyson Stonehead" invi "drop-980083"', '2024-11-24 16:33:13', 0),
	(35, 1, 'INVENTUUR', '"false" Lisatud 10x brownie to "Tyson Stonehead"', '2024-11-24 16:33:23', 0),
	(36, 1, 'INVENTUUR', '"false" eemaldatud 1x brownie from "Tyson Stonehead"', '2024-11-24 16:33:35', 0),
	(37, 1, 'INVENTUUR', '"false" Lisatud 1x cola_cup to "Tyson Stonehead"', '2024-11-24 16:33:44', 0),
	(38, 1, 'INVENTUUR', '"false" Lisatud 9x cola_cup to "Tyson Stonehead"', '2024-11-24 16:33:46', 0),
	(39, 1, 'MUU', 'Teostas tegevuse /me uurib pingsalt ümbrust.', '2024-11-24 16:33:51', 0),
	(40, 1, 'INVENTUUR', '"false" eemaldatud 1x cola_cup from "Tyson Stonehead"', '2024-11-24 16:33:58', 0),
	(41, 1, 'MUU', 'Teostas tegevuse /me uurib pingsalt ümbrust.', '2024-11-24 16:38:37', 0),
	(42, 1, 'MUU', 'Lahkus serverist! Põhjus: Exiting.', '2024-11-24 16:40:36', 0),
	(43, 1, 'MUU', 'Liitub serveriga.', '2024-11-24 16:41:09', 0),
	(44, 1, 'MUU', 'Lahkus serverist! Põhjus: Exiting.', '2024-11-24 16:57:08', 0),
	(45, 1, 'MUU', 'Liitub serveriga.', '2024-11-24 16:57:37', 0),
	(46, 1, 'MUU', 'Lahkus serverist! Põhjus: Exiting.', '2024-11-24 17:21:57', 0),
	(47, 1, 'MUU', 'Liitub serveriga.', '2024-11-24 17:24:42', 0),
	(48, 1, 'A-TEAM', 'Seadis töökohaks police auastmega 99.', '2024-11-24 17:28:32', 1),
	(49, 1, 'A-TEAM', 'Seadis töökohaks ambulance auastmega 99.', '2024-11-24 17:28:38', 1),
	(50, 1, 'A-TEAM', 'Seadis töökohaks taxi auastmega 99.', '2024-11-24 17:28:44', 1),
	(51, 1, 'A-TEAM', 'Seadis töökohaks tunershop auastmega 99.', '2024-11-24 17:29:05', 1),
	(52, 1, 'A-TEAM', 'Seadis töökohaks uwucafe auastmega 99.', '2024-11-24 17:29:12', 1),
	(53, 1, 'A-TEAM', 'Seadis töökohaks driftmotors auastmega 99.', '2024-11-24 17:29:27', 1),
	(54, 1, 'A-TEAM', 'Seadis töökohaks burgershot auastmega 99.', '2024-11-24 17:29:34', 1),
	(55, 1, 'A-TEAM', 'Seadis end kui ONDUTY.', '2024-11-24 17:29:39', 0),
	(56, 1, 'INVENTUUR', '1x money invist "Tyson Stonehead" invi "burgershot_tray_4"', '2024-11-24 17:29:47', 0),
	(57, 1, 'INVENTUUR', '1x money invist "burgershot_tray_4" invi "Tyson Stonehead"', '2024-11-24 17:29:48', 0),
	(58, 1, 'A-TEAM', 'Seadis end kui ONDUTY.', '2024-11-24 17:32:03', 0),
	(59, 1, 'A-TEAM', 'Seadis end kui ONDUTY.', '2024-11-24 17:32:07', 0),
	(60, 1, 'A-TEAM', 'Seadis end kui ONDUTY.', '2024-11-24 17:34:03', 0),
	(61, 1, 'A-TEAM', 'Seadis end kui ONDUTY.', '2024-11-24 17:34:10', 0),
	(62, 1, 'A-TEAM', 'Seadis end kui ONDUTY.', '2024-11-24 17:34:22', 0),
	(63, 1, 'A-TEAM', 'Seadis end kui ONDUTY.', '2024-11-24 17:34:24', 0),
	(64, 1, 'A-TEAM', 'Seadis end kui ONDUTY.', '2024-11-24 17:34:40', 0),
	(65, 1, 'A-TEAM', 'Seadis end kui ONDUTY.', '2024-11-24 17:34:55', 0),
	(66, 1, 'INVENTUUR', '"false" eemaldatud 1x brownie from "Tyson Stonehead"', '2024-11-24 17:39:26', 0),
	(67, 1, 'MUU', 'Lahkus serverist! Põhjus: Exiting.', '2024-11-24 17:39:28', 0),
	(68, 1, 'MUU', 'Liitub serveriga.', '2024-11-24 17:50:35', 0),
	(69, 1, 'INVENTUUR', '"false" Lisatud 1x taara to "Tyson Stonehead"', '2024-11-24 17:55:37', 0),
	(70, 1, 'TÖÖD', 'Sai prügikastist Taara 1tk.', '2024-11-24 17:55:37', 0),
	(71, 1, 'INVENTUUR', '1x taara viis eseme invist "Tyson Stonehead" invi "drop-906935"', '2024-11-24 17:55:40', 0),
	(72, 1, 'MUU', 'Lahkus serverist! Põhjus: Exiting.', '2024-11-24 17:57:07', 0),
	(73, 1, 'MUU', 'Liitub serveriga.', '2024-11-24 17:58:33', 0),
	(74, 1, 'A-TEAM', 'Seadis töökohaks bean auastmega 99.', '2024-11-24 17:59:38', 1),
	(75, 1, 'A-TEAM', 'Seadis end kui ONDUTY.', '2024-11-24 17:59:45', 0),
	(76, 1, 'A-TEAM', 'Seadis end kui ONDUTY.', '2024-11-24 18:00:00', 0),
	(77, 1, 'MUU', 'Lahkus serverist! Põhjus: Exiting.', '2024-11-24 18:14:33', 0),
	(78, 1, 'MUU', 'Liitub serveriga.', '2024-11-24 18:15:03', 0),
	(79, 1, 'INVENTUUR', '"false" Lisatud 1x salty_chips to "Tyson Stonehead"', '2024-11-24 18:16:50', 0),
	(80, 1, 'INVENTUUR', '"false" eemaldatud 1x salty_chips from "Tyson Stonehead"', '2024-11-24 18:17:07', 0),
	(81, 1, 'MUU', 'Teostas tegevuse /me uurib pingsalt ümbrust.', '2024-11-24 18:17:09', 0),
	(82, 1, 'MUU', 'Teostas tegevuse /me uurib pingsalt ümbrust.', '2024-11-24 18:17:14', 0),
	(83, 1, 'MUU', 'Teostas tegevuse /me uurib pingsalt ümbrust.', '2024-11-24 18:17:19', 0),
	(84, 1, 'INVENTUUR', '"false" Lisatud 1x salty_chips to "Tyson Stonehead"', '2024-11-24 18:17:35', 0),
	(85, 1, 'INVENTUUR', '"false" Lisatud 1x salty_chips to "Tyson Stonehead"', '2024-11-24 18:17:35', 0),
	(86, 1, 'INVENTUUR', '"false" eemaldatud 1x salty_chips from "Tyson Stonehead"', '2024-11-24 18:17:50', 0),
	(87, 1, 'INVENTUUR', '"false" Lisatud 1x cola_bottle to "Tyson Stonehead"', '2024-11-24 18:18:07', 0),
	(88, 1, 'INVENTUUR', '"false" eemaldatud 1x cola_bottle from "Tyson Stonehead"', '2024-11-24 18:18:19', 0),
	(89, 1, 'A-TEAM', 'Seadis söögi, joogi täis ning stressi nulli.', '2024-11-24 18:28:44', 1),
	(90, 1, 'A-TEAM', 'Seadis söögi, joogi täis ning stressi nulli.', '2024-11-24 18:28:55', 1),
	(91, 1, 'A-TEAM', 'Seadis söögi, joogi täis ning stressi nulli.', '2024-11-24 18:31:55', 1),
	(92, 1, 'A-TEAM', 'Teostas päringu.', '2024-11-24 18:34:54', 1),
	(93, 1, 'A-TEAM', 'Avas mängija inventory: ', '2024-11-24 18:57:54', 1),
	(94, 1, 'A-TEAM', 'Avas mängija inventory: ', '2024-11-24 18:58:23', 1),
	(95, 1, 'A-TEAM', 'Avas mängija inventory: ', '2024-11-24 18:58:25', 1),
	(96, 1, 'A-TEAM', 'Avas mängija inventory: ', '2024-11-24 18:58:25', 1),
	(97, 1, 'A-TEAM', 'Avas mängija inventory: ', '2024-11-24 18:58:27', 1),
	(98, 1, 'A-TEAM', 'Elustas isiku.', '2024-11-24 18:59:05', 1),
	(99, 1, 'A-TEAM', 'Avas mängija inventory: ', '2024-11-24 18:59:22', 1),
	(100, 1, 'A-TEAM', 'Avas mängija inventory: ', '2024-11-24 18:59:51', 1),
	(101, 1, 'A-TEAM', 'Seadis söögi, joogi täis ning stressi nulli.', '2024-11-24 19:00:40', 1),
	(102, 1, 'A-TEAM', 'Teleportis enda juurde.', '2024-11-24 19:00:43', 1),
	(103, 1, 'A-TEAM', 'Teleportis juurde.', '2024-11-24 19:00:44', 1),
	(104, 1, 'A-TEAM', 'Andis eseme hairdryer 1tk.', '2024-11-24 19:08:21', 1),
	(105, 1, 'INVENTUUR', '"false" Lisatud 1x hairdryer to "Tyson Stonehead"', '2024-11-24 19:08:21', 0),
	(106, 1, 'MUU', 'Lahkus serverist! Põhjus: Exiting.', '2024-11-24 19:21:59', 0),
	(107, 1, 'MUU', 'Liitub serveriga.', '2024-11-24 19:22:33', 0),
	(108, 1, 'A-TEAM', 'Andis eseme cash 100000tk.', '2024-11-24 19:24:05', 1),
	(109, 1, 'INVENTUUR', '"false" Lisatud 100000x money to "Tyson Stonehead"', '2024-11-24 19:24:05', 0),
	(110, 1, 'INVENTUUR', '"false" eemaldatud 350x money from "Tyson Stonehead"', '2024-11-24 19:24:06', 0),
	(111, 1, 'TÖÖD', 'Sai tööga eseme Õli 3tk.', '2024-11-24 19:25:04', 0),
	(112, 1, 'INVENTUUR', '"false" Lisatud 3x oil to "Tyson Stonehead"', '2024-11-24 19:25:04', 0),
	(113, 1, 'TÖÖD', 'Sai tööga eseme Õli 3tk.', '2024-11-24 19:25:35', 0),
	(114, 1, 'INVENTUUR', '"false" Lisatud 3x oil to "Tyson Stonehead"', '2024-11-24 19:25:35', 0),
	(115, 1, 'TÖÖD', 'Sai esemest Õli 1tk eseme Rafineeritud õli 1tk.', '2024-11-24 19:27:04', 0),
	(116, 1, 'INVENTUUR', '"false" eemaldatud 1x oil from "Tyson Stonehead"', '2024-11-24 19:27:04', 0),
	(117, 1, 'INVENTUUR', '"false" Lisatud 1x proccesedoil to "Tyson Stonehead"', '2024-11-24 19:27:04', 0),
	(118, 1, 'INVENTUUR', '"false" eemaldatud 1x cola_cup from "Tyson Stonehead"', '2024-11-24 19:31:56', 0),
	(119, 1, 'TÖÖD', 'Sai esemest Õli 1tk eseme Rafineeritud õli 1tk.', '2024-11-24 19:32:39', 0),
	(120, 1, 'INVENTUUR', '"false" eemaldatud 3x oil from "Tyson Stonehead"', '2024-11-24 19:32:39', 0),
	(121, 1, 'INVENTUUR', '"false" Lisatud 3x proccesedoil to "Tyson Stonehead"', '2024-11-24 19:32:39', 0),
	(122, 1, 'TÖÖD', 'Sai esemest Õli 1tk eseme Rafineeritud õli 1tk.', '2024-11-24 19:33:56', 0),
	(123, 1, 'INVENTUUR', '"false" eemaldatud 1x oil from "Tyson Stonehead"', '2024-11-24 19:33:56', 0),
	(124, 1, 'INVENTUUR', '"false" Lisatud 1x proccesedoil to "Tyson Stonehead"', '2024-11-24 19:33:56', 0),
	(125, 1, 'MUU', 'Lahkus serverist! Põhjus: [txAdmin] Server restarting (requested by AtuDevelopment)..', '2024-11-24 19:56:57', 0),
	(126, 1, 'MUU', 'Liitub serveriga.', '2024-11-24 19:57:30', 0),
	(127, 1, 'A-TEAM', 'Andis eseme tunertablet 1tk.', '2024-11-24 20:00:15', 1),
	(128, 1, 'INVENTUUR', '"false" lisatud 1x tunertablet to "Tyson Stonehead"', '2024-11-24 20:00:15', 0),
	(129, 1, 'MUU', 'Lahkus serverist! Põhjus: Exiting.', '2024-11-24 20:03:26', 0),
	(130, 1, 'MUU', 'Liitub serveriga.', '2024-11-25 20:06:08', 0),
	(131, 1, 'INVENTUUR', '1x salty_chips viis eseme invist "Tyson Stonehead" invi "drop-398991"', '2024-11-25 20:07:03', 0),
	(132, 1, 'INVENTUUR', '8x brownie invist "Tyson Stonehead" invi "drop-398991"', '2024-11-25 20:07:03', 0),
	(133, 1, 'INVENTUUR', '"false" eemaldatud 1x cola_cup from "Tyson Stonehead"', '2024-11-25 20:07:14', 0),
	(134, 1, 'INVENTUUR', '"false" eemaldatud 10000x money from "Tyson Stonehead"', '2024-11-25 20:08:01', 0),
	(135, 1, 'A-TEAM', 'Andis eseme melon_seed 5tk.', '2024-11-25 20:08:31', 1),
	(136, 1, 'INVENTUUR', '"false" Lisatud 5x melon_seed to "Tyson Stonehead"', '2024-11-25 20:08:31', 0),
	(137, 1, 'INVENTUUR', '"false" eemaldatud 1x melon_seed from "Tyson Stonehead"', '2024-11-25 20:08:36', 0),
	(138, 1, 'A-TEAM', 'Andis eseme water 10tk.', '2024-11-25 20:08:54', 1),
	(139, 1, 'INVENTUUR', '"false" Lisatud 10x water to "Tyson Stonehead"', '2024-11-25 20:08:54', 0),
	(140, 1, 'A-TEAM', 'Andis eseme fertilizer 10tk.', '2024-11-25 20:08:57', 1),
	(141, 1, 'INVENTUUR', '"false" Lisatud 10x fertilizer to "Tyson Stonehead"', '2024-11-25 20:08:57', 0),
	(142, 1, 'INVENTUUR', '"false" eemaldatud 1x water from "Tyson Stonehead"', '2024-11-25 20:09:01', 0),
	(143, 1, 'INVENTUUR', '"false" eemaldatud 1x fertilizer from "Tyson Stonehead"', '2024-11-25 20:09:05', 0),
	(144, 1, 'INVENTUUR', '"false" eemaldatud 1x water from "Tyson Stonehead"', '2024-11-25 20:09:08', 0),
	(145, 1, 'INVENTUUR', '"false" eemaldatud 1x fertilizer from "Tyson Stonehead"', '2024-11-25 20:09:12', 0),
	(146, 1, 'A-TEAM', 'Andis eseme strawberry_seed 10tk.', '2024-11-25 20:09:29', 1),
	(147, 1, 'INVENTUUR', '"false" Lisatud 10x strawberry_seed to "Tyson Stonehead"', '2024-11-25 20:09:29', 0),
	(148, 1, 'INVENTUUR', '"false" eemaldatud 1x strawberry_seed from "Tyson Stonehead"', '2024-11-25 20:09:35', 0),
	(149, 1, 'INVENTUUR', '"false" eemaldatud 1x water from "Tyson Stonehead"', '2024-11-25 20:09:39', 0),
	(150, 1, 'INVENTUUR', '"false" eemaldatud 1x fertilizer from "Tyson Stonehead"', '2024-11-25 20:09:43', 0),
	(151, 1, 'INVENTUUR', '"false" eemaldatud 1x fertilizer from "Tyson Stonehead"', '2024-11-25 20:09:47', 0),
	(152, 1, 'INVENTUUR', '"false" eemaldatud 1x water from "Tyson Stonehead"', '2024-11-25 20:09:50', 0),
	(153, 1, 'A-TEAM', 'Andis eseme pineapple_seed 10tk.', '2024-11-25 20:10:12', 1),
	(154, 1, 'INVENTUUR', '"false" Lisatud 10x pineapple_seed to "Tyson Stonehead"', '2024-11-25 20:10:12', 0),
	(155, 1, 'INVENTUUR', '"false" eemaldatud 1x pineapple_seed from "Tyson Stonehead"', '2024-11-25 20:10:18', 0),
	(156, 1, 'INVENTUUR', '"false" eemaldatud 1x water from "Tyson Stonehead"', '2024-11-25 20:10:43', 0),
	(157, 1, 'INVENTUUR', '"false" eemaldatud 1x water from "Tyson Stonehead"', '2024-11-25 20:11:05', 0),
	(158, 1, 'INVENTUUR', '"false" eemaldatud 1x fertilizer from "Tyson Stonehead"', '2024-11-25 20:11:09', 0),
	(159, 1, 'INVENTUUR', '"false" eemaldatud 1x fertilizer from "Tyson Stonehead"', '2024-11-25 20:11:12', 0),
	(160, 1, 'INVENTUUR', '"false" eemaldatud 1x water from "Tyson Stonehead"', '2024-11-25 20:11:15', 0),
	(161, 1, 'INVENTUUR', '"false" eemaldatud 1x water from "Tyson Stonehead"', '2024-11-25 20:11:29', 0),
	(162, 1, 'INVENTUUR', '"false" eemaldatud 1x fertilizer from "Tyson Stonehead"', '2024-11-25 20:11:32', 0),
	(163, 1, 'INVENTUUR', '"false" eemaldatud 1x water from "Tyson Stonehead"', '2024-11-25 20:11:37', 0),
	(164, 1, 'INVENTUUR', '"false" eemaldatud 1x fertilizer from "Tyson Stonehead"', '2024-11-25 20:11:40', 0),
	(165, 1, 'INVENTUUR', '"false" eemaldatud 1x water from "Tyson Stonehead"', '2024-11-25 20:11:45', 0),
	(166, 1, 'INVENTUUR', '"false" eemaldatud 1x fertilizer from "Tyson Stonehead"', '2024-11-25 20:11:48', 0),
	(167, 1, 'INVENTUUR', '"false" Lisatud 3x pineapple to "Tyson Stonehead"', '2024-11-25 20:12:28', 0),
	(168, 1, 'INVENTUUR', '"false" Lisatud 2x watermelon to "Tyson Stonehead"', '2024-11-25 20:12:33', 0),
	(169, 1, 'INVENTUUR', '"false" Lisatud 1x strawberry to "Tyson Stonehead"', '2024-11-25 20:12:44', 0),
	(170, 1, 'INVENTUUR', '"false" eemaldatud 1x melon_seed from "Tyson Stonehead"', '2024-11-25 20:14:45', 0),
	(171, 1, 'INVENTUUR', '"false" eemaldatud 60x money from "Tyson Stonehead"', '2024-11-25 21:37:46', 0),
	(172, 1, 'INVENTUUR', '"false" eemaldatud 81x money from "Tyson Stonehead"', '2024-11-25 21:37:47', 0),
	(173, 1, 'INVENTUUR', '"false" eemaldatud 81x money from "Tyson Stonehead"', '2024-11-25 21:40:18', 0),
	(174, 1, 'INVENTUUR', '"false" eemaldatud 60x money from "Tyson Stonehead"', '2024-11-25 21:40:20', 0),
	(175, 1, 'INVENTUUR', '"false" eemaldatud 1x cola from "Tyson Stonehead"', '2024-11-25 21:46:35', 0),
	(176, 1, 'INVENTUUR', '"false" eemaldatud 1x chips from "Tyson Stonehead"', '2024-11-25 21:46:35', 0),
	(177, 1, 'INVENTUUR', '"false" Lisatud 1x lockpick to "Tyson Stonehead"', '2024-11-25 21:46:35', 0),
	(178, 1, 'INVENTUUR', '"false" eemaldatud 600x money from "Tyson Stonehead"', '2024-11-25 21:53:05', 0),
	(179, 1, 'INVENTUUR', '"false" eemaldatud 810x money from "Tyson Stonehead"', '2024-11-25 21:53:06', 0),
	(180, 1, 'INVENTUUR', '"false" eemaldatud 1x chips from "Tyson Stonehead"', '2024-11-25 21:53:14', 0),
	(181, 1, 'INVENTUUR', '"false" eemaldatud 1x cola from "Tyson Stonehead"', '2024-11-25 21:53:14', 0),
	(182, 1, 'INVENTUUR', '"false" Lisatud 1x lockpick to "Tyson Stonehead"', '2024-11-25 21:53:14', 0),
	(183, 1, 'MUU', 'Lahkus serverist! Põhjus: Couldn\'t load resource kk-guide: Couldn\'t load resource kk-guide from resources:/kk-guide/: Could no.', '2024-11-25 22:01:31', 0),
	(184, 1, 'MUU', 'Liitub serveriga.', '2024-11-25 22:02:19', 0),
	(185, 1, 'INVENTUUR', '"false" eemaldatud 325x money from "Tyson Stonehead"', '2024-11-25 22:10:25', 0),
	(186, 1, 'A-TEAM', 'Andis eseme radio 1tk.', '2024-11-25 22:24:20', 1),
	(187, 1, 'INVENTUUR', '"false" lisatud 1x radio to "Tyson Stonehead"', '2024-11-25 22:24:20', 0),
	(188, 1, 'MUU', 'Lahkus serverist! Põhjus: Exiting.', '2024-11-25 22:29:35', 0),
	(189, 1, 'MUU', 'Liitub serveriga.', '2024-11-25 22:30:31', 0),
	(190, 1, 'A-TEAM', 'Andis eseme binoculars 1tk.', '2024-11-25 22:32:03', 1),
	(191, 1, 'INVENTUUR', '"false" Lisatud 1x binoculars to "Tyson Stonehead"', '2024-11-25 22:32:03', 0),
	(192, 1, 'MUU', 'Lahkus serverist! Põhjus: Exiting.', '2024-11-25 22:48:48', 0),
	(193, 1, 'MUU', 'Liitub serveriga.', '2024-11-25 22:59:05', 0),
	(194, 1, 'A-TEAM', 'Andis eseme jerrycan 1tk.', '2024-11-25 23:10:54', 1),
	(195, 1, 'INVENTUUR', '"false" lisatud 1x jerrycan to "Tyson Stonehead"', '2024-11-25 23:10:54', 0),
	(196, 1, 'INVENTUUR', '1x jerrycan viis eseme invist "Tyson Stonehead" invi "drop-546263"', '2024-11-25 23:10:56', 0),
	(197, 1, 'INVENTUUR', '"false" lisatud 1x jerrycan to "Tyson Stonehead"', '2024-11-25 23:11:02', 0),
	(198, 1, 'A-TEAM', 'Seadis söögi, joogi täis ning stressi nulli.', '2024-11-25 23:12:00', 1),
	(199, 1, 'A-TEAM', 'Andis eseme cash 9999999999999999tk.', '2024-11-25 23:12:26', 1),
	(200, 1, 'INVENTUUR', '"false" Lisatud 10000000000000000x money to "Tyson Stonehead"', '2024-11-25 23:12:26', 0),
	(201, 1, 'MUU', 'Lahkus serverist! Põhjus: Exiting.', '2024-11-25 23:13:45', 0),
	(202, 1, 'MUU', 'Liitub serveriga.', '2024-11-25 23:14:20', 0),
	(203, 1, 'INVENTUUR', '"false" eemaldatud 9999999999x money from "Tyson Stonehead"', '2024-11-25 23:15:45', 0),
	(204, 1, 'PANGANDUS', 'Sisestas raha summas $7799999999 oma pangakontole.', '2024-11-25 23:15:45', 0),
	(205, 1, 'INVENTUUR', '"false" eemaldatud 10x money from "Tyson Stonehead"', '2024-11-25 23:16:29', 0),
	(206, 1, 'PANGANDUS', 'Sisestas raha summas $8 oma pangakontole.', '2024-11-25 23:16:29', 0),
	(207, 1, 'INVENTUUR', '"false" eemaldatud 100x money from "Tyson Stonehead"', '2024-11-25 23:16:41', 0),
	(208, 1, 'PANGANDUS', 'Sisestas raha summas $78 oma pangakontole.', '2024-11-25 23:16:41', 0),
	(209, 1, 'INVENTUUR', '"false" Lisatud 1000x money to "Tyson Stonehead"', '2024-11-25 23:17:08', 0),
	(210, 1, 'PANGANDUS', 'Väljastas raha summas $1000 oma pangakontolt.', '2024-11-25 23:17:08', 0),
	(211, 1, 'INVENTUUR', '"false" eemaldatud 56269x money from "Tyson Stonehead"', '2024-11-25 23:17:23', 0),
	(212, 1, 'SÕIDUKID', 'Soetas sõiduki (Pony; PLATE: ZHSF2737) $56269 eest.', '2024-11-25 23:17:23', 0),
	(213, 1, 'A-TEAM', 'Andis eseme pot 1tk.', '2024-11-25 23:29:50', 1),
	(214, 1, 'INVENTUUR', '"false" Lisatud 1x pot to "Tyson Stonehead"', '2024-11-25 23:29:50', 0),
	(215, 1, 'INVENTUUR', '"false" eemaldatud 1x pot from "Tyson Stonehead"', '2024-11-25 23:29:55', 0),
	(216, 1, 'A-TEAM', 'Andis eseme pot 1tk.', '2024-11-25 23:31:24', 1),
	(217, 1, 'INVENTUUR', '"false" Lisatud 1x pot to "Tyson Stonehead"', '2024-11-25 23:31:24', 0),
	(218, 1, 'INVENTUUR', '"false" eemaldatud 1x pot from "Tyson Stonehead"', '2024-11-25 23:31:33', 0),
	(219, 1, 'A-TEAM', 'Andis eseme weed_seed 4tk.', '2024-11-25 23:31:42', 1),
	(220, 1, 'INVENTUUR', '"false" Lisatud 4x weed_seed to "Tyson Stonehead"', '2024-11-25 23:31:42', 0),
	(221, 1, 'INVENTUUR', '"false" eemaldatud 1x weed_seed from "Tyson Stonehead"', '2024-11-25 23:31:47', 0),
	(222, 1, 'INVENTUUR', '"false" eemaldatud 1x fertilizer from "Tyson Stonehead"', '2024-11-25 23:31:52', 0),
	(223, 1, 'MUU', 'Lahkus serverist! Põhjus: Exiting.', '2024-11-25 23:33:31', 0),
	(224, 1, 'MUU', 'Liitub serveriga.', '2024-11-26 14:29:47', 0),
	(225, 1, 'MUU', 'Liitub serveriga.', '2024-11-26 14:30:55', 0),
	(226, 1, 'A-TEAM', 'Clearis inventory.', '2024-11-26 14:35:23', 1),
	(227, 1, 'A-TEAM', 'Andis eseme phone 1tk.', '2024-11-26 14:36:51', 1),
	(228, 1, 'INVENTUUR', '"false" lisatud 1x phone to "Tyson Stonehead"', '2024-11-26 14:36:51', 0),
	(229, 1, 'A-TEAM', 'Andis eseme cash 999999tk.', '2024-11-26 14:36:56', 1),
	(230, 1, 'INVENTUUR', '"false" Lisatud 999999x money to "Tyson Stonehead"', '2024-11-26 14:36:56', 0),
	(231, 1, 'INVENTUUR', '"false" eemaldatud 414x money from "Tyson Stonehead"', '2024-11-26 14:43:14', 0),
	(232, 1, 'A-TEAM', 'Andis eseme lockpick 1tk.', '2024-11-26 14:43:30', 1),
	(233, 1, 'INVENTUUR', '"false" lisatud 1x lockpick to "Tyson Stonehead"', '2024-11-26 14:43:30', 0),
	(234, 1, 'A-TEAM', 'Tankis sõiduki.', '2024-11-26 14:43:58', 0),
	(235, 1, 'INVENTUUR', '"false" lisatud 1x WEAPON_PETROLCAN to "Tyson Stonehead"', '2024-11-26 14:53:36', 0),
	(236, 1, 'A-TEAM', 'Võttis sõiduki YC911TSA võtme.', '2024-11-26 14:54:01', 0),
	(237, 1, 'MUU', 'Liitub serveriga.', '2024-11-26 18:16:57', 0),
	(238, 1, 'MUU', 'Lahkus serverist! Põhjus: Exiting.', '2024-11-26 18:18:11', 0),
	(239, 1, 'MUU', 'Liitub serveriga.', '2024-11-26 18:19:09', 0),
	(240, 1, 'MUU', 'Liitub serveriga.', '2024-11-26 18:22:21', 0),
	(241, 1, 'A-TEAM', 'Seadis töökohaks taxi auastmega 99.', '2024-11-26 18:23:41', 1),
	(242, 1, 'FRAKTSIOONID', 'Soetas sõiduki (PLATE: PZUN0189) $23000 eest.', '2024-11-26 18:23:52', 0),
	(243, 1, 'MUU', 'Lahkus serverist! Põhjus: Exiting.', '2024-11-26 18:35:58', 0),
	(244, 1, 'MUU', 'Liitub serveriga.', '2024-11-26 18:36:39', 0),
	(245, 1, 'A-TEAM', 'Seadis end kui ONDUTY.', '2024-11-26 18:39:21', 0),
	(246, 1, 'MUU', 'Lahkus serverist! Põhjus: Exiting.', '2024-11-26 18:46:26', 0),
	(247, 1, 'MUU', 'Liitub serveriga.', '2024-11-26 18:49:36', 0),
	(248, 1, 'INVENTUUR', '"false" Lisatud 2x money to "Tyson Stonehead"', '2024-11-26 19:04:59', 0),
	(249, 1, 'PANGANDUS', 'Väljastas raha summas $1.9092602538 oma pangakontolt.', '2024-11-26 19:04:59', 0),
	(250, 1, 'INVENTUUR', '"false" Lisatud 2x money to "Tyson Stonehead"', '2024-11-26 19:05:13', 0),
	(251, 1, 'INVENTUUR', '"false" Lisatud 111x money to "Tyson Stonehead"', '2024-11-26 19:05:33', 0),
	(252, 1, 'MUU', 'Lahkus serverist! Põhjus: [txAdmin] Server restarting (requested by AtuDevelopment)..', '2024-11-26 19:48:37', 0),
	(253, 1, 'MUU', 'Liitub serveriga.', '2024-11-26 19:49:20', 0),
	(254, 1, 'A-TEAM', 'Andis eseme idcard 1tk.', '2024-11-26 19:50:43', 1),
	(255, 1, 'INVENTUUR', '"false" lisatud 1x idcard to "Tyson Stonehead"', '2024-11-26 19:50:43', 0),
	(256, 1, 'A-TEAM', 'Andis eseme fishing_id 1tk.', '2024-11-26 19:54:21', 1),
	(257, 1, 'INVENTUUR', '"false" lisatud 1x fishing_id to "Tyson Stonehead"', '2024-11-26 19:54:21', 0),
	(258, 1, 'A-TEAM', 'Seadis end kui ONDUTY.', '2024-11-26 19:58:19', 0),
	(259, 1, 'MUU', 'Lahkus serverist! Põhjus: Exiting.', '2024-11-26 20:44:18', 0),
	(260, 1, 'MUU', 'Liitub serveriga.', '2024-11-26 21:25:47', 0),
	(261, 1, 'A-TEAM', 'Andis eseme fishingrod 1tk.', '2024-11-26 21:40:43', 1),
	(262, 1, 'INVENTUUR', '"false" Lisatud 1x fishingrod to "Tyson Stonehead"', '2024-11-26 21:40:43', 0),
	(263, 1, 'A-TEAM', 'Seadis söögi, joogi täis ning stressi nulli.', '2024-11-26 21:41:04', 1),
	(264, 1, 'INVENTUUR', '"false" lisatud 1x bass to "Tyson Stonehead"', '2024-11-26 21:44:41', 0),
	(265, 1, 'INVENTUUR', '"false" Lisatud 3x shrimp to "Tyson Stonehead"', '2024-11-26 21:44:44', 0),
	(266, 1, 'INVENTUUR', '"false" lisatud 1x salmon to "Tyson Stonehead"', '2024-11-26 21:44:46', 0),
	(267, 1, 'INVENTUUR', '"false" lisatud 2x salmon to "Tyson Stonehead"', '2024-11-26 21:44:59', 0),
	(268, 1, 'INVENTUUR', '"false" eemaldatud 3x salmon from "Tyson Stonehead"', '2024-11-26 21:55:29', 0),
	(269, 1, 'INVENTUUR', '"false" Lisatud 150x money to "Tyson Stonehead"', '2024-11-26 21:55:29', 0),
	(270, 1, 'INVENTUUR', '"false" eemaldatud 3x shrimp from "Tyson Stonehead"', '2024-11-26 21:55:34', 0),
	(271, 1, 'INVENTUUR', '"false" Lisatud 300x money to "Tyson Stonehead"', '2024-11-26 21:55:34', 0),
	(272, 1, 'INVENTUUR', '1x fishing_id viis eseme invist "Tyson Stonehead" invi "drop-365821"', '2024-11-26 21:58:29', 0),
	(273, 1, 'INVENTUUR', '"false" lisatud 1x fishing_id to "Tyson Stonehead"', '2024-11-26 21:58:32', 0),
	(274, 1, 'INVENTUUR', '"false" eemaldatud 610x money from "Tyson Stonehead"', '2024-11-26 21:58:32', 0),
	(275, 1, 'INVENTUUR', '1x fishing_id viis eseme invist "Tyson Stonehead" invi "drop-889704"', '2024-11-26 22:03:53', 0),
	(276, 1, 'INVENTUUR', '"false" lisatud 1x fishing_id to "Tyson Stonehead"', '2024-11-26 22:03:56', 0),
	(277, 1, 'INVENTUUR', '"false" eemaldatud 610x money from "Tyson Stonehead"', '2024-11-26 22:03:56', 0),
	(278, 1, 'INVENTUUR', '"false" lisatud 1x fishing_id to "Tyson Stonehead"', '2024-11-26 22:07:32', 0),
	(279, 1, 'INVENTUUR', '"false" eemaldatud 610x money from "Tyson Stonehead"', '2024-11-26 22:07:32', 0),
	(280, 1, 'INVENTUUR', '"false" eemaldatud 1x bass from "Tyson Stonehead"', '2024-11-26 22:30:10', 0),
	(281, 1, 'INVENTUUR', '"false" Lisatud 133x money to "Tyson Stonehead"', '2024-11-26 22:30:10', 0),
	(282, 1, 'MUU', 'Teostas tegevuse /me uurib pingsalt ümbrust.', '2024-11-26 22:33:13', 0),
	(283, 1, 'A-TEAM', 'Andis eseme salamon 10tk.', '2024-11-26 22:35:59', 1),
	(284, 1, 'A-TEAM', 'Andis eseme eer 10tk.', '2024-11-26 22:36:08', 1),
	(285, 1, 'INVENTUUR', '"false" Lisatud 1x shrimp to "Tyson Stonehead"', '2024-11-26 22:36:10', 0),
	(286, 1, 'INVENTUUR', '"false" Lisatud 1x shrimp to "Tyson Stonehead"', '2024-11-26 22:36:55', 0),
	(287, 1, 'MUU', 'Lahkus serverist! Põhjus: Exiting.', '2024-11-26 22:54:01', 0),
	(288, 1, 'MUU', 'Liitub serveriga.', '2024-12-17 12:22:08', 0),
	(289, 1, 'INVENTUUR', '"false" eemaldatud 56269x money from "Tyson Stonehead"', '2024-12-17 12:24:25', 0),
	(290, 1, 'SÕIDUKID', 'Soetas sõiduki (Pony; PLATE: SQIG3635) $56269 eest.', '2024-12-17 12:24:25', 0),
	(291, 1, 'INVENTUUR', '"false" eemaldatud 56269x money from "Tyson Stonehead"', '2024-12-17 12:27:40', 0),
	(292, 1, 'INVENTUUR', '"false" eemaldatud 56269x money from "Tyson Stonehead"', '2024-12-17 12:28:10', 0),
	(293, 1, 'SÕIDUKID', 'Soetas sõiduki (Baller; PLATE: RBYQ9598) $56269 eest.', '2024-12-17 12:28:10', 0),
	(294, 1, 'A-TEAM', 'Andis eseme tablet 1tk.', '2024-12-17 12:34:28', 1),
	(295, 1, 'INVENTUUR', '"false" Lisatud 1x tablet to "Tyson Stonehead"', '2024-12-17 12:34:28', 0),
	(296, 1, 'A-TEAM', 'Andis eseme droppy_stick 1tk.', '2024-12-17 12:34:36', 1),
	(297, 1, 'INVENTUUR', '"false" lisatud 1x droppy_stick to "Tyson Stonehead"', '2024-12-17 12:34:36', 0),
	(298, 1, 'A-TEAM', 'Andis eseme water 1tk.', '2024-12-17 12:35:13', 1),
	(299, 1, 'INVENTUUR', '"false" Lisatud 1x water to "Tyson Stonehead"', '2024-12-17 12:35:13', 0),
	(300, 1, 'A-TEAM', 'Andis eseme water 1tk.', '2024-12-17 12:35:15', 1),
	(301, 1, 'INVENTUUR', '"false" Lisatud 1x water to "Tyson Stonehead"', '2024-12-17 12:35:15', 0),
	(302, 1, 'INVENTUUR', '"false" eemaldatud 2x water from "Tyson Stonehead"', '2024-12-17 12:35:19', 0),
	(303, 1, 'INVENTUUR', '"false" Lisatud 966x money to "Tyson Stonehead"', '2024-12-17 12:35:19', 0);

-- Dumping structure for table kkf.society_logs
CREATE TABLE IF NOT EXISTS `society_logs` (
  `id` int(64) NOT NULL AUTO_INCREMENT,
  `pid` varchar(255) NOT NULL,
  `society` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `text` varchar(255) DEFAULT NULL,
  `time` varchar(69) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table kkf.society_logs: ~60 rows (approximately)
DELETE FROM `society_logs`;
INSERT INTO `society_logs` (`id`, `pid`, `society`, `action`, `text`, `time`) VALUES
	(1, 'Tyson Stonehead (1)', 'unemployed', 'GRAAFIK', 'Lõpetas tööpäeva.', '2024-11-24 17:28:32'),
	(2, 'Tyson Stonehead (1)', 'unemployed', 'GRAAFIK', 'Alustas tööpäeva.', '2024-11-24 17:28:32'),
	(3, 'Tyson Stonehead (1)', 'unemployed', 'GRAAFIK', 'Lõpetas tööpäeva.', '2024-11-24 17:28:39'),
	(4, 'Tyson Stonehead (1)', 'unemployed', 'GRAAFIK', 'Alustas tööpäeva.', '2024-11-24 17:28:39'),
	(5, 'Tyson Stonehead (1)', 'unemployed', 'GRAAFIK', 'Lõpetas tööpäeva.', '2024-11-24 17:28:44'),
	(6, 'Tyson Stonehead (1)', 'unemployed', 'GRAAFIK', 'Alustas tööpäeva.', '2024-11-24 17:28:44'),
	(7, 'Tyson Stonehead (1)', 'unemployed', 'GRAAFIK', 'Lõpetas tööpäeva.', '2024-11-24 17:29:05'),
	(8, 'Tyson Stonehead (1)', 'unemployed', 'GRAAFIK', 'Alustas tööpäeva.', '2024-11-24 17:29:05'),
	(9, 'Tyson Stonehead (1)', 'unemployed', 'GRAAFIK', 'Lõpetas tööpäeva.', '2024-11-24 17:29:13'),
	(10, 'Tyson Stonehead (1)', 'unemployed', 'GRAAFIK', 'Alustas tööpäeva.', '2024-11-24 17:29:13'),
	(11, 'Tyson Stonehead (1)', 'unemployed', 'GRAAFIK', 'Lõpetas tööpäeva.', '2024-11-24 17:29:28'),
	(12, 'Tyson Stonehead (1)', 'unemployed', 'GRAAFIK', 'Alustas tööpäeva.', '2024-11-24 17:29:28'),
	(13, 'Tyson Stonehead (1)', 'unemployed', 'GRAAFIK', 'Lõpetas tööpäeva.', '2024-11-24 17:29:34'),
	(14, 'Tyson Stonehead (1)', 'unemployed', 'GRAAFIK', 'Alustas tööpäeva.', '2024-11-24 17:29:34'),
	(15, 'Tyson Stonehead (1)', 'unemployed', 'GRAAFIK', 'Lõpetas tööpäeva.', '2024-11-24 17:29:38'),
	(16, 'Tyson Stonehead (1)', 'unemployed', 'GRAAFIK', 'Alustas tööpäeva.', '2024-11-24 17:29:39'),
	(17, 'Tyson Stonehead (1)', 'unemployed', 'GRAAFIK', 'Lõpetas tööpäeva.', '2024-11-24 17:32:03'),
	(18, 'Tyson Stonehead (1)', 'unemployed', 'GRAAFIK', 'Alustas tööpäeva.', '2024-11-24 17:32:03'),
	(19, 'Tyson Stonehead (1)', 'unemployed', 'GRAAFIK', 'Lõpetas tööpäeva.', '2024-11-24 17:32:06'),
	(20, 'Tyson Stonehead (1)', 'unemployed', 'GRAAFIK', 'Alustas tööpäeva.', '2024-11-24 17:32:07'),
	(21, 'Tyson Stonehead (1)', 'unemployed', 'GRAAFIK', 'Lõpetas tööpäeva.', '2024-11-24 17:34:02'),
	(22, 'Tyson Stonehead (1)', 'unemployed', 'GRAAFIK', 'Alustas tööpäeva.', '2024-11-24 17:34:03'),
	(23, 'Tyson Stonehead (1)', 'burgershot', 'GRAAFIK', 'Lõpetas tööpäeva.', '2024-11-24 17:34:06'),
	(24, 'Tyson Stonehead (1)', 'burgershot', 'GRAAFIK', 'Lõpetas tööpäeva.', '2024-11-24 17:34:09'),
	(25, 'Tyson Stonehead (1)', 'burgershot', 'GRAAFIK', 'Alustas tööpäeva.', '2024-11-24 17:34:10'),
	(26, 'Tyson Stonehead (1)', 'burgershot', 'GRAAFIK', 'Lõpetas tööpäeva.', '2024-11-24 17:34:21'),
	(27, 'Tyson Stonehead (1)', 'burgershot', 'GRAAFIK', 'Alustas tööpäeva.', '2024-11-24 17:34:22'),
	(28, 'Tyson Stonehead (1)', 'burgershot', 'GRAAFIK', 'Lõpetas tööpäeva.', '2024-11-24 17:34:24'),
	(29, 'Tyson Stonehead (1)', 'burgershot', 'GRAAFIK', 'Alustas tööpäeva.', '2024-11-24 17:34:24'),
	(30, 'Tyson Stonehead (1)', 'ambulance', 'GRAAFIK', 'Lõpetas tööpäeva.', '2024-11-24 17:34:26'),
	(31, 'Tyson Stonehead (1)', 'tunershop', 'GRAAFIK', 'Lõpetas tööpäeva.', '2024-11-24 17:34:30'),
	(32, 'Tyson Stonehead (1)', 'burgershot', 'GRAAFIK', 'Lõpetas tööpäeva.', '2024-11-24 17:34:38'),
	(33, 'Tyson Stonehead (1)', 'burgershot', 'GRAAFIK', 'Lõpetas tööpäeva.', '2024-11-24 17:34:40'),
	(34, 'Tyson Stonehead (1)', 'burgershot', 'GRAAFIK', 'Alustas tööpäeva.', '2024-11-24 17:34:40'),
	(35, 'Tyson Stonehead (1)', 'burgershot', 'GRAAFIK', 'Lõpetas tööpäeva.', '2024-11-24 17:34:55'),
	(36, 'Tyson Stonehead (1)', 'burgershot', 'GRAAFIK', 'Alustas tööpäeva.', '2024-11-24 17:34:55'),
	(37, 'Tyson Stonehead (1)', 'burgershot', 'GRAAFIK', 'Lõpetas tööpäeva.', '2024-11-24 17:35:55'),
	(38, 'Tyson Stonehead (1)', 'burgershot', 'GRAAFIK', 'Alustas tööpäeva.', '2024-11-24 17:35:57'),
	(39, 'Tyson Stonehead (1)', 'unemployed', 'GRAAFIK', 'Lõpetas tööpäeva.', '2024-11-24 17:59:39'),
	(40, 'Tyson Stonehead (1)', 'unemployed', 'GRAAFIK', 'Alustas tööpäeva.', '2024-11-24 17:59:39'),
	(41, 'Tyson Stonehead (1)', 'unemployed', 'GRAAFIK', 'Lõpetas tööpäeva.', '2024-11-24 17:59:44'),
	(42, 'Tyson Stonehead (1)', 'unemployed', 'GRAAFIK', 'Alustas tööpäeva.', '2024-11-24 17:59:45'),
	(43, 'Tyson Stonehead (1)', 'bean', 'GRAAFIK', 'Lõpetas tööpäeva.', '2024-11-24 17:59:58'),
	(44, 'Tyson Stonehead (1)', 'bean', 'GRAAFIK', 'Lõpetas tööpäeva.', '2024-11-24 17:59:59'),
	(45, 'Tyson Stonehead (1)', 'bean', 'GRAAFIK', 'Alustas tööpäeva.', '2024-11-24 18:00:00'),
	(46, 'Tyson Stonehead (1)', 'tunershop', 'GRAAFIK', 'Lõpetas tööpäeva.', '2024-11-24 19:59:59'),
	(47, 'Tyson Stonehead (1)', 'unemployed', 'GRAAFIK', 'Lõpetas tööpäeva.', '2024-11-26 18:23:41'),
	(48, 'Tyson Stonehead (1)', 'unemployed', 'GRAAFIK', 'Alustas tööpäeva.', '2024-11-26 18:23:41'),
	(49, 'Tyson Stonehead (1)', 'taxi', 'GRAAFIK', 'Lõpetas tööpäeva.', '2024-11-26 18:23:46'),
	(50, 'Tyson Stonehead (1)', 'taxi', 'SÕIDUKI OST', 'Sõiduki REG.NR PZUN0189; HIND: $23000.', '2024-11-26 18:23:52'),
	(51, 'Tyson Stonehead (1)', 'taxi', 'GRAAFIK', 'Lõpetas tööpäeva.', '2024-11-26 18:39:21'),
	(52, 'Tyson Stonehead (1)', 'taxi', 'GRAAFIK', 'Alustas tööpäeva.', '2024-11-26 18:39:21'),
	(53, 'Tyson Stonehead (1)', 'taxi', 'SÕIDUKI VÄLJASTAMINE', 'Sõiduki REG.NR PZUN0189; Kere: 1000; Mootor: 1000; Kütus: 100;', '2024-11-26 18:40:49'),
	(54, 'Tyson Stonehead (1)', 'taxi', 'SÕIDUKI HOIUSTAMINE', 'Sõiduki REG.NR PZUN0189; Kere: 996; Mootor: 995; Kütus: 60;', '2024-11-26 18:46:15'),
	(55, 'Tyson Stonehead (1)', 'taxi', 'SÕIDUKI VÄLJASTAMINE', 'Sõiduki REG.NR PZUN0189; Kere: 996; Mootor: 995; Kütus: 60;', '2024-11-26 18:50:50'),
	(56, 'Tyson Stonehead (1)', 'taxi', 'PANGANDUS', 'Eemaldas raha fraktsiooni kontolt summas: $1.9092602538', '2024-11-26 19:05:13'),
	(57, 'Tyson Stonehead (1)', 'taxi', 'PANGANDUS', 'Eemaldas raha fraktsiooni kontolt summas: $111', '2024-11-26 19:05:33'),
	(58, 'Tyson Stonehead (1)', 'police', 'GRAAFIK', 'Lõpetas tööpäeva.', '2024-11-26 19:58:10'),
	(59, 'Tyson Stonehead (1)', 'police', 'GRAAFIK', 'Lõpetas tööpäeva.', '2024-11-26 19:58:18'),
	(60, 'Tyson Stonehead (1)', 'police', 'GRAAFIK', 'Alustas tööpäeva.', '2024-11-26 19:58:19'),
	(61, 'Tyson Stonehead (1)', 'uwucafe', 'GRAAFIK', 'Lõpetas tööpäeva.', '2024-12-17 12:34:43');

-- Dumping structure for table kkf.taxes
CREATE TABLE IF NOT EXISTS `taxes` (
  `tax` varchar(50) NOT NULL,
  `label` varchar(100) NOT NULL,
  `value` float NOT NULL,
  PRIMARY KEY (`tax`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table kkf.taxes: ~2 rows (approximately)
DELETE FROM `taxes`;
INSERT INTO `taxes` (`tax`, `label`, `value`) VALUES
	('CRYPTO', 'CRYPTO', 5),
	('primary', 'VAT', 22);

-- Dumping structure for table kkf.territories
CREATE TABLE IF NOT EXISTS `territories` (
  `point` varchar(5) NOT NULL,
  `owner` varchar(50) NOT NULL DEFAULT '',
  `label` varchar(50) NOT NULL,
  PRIMARY KEY (`point`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table kkf.territories: ~3 rows (approximately)
DELETE FROM `territories`;
INSERT INTO `territories` (`point`, `owner`, `label`) VALUES
	('A', 'none', 'Vaba'),
	('B', 'none', 'Vaba'),
	('C', 'none', 'Vaba');

-- Dumping structure for table kkf.ucp_punishments
CREATE TABLE IF NOT EXISTS `ucp_punishments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `steamhex` varchar(255) DEFAULT NULL,
  `punishment` varchar(50) DEFAULT NULL,
  `description` varchar(50) DEFAULT NULL,
  `punisher` varchar(50) DEFAULT NULL,
  `timeat` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table kkf.ucp_punishments: ~0 rows (approximately)
DELETE FROM `ucp_punishments`;

-- Dumping structure for table kkf.ucp_questions
CREATE TABLE IF NOT EXISTS `ucp_questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table kkf.ucp_questions: ~14 rows (approximately)
DELETE FROM `ucp_questions`;
INSERT INTO `ucp_questions` (`id`, `question`) VALUES
	(1, 'Milline peab olema su rollimängulik käitumine, et sa ei tekitaks teistele mängijatele negatiivset ja ebameeldivat RP kogemust.'),
	(2, 'Millised on Teie jaoks kõige paremad rollimängulised situatsioonid/olukorrad?'),
	(3, 'Kuna on out of character ehk karakteriväline jutuajamine lubatud?'),
	(4, 'Kirjelda detailselt algusest kuni olukorra lõpuni läbimõeldud pangaröövi.'),
	(5, 'Millistel puhkudel on kehavigastuste tekitamine teisele mängijale rollimänguliselt lubatud?'),
	(6, 'Millist reeglit oleks sinu arvates vaja kehtestada, et muuta praeguseid reegleid täiuslikumaks?'),
	(7, 'Milliste reeglite rikkumiste puhul tuleks kohe teavitada serveri meeskonda?'),
	(8, 'Kuidas toimub tänavagängide vaheline rollimäng?'),
	(9, 'Te ei ole nõus Teile kehtestatud karistusega meeskonnaliikme poolt. Kuidas käitute?'),
	(10, 'Kuidas reageerib karakter tema poole sihitud relvale? Kuidas anda edasi rollimängulist hirmu?'),
	(11, 'Sa oled linna suurimas töökojas mehaanik. Sulle tuuakse väliselt terve sõiduk, aga klient kurdab sõidukil puudub jõud ja mootor ei tööta ilusti. Milline on su rollimängulik tegevus situatsiooni lahendamiseks?'),
	(12, 'Töötad kiirabis arstina ja sulle tuleb väljakutse reageerida kahe sõiduki avariile, kus on vigastada saanud 5 inimest. Kohale jõudes annab politseinik sulle inimeste vigastuste kohta ülevaate. Kuidas reageerid olukorras ja milliseid karakteri animatsioone sa olukorras kasutad?'),
	(13, 'Miks ei soodusta rollimängu serverid mängijate vahelist ahelröövimist?'),
	(14, 'Mis on greenzone ehk roheala põhimõte? Miks neid on vaja serveris kehtestada?');

-- Dumping structure for table kkf.ucp_users
CREATE TABLE IF NOT EXISTS `ucp_users` (
  `id` int(111) NOT NULL AUTO_INCREMENT,
  `steamhex` varchar(120) NOT NULL DEFAULT '0',
  `steamname` varchar(120) NOT NULL DEFAULT '0',
  `gamehours` varchar(120) NOT NULL DEFAULT '0',
  `points` int(111) NOT NULL DEFAULT 0,
  `prioque` int(100) NOT NULL DEFAULT 0,
  `last_online` varchar(120) NOT NULL DEFAULT '1970-01-01 03:00:00',
  `character_slots` int(11) NOT NULL DEFAULT 2,
  `mod_candidation` int(111) NOT NULL DEFAULT 0,
  `blacklist` int(111) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table kkf.ucp_users: ~0 rows (approximately)
DELETE FROM `ucp_users`;

-- Dumping structure for table kkf.ucp_whitelist
CREATE TABLE IF NOT EXISTS `ucp_whitelist` (
  `id` int(111) NOT NULL AUTO_INCREMENT,
  `ucp_id` int(111) DEFAULT NULL,
  `steamhex` varchar(250) NOT NULL DEFAULT 'ERROR',
  `questions` longtext DEFAULT '0',
  `answers` longtext DEFAULT '0',
  `status` longtext NOT NULL DEFAULT 'notsent',
  `adminanswer` longtext DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table kkf.ucp_whitelist: ~0 rows (approximately)
DELETE FROM `ucp_whitelist`;

-- Dumping structure for table kkf.users
CREATE TABLE IF NOT EXISTS `users` (
  `pid` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) DEFAULT NULL,
  `name` varchar(550) DEFAULT 'USER',
  `firstname` varchar(16) DEFAULT NULL,
  `lastname` varchar(16) DEFAULT NULL,
  `skin` longtext DEFAULT NULL,
  `tattoos` longtext DEFAULT NULL,
  `job` varchar(32) DEFAULT 'unemployed',
  `job_grade` int(11) DEFAULT 0,
  `societies` longtext DEFAULT '{"unemployed":0}',
  `is_dead` int(11) DEFAULT 0,
  `duty` tinyint(4) DEFAULT 1,
  `jail_time` int(11) unsigned zerofill NOT NULL DEFAULT 00000000000,
  `ajail` int(11) unsigned zerofill DEFAULT 00000000000,
  `cuffed` int(11) NOT NULL DEFAULT 0,
  `disabled` tinyint(1) NOT NULL DEFAULT 0,
  `accounts` varchar(550) NOT NULL DEFAULT '{"bank":2500,"money":2500}',
  `inventory` longtext DEFAULT NULL,
  `loadout` longtext DEFAULT NULL,
  `position` varchar(255) DEFAULT '{"x":-269.4,"y":-955.3,"z":31.2,"heading":205.8}',
  `dateofbirth` varchar(10) DEFAULT NULL,
  `sex` varchar(1) DEFAULT NULL,
  `needs` varchar(550) DEFAULT '{"thirst":{"warning":0,"val":25000},"drunk":{"warning":0,"val":0},"hunger":{"warning":0,"val":25000},"stress":{"warning":0,"val":5}}',
  `lastwork` varchar(69) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `licenses` varchar(550) NOT NULL DEFAULT '{"weapon":false,"dmv":false,"health":false}',
  `crafting` int(11) NOT NULL DEFAULT 1,
  `profilepic` varchar(500) NOT NULL DEFAULT 'https://i.imgur.com/cf1uosd.png',
  `badge` varchar(4) NOT NULL DEFAULT '99',
  `department` varchar(50) NOT NULL DEFAULT 'CIV',
  `last_property` varchar(255) DEFAULT NULL,
  `phone` varchar(10) DEFAULT NULL,
  `radardata` longtext DEFAULT NULL,
  `health` varchar(550) NOT NULL DEFAULT '{"armour":0,"health":200}',
  `is_wanted` tinyint(1) DEFAULT 0,
  `notes` varchar(535) NOT NULL DEFAULT '... ',
  `wanted_reason` varchar(535) NOT NULL DEFAULT '...',
  `apartment` longtext DEFAULT NULL,
  `last_apartment` varchar(111) DEFAULT NULL,
  `medicrevives` int(11) NOT NULL DEFAULT 0,
  `donebills` int(11) NOT NULL DEFAULT 0,
  `last_warehouse` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`pid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table kkf.users: ~1 rows (approximately)
DELETE FROM `users`;
INSERT INTO `users` (`pid`, `identifier`, `name`, `firstname`, `lastname`, `skin`, `tattoos`, `job`, `job_grade`, `societies`, `is_dead`, `duty`, `jail_time`, `ajail`, `cuffed`, `disabled`, `accounts`, `inventory`, `loadout`, `position`, `dateofbirth`, `sex`, `needs`, `lastwork`, `licenses`, `crafting`, `profilepic`, `badge`, `department`, `last_property`, `phone`, `radardata`, `health`, `is_wanted`, `notes`, `wanted_reason`, `apartment`, `last_apartment`, `medicrevives`, `donebills`, `last_warehouse`) VALUES
	(1, 'steam:11000010f74ea41', 'Atu', 'Tyson', 'Stonehead', '{"drawables":{"1":["masks",0],"2":["hair",79],"3":["torsos",23],"4":["legs",90],"5":["bags",0],"6":["shoes",25],"7":["neck",0],"8":["undershirts",15],"9":["vest",0],"10":["decals",0],"11":["jackets",-1],"0":["face",0]},"eyeColor":-1,"props":{"1":["glasses",-1],"2":["earrings",-1],"3":["mouth",-1],"4":["lhand",-1],"5":["rhand",-1],"6":["watches",-1],"7":["braclets",-1],"0":["hats",-1]},"headOverlay":[{"overlayValue":255,"secondColour":0,"firstColour":0,"overlayOpacity":1.0,"name":"Blemishes","colourType":0},{"overlayValue":11,"secondColour":0,"firstColour":0,"overlayOpacity":0.5,"name":"FacialHair","colourType":1},{"overlayValue":3,"secondColour":0,"firstColour":0,"overlayOpacity":0.82999998331069,"name":"Eyebrows","colourType":1},{"overlayValue":255,"secondColour":0,"firstColour":0,"overlayOpacity":1.0,"name":"Ageing","colourType":0},{"overlayValue":255,"secondColour":0,"firstColour":0,"overlayOpacity":1.0,"name":"Makeup","colourType":2},{"overlayValue":255,"secondColour":0,"firstColour":0,"overlayOpacity":1.0,"name":"Blush","colourType":2},{"overlayValue":255,"secondColour":0,"firstColour":0,"overlayOpacity":1.0,"name":"Complexion","colourType":0},{"overlayValue":255,"secondColour":0,"firstColour":0,"overlayOpacity":1.0,"name":"SunDamage","colourType":0},{"overlayValue":255,"secondColour":0,"firstColour":0,"overlayOpacity":1.0,"name":"Lipstick","colourType":2},{"overlayValue":255,"secondColour":0,"firstColour":0,"overlayOpacity":1.0,"name":"MolesFreckles","colourType":0},{"overlayValue":255,"secondColour":0,"firstColour":0,"overlayOpacity":1.0,"name":"ChestHair","colourType":1},{"overlayValue":255,"secondColour":0,"firstColour":0,"overlayOpacity":1.0,"name":"BodyBlemishes","colourType":0},{"overlayValue":255,"secondColour":0,"firstColour":0,"overlayOpacity":1.0,"name":"AddBodyBlemishes","colourType":0}],"headStructure":[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0],"model":1885233650,"headBlend":{"hasParent":false,"skinMix":0.0,"skinSecond":0,"shapeSecond":0,"shapeMix":0.0,"thirdMix":0.0,"shapeThird":0,"skinFirst":15,"shapeFirst":0,"skinThird":0},"hairColor":[1,1],"drawtextures":[["face",0],["masks",0],["hair",0],["torsos",0],["legs",0],["bags",0],["shoes",0],["neck",0],["undershirts",0],["vest",0],["decals",0],["jackets",0]],"proptextures":[["hats",-1],["glasses",-1],["earrings",-1],["mouth",-1],["lhand",-1],["rhand",-1],["watches",-1],["braclets",-1]]}', NULL, 'uwucafe', 99, '{"uwucafe":"99","ambulance":"99","police":"99","taxi":"99","driftmotors":"99","bean":"99"}', 0, 1, 00000000000, 00000000000, 0, 0, '{"money":830060,"bank":9118918805,"black_money":0}', '[{"count":1,"slot":1,"name":"tablet"},{"count":830060,"slot":2,"name":"money"},{"count":1,"slot":3,"name":"idcard"},{"count":1,"metadata":{"pid":1,"doe":"03-02-2025"},"slot":4,"name":"fishing_id"},{"count":1,"slot":5,"name":"fishingrod"},{"count":2,"slot":6,"name":"shrimp"},{"count":1,"metadata":{"pid":1,"doe":"03-02-2025"},"slot":7,"name":"fishing_id"},{"count":1,"slot":8,"name":"phone"},{"count":1,"slot":9,"name":"droppy_stick"}]', '[]', '{"z":45.3209228515625,"y":-230.90109252929688,"x":-59.07691955566406}', '1990-01-01', 'm', '{"stress":{"warning":0,"val":0},"thirst":{"warning":0,"val":66771.0},"hunger":{"warning":0,"val":66771.0},"drunk":{"warning":0,"val":0}}', '2024-12-17 12:34:43', '{"health":false,"dmv":false,"weapon":false}', 1, 'nil', '99', 'CIV', NULL, '58655702', NULL, '{"armour":0,"health":200}', 0, '... ', '...', NULL, NULL, 0, 0, NULL);

-- Dumping structure for table kkf.user_contacts
CREATE TABLE IF NOT EXISTS `user_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pid` int(11) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `pid` (`pid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table kkf.user_contacts: ~0 rows (approximately)
DELETE FROM `user_contacts`;

-- Dumping structure for table kkf.user_droppy
CREATE TABLE IF NOT EXISTS `user_droppy` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) NOT NULL,
  `done` int(11) DEFAULT 0,
  `earned` int(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `identifier` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table kkf.user_droppy: ~0 rows (approximately)
DELETE FROM `user_droppy`;
INSERT INTO `user_droppy` (`id`, `identifier`, `done`, `earned`) VALUES
	(1, '1', 1, 966);

-- Dumping structure for table kkf.user_emsbills
CREATE TABLE IF NOT EXISTS `user_emsbills` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pid` int(11) DEFAULT NULL,
  `medic` varchar(155) DEFAULT NULL,
  `injuries` varchar(255) DEFAULT NULL,
  `bill` int(11) DEFAULT NULL,
  `time` varchar(255) NOT NULL DEFAULT '1970-01-01 03:00:00',
  `description` varchar(535) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table kkf.user_emsbills: ~0 rows (approximately)
DELETE FROM `user_emsbills`;

-- Dumping structure for table kkf.user_houses
CREATE TABLE IF NOT EXISTS `user_houses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT 'Maja',
  `enterance` longtext DEFAULT NULL,
  `exit` longtext DEFAULT NULL,
  `ipl` varchar(50) DEFAULT NULL,
  `safesize` int(55) DEFAULT 100,
  `locked` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table kkf.user_houses: ~0 rows (approximately)
DELETE FROM `user_houses`;

-- Dumping structure for table kkf.user_labs
CREATE TABLE IF NOT EXISTS `user_labs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(50) DEFAULT NULL,
  `enter` longtext DEFAULT NULL,
  `password` varchar(6) DEFAULT '000000',
  `data` longtext DEFAULT '{"plants":[], "tables":[]}',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table kkf.user_labs: ~1 rows (approximately)
DELETE FROM `user_labs`;
INSERT INTO `user_labs` (`id`, `owner`, `enter`, `password`, `data`) VALUES
	(1, '1', '{"z":38.766357421875,"y":3594.764892578125,"x":1537.002197265625}', '0000', '{"tables":[{"pos":{"z":-39.15999984741211,"w":180.86000061035157,"x":1043.3699951171876,"y":-3208.0},"prop":"v_ret_fh_dryer"},{"pos":{"z":-39.15999984741211,"w":180.86000061035157,"x":1041.010009765625,"y":-3208.0},"prop":"prop_cementmixer_01a"},{"pos":{"z":-39.15999984741211,"w":180.86000061035157,"x":1038.6500244140626,"y":-3208.0},"prop":"bkr_prop_coke_press_01aa"},{"pos":{"z":-39.15999984741211,"w":180.86000061035157,"x":1036.2900390625,"y":-3208.0},"prop":"prop_cementmixer_02a"},{"pos":{"z":-39.15999984741211,"w":180.86000061035157,"x":1033.9300537109376,"y":-3208.0},"prop":"prop_wooden_barrel"},{"pos":{"z":-39.15999984741211,"w":180.86000061035157,"x":1031.5699462890626,"y":-3208.0},"prop":"v_ret_ml_tablea"}],"plants":[{"prop":"none","pos":{"z":-40.2400016784668,"x":1064.8499755859376,"y":-3206.85009765625},"health":{"water":0,"progress":0,"fertilizer":0}},{"prop":"none","pos":{"z":-40.2400016784668,"x":1064.8299560546876,"y":-3205.199951171875},"health":{"water":0,"progress":0,"fertilizer":0}},{"prop":"none","pos":{"z":-40.2400016784668,"x":1064.81005859375,"y":-3203.550048828125},"health":{"water":0,"progress":0,"fertilizer":0}},{"prop":"none","pos":{"z":-40.2400016784668,"x":1064.7900390625,"y":-3201.89990234375},"health":{"water":0,"progress":0,"fertilizer":0}},{"prop":"none","pos":{"z":-40.2400016784668,"x":1064.77001953125,"y":-3200.25},"health":{"water":0,"progress":0,"fertilizer":0}},{"prop":"none","pos":{"z":-40.2400016784668,"x":1064.75,"y":-3198.60009765625},"health":{"water":0,"progress":0,"fertilizer":0}},{"prop":"none","pos":{"z":-40.2400016784668,"x":1064.72998046875,"y":-3196.949951171875},"health":{"water":0,"progress":0,"fertilizer":0}},{"prop":"none","pos":{"z":-40.2400016784668,"x":1064.7099609375,"y":-3195.300048828125},"health":{"water":0,"progress":0,"fertilizer":0}},{"prop":"none","pos":{"z":-40.2400016784668,"x":1064.68994140625,"y":-3193.64990234375},"health":{"water":0,"progress":0,"fertilizer":0}},{"prop":"none","pos":{"z":-40.2400016784668,"x":1064.6700439453126,"y":-3192.0},"health":{"water":0,"progress":0,"fertilizer":0}},{"prop":"none","pos":{"z":-40.2400016784668,"x":1064.6500244140626,"y":-3190.35009765625},"health":{"water":0,"progress":0,"fertilizer":0}},{"prop":"none","pos":{"z":-40.2400016784668,"x":1064.6300048828126,"y":-3188.699951171875},"health":{"water":0,"progress":0,"fertilizer":0}},{"prop":"none","pos":{"z":-40.2400016784668,"x":1064.6099853515626,"y":-3187.050048828125},"health":{"water":0,"progress":0,"fertilizer":0}},{"prop":"none","pos":{"z":-40.2400016784668,"x":1063.199951171875,"y":-3206.85009765625},"health":{"water":0,"progress":0,"fertilizer":0}}]}');

-- Dumping structure for table kkf.user_outfits
CREATE TABLE IF NOT EXISTS `user_outfits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) NOT NULL,
  `name` longtext DEFAULT NULL,
  `outfit` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Dumping data for table kkf.user_outfits: ~0 rows (approximately)
DELETE FROM `user_outfits`;

-- Dumping structure for table kkf.user_permissions
CREATE TABLE IF NOT EXISTS `user_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `lvl` int(11) DEFAULT NULL,
  `ped` varchar(50) DEFAULT 'u_m_m_jesus_01',
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table kkf.user_permissions: ~1 rows (approximately)
DELETE FROM `user_permissions`;
INSERT INTO `user_permissions` (`id`, `identifier`, `lvl`, `ped`) VALUES
	(1, 'steam:11000010f74ea41', 10, 'u_m_m_jesus_01');

-- Dumping structure for table kkf.user_plants
CREATE TABLE IF NOT EXISTS `user_plants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data` longtext DEFAULT '{}',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table kkf.user_plants: ~2 rows (approximately)
DELETE FROM `user_plants`;
INSERT INTO `user_plants` (`id`, `data`) VALUES
	(27, '{"position":{"z":35.794921875,"y":-1040.17578125,"x":1120.839599609375},"health":{"progress":0,"fertilizer":0,"water":0},"type":"none"}'),
	(28, '{"position":{"z":36.5699462890625,"y":-1039.3055419921876,"x":1123.147216796875},"health":{"progress":25.45999999999997,"fertilizer":0,"water":0},"type":"weed_seed"}');

-- Dumping structure for table kkf.user_punishments
CREATE TABLE IF NOT EXISTS `user_punishments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pid` int(11) DEFAULT NULL,
  `officer` varchar(155) DEFAULT NULL,
  `offenses` varchar(255) DEFAULT NULL,
  `fine` int(11) DEFAULT NULL,
  `time` varchar(255) NOT NULL DEFAULT '1970-01-01 03:00:00',
  `description` varchar(535) NOT NULL,
  `jail` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table kkf.user_punishments: ~0 rows (approximately)
DELETE FROM `user_punishments`;

-- Dumping structure for table kkf.user_skills
CREATE TABLE IF NOT EXISTS `user_skills` (
  `pid` varchar(50) NOT NULL,
  `skills` longtext DEFAULT '{}',
  PRIMARY KEY (`pid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table kkf.user_skills: ~1 rows (approximately)
DELETE FROM `user_skills`;
INSERT INTO `user_skills` (`pid`, `skills`) VALUES
	('1', '{"hacking":{"lvl":1,"progress":0},"hunting":{"lvl":1,"progress":0},"mining":{"lvl":1,"progress":0},"cooking":{"lvl":1,"progress":0},"sewing":{"lvl":1,"progress":0},"farming":{"lvl":1,"progress":0.3},"crafting":{"lvl":1,"progress":0},"fishing":{"lvl":1,"progress":2.0},"delivering":{"lvl":1,"progress":0},"oxy":{"lvl":1,"progress":0}}');

-- Dumping structure for table kkf.user_vehicles
CREATE TABLE IF NOT EXISTS `user_vehicles` (
  `vehicle` longtext NOT NULL,
  `owner` varchar(60) NOT NULL,
  `impoundable` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Status of vehicle being purchased off impound\r\n',
  `stored` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'State of the vehicle',
  `location` varchar(50) DEFAULT 'main',
  `plate` varchar(50) NOT NULL,
  `type` varchar(10) NOT NULL DEFAULT 'car',
  `ownername` varchar(255) NOT NULL DEFAULT 'PUUDUB',
  `fakeplate` varchar(50) DEFAULT NULL,
  `model` varchar(50) NOT NULL DEFAULT 'TUNDMATU',
  `trunk` longtext DEFAULT NULL,
  `glovebox` longtext DEFAULT NULL,
  `logbook` longtext DEFAULT '[]',
  `degradation` text DEFAULT '{\r\n    "fuel_injector": [100.0, "Kütusepihusti"],\r\n    "radiator": [100.0, "Radiaator"],\r\n    "axle": [100.0, "Teljed"],\r\n    "transmission": [100.0, "Käigukast"],\r\n    "electronics": [100.0, "Elektroonika"],\r\n    "brakes": [100.0, "Pidurid"],\r\n    "clutch": [100.0, "Sidur"],\r\n    "tire": [100.0, "Rehvid"]\r\n}',
  `stance_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`stance_data`)),
  `police_impound` tinyint(1) DEFAULT 0,
  `impound_description` text DEFAULT NULL,
  `impound_until` datetime DEFAULT NULL,
  `impound_date` datetime DEFAULT NULL,
  `nickname` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`plate`),
  KEY `vehsowned` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table kkf.user_vehicles: ~4 rows (approximately)
DELETE FROM `user_vehicles`;
INSERT INTO `user_vehicles` (`vehicle`, `owner`, `impoundable`, `stored`, `location`, `plate`, `type`, `ownername`, `fakeplate`, `model`, `trunk`, `glovebox`, `logbook`, `degradation`, `stance_data`, `police_impound`, `impound_description`, `impound_until`, `impound_date`, `nickname`) VALUES
	('{"modStruts":-1,"headlightColor":255,"modBackWheels":-1,"bodyHealth":996.8819345789732,"xenonColor":255,"modSmokeEnabled":false,"modFrontWheels":-1,"modSideSkirt":-1,"modTransmission":-1,"modSpoilers":-1,"windowStatus":{"1":true,"2":true,"3":true,"4":false,"5":false,"6":true,"7":true,"0":true},"liveryRoof":-1,"modArmor":-1,"modWindows":-1,"modKit17":-1,"neonEnabled":[false,false,false,false],"modKit47":-1,"modCustomTiresF":false,"modSteeringWheel":-1,"tyreSmokeColor":[255,255,255],"modHydrolic":-1,"modTurbo":false,"modTrimA":-1,"engineHealth":995.2932781095246,"wheelSize":0.0,"modAPlate":-1,"modBrakes":-1,"wheelWidth":0.0,"modFrontBumper":-1,"color2":77,"modHorns":-1,"oilLevel":4.76596940834568,"doorStatus":{"1":false,"2":false,"3":false,"4":false,"5":false,"0":false},"modTank":-1,"modFrame":-1,"neonColor":[255,0,255],"modSuspension":-1,"modKit49":-1,"modTrimB":-1,"modRearBumper":-1,"modDial":-1,"modVanityPlate":-1,"dashboardColor":0,"extras":{"6":true,"7":false,"10":false,"11":true,"8":false,"9":false,"5":false},"modAirFilter":-1,"modRightFender":-1,"waxTime":0,"wheelColor":156,"tireHealth":{"1":1000.0,"2":1000.0,"3":1000.0,"0":1000.0},"plate":"PZUN0189","modSeats":-1,"tireBurstState":{"1":false,"2":false,"3":false,"4":false,"5":false,"0":false},"model":-956048545,"modDashboard":-1,"modOrnaments":-1,"modCustomTiresR":false,"windowTint":-1,"plateIndex":0,"modFender":-1,"modEngineBlock":-1,"modShifterLeavers":-1,"interiorColor":0,"modLivery":-1,"modRoof":-1,"modSpeakers":-1,"fuelLevel":60.66999816894531,"wheels":0,"modEngine":-1,"dirtLevel":6.35462587779425,"modKit21":-1,"color1":88,"modPlateHolder":-1,"modGrille":-1,"modExhaust":-1,"tireBurstCompletely":{"1":false,"2":false,"3":false,"4":false,"5":false,"0":false},"pearlescentColor":5,"modDoorSpeaker":-1,"modXenon":false,"modKit19":-1,"modArchCover":-1,"modTrunk":-1,"modHood":-1,"tankHealth":1000.0592475178704,"modAerials":-1}', 'society_taxi', 1, 0, 'taxi_workers_1', 'PZUN0189', 'car', 'Takso', NULL, 'TUNDMATU', NULL, NULL, '[]', '{\r\n    "fuel_injector": [100.0, "Kütusepihusti"],\r\n    "radiator": [100.0, "Radiaator"],\r\n    "axle": [100.0, "Teljed"],\r\n    "transmission": [100.0, "Käigukast"],\r\n    "electronics": [100.0, "Elektroonika"],\r\n    "brakes": [100.0, "Pidurid"],\r\n    "clutch": [100.0, "Sidur"],\r\n    "tire": [100.0, "Rehvid"]\r\n}', NULL, 0, NULL, NULL, NULL, NULL),
	('{"plateIndex":0,"modArmor":-1,"modSpoilers":-1,"tireBurstState":{"1":false,"2":false,"3":false,"4":false,"5":false,"0":false},"modPlateHolder":-1,"modDoorSpeaker":-1,"xenonColor":255,"modSteeringWheel":-1,"modKit49":-1,"modFrame":-1,"wheelWidth":0.0,"modDial":-1,"modSmokeEnabled":false,"tyreSmokeColor":[255,255,255],"modKit21":-1,"modFrontWheels":-1,"modTrimB":-1,"dirtLevel":7.94328234724281,"engineHealth":1000.0592475178704,"windowStatus":{"1":true,"2":true,"3":true,"4":true,"5":true,"6":true,"7":true,"0":true},"modHydrolic":-1,"extras":{"12":false,"11":false,"10":false},"modTank":-1,"modEngineBlock":-1,"modTrimA":-1,"modRoof":-1,"modOrnaments":-1,"oilLevel":7.94328234724281,"modTurbo":false,"modBackWheels":-1,"modWindows":-1,"modRearBumper":-1,"modTransmission":-1,"modSuspension":-1,"color2":0,"modGrille":-1,"modHorns":-1,"modKit17":-1,"windowTint":-1,"modAerials":-1,"color1":0,"modRightFender":-1,"modAPlate":-1,"wheels":3,"doorStatus":{"1":false,"2":false,"3":false,"4":false,"5":false,"0":false},"fuelLevel":79.9800033569336,"tireHealth":{"1":1000.0,"2":1000.0,"3":1000.0,"0":1000.0},"tireBurstCompletely":{"1":false,"2":false,"3":false,"4":false,"5":false,"0":false},"modCustomTiresF":false,"modVanityPlate":-1,"modArchCover":-1,"modExhaust":-1,"interiorColor":0,"model":-808831384,"headlightColor":255,"modSeats":-1,"modXenon":false,"modFrontBumper":-1,"pearlescentColor":3,"mileage":1571.5632095336915,"modKit19":-1,"modShifterLeavers":-1,"neonEnabled":[false,false,false,false],"modTrunk":-1,"modSideSkirt":-1,"neonColor":[255,0,255],"modHood":-1,"liveryRoof":-1,"modDashboard":-1,"plate":"RBYQ9598","modSpeakers":-1,"modLivery":-1,"waxTime":0,"bodyHealth":1000.0592475178704,"modStruts":-1,"tankHealth":1000.0592475178704,"modBrakes":-1,"modCustomTiresR":false,"modEngine":-1,"wheelColor":156,"wheelSize":0.0,"modFender":-1,"dashboardColor":0,"modKit47":-1,"modAirFilter":-1}', '1', 0, 1, 'occupation', 'RBYQ9598', 'car', 'Tyson Stonehead', NULL, 'baller', NULL, NULL, '[]', '{\r\n    "fuel_injector": [100.0, "Kütusepihusti"],\r\n    "radiator": [100.0, "Radiaator"],\r\n    "axle": [100.0, "Teljed"],\r\n    "transmission": [100.0, "Käigukast"],\r\n    "electronics": [100.0, "Elektroonika"],\r\n    "brakes": [100.0, "Pidurid"],\r\n    "clutch": [100.0, "Sidur"],\r\n    "tire": [100.0, "Rehvid"]\r\n}', NULL, 0, NULL, NULL, NULL, NULL),
	('{"model":943752001,"plate":"SQIG3635"}', '1', 0, 1, 'cardealer', 'SQIG3635', 'car', 'Tyson Stonehead', NULL, 'pony2', NULL, NULL, '[]', '{\r\n    "fuel_injector": [100.0, "Kütusepihusti"],\r\n    "radiator": [100.0, "Radiaator"],\r\n    "axle": [100.0, "Teljed"],\r\n    "transmission": [100.0, "Käigukast"],\r\n    "electronics": [100.0, "Elektroonika"],\r\n    "brakes": [100.0, "Pidurid"],\r\n    "clutch": [100.0, "Sidur"],\r\n    "tire": [100.0, "Rehvid"]\r\n}', NULL, 0, NULL, NULL, NULL, NULL),
	('{"model":943752001,"plate":"ZHSF2737"}', '1', 0, 0, 'cardealer', 'ZHSF2737', 'car', 'Tyson Stonehead', NULL, 'TUNDMATU', NULL, NULL, '[]', '{\r\n    "fuel_injector": [100.0, "Kütusepihusti"],\r\n    "radiator": [100.0, "Radiaator"],\r\n    "axle": [100.0, "Teljed"],\r\n    "transmission": [100.0, "Käigukast"],\r\n    "electronics": [100.0, "Elektroonika"],\r\n    "brakes": [100.0, "Pidurid"],\r\n    "clutch": [100.0, "Sidur"],\r\n    "tire": [100.0, "Rehvid"]\r\n}', NULL, 0, NULL, NULL, NULL, NULL);

-- Dumping structure for table kkf.user_warehouses
CREATE TABLE IF NOT EXISTS `user_warehouses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(255) DEFAULT NULL,
  `enterance` longtext DEFAULT NULL,
  `exit` varchar(550) DEFAULT '{"y":-3099.9033203125,"z":-39.012451171875,"x":1104.751708984375}',
  `locked` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table kkf.user_warehouses: ~0 rows (approximately)
DELETE FROM `user_warehouses`;

-- Dumping structure for table kkf.user_weapons
CREATE TABLE IF NOT EXISTS `user_weapons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `license` varchar(50) NOT NULL DEFAULT '',
  `owner` varchar(50) NOT NULL DEFAULT '',
  `name` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table kkf.user_weapons: ~0 rows (approximately)
DELETE FROM `user_weapons`;

-- Dumping structure for table kkf.vehicleshop_custom
CREATE TABLE IF NOT EXISTS `vehicleshop_custom` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pid` varchar(255) DEFAULT NULL,
  `brand` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `class` varchar(255) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `model` text DEFAULT NULL,
  `sold` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table kkf.vehicleshop_custom: ~7 rows (approximately)
DELETE FROM `vehicleshop_custom`;
INSERT INTO `vehicleshop_custom` (`id`, `pid`, `brand`, `name`, `class`, `price`, `model`, `sold`) VALUES
	(1, '1', 'Ferrari', '488 GTB', 'S', 5.00, 'elegy', 1),
	(2, '2', 'BMW', 'F11 2016', 'A', 1100000.00, '16m5', 0),
	(3, '2', 'BMW', 'M5 E60 2009', 'A', 1100000.00, 'm5e60', 0),
	(4, '2', 'GAZ', '52', 'D', 650000.00, 'gaz52', 0),
	(5, '2', 'Nissan', 'GTR R35', 'S', 1450000.00, 'gtrpit', 0),
	(6, '2', 'Mercedes', 'Mercedes-Benz CLS 6.3 AMG 2015', 'S', 1400000.00, 'cls2015', 0),
	(7, '2', 'BMW', 'M4', 'S', 1500000.00, 'rbmwm4', 1);

-- Dumping structure for table kkf.vehicleshop_import
CREATE TABLE IF NOT EXISTS `vehicleshop_import` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `brand` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `class` varchar(255) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `model` text DEFAULT NULL,
  `stock` char(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table kkf.vehicleshop_import: ~10 rows (approximately)
DELETE FROM `vehicleshop_import`;
INSERT INTO `vehicleshop_import` (`id`, `brand`, `name`, `class`, `price`, `model`, `stock`) VALUES
	(21, 'Toyota', 'Supra', 'Sports', 45000.00, 'elegy', '1'),
	(22, 'Nissan', 'Skyline GT-R', 'Sports', 55000.00, 'elegy', '3'),
	(23, 'BMW', 'M5', 'Sedan', 70000.00, 'elegy', '6'),
	(24, 'Mercedes', 'G-Class', 'SUV', 120000.00, 'elegy', '0'),
	(25, 'Ford', 'Mustang GT', 'Muscle', 60000.00, 'elegy', '10'),
	(26, 'Tesla', 'Model S', 'Electric', 85000.00, 'elegy', '1'),
	(27, 'Chevrolet', 'Camaro', 'Muscle', 50000.00, 'elegy', '3'),
	(28, 'Lamborghini', 'Huracan', 'Sports', 250000.00, 'elegy', '5'),
	(29, 'Ferrari', '488 GTB', 'Sports', 300000.00, 'elegy', '7'),
	(30, 'Audi', 'RS7', 'Sedan', 110000.00, 'elegy', '1');

-- Dumping structure for table kkf.vehicle_stocks
CREATE TABLE IF NOT EXISTS `vehicle_stocks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vehicle` varchar(255) NOT NULL,
  `stock` int(11) NOT NULL DEFAULT 10,
  PRIMARY KEY (`id`),
  UNIQUE KEY `vehicle` (`vehicle`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table kkf.vehicle_stocks: ~0 rows (approximately)
DELETE FROM `vehicle_stocks`;
INSERT INTO `vehicle_stocks` (`id`, `vehicle`, `stock`) VALUES
	(1, 'cavalcade2', 10),
	(2, 'baller2', 10),
	(3, 'pony2', 8),
	(4, 'baller4', 10),
	(5, 'bjxl', 10),
	(6, 'baller3', 10),
	(7, 'cavalcade', 10),
	(8, 'baller', 9);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
