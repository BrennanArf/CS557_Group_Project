ALTER TABLE uwm_track_and_field_performance_management_system_athlete ADD COLUMN avg_practice_mark DECIMAL(6,2) DEFAULT 0.00, 
ADD CONSTRAINT unique_tfrrs UNIQUE (tfrrs_url), 
ADD CONSTRAINT unique_athlete_name UNIQUE (first_name, last_name, gender); 

DELIMITER // 
CREATE PROCEDURE UpdateAthletePracticeAvg(IN p_athlete_id INT) 
BEGIN 
	UPDATE uwm_track_and_field_performance_management_system_athlete 
    SET avg_practice_mark = 
		( SELECT AVG(mark_meters) FROM uwm_track_and_field_performance_management_system_practiceresult 
			WHERE athlete_id = p_athlete_id ) 
	WHERE athlete_id = p_athlete_id; 
END // 

CREATE TRIGGER after_practice_insert 
AFTER INSERT ON uwm_track_and_field_performance_management_system_practiceresult 
FOR EACH ROW 
BEGIN 
	CALL UpdateAthletePracticeAvg(NEW.athlete_id); 
END //

DELIMITER ;