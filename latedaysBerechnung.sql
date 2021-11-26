USE performancetracker;
-- für Steini ^^

-- Wird weiter unten benutzt und in der Prozedur resettet.
-- Aufruf nur der View resettet die Variable nicht und führt
-- zu falschen Ergebnissen
SET @`latedaysUsed` = 0;

-- Korrektur der Tageberechnung in Datediff
DELIMITER //
DROP FUNCTION IF EXISTS round_days_diff //
CREATE FUNCTION round_days_diff (frist DATETIME, datum_ist DATETIME)
    RETURNS INT
    DETERMINISTIC
    BEGIN
        DECLARE days_diff INT;
        SET days_diff = DATEDIFF(frist, datum_ist);
        IF days_diff <= 0 THEN
            SET days_diff = days_diff - 1;
        END IF;
        RETURN days_diff;
    END //
DELIMITER ;

-- Berechnung der Latedays anhand der gesamtverfügbaren,
-- der für die Leistung verfügbaren und der Härtefalltage
DELIMITER //
DROP FUNCTION IF EXISTS increment_used_latedays //
CREATE FUNCTION increment_used_latedays (diff INT, latedays INT, courseId INT)
    RETURNS INT
    DETERMINISTIC
    BEGIN
        DECLARE ld_temp INT;
        DECLARE max_ld INT;
        SET max_ld = (SELECT latedays_verfuegbar FROM kurs WHERE id = courseId);
        IF @latedaysUsed >= max_ld THEN
            SET ld_temp = diff;
        ELSEIF diff + latedays > 0 THEN
            SET @latedaysUsed = @latedaysUsed - diff;
            SET ld_temp = 0;
        ELSE
            SET @latedaysUsed = @latedaysUsed + latedays;
            SET ld_temp = diff + latedays;
        END IF;
        IF @latedaysUsed > max_ld THEN
            SET ld_temp = ld_temp - (@latedaysUsed - max_ld);
        END IF;
        RETURN ld_temp;
    END //
DELIMITER ;

-- Erstellung der View die den Aufrufen zugrundeliegt
DROP VIEW IF EXISTS berechnete_latedays;
CREATE VIEW berechnete_latedays AS
SELECT k.id as abgabe_id, fk_matnr, fk_kurs, SUM(increment_used_latedays(difference, latedays, fk_kurs)) as latedays_verrechnet, fk_leistungstyp FROM (
SELECT p.id, p.fk_leistungstyp, p.latedays, p.fk_matnr, p.fk_kurs, round_days_diff(p.frist, p.abgabe_ist) + frist_verlaengerung_tage
    AS difference
    FROM (
        SELECT frist, abgabe_ist, frist_verlaengerung_tage, fk_leistungstyp, latedays, fk_matnr, fk_kurs, a.id
        FROM abgabe_in_kurs a
        JOIN leistung l on a.id = l.fk_abgabe_in_kurs
        JOIN leistung_template lt on a.fk_leistung_template = lt.id)
        p) k
WHERE difference < 0
GROUP BY fk_leistungstyp, fk_matnr, fk_kurs;

-- Entscheidung für Backendübergabe und wichtig: Reset der globalen Variable latedaysused
DELIMITER //
DROP PROCEDURE IF EXISTS berechne_latedays //
CREATE PROCEDURE berechne_latedays (IN p_course_id INT, IN p_mat_nr INT)
    BEGIN
        SET @latedaysUsed = 0;
        IF p_course_id = -1 AND p_mat_nr = -1 THEN
            SELECT fk_matnr as matnr, fk_kurs as courseid, latedays_verrechnet AS value, fk_leistungstyp AS worktype FROM berechnete_latedays;
        ELSEIF p_course_id = -1 THEN
            SELECT fk_matnr as matnr, fk_kurs as courseid, latedays_verrechnet AS value, fk_leistungstyp AS worktype FROM berechnete_latedays WHERE fk_matnr = p_mat_nr;
        ELSEIF p_mat_nr = -1 THEN
            SELECT fk_matnr as matnr, fk_kurs as courseid, latedays_verrechnet AS value, fk_leistungstyp AS worktype FROM berechnete_latedays WHERE fk_kurs = p_course_id;
        ELSE
            SELECT fk_matnr as matnr, fk_kurs as courseid, latedays_verrechnet AS value, fk_leistungstyp AS worktype FROM berechnete_latedays WHERE fk_kurs = p_course_id AND fk_matnr = p_mat_nr;
        END IF;
    END //
DELIMITER ;

DELIMITER //
DROP FUNCTION IF EXISTS berechne_latedays_aggregiert //
CREATE FUNCTION berechne_latedays_aggregiert (p_course_id INT, p_mat_nr INT, p_leistungstyp CHAR(30))
    RETURNS INT
    DETERMINISTIC
    BEGIN
        SET @latedaysUsed = 0;
        IF p_leistungstyp <> '-1' THEN
			IF p_course_id = -1 AND p_mat_nr = -1 THEN
				RETURN (SELECT SUM(latedays_verrechnet) FROM berechnete_latedays WHERE fk_leistungstyp = p_leistungstyp);
			ELSEIF p_course_id = -1 THEN
				RETURN (SELECT SUM(latedays_verrechnet) FROM berechnete_latedays WHERE fk_matnr = p_mat_nr AND fk_leistungstyp = p_leistungstyp);
			ELSEIF p_mat_nr = -1 THEN
				RETURN (SELECT SUM(latedays_verrechnet) FROM berechnete_latedays WHERE fk_kurs = p_course_id  AND fk_leistungstyp = p_leistungstyp);
			ELSE
				RETURN (SELECT SUM(latedays_verrechnet) FROM berechnete_latedays WHERE fk_kurs = p_course_id AND fk_matnr = p_mat_nr AND fk_leistungstyp = p_leistungstyp);
			End IF;
        ELSE 
			IF p_course_id = -1 AND p_mat_nr = -1 THEN
				RETURN (SELECT SUM(latedays_verrechnet) FROM berechnete_latedays );
			ELSEIF p_course_id = -1 THEN
				RETURN (SELECT SUM(latedays_verrechnet) FROM berechnete_latedays WHERE fk_matnr = p_mat_nr );
			ELSEIF p_mat_nr = -1 THEN
				RETURN (SELECT SUM(latedays_verrechnet) FROM berechnete_latedays WHERE fk_kurs = p_course_id) ;
			ELSE
				RETURN (SELECT SUM(latedays_verrechnet) FROM berechnete_latedays WHERE fk_kurs = p_course_id AND fk_matnr = p_mat_nr );
			End IF;
        END IF;
    END //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS berechne_latedays_team //
CREATE PROCEDURE berechne_latedays_team (IN p_abgabeid INT, p_team INT)
    BEGIN
        SET @latedaysUsed = 0;
        SELECT MIN(latedays_verrechnet) FROM berechnete_latedays bl
JOIN student_in_team st on st.fk_matnr = bl.fk_matnr
WHERE st.fk_team = p_team  and bl.abgabe_id = p_abgabeid;
    END //
DELIMITER ;

SET @latedaysused = 0 ;
SELECT * from berechnete_latedays;

call berechne_latedays(-1, -1);     -- alle Kurse, alle Studenten, latedays zusammengefasst
call berechne_latedays(1, -1);      -- Kurs 1, alle Studenten, latedays zusammengefasst
call berechne_latedays(-1, 123456); -- alle Kurse, Student 123456, latedays zusammengefasst
call berechne_latedays(3, 123456);  -- Kurs 1, Student 123456, latedays zusammengefasst
SELECT round_days_diff ('2021-11-01', '2021-11-26') + berechne_latedays_aggregiert (1, 123456, 'Arbeitsblatt') AS 'Verbleibende Tage'; -- verbleibende Zeit nach kurs, matn und Leistungstyp
call berechne_latedays_team (1,1); -- verbleibende zeit nach Abgabe und Team
