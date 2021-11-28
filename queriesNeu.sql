USE performacetrackerhwr;

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

DROP VIEW aktive_mitarbeit_von_studenten;
CREATE VIEW aktive_mitarbeit_von_studenten AS
    SELECT vorname, nachname, bezeichnung, zeitpunkt, nachweis, fk_matnr as matnr, fk_kurs
FROM aktive_mitarbeit_in_kurs ak
JOIN aktive_mitarbeit am on am.id = ak.fk_aktive_mitarbeit
JOIN student s on ak.fk_matnr = s.matnr
JOIN person p on s.fk_mail = p.mail
ORDER BY zeitpunkt;

SELECT  * FROM aktive_mitarbeit_von_studenten;

DROP VIEW persons_overview;
CREATE VIEW persons_overview AS
SELECT CONCAT(vorname, ' ', nachname) AS fullname, mail FROM person p
INNER JOIN dozent d ON p.mail = d.fk_person
UNION
SELECT CONCAT(vorname, ' ', nachname) AS fullname, mail FROM person p
INNER JOIN student s ON p.mail = s.fk_mail;

DROP VIEW kurs_overview;
CREATE VIEW kurs_overview AS
SELECT CONCAT(fk_fachrichtung, '-', jahr, '-', wert,'-', modulnummer) AS kurs_kurzform,
       k.beschreibung AS kursbeschreibung, m.beschreibung AS modulbeschreibung, k.id, dik.fk_mail
FROM kurs k
JOIN dozent_in_kurs dik on k.id = dik.fk_kurs
JOIN jahrgang j on k.fk_jahrgang = j.id
JOIN kurs_buchstabe kb on k.fk_kurs_buchstabe = kb.wert
JOIN modul m on k.fk_modul = m.id
JOIN fachrichtung f on m.fk_fachrichtung = f.bezeichnung;

SELECT kurs_kurzform, kursbeschreibung, modulbeschreibung, id, mail, fullname
FROM kurs_overview ko
JOIN persons_overview p ON ko.fk_mail = p.mail
JOIN student_in_kurs sik ON ko.id = sik.fk_kurs
WHERE fk_matnr = 123456
GROUP BY id;


