SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

CREATE SCHEMA IF NOT EXISTS `UWMtrackandfield` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `UWMtrackandfield`;

-- athlete
CREATE TABLE IF NOT EXISTS `UWMtrackandfield`.`athlete` (
  `athlete_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,  -- added AUTO_INCREMENT
  `first_name` VARCHAR(45) NULL,
  `last_name`  VARCHAR(45) NOT NULL,
  `event_group` VARCHAR(45) NULL DEFAULT NULL,
  `gender`     VARCHAR(45) NOT NULL,
  PRIMARY KEY (`athlete_id`)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- competition_results
CREATE TABLE IF NOT EXISTS `UWMtrackandfield`.`competition_results` (
  `result_id`       INT UNSIGNED NOT NULL AUTO_INCREMENT,  -- added surrogate PK
  `athlete_id`      INT UNSIGNED NOT NULL,                 -- matched UNSIGNED to athlete
  `meet_name`       VARCHAR(100) NOT NULL,                 -- bumped from 45, meet names get long
  `meet_date`       DATE NOT NULL,                         -- was VARCHAR
  `event`           VARCHAR(45) NOT NULL,
  `result_distance` DECIMAL(6,2) NULL DEFAULT NULL,        -- was INT, meters e.g. 13.45
  `result_time`     TIME NULL DEFAULT NULL,                -- was INT, e.g. 00:07.42
  `wind`            DECIMAL(4,1) NULL DEFAULT NULL,        -- was INT, wind is e.g. +1.2
  PRIMARY KEY (`result_id`),                               -- was athlete_id, which can't be PK here
  CONSTRAINT `com_athlete_FK`
    FOREIGN KEY (`athlete_id`)
    REFERENCES `UWMtrackandfield`.`athlete` (`athlete_id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- fall_testing
CREATE TABLE IF NOT EXISTS `UWMtrackandfield`.`fall_testing` (
  `test_id`    INT UNSIGNED NOT NULL AUTO_INCREMENT,       -- added surrogate PK
  `athlete_id` INT UNSIGNED NOT NULL,
  `Season`     VARCHAR(45) NULL DEFAULT NULL,
  `Vertical`   DECIMAL(5,2) NULL DEFAULT NULL,             -- was INT, e.g. 32.5 inches
  `SLJ`        DECIMAL(5,2) NULL DEFAULT NULL,             -- standing long jump
  `STJ`        DECIMAL(5,2) NULL DEFAULT NULL,             -- standing triple jump
  `Sprint_50`  TIME NULL DEFAULT NULL,                     -- was INT, e.g. 00:06.42
  `OHB`        DECIMAL(5,2) NULL DEFAULT NULL,             -- overhead back throw, distance
  `Sprint_150` TIME NULL DEFAULT NULL,                     -- was INT
  PRIMARY KEY (`test_id`),
  CONSTRAINT `fall_athlete_FK`
    FOREIGN KEY (`athlete_id`)
    REFERENCES `UWMtrackandfield`.`athlete` (`athlete_id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- practice_results
CREATE TABLE IF NOT EXISTS `UWMtrackandfield`.`practice_results` (
  `practice_id`      INT UNSIGNED NOT NULL AUTO_INCREMENT, -- added surrogate PK
  `athlete_id`       INT UNSIGNED NOT NULL,
  `date`             DATE NULL DEFAULT NULL,               -- was DATETIME, DATE is enough
  `event`            VARCHAR(45) NULL,
  `practice_type`    VARCHAR(45) NULL,
  `result_distance_m` DECIMAL(6,2) NULL DEFAULT NULL,      -- was VARCHAR
  `result_time`      TIME NULL DEFAULT NULL,               -- was VARCHAR
  `footwear`         VARCHAR(45) NULL,
  PRIMARY KEY (`practice_id`),
  CONSTRAINT `practice_athlete_FK`
    FOREIGN KEY (`athlete_id`)
    REFERENCES `UWMtrackandfield`.`athlete` (`athlete_id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;