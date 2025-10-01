CREATE TABLE `work_times` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`pid` INT(11) NOT NULL,
	`minutes` INT(11) NOT NULL DEFAULT '0',
	`faction` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_uca1400_ai_ci',
	`date` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
	PRIMARY KEY (`id`) USING BTREE
)
ENGINE=InnoDB
AUTO_INCREMENT=3
;

CREATE TABLE `taxi_job` (
	`pid` INT(11) NOT NULL,
	`done` INT(11) NOT NULL DEFAULT '0',
	PRIMARY KEY (`pid`) USING BTREE
)
COLLATE='utf8mb4_unicode_ci'
ENGINE=InnoDB
;

CREATE TABLE `factions` (
	`name` VARCHAR(64) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`label` VARCHAR(64) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`type` VARCHAR(64) NOT NULL DEFAULT 'job' COLLATE 'utf8mb4_unicode_ci',
	`max_count` INT(11) NOT NULL DEFAULT '7',
	`money` INT(25) NOT NULL DEFAULT '0',
	`crypto` INT(25) NOT NULL DEFAULT '0',
	`data` LONGTEXT NULL DEFAULT '{"color":"FFFFFF"}' COLLATE 'utf8mb4_unicode_ci',
	PRIMARY KEY (`name`) USING BTREE
)
COLLATE='utf8mb4_unicode_ci'
ENGINE=InnoDB
;

CREATE TABLE `faction_logs` (
	`id` INT(64) NOT NULL AUTO_INCREMENT,
	`pid` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`faction` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`action` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`text` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`time` TIMESTAMP NULL DEFAULT current_timestamp(),
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8mb4_unicode_ci'
ENGINE=InnoDB
AUTO_INCREMENT=117967
;

CREATE TABLE `faction_announcements` (
	`id` INT(64) NOT NULL AUTO_INCREMENT,
	`sender` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`faction` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`title` VARCHAR(50) NULL DEFAULT '' COLLATE 'utf8mb4_unicode_ci',
	`context` VARCHAR(3000) NULL DEFAULT '' COLLATE 'utf8mb4_unicode_ci',
	`time` TIMESTAMP NULL DEFAULT current_timestamp(),
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8mb4_unicode_ci'
ENGINE=InnoDB
ROW_FORMAT=DYNAMIC
AUTO_INCREMENT=154
;

CREATE TABLE `faction_grades` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`job_name` VARCHAR(32) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`grade` INT(11) NOT NULL,
	`label` VARCHAR(64) NOT NULL DEFAULT 'Puudub' COLLATE 'utf8mb4_unicode_ci',
	`short` VARCHAR(64) NOT NULL DEFAULT 'Puudub' COLLATE 'utf8mb4_unicode_ci',
	`salary` INT(11) NOT NULL DEFAULT '0',
	`permissions` VARCHAR(550) NOT NULL DEFAULT '{"leaderMenu":false,"jobMenu":false,"banking":false,"stash":false,"garage":false,"members":false,"ranks":false}' COLLATE 'utf8mb4_unicode_ci',
	PRIMARY KEY (`id`) USING BTREE,
	INDEX `job_name` (`job_name`) USING BTREE,
	INDEX `grade` (`grade`) USING BTREE
)
COLLATE='utf8mb4_unicode_ci'
ENGINE=InnoDB
AUTO_INCREMENT=335
;
