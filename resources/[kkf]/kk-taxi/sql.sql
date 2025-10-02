CREATE TABLE `taxi_job` (
	`pid` VARCHAR(11) NOT NULL,
	`done` INT(11) NOT NULL DEFAULT '0',
	PRIMARY KEY (`pid`) USING BTREE
)
COLLATE='utf8mb4_unicode_ci'
ENGINE=InnoDB
;
