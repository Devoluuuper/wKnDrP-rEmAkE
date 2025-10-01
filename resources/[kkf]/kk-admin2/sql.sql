CREATE TABLE `baninfo` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`pid` INT(11) NULL DEFAULT NULL,
	`license` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`identifier` VARCHAR(25) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`liveid` VARCHAR(21) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`xblid` VARCHAR(21) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`discord` VARCHAR(30) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`fivem` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`playerip` VARCHAR(25) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`playername` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`tokens` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8mb4_unicode_ci'
ENGINE=InnoDB
AUTO_INCREMENT=5688
;

CREATE TABLE `banlist` (
	`id` INT(255) NOT NULL AUTO_INCREMENT,
	`pid` INT(11) NULL DEFAULT NULL,
	`license` VARCHAR(50) NOT NULL DEFAULT '1' COLLATE 'utf8mb4_unicode_ci',
	`identifier` VARCHAR(25) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`liveid` VARCHAR(21) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`xblid` VARCHAR(21) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`discord` VARCHAR(30) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`playerip` VARCHAR(25) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`fivem` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`targetplayername` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`sourceplayername` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`reason` VARCHAR(1000) NOT NULL DEFAULT 'Adminite otsus.' COLLATE 'utf8mb4_unicode_ci',
	`timeat` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`expiration` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_unicode_ci',
	`tokens` LONGTEXT NULL DEFAULT '[]' COLLATE 'utf8mb4_unicode_ci',
	`permanent` INT(1) NULL DEFAULT '0',
	`banned` INT(11) NULL DEFAULT '1',
	INDEX `id` (`id`) USING BTREE
)
COLLATE='utf8mb4_unicode_ci'
ENGINE=InnoDB
AUTO_INCREMENT=2403
;

CREATE TABLE `ucp_users` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`identifier` VARCHAR(60) NOT NULL COLLATE 'utf8mb4_uca1400_ai_ci',
	`discord` VARCHAR(60) NULL DEFAULT NULL COLLATE 'utf8mb4_uca1400_ai_ci',
	`status` VARCHAR(10) NULL DEFAULT NULL COLLATE 'utf8mb4_uca1400_ai_ci',
	`supporter` TINYINT(1) NULL DEFAULT '0',
	`name` VARCHAR(60) NOT NULL DEFAULT '' COLLATE 'utf8mb4_uca1400_ai_ci',
	`hours` INT(11) NOT NULL DEFAULT '0',
	`questions` LONGTEXT NOT NULL COLLATE 'utf8mb4_uca1400_ai_ci',
	`admin_lvl` INT(11) NOT NULL DEFAULT '0',
	`admin_ped` VARCHAR(15) NOT NULL DEFAULT 'u_m_m_jesus_01' COLLATE 'utf8mb4_uca1400_ai_ci',
	`points` INT(11) NOT NULL DEFAULT '0',
	`character_slots` INT(1) NOT NULL DEFAULT '2',
	`last_online` VARCHAR(50) NOT NULL DEFAULT 'PUUDUB' COLLATE 'utf8mb4_uca1400_ai_ci',
	`queue` INT(5) NOT NULL DEFAULT '0',
	`last_answer` TIMESTAMP NULL DEFAULT '2000-01-01 00:00:00',
	`test_tries` INT(11) NULL DEFAULT '0',
	`wrong_answers` INT(11) NULL DEFAULT '5',
	`bug_tries` INT(11) NULL DEFAULT '0',
	`jail` INT(11) NULL DEFAULT '0',
	`admin_notes` VARCHAR(535) NULL DEFAULT '...' COLLATE 'utf8mb4_uca1400_ai_ci',
	`whitelist_disabled` TINYINT(1) NULL DEFAULT '0',
	PRIMARY KEY (`id`) USING BTREE
)
ENGINE=InnoDB
AUTO_INCREMENT=9301
;
