USE performancetracker;

SELECT frist, fk_leistungstyp FROM abgabe_in_kurs a
INNER JOIN leistung_template lt
    ON a.fk_leistung_template = lt.id
WHERE a.id NOT IN (
    SELECT fk_abgabe_in_kurs
    FROM leistung
    WHERE fk_matnr = 123456)
  AND fk_kurs = 2;

SELECT mail, vorname, nachname, matnr
FROM student_in_kurs sk
JOIN student s ON sk.fk_matnr = s.matnr
JOIN person p ON p.mail = s.fk_mail
WHERE fk_kurs = 4
ORDER BY nachname;

SELECT l.wert, lt.fk_leistungstyp, aik.frist, l.abgabe_ist FROM leistung l
JOIN abgabe_in_kurs aik on l.fk_abgabe_in_kurs = aik.id
JOIN leistung_template lt on aik.fk_leistung_template = lt.id
WHERE fk_matnr = 123456;

CREATE VIEW aktive_mitarbeit_von_studenten AS
    SELECT vorname, nachname, bezeichnung, zeitpunkt
FROM aktive_mitarbeit_in_kurs ak
JOIN aktive_mitarbeit am on am.id = ak.fk_aktive_mitarbeit
JOIN student s on ak.fk_matnr = s.matnr
JOIN person p on s.fk_mail = p.mail
ORDER BY zeitpunkt;


-- View für Abfragen unten
CREATE VIEW berechnete_latedays AS
SELECT SUM(difference + frist_verlaengerung_tage + latedays) AS verfuegbare_latedays, fk_kurs, fk_leistungstyp, fk_matnr FROM
(
    SELECT p.frist_verlaengerung_tage, p.fk_leistungstyp, p.latedays, p.fk_matnr, p.fk_kurs, DATEDIFF(p.frist, p.abgabe_ist)
    AS difference
    FROM (
        SELECT frist, abgabe_ist, frist_verlaengerung_tage, fk_leistungstyp, latedays, fk_matnr, fk_kurs
        FROM abgabe_in_kurs a
        JOIN leistung l on a.id = l.fk_abgabe_in_kurs
        JOIN leistung_template lt on a.fk_leistung_template = lt.id)
        p)
    k
WHERE difference + k.frist_verlaengerung_tage < 0
GROUP BY fk_leistungstyp, fk_matnr;

-- Berechnung Notenabzug für Student
SELECT SUM(verfuegbare_latedays) AS abzug_auf_note
FROM berechnete_latedays
WHERE fk_matnr = 123456
AND fk_kurs = 1
AND verfuegbare_latedays < 0;

-- verfügbare latedays (alle Kategorien in denen noch welche übrig sind werden angezeigt)
SELECT verfuegbare_latedays, fk_leistungstyp
FROM berechnete_latedays
WHERE fk_matnr = 123456
AND fk_kurs = 1
AND verfuegbare_latedays > 0;