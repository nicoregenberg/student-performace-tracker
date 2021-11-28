USE performacetrackerhwr;
-- für Steini 2.0 ^^

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

DROP FUNCTION IF EXISTS calc_malus_leistung //
CREATE FUNCTION calc_malus_leistung (diff INT, latedays_leistung INT)
    RETURNS INT
    DETERMINISTIC
    BEGIN
        IF latedays_leistung + diff < 0 THEN
            RETURN latedays_leistung + diff;
        ELSE
            RETURN 0;
        END IF;
    END //

DROP FUNCTION IF EXISTS calc_latedaysUsed //
CREATE FUNCTION calc_latedaysUsed (diff INT, latedays_leistung INT)
    RETURNS INT
    DETERMINISTIC
    BEGIN
        IF latedays_leistung + diff >= 0 THEN
            RETURN diff * -1;
        ELSE
            RETURN latedays_leistung;
        END IF;
    END //

DROP FUNCTION IF EXISTS calc_latedays_left_total //
CREATE FUNCTION calc_latedays_left_total (ld_used INT, ld_available INT)
    RETURNS INT
    DETERMINISTIC
    BEGIN
        IF ld_available - ld_used >= 0 THEN
            RETURN ld_available - ld_used;
        ELSE
            RETURN 0;
        END IF;
    END //
DELIMITER ;

DELIMITER //
DROP FUNCTION IF EXISTS aggregate_latedays //
CREATE FUNCTION aggregate_latedays (ld_used INT, ld_available INT, penalty INT)
    RETURNS INT
    DETERMINISTIC
    BEGIN
        IF ld_available - ld_used < 0 THEN
            RETURN ld_available - ld_used + penalty;
        ELSE
            RETURN penalty;
        END IF;
    END //
DELIMITER ;

-- Strafe auf Note inkl aller Variablen
DELIMITER //
DROP FUNCTION IF EXISTS berechne_latedays_aggregiert //
CREATE FUNCTION berechne_latedays_aggregiert (p_course_id INT, p_mat_nr INT)
    RETURNS INT
    DETERMINISTIC
    BEGIN
        DECLARE penalty INT;
        SET penalty = (SELECT SUM(aggregate_latedays(VerbrauchteLD, latedays_verfuegbar, Malus))
            FROM latedays_merged_overvies
            WHERE fk_matnr = p_mat_nr
            AND kurs_id = p_course_id
            GROUP BY fk_matnr);
        IF penalty IS NULL THEN
            RETURN 0;
        ELSE
            RETURN penalty;
        END IF;
    END //
DELIMITER ;

    -- View mit Übersicht aller Latedays Variablen
    DROP VIEW latedays_merged_overvies;
    CREATE VIEW latedays_merged_overvies AS (
    SELECT kurs_id, abgabe_id, k.fk_matnr, k.fk_team, k.latedays_verfuegbar, fk_leistungstyp,
           calc_latedaysUsed(difference, latedays) AS VerbrauchteLD,
           calc_malus_leistung(difference, latedays) AS Malus
    FROM (
        SELECT p.fk_leistungstyp, p.fk_team, abgabe_id, kurs_id, p.fk_matnr, p.latedays, p.latedays_verfuegbar,
               (round_days_diff(p.frist, p.abgabe_ist) + frist_verlaengerung_tage)
            AS difference
            FROM (
                SELECT frist, abgabe_ist, fk_matnr, l.fk_team, latedays_verfuegbar, frist_verlaengerung_tage,
                       fk_leistungstyp, latedays, k2.id as kurs_id, a.id as abgabe_id
                FROM abgabe_in_kurs a
                JOIN leistung l on a.id = l.fk_abgabe_in_kurs
                JOIN leistung_template lt on a.fk_leistung_template = lt.id
                JOIN kurs k2 on a.fk_kurs = k2.id)
            p)
        k WHERE difference < 0);

-- Testaufruf zum Vergleichen
SELECT latedays_verfuegbar as latedayskurs, VerbrauchteLD, latedays_verfuegbar - VerbrauchteLD as latedaysuebrig, Malus,
       aggregate_latedays(VerbrauchteLD, latedays_verfuegbar, Malus) as finaler_abzug
    FROM latedays_merged_overvies;

-- Abruf Abgabe mit Frist und noch min verfügbaren Latedays in Team
SELECT MIN(l.latedaysuebrig), l.frist FROM (
SELECT calc_latedays_left_total(VerbrauchteLD, latedays_verfuegbar) as latedaysuebrig, ak.frist
    FROM latedays_merged_overvies lo
JOIN abgabe_in_kurs ak ON ak.id = lo.abgabe_id
WHERE fk_team = 1 AND kurs_id = 1) l;

SELECT calc_latedays_left_total(VerbrauchteLD, latedays_verfuegbar) as latedaysuebrig, ak.frist
    FROM latedays_merged_overvies lo
JOIN abgabe_in_kurs ak ON ak.id = lo.abgabe_id
WHERE fk_team = 1 AND kurs_id = 1;