USE performancetracker;

CREATE VIEW studenten_uebersicht AS
    SELECT p.vorname, p.nachname, p.mail, m.matnr, s.studiengang
    FROM student s
    INNER JOIN matrikelnummer m ON m.matnr = s.fk_matnr
    INNER JOIN person p ON s.fk_mail = p.mail;

UPDATE studenten_uebersicht
SET matnr = 123456
WHERE matnr = 111111

