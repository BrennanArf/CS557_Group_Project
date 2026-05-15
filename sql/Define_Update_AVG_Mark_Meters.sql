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
