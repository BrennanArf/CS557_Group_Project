SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

CREATE SCHEMA IF NOT EXISTS `UWMtrackandfield` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `UWMtrackandfield`;

-- athlete
CREATE TABLE IF NOT EXISTS `UWMtrackandfield`.`athlete` (
  `athlete_id`  INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `first_name`  VARCHAR(45) NULL,
  `last_name`   VARCHAR(45) NOT NULL,
  `gender`      VARCHAR(10) NOT NULL,
  `event_group` VARCHAR(45) NULL DEFAULT NULL,
  `tfrrs_url`   VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`athlete_id`)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- competition_results
CREATE TABLE IF NOT EXISTS `UWMtrackandfield`.`competition_results` (
  `result_id`       INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `athlete_id`      INT UNSIGNED NOT NULL,
  `meet_name`       VARCHAR(150) NOT NULL,
  `meet_date`       DATE NOT NULL,
  `event`           VARCHAR(45) NOT NULL,
  `result_distance` DECIMAL(6,2) NULL DEFAULT NULL,
  `result_time`     VARCHAR(20) NULL DEFAULT NULL,
  `wind`            DECIMAL(6,2) NULL DEFAULT NULL,
  PRIMARY KEY (`result_id`),
  CONSTRAINT `com_athlete_FK`
    FOREIGN KEY (`athlete_id`)
    REFERENCES `UWMtrackandfield`.`athlete` (`athlete_id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- fall_testing
CREATE TABLE IF NOT EXISTS `UWMtrackandfield`.`fall_testing` (
  `test_id`     INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `athlete_id`  INT UNSIGNED NOT NULL,
  `season`      VARCHAR(10) NULL DEFAULT NULL,
  `vertical`    DECIMAL(5,2) NULL DEFAULT NULL,
  `slj`         DECIMAL(5,2) NULL DEFAULT NULL,
  `stj`         DECIMAL(5,2) NULL DEFAULT NULL,
  `sprint_50`   DECIMAL(5,2) NULL DEFAULT NULL,
  `ohb`         DECIMAL(5,2) NULL DEFAULT NULL,
  `blf`         DECIMAL(5,2) NULL DEFAULT NULL,
  `sprint_150`  DECIMAL(5,2) NULL DEFAULT NULL,
  PRIMARY KEY (`test_id`),
  CONSTRAINT `fall_athlete_FK`
    FOREIGN KEY (`athlete_id`)
    REFERENCES `UWMtrackandfield`.`athlete` (`athlete_id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- practice_results
CREATE TABLE IF NOT EXISTS `UWMtrackandfield`.`practice_results` (
  `practice_id`   INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `athlete_id`    INT UNSIGNED NOT NULL,
  `practice_date` DATE NULL DEFAULT NULL,
  `event`         VARCHAR(45) NULL DEFAULT NULL,
  `approach`      VARCHAR(45) NULL DEFAULT NULL,
  `gear`          VARCHAR(45) NULL DEFAULT NULL,
  `mark_meters`   DECIMAL(6,2) NULL DEFAULT NULL,
  `mark_raw`      DECIMAL(6,2) NULL DEFAULT NULL,
  `season`        VARCHAR(10) NULL DEFAULT NULL,
  PRIMARY KEY (`practice_id`),
  CONSTRAINT `practice_athlete_FK`
    FOREIGN KEY (`athlete_id`)
    REFERENCES `UWMtrackandfield`.`athlete` (`athlete_id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
