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

DELETE FROM `vehicleshop_custom`;
INSERT INTO `vehicleshop_custom` (`id`, `pid`, `brand`, `name`, `class`, `price`, `model`, `sold`) VALUES
	(1, '1', 'Ferrari', '488 GTB', 'S', 5.00, 'elegy', 1),
	(2, '2', 'BMW', 'F11 2016', 'A', 1100000.00, '16m5', 0),
	(3, '2', 'BMW', 'M5 E60 2009', 'A', 1100000.00, 'm5e60', 0),
	(4, '2', 'GAZ', '52', 'D', 650000.00, 'gaz52', 0),
	(5, '2', 'Nissan', 'GTR R35', 'S', 1450000.00, 'gtrpit', 0),
	(6, '2', 'Mercedes', 'Mercedes-Benz CLS 6.3 AMG 2015', 'S', 1400000.00, 'cls2015', 0),
	(7, '2', 'BMW', 'M4', 'S', 1500000.00, 'rbmwm4', 1);


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
