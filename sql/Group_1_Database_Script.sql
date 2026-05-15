-- MySQL database schema

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

CREATE SCHEMA IF NOT EXISTS `UWMtrackandfield` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `UWMtrackandfield`;

-- athlete table
CREATE TABLE IF NOT EXISTS `UWMtrackandfield`.`athlete` (
  `athlete_id`  INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `first_name`  VARCHAR(45) NULL,
  `last_name`   VARCHAR(45) NOT NULL,
  `gender`      VARCHAR(10) NOT NULL,
  `event_group` VARCHAR(45) NULL DEFAULT NULL,
  `tfrrs_url`   VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`athlete_id`)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- competition_results table
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

-- fall_testing table
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

-- practice_results table
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

---------------------------------------------------------------------
-- ALL OTHER SQL STATEMENTS
---------------------------------------------------------------------

-- Column added to athlete table
ALTER TABLE uwm_track_and_field_performance_management_system_athlete ADD COLUMN avg_practice_mark DECIMAL(6,2) NULL DEFAULT NULL,
ADD CONSTRAINT unique_athlete_name UNIQUE (first_name, last_name, gender);

-- Practice average procedure
DELIMITER //
CREATE PROCEDURE UpdateAthletePracticeAvg(IN p_athlete_id INT)
BEGIN
	UPDATE uwm_track_and_field_performance_management_system_athlete
    SET avg_practice_mark =
		( SELECT AVG(mark_meters) FROM uwm_track_and_field_performance_management_system_practiceresult
			WHERE athlete_id = p_athlete_id )
	WHERE athlete_id = p_athlete_id;
END //

-- Trigger on new athletes to have updated practice average from procedure
CREATE TRIGGER after_practice_insert
AFTER INSERT ON uwm_track_and_field_performance_management_system_practiceresult
FOR EACH ROW
BEGIN
	CALL UpdateAthletePracticeAvg(NEW.athlete_id);
END //

CREATE TRIGGER after_practice_update
AFTER UPDATE ON uwm_track_and_field_performance_management_system_practiceresult
FOR EACH ROW
BEGIN
	CALL UpdateAthletePracticeAvg(NEW.athlete_id);
END //

DELIMITER ;

-- Average practice number for all athletes' practice data
DELIMITER //

CREATE PROCEDURE athlete_practice_averages()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE current_athlete_id INT;
    DECLARE calculated_avg DECIMAL(6,2);

    DECLARE athlete_cursor CURSOR FOR
        SELECT athlete_id
        FROM uwm_track_and_field_performance_management_system_athlete;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    OPEN athlete_cursor;
    FETCH_LOOP: LOOP
        FETCH athlete_cursor INTO current_athlete_id;
        IF done THEN
            LEAVE FETCH_LOOP;
        END IF;

        SELECT AVG(mark_meters)
        INTO calculated_avg
        FROM uwm_track_and_field_performance_management_system_practiceresult
        WHERE athlete_id = current_athlete_id;

        IF calculated_avg IS NOT NULL THEN
            UPDATE uwm_track_and_field_performance_management_system_athlete
            SET avg_practice_mark = calculated_avg
            WHERE athlete_id = current_athlete_id;
        END IF;

    END LOOP FETCH_LOOP;

    CLOSE athlete_cursor;

END//

DELIMITER ;

-- COACH VIEW: All athletes with basic profile info
CREATE OR REPLACE VIEW coach_all_athletes AS
SELECT
    athlete_id,
    first_name,
    last_name,
    gender,
    event_group,
    tfrrs_url
FROM athlete;

-- COACH VIEW: Competition results for all athletes
CREATE OR REPLACE VIEW coach_competition_results AS
SELECT
    a.athlete_id,
    a.first_name,
    a.last_name,
    cr.meet_name,
    cr.meet_date,
    cr.event,
    cr.result_distance,
    cr.result_time,
    cr.wind
FROM competition_results cr
JOIN athlete a ON a.athlete_id = cr.athlete_id;

-- COACH VIEW: Fall testing summary for all athletes
CREATE OR REPLACE VIEW coach_fall_testing AS
SELECT
    a.athlete_id,
    a.first_name,
    a.last_name,
    ft.season,
    ft.vertical,
    ft.slj,
    ft.stj,
    ft.sprint_50,
    ft.ohb,
    ft.blf,
    ft.sprint_150
FROM fall_testing ft
JOIN athlete a ON a.athlete_id = ft.athlete_id;

-- COACH VIEW: Practice results for all athletes
CREATE OR REPLACE VIEW coach_practice_results AS
SELECT
    a.athlete_id,
    a.first_name,
    a.last_name,
    pr.practice_date,
    pr.event,
    pr.approach,
    pr.gear,
    pr.mark_meters,
    pr.mark_raw,
    pr.season
FROM practice_results pr
JOIN athlete a ON a.athlete_id = pr.athlete_id;

-- STUDENT VIEW: A single athlete’s competition results
CREATE OR REPLACE VIEW student_competition_results AS
SELECT
    cr.athlete_id,
    cr.meet_name,
    cr.meet_date,
    cr.event,
    cr.result_distance,
    cr.result_time,
    cr.wind
FROM competition_results cr;

-- STUDENT VIEW: A single athlete’s fall testing history
CREATE OR REPLACE VIEW student_fall_testing AS
SELECT
    ft.athlete_id,
    ft.season,
    ft.vertical,
    ft.slj,
    ft.stj,
    ft.sprint_50,
    ft.ohb,
    ft.blf,
    ft.sprint_150
FROM fall_testing ft;

-- STUDENT VIEW: A single athlete’s practice results
CREATE OR REPLACE VIEW student_practice_results AS
SELECT
    pr.athlete_id,
    pr.practice_date,
    pr.event,
    pr.approach,
    pr.gear,
    pr.mark_meters,
    pr.mark_raw,
    pr.season
FROM practice_results pr;

-- Athlete performance summary
CREATE OR REPLACE VIEW athlete_performance_summary AS
SELECT
    a.athlete_id,
    CONCAT(a.first_name, ' ', a.last_name) AS athlete_name,
    COUNT(DISTINCT cr.result_id) AS total_competitions,
    COUNT(DISTINCT ft.test_id) AS total_fall_tests,
    COUNT(DISTINCT pr.practice_id) AS total_practices
FROM athlete a
LEFT JOIN competition_results cr ON cr.athlete_id = a.athlete_id
LEFT JOIN fall_testing ft ON ft.athlete_id = a.athlete_id
LEFT JOIN practice_results pr ON pr.athlete_id = a.athlete_id
GROUP BY a.athlete_id, athlete_name;
