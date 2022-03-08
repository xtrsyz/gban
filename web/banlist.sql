CREATE TABLE `banlist` (
	`identifier` VARCHAR(60) NOT NULL,
	`reason` VARCHAR(255) NOT NULL DEFAULT 'Banned by Staff',
	`until` TIMESTAMP NOT NULL DEFAULT '2030-12-31 23:59:59',
	`created_at` TIMESTAMP NULL DEFAULT current_timestamp(),
	PRIMARY KEY (`identifier`)
);
