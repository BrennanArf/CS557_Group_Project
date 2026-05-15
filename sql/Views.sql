USE UWMtrackandfield;

------------------------------------------------------------
-- 1. COACH VIEW: All athletes with basic profile info
------------------------------------------------------------
CREATE OR REPLACE VIEW coach_all_athletes AS
SELECT 
    athlete_id,
    first_name,
    last_name,
    gender,
    event_group,
    tfrrs_url
FROM athlete;

------------------------------------------------------------
-- 2. COACH VIEW: Competition results for all athletes
------------------------------------------------------------
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

------------------------------------------------------------
-- 3. COACH VIEW: Fall testing summary for all athletes
------------------------------------------------------------
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

------------------------------------------------------------
-- 4. COACH VIEW: Practice results for all athletes
------------------------------------------------------------
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

------------------------------------------------------------
-- 5. STUDENT VIEW: A single athlete’s competition results
------------------------------------------------------------
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

------------------------------------------------------------
-- 6. STUDENT VIEW: A single athlete’s fall testing history
------------------------------------------------------------
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

------------------------------------------------------------
-- 7. STUDENT VIEW: A single athlete’s practice results
------------------------------------------------------------
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

------------------------------------------------------------
-- 8. Athlete performance summary
------------------------------------------------------------
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
