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