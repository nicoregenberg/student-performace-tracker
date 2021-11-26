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
SELECT fk_matnr, fk_kurs, SUM(increment_used_latedays(difference, latedays, fk_kurs)) as latedays_verrechnet, fk_leistungstyp FROM (
SELECT p.fk_leistungstyp, p.latedays, p.fk_matnr, p.fk_kurs, round_days_diff(p.frist, p.abgabe_ist) + frist_verlaengerung_tage
    AS difference
    FROM (
        SELECT frist, abgabe_ist, frist_verlaengerung_tage, fk_leistungstyp, latedays, fk_matnr, fk_kurs
        FROM abgabe_in_kurs a
        JOIN leistung l on a.id = l.fk_abgabe_in_kurs
        JOIN leistung_template lt on a.fk_leistung_template = lt.id)
        p) k
WHERE difference < 0
GROUP BY fk_leistungstyp, fk_matnr, fk_kurs;

-- Entscheidung für Backendübergabe und wichtig: Reset der globalen Variable latedaysused
DELIMITER //
DROP PROCEDURE IF EXISTS berechne_latedays //
CREATE PROCEDURE berechne_latedays (p_course_id INT, p_mat_nr INT, aggregate_leistungstyp bool)
    BEGIN
        SET @latedaysUsed = 0;
        IF aggregate_leistungstyp THEN
            IF p_course_id = -1 AND p_mat_nr = -1 THEN
                SELECT SUM(latedays_verrechnet) FROM berechnete_latedays;
            ELSEIF p_course_id = -1 THEN
                SELECT SUM(latedays_verrechnet) FROM berechnete_latedays WHERE fk_matnr = p_mat_nr;
            ELSEIF p_mat_nr = -1 THEN
                SELECT SUM(latedays_verrechnet) FROM berechnete_latedays WHERE fk_kurs = p_course_id;
            ELSE
                SELECT SUM(latedays_verrechnet) FROM berechnete_latedays WHERE fk_kurs = p_course_id AND fk_matnr = p_mat_nr;
            END IF;
        ELSE
            IF p_course_id = -1 AND p_mat_nr = -1 THEN
                SELECT latedays_verrechnet, fk_leistungstyp FROM berechnete_latedays;
            ELSEIF p_course_id = -1 THEN
                SELECT latedays_verrechnet, fk_leistungstyp FROM berechnete_latedays WHERE fk_matnr = p_mat_nr;
            ELSEIF p_mat_nr = -1 THEN
                SELECT latedays_verrechnet, fk_leistungstyp FROM berechnete_latedays WHERE fk_kurs = p_course_id;
            ELSE
                SELECT latedays_verrechnet, fk_leistungstyp FROM berechnete_latedays WHERE fk_kurs = p_course_id AND fk_matnr = p_mat_nr;
            END IF;
        END IF;
    END //
DELIMITER ;

call berechne_latedays(-1, -1, false);     -- alle Kurse, alle Studenten, latedays zusammengefasst
call berechne_latedays(1, -1, false);      -- Kurs 1, alle Studenten, latedays zusammengefasst
call berechne_latedays(-1, 123456, false); -- alle Kurse, Student 123456, latedays zusammengefasst
call berechne_latedays(1, 123456, false);  -- Kurs 1, Student 123456, latedays zusammengefasst

-- wie oben aber einzelne ausgabe
call berechne_latedays(-1, -1, true);
call berechne_latedays(1, -1, true);
call berechne_latedays(-1, 123456, true);
call berechne_latedays(1, 123456, true);