/*
--------------------------------------------------
    Skript zur Erstellung der Datenbank Performancetracker
    im Kurs Datenbanken im Kurs WI 20 C bei Herrn Fischer

    Autoren:
    Nico Regenberg, Nico Steinmüller Robert Neubert,
    Corentin Hamp, Danny Neupauer, Hannes Roever

    Gliederung:
      1-100     Schema
    100-300     Trigger
    usw.

--------------------------------------------------
*/

USE performacetrackerhwr;
DROP DATABASE IF EXISTS performacetrackerhwr;
CREATE DATABASE IF NOT EXISTS performacetrackerhwr;
USE performacetrackerhwr;

/*
--------------------------------------------------
    SCHEMA
--------------------------------------------------
*/

DROP TABLE IF EXISTS aktive_mitarbeit;
CREATE TABLE aktive_mitarbeit
(
    id          INT AUTO_INCREMENT PRIMARY KEY,
    zeitpunkt   DATETIME  NOT NULL,
    nachweis    CHAR(255) NOT NULL,
    bezeichnung CHAR(255) NULL
);

CREATE TABLE fachrichtung
(
    bezeichnung CHAR(10) NOT NULL PRIMARY KEY
);

CREATE TABLE jahrgang
(
    id        INT AUTO_INCREMENT PRIMARY KEY,
    jahr      CHAR(2) NOT NULL,
    sem_so_wi CHAR    NOT NULL
);

CREATE TABLE kurs_buchstabe
(
    wert CHAR(1) NOT NULL PRIMARY KEY
);

CREATE TABLE leistungstyp
(
    bezeichnung CHAR(30) NOT NULL PRIMARY KEY
);

CREATE TABLE leistung_template
(
    id              INT AUTO_INCREMENT PRIMARY KEY,
    fk_leistungstyp CHAR(30)      NOT NULL,
    latedays        SMALLINT      NULL,
    gewichtung      DECIMAL(3, 2) NULL,
    teiler          SMALLINT      NOT NULL,
    CONSTRAINT leistung_template_leistungstyp_bezeichnung_fk
        FOREIGN KEY (fk_leistungstyp) REFERENCES leistungstyp (bezeichnung) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE modul
(
    id              INT AUTO_INCREMENT PRIMARY KEY,
    fk_fachrichtung CHAR(10)  NOT NULL,
    modulnummer     INT(3)    NOT NULL,
    beschreibung    CHAR(255) NULL,
    CONSTRAINT modul_fachrichtung_fk
        FOREIGN KEY (fk_fachrichtung) REFERENCES fachrichtung (bezeichnung) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE kurs
(
    id                  INT AUTO_INCREMENT PRIMARY KEY,
    beschreibung        CHAR(200)     NULL,
    fk_jahrgang         INT           NOT NULL,
    fk_kurs_buchstabe   CHAR          NOT NULL,
    fk_modul            INT           NOT NULL,
    modul_gewichtung    DECIMAL(3, 2) NOT NULL,
    latedays_verfuegbar SMALLINT      NULL,
    CONSTRAINT kurs_ibfk_1
        FOREIGN KEY (fk_jahrgang) REFERENCES jahrgang (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT kurs_ibfk_2
        FOREIGN KEY (fk_kurs_buchstabe) REFERENCES kurs_buchstabe (wert) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT kurs_ibfk_3
        FOREIGN KEY (fk_modul) REFERENCES modul (id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE abgabe_in_kurs
(
    id                     INT AUTO_INCREMENT PRIMARY KEY,
    frist                  DATETIME NOT NULL,
    teamarbeit_max_erlaubt SMALLINT NULL,
    fk_leistung_template   INT      NOT NULL,
    fk_kurs                INT      NOT NULL,
    CONSTRAINT abgabe_kurs_id_fk
        FOREIGN KEY (fk_kurs) REFERENCES kurs (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT abgabe_leistung_template_id_fk
        FOREIGN KEY (fk_leistung_template) REFERENCES leistung_template (id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE person
(
    mail     CHAR(50) NOT NULL PRIMARY KEY,
    vorname  CHAR(30) NULL,
    nachname CHAR(30) NOT NULL
);

CREATE TABLE student
(
    fk_mail         CHAR(50) NOT NULL,
    matnr           INT      NOT NULL PRIMARY KEY,
    fk_fachrichtung CHAR(30) NOT NULL,
    CONSTRAINT student_person_mail_fk
        FOREIGN KEY (fk_mail) REFERENCES person (mail) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT student_fachrichtung_fk
        FOREIGN KEY (fk_fachrichtung) REFERENCES fachrichtung (bezeichnung) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE aktive_mitarbeit_in_kurs
(
    fk_matnr            INT NOT NULL,
    fk_kurs             INT NOT NULL,
    fk_aktive_mitarbeit INT NOT NULL,
    CONSTRAINT aktive_mitarbeit_in_kurs_ibfk_1
        FOREIGN KEY (fk_matnr) REFERENCES student (matnr) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT aktive_mitarbeit_in_kurs_ibfk_2
        FOREIGN KEY (fk_kurs) REFERENCES kurs (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT aktive_mitarbeit_in_kurs_ibfk_3
        FOREIGN KEY (fk_aktive_mitarbeit) REFERENCES aktive_mitarbeit (id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE anfrageaufnahme
(
    fk_kurs  INT NOT NULL,
    fk_matnr INT NOT NULL,
    CONSTRAINT anfrageaufnahme_ibfk_1
        FOREIGN KEY (fk_kurs) REFERENCES kurs (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT anfrageaufnahme_ibfk_2
        FOREIGN KEY (fk_matnr) REFERENCES student (matnr) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE team
(
    id             INT AUTO_INCREMENT PRIMARY KEY,
    max_mitglieder SMALLINT DEFAULT 3 NOT NULL,
    kommentar      CHAR(255)          NULL
);

CREATE TABLE leistung
(
    id                       INT AUTO_INCREMENT PRIMARY KEY,
    fk_matnr                 INT           NOT NULL,
    fk_abgabe_in_kurs        INT           NOT NULL,
    fk_team                  INT           NULL,
    wert                     DECIMAL(3, 2) NOT NULL,
    abgabe_ist               DATETIME      NULL,
    frist_verlaengerung_tage SMALLINT      NULL,
    festgesetzt              BOOL,
    CONSTRAINT leistung_team_id_fk
        FOREIGN KEY (fk_team) REFERENCES team (id) ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT leistung_abgabe_id_fk
        FOREIGN KEY (fk_abgabe_in_kurs) REFERENCES abgabe_in_kurs (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT leistung_matrikelnummer_von_student_matrikelnummer_fk
        FOREIGN KEY (fk_matnr) REFERENCES student (matnr) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE account
(
    fk_mail       CHAR(50)  NOT NULL,
    password_hash CHAR(255) NOT NULL,
    CONSTRAINT account_person_mail_fk
        FOREIGN KEY (fk_mail) REFERENCES person (mail)
);

CREATE TABLE dozent
(
    fk_person CHAR(50) NOT NULL PRIMARY KEY,
    CONSTRAINT dozent_person_mail_fk
        FOREIGN KEY (fk_person) REFERENCES person (mail) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE student_in_team
(
    fk_matnr INT NOT NULL,
    fk_team  INT NOT NULL,
    CONSTRAINT student_in_team_matrikelnummer_von_student_matrikelnummer_fk
        FOREIGN KEY (fk_matnr) REFERENCES student (matnr) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT student_in_team_team_id_fk
        FOREIGN KEY (fk_team) REFERENCES team (id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE zugriffsrecht
(
    abkuerzung   CHAR(3)   NOT NULL PRIMARY KEY,
    beschreibung CHAR(255) NULL,
    CONSTRAINT rollen_rechte_uindex
        UNIQUE (abkuerzung)
);

CREATE TABLE dozent_in_kurs
(
    fk_zugriffsrecht CHAR(3)  NOT NULL,
    fk_mail          CHAR(50) NOT NULL,
    fk_kurs          INT      NOT NULL,
    CONSTRAINT dozent_in_kurs_dozent_fk_mail_fk
        FOREIGN KEY (fk_mail) REFERENCES dozent (fk_person) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT dozent_in_kurs_kurs_id_fk
        FOREIGN KEY (fk_kurs) REFERENCES kurs (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT dozent_in_kurs_zugriffsrecht_abkuerzung_fk
        FOREIGN KEY (fk_zugriffsrecht) REFERENCES zugriffsrecht (abkuerzung) ON UPDATE CASCADE
);

CREATE TABLE student_in_kurs
(
    fk_kurs                INT     NULL,
    fk_matnr               INT     NULL,
    fk_zugriffsrechte      CHAR(3) NULL,
    aktive_mitarbeit_bonus INT     NULL,
    CONSTRAINT student_in_kurs_kurs_id_fk
        FOREIGN KEY (fk_kurs) REFERENCES kurs (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT student_in_kurs_matrikelnummer_von_student_matrikelnummer_fk
        FOREIGN KEY (fk_matnr) REFERENCES student (matnr) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT student_in_kurs_zugriffsrecht_abkuerzung_fk
        FOREIGN KEY (fk_zugriffsrechte) REFERENCES zugriffsrecht (abkuerzung) ON UPDATE CASCADE
);

CREATE INDEX kurs_id
    ON anfrageaufnahme (fk_kurs);

CREATE INDEX student_matnr
    ON anfrageaufnahme (fk_matnr);

CREATE INDEX jahrgangid
    ON kurs (fk_jahrgang);

CREATE INDEX kursbuchstabeid
    ON kurs (fk_kurs_buchstabe);

CREATE INDEX modulid
    ON kurs (fk_modul);

CREATE INDEX aktive_mitarbeit_id
    ON aktive_mitarbeit_in_kurs (fk_aktive_mitarbeit);

CREATE INDEX kurs_id
    ON aktive_mitarbeit_in_kurs (fk_kurs);

CREATE INDEX student_matnr
    ON aktive_mitarbeit_in_kurs (fk_matnr);

/*
--------------------------------------------------
    PROZEDUREN UND FUNKTIONEN
--------------------------------------------------
*/

-- Korrektur der Tageberechnung in Datediff
DELIMITER //
DROP FUNCTION IF EXISTS round_days_diff //
CREATE FUNCTION round_days_diff(frist DATETIME, datum_ist DATETIME)
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

DROP FUNCTION IF EXISTS calc_penalty_on_leistung //
CREATE FUNCTION calc_penalty_on_leistung(diff INT, latedays_leistung INT)
    RETURNS INT
    DETERMINISTIC
BEGIN
    IF latedays_leistung + diff < 0 THEN
        RETURN latedays_leistung + diff;
    ELSE
        RETURN 0;
    END IF;
END //

DROP FUNCTION IF EXISTS calc_latedays_used //
CREATE FUNCTION calc_latedays_used(diff INT, latedays_leistung INT)
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
CREATE FUNCTION calc_latedays_left_total(ld_used INT, ld_available INT)
    RETURNS INT
    DETERMINISTIC
BEGIN
    IF ld_available - ld_used >= 0 THEN
        RETURN ld_available - ld_used;
    ELSE
        RETURN 0;
    END IF;
END //

DROP FUNCTION IF EXISTS sum_latedays_and_penalty //
CREATE FUNCTION sum_latedays_and_penalty(ld_used INT, ld_available INT, penalty INT)
    RETURNS INT
    DETERMINISTIC
BEGIN
    IF ld_available - ld_used < 0 THEN
        RETURN ld_available - ld_used + penalty;
    ELSE
        RETURN penalty;
    END IF;
END //

-- Strafe auf Note inkl aller Variablen
DROP FUNCTION IF EXISTS calc_penalty_on_course_grade //
CREATE FUNCTION calc_penalty_on_course_grade(p_course_id INT, p_mat_nr INT)
    RETURNS INT
    DETERMINISTIC
BEGIN
    DECLARE penalty INT;
    SET penalty = (SELECT SUM(sum_latedays_and_penalty(verbrauchteld, latedays_verfuegbar, malus))
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


DROP FUNCTION IF EXISTS get_Kurse_gewicht //
CREATE FUNCTION get_Kurse_gewicht(Matrikelnummer INT, Modul_ID INT)
RETURNS DECIMAL(3, 2)
    DETERMINISTIC BEGIN
    RETURN (
        SELECT SUM(modul_gewichtung)
        FROM (
            SELECT DISTINCT *
            FROM Kursnote
            WHERE fk_modul = Modul_ID AND fk_matnr = Matrikelnummer
        ) AS abc
    );
END //


DROP PROCEDURE IF EXISTS insert_aktive_mitarbeit //
CREATE PROCEDURE insert_aktive_mitarbeit(matrikelnummer INT, kurs_id INT,
        p_zeitpunkt DATE, p_nachweis CHAR(255), p_bezeichnung CHAR(255))
BEGIN
    INSERT INTO aktive_mitarbeit(id, zeitpunkt, nachweis, bezeichnung)
    VALUES (NULL, p_zeitpunkt, p_nachweis, p_bezeichnung);
    INSERT INTO aktive_mitarbeit_in_kurs(fk_matnr, fk_kurs, fk_aktive_mitarbeit)
    VALUES (matrikelnummer, kurs_id, LAST_INSERT_ID());
END //

## Beitrittsanfrage für einen Kurs annehmen
DROP PROCEDURE IF EXISTS accept_pending_request //
CREATE PROCEDURE accept_pending_request(matrikelnummer INT, kurs_id INT, rechte CHAR(3))
BEGIN
    DELETE FROM anfrageaufnahme WHERE fk_kurs = kurs_id AND fk_matnr = matrikelnummer;
    INSERT INTO student_in_kurs(fk_kurs, fk_matnr, fk_zugriffsrechte) VALUES (kurs_id, matrikelnummer, rechte);
END //
DELIMITER ;

/*
--------------------------------------------------
    VIEWS
--------------------------------------------------
*/

-- View mit Übersicht aller Latedays Variablen
DROP VIEW IF EXISTS latedays_merged_overvies;
CREATE VIEW latedays_merged_overvies AS (
SELECT kurs_id, abgabe_id, k.fk_matnr, k.fk_team, k.latedays_verfuegbar, fk_leistungstyp,
    calc_latedays_used(difference, latedays)       AS verbrauchteld,
    calc_penalty_on_leistung(difference, latedays) AS malus
FROM (
    SELECT p.fk_leistungstyp, p.fk_team, abgabe_id, kurs_id, p.fk_matnr, p.latedays, p.latedays_verfuegbar,
        (round_days_diff(p.frist, p.abgabe_ist) + frist_verlaengerung_tage)
            AS difference
    FROM (
        SELECT frist, abgabe_ist, fk_matnr, l.fk_team, latedays_verfuegbar, frist_verlaengerung_tage, fk_leistungstyp,
            latedays, k2.id AS kurs_id, a.id  AS abgabe_id FROM abgabe_in_kurs a
                 JOIN leistung l ON a.id = l.fk_abgabe_in_kurs
                 JOIN leistung_template lt ON a.fk_leistung_template = lt.id
                 JOIN kurs k2 ON a.fk_kurs = k2.id) p) k
WHERE difference < 0);


##Student lässt sich alle Noten eines Kurses anzeigen = Note je Kategorie
CREATE VIEW note_nach_leistungstyp AS
SELECT fk_kurs, fk_matnr, fk_leistungstyp, FORMAT(AVG(wert), 1) AS note, gewichtung
FROM leistung
         JOIN abgabe_in_kurs ON abgabe_in_kurs.id = leistung.fk_abgabe_in_kurs
         JOIN leistung_template ON leistung_template.id = abgabe_in_kurs.fk_leistung_template
GROUP BY fk_leistungstyp, fk_matnr, gewichtung, fk_leistung_template, fk_kurs;


##Student lässt sich offene Anfragen für Module anzeigen
DROP VIEW IF EXISTS kursname_voll;
CREATE VIEW kursname_voll AS
SELECT kurs.id AS fk_kurs_id, modul.id AS fk_modul_id,
    CONCAT(kurs.fk_jahrgang, '-', modul.fk_fachrichtung, '-', modul.modulnummer, '-', jahrgang.sem_so_wi, '-',
           modul.fk_fachrichtung, jahrgang.jahr, kurs.fk_kurs_buchstabe, '/', person.nachname, ',',
           person.vorname) AS vollname
FROM kurs
         JOIN modul ON kurs.fk_modul = modul.id
         JOIN jahrgang ON kurs.fk_jahrgang = jahrgang.id
         JOIN dozent_in_kurs ON dozent_in_kurs.fk_kurs = kurs.id
         JOIN dozent ON dozent_in_kurs.fk_mail = dozent.fk_person
         JOIN person ON dozent.fk_person = person.mail;


##Student, Dozent: Welche aktiven Mitarbeiten hat Student XY in einem Kurs erbracht?
DROP VIEW IF EXISTS aktive_mitarbeit_von_studenten;
CREATE VIEW aktive_mitarbeit_von_studenten AS
    SELECT vorname, nachname, bezeichnung, zeitpunkt, nachweis, fk_matnr as matnr, fk_kurs
FROM aktive_mitarbeit_in_kurs ak
JOIN aktive_mitarbeit am on am.id = ak.fk_aktive_mitarbeit
JOIN student s on ak.fk_matnr = s.matnr
JOIN person p on s.fk_mail = p.mail
ORDER BY zeitpunkt;


# Abhängigkeit von einer View, wird deshalb erst hier erstellt
DELIMITER //
DROP FUNCTION IF EXISTS get_leistungstypen_gewicht //
CREATE FUNCTION get_leistungstypen_gewicht(Matrikelnummer INT, Kurs_ID INT)
RETURNS DECIMAL(3, 2)
    DETERMINISTIC BEGIN
    RETURN (
        SELECT SUM(N.gewichtung)
        FROM Note_nach_Leistungstyp AS N
        WHERE N.fk_kurs = Kurs_ID AND N.fk_matnr = Matrikelnummer
    );
END //


DROP VIEW IF EXISTS Kursnote;
CREATE VIEW Kursnote AS SELECT DISTINCT
    fk_kurs, fk_matnr, kurs.fk_modul, kurs.modul_gewichtung, FORMAT(
        Kursnote -(1 / 15) * (IFNULL(student_in_kurs.aktive_mitarbeit_bonus, 0) + (
                IF(calc_penalty_on_course_grade(fk_kurs, fk_matnr)
                       >= 0, 0, calc_penalty_on_course_grade(fk_kurs, fk_matnr)))), 1
) AS Kursnote
FROM (SELECT fk_kurs, fk_matnr, (FORMAT((SUM(NoteGewichtet)), 2)) AS Kursnote
    FROM (
        SELECT fk_kurs, fk_matnr, (Note * (gewichtung / get_leistungstypen_gewicht(
                        Note_nach_Leistungstyp.fk_matnr,
                        Note_nach_Leistungstyp.fk_kurs))) AS NoteGewichtet
        FROM Note_nach_Leistungstyp) AS abc
GROUP BY fk_kurs, fk_matnr) AS def
INNER JOIN student_in_kurs USING(fk_matnr, fk_kurs)
JOIN kurs On kurs.id = student_in_kurs.fk_kurs;


DROP VIEW IF EXISTS Modulnote;
CREATE VIEW Modulnote AS
    SELECT fk_matnr, fk_modul, FORMAT(SUM(a), 1) AS Modulnote
    FROM (
    SELECT DISTINCT Kursnote.fk_matnr, kurs.fk_modul, (
            Kursnote.Kursnote * (kurs.modul_gewichtung / get_Kurse_gewicht(
                    Kursnote.fk_matnr,
                    kurs.fk_modul))) AS a
    FROM Kursnote
    JOIN kurs ON kurs.id = Kursnote.fk_kurs) AS def
    GROUP BY fk_modul, fk_matnr;


/*
--------------------------------------------------
    TRIGGER
--------------------------------------------------
*/

DROP TRIGGER IF EXISTS check_student_in_kurs_before_insert_on_leistung;
DELIMITER //
CREATE TRIGGER check_student_in_kurs_before_insert_on_leistung
    BEFORE INSERT ON leistung
    FOR EACH ROW
BEGIN
    ##Kursprüfung
    SET @kurs = (SELECT fk_kurs FROM abgabe_in_kurs WHERE abgabe_in_kurs.id = new.fk_abgabe_in_kurs);
    SET @count_kurse = (SELECT COUNT(student_in_kurs.fk_kurs)
                       FROM student_in_kurs
                       WHERE student_in_kurs.fk_kurs = @kurs
                         AND student_in_kurs.fk_matnr = new.fk_matnr);
    SET @count_kurse = IFNULL(@count_kurse, 0);

    IF (@count_kurse < 1) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT =
                'Fehler: Der Student ist nicht in dem Kurs, für den Er versucht eine Leistung einzutragen!';
    END IF;

    ##Student in Team Prüfung
    IF (new.fk_team IS NOT NULL) THEN
        SET @count_team = (SELECT COUNT(student_in_team.fk_team)
                          FROM student_in_team
                          WHERE student_in_team.fk_team = new.fk_team
                            AND student_in_team.fk_matnr = new.fk_matnr);
        SET @count_team = IFNULL(@count_team, 0);

        IF (@count_team < 1) THEN
            SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT =
                    'Fehler: Der Student ist nicht in dem Team, für das Er versucht eine Leistung einzutragen!';
        END IF;
    END IF;

    ##Teamgrößen Prüfung
    SET @max_team_grosse = (SELECT abgabe_in_kurs.teamarbeit_max_erlaubt
                           FROM abgabe_in_kurs
                           WHERE abgabe_in_kurs.id = new.fk_abgabe_in_kurs);
    SET @max_team_grosse = IFNULL(@max_team_grosse, 0);
    SET @team_grosse =
            (SELECT COUNT(student_in_team.fk_matnr) FROM student_in_team WHERE student_in_team.fk_team = new.fk_team);
    SET @team_grosse = IFNULL(@team_grosse, 0);

    IF (@team_grosse > @max_team_grosse) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'Fehler: Das angegebene Team ist für die Leistung zu groß!';
    END IF;

    ##Leistungsdopplung prüfen
    SET @count_leistung = (SELECT COUNT(leistung.fk_matnr)
                          FROM leistung
                          WHERE leistung.fk_matnr = new.fk_matnr
                            AND leistung.fk_abgabe_in_kurs = new.fk_abgabe_in_kurs);
    SET @count_leistung = IFNULL(@count_leistung, 0);

    IF (@count_leistung > 0) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT =
                'Fehler: Die Abgabe in Kurs wurde bereits für den Studenten eingetragen)';
    END IF;
END //

DROP TRIGGER IF EXISTS check_person_is_from_hwr_before_insert_on_person;
CREATE TRIGGER check_person_is_from_hwr_before_insert_on_person
    BEFORE INSERT ON person
    FOR EACH ROW
BEGIN
    IF NOT (new.mail LIKE '%@hwr-berlin.de' OR new.mail LIKE '%@doz.hwr-berlin.de' OR
            new.mail LIKE '%@stud.hwr-berlin.de') THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'Fehler: Die Mail gehört nicht zur HWR.';
    END IF;
END //


/*
--------------------------------------------------
    DUMMY DATA
--------------------------------------------------
*/

INSERT INTO kurs_buchstabe (wert)
VALUES ('A'),
    ('B'),
    ('C');

INSERT INTO jahrgang (jahr, sem_so_wi)
VALUES ('19', 'W'),
    ('19', 'S'),
    ('20', 'W'),
    ('20', 'S'),
    ('21', 'W'),
    ('21', 'S');

INSERT INTO fachrichtung (bezeichnung)
VALUES ('WI'),
    ('Etechnik'),
    ('BWL');

INSERT INTO modul (fk_fachrichtung, modulnummer, beschreibung)
VALUES ('WI', 103, 'VWL2'),
    ('WI', 602, 'Datenbanken'),
    ('WI', 301, 'Oldschool Java'),
    ('BWL', 10, 'Die Kunst, Leute zu überreden, Dinge zu kaufen, die sie nicht brauchen (Marketing)'),
    ('BWL', 12, 'Pseudowissenschaft für junge Gründer'),
    ('Etechnik', 47, 'Mathematik'),
    ('Etechnik', 48, 'Regelungstechnik'),
    ('Etechnik', 51, 'Halbleitertechnik');

INSERT INTO team (max_mitglieder, kommentar)
VALUES (4, 'Gruppe 1'),
    (4, 'Gruppe 2'),
    (4, 'Gruppe 3'),
    (4, 'Gruppe 4'),
    (5, 'Timo Beil'),
    (5, 'Jack Pott'),
    (5, 'Die zwei lustigen Drei'),
    (5, 'Die Helmers'),
    (5, 'Die fantastischen Vier'),
    (5, 'Team 50/50'),
    #ab hier noch nicht genutzt
    (3, 'Havana Club'),
    (3, 'Altenheim :-)'),
    (6, 'Landliebe Sahnepuddig'),
    (6, 'die Unkreativen'),
    (6, 'The Big Beer Theory'),
    (6, 'Stuzubis'),
    (2, 'Just married');

INSERT INTO person (mail, vorname, nachname)
VALUES ('doz.super.man@doz.hwr-berlin.de', 'Super', 'Man'),
    ('doz.micky.mouse@doz.hwr-berlin.de', 'Micky', 'Mouse'),
    ('doz.james.bond@doz.hwr-berlin.de', 'James', 'Bond'),
    ('doz.bugs.bunny@doz.hwr-berlin.de', 'Bugs', 'Bunny'),
    ('doz.dorothy.gale@doz.hwr-berlin.de', 'Dorothy', 'Gale'),
    #neue Dozenten
    ('yhawtry0@doz.hwr-berlin.de', 'Yolanda', 'Hawtry'),
    ('pspon1@doz.hwr-berlin.de', 'Patrice', 'Spon'),
    ('awayne2@doz.hwr-berlin.de', 'Ashlen', 'Wayne'),
    ('kmacritchie3@doz.hwr-berlin.de', 'Krishnah', 'MacRitchie'),
    #Studenten
    #WI C
    ('stud.bat.man@stud.hwr-berlin.de', 'Bat', 'Man'),
    ('stud.darth.vader@stud.hwr-berlin.de', 'Darth', 'Vader'),
    ('stud.indiana.jones@stud.hwr-berlin.de', 'Indiana', 'Jones'),
    ('stud.rocky.balboa@stud.hwr-berlin.de', 'Rocky', 'Balboa'),
    ('stud.vito.corleone@stud.hwr-berlin.de', 'Vito', 'Corleone'),
    ('stud.princess.leia@stud.hwr-berlin.de', 'Prinzessin', 'Leia'),
    ('stud.scarlett.ohara@stud.hwr-berlin.de', 'Scarlett', 'OHara'),
    ('stud.the.joker@stud.hwr-berlin.de', 'The', 'Joker'),
    ('stud.hannibal.lector@stud.hwr-berlin.de', 'Hannibal', 'Lector'),
    ('stud.tony.montana@stud.hwr-berlin.de', 'Tony', 'Montana'),
    ('stud.mary.poppins@stud.hwr-berlin.de', 'Mary', 'Poppins'),
    ('stud.black.widow@stud.hwr-berlin.de', 'Black', 'Widow'),
    ('stud.cosmo.cramer@stud.hwr-berlin.de', 'Cosmo', 'Cramer'),
    ('stud.ellen.ripley@stud.hwr-berlin.de', 'Ellen', 'Ripley'),
    ('stud.marge.simpson@stud.hwr-berlin.de', 'Marge', 'Simpson'),
    ('stud.mutti@stud.hwr-berlin.de', 'Angela', 'Merkel'),
    #WI A
    ('stud.captain.america@stud.hwr-berlin.de', 'Captain', 'America'),
    ('stud.greta.thunberg@stud.hwr-berlin.de', 'Greta', 'Thunberg'),
    ('stud.fauler.sack@stud.hwr-berlin.de', 'Fauler', 'Sack'),
    ('stud.super.streber@stud.hwr-berlin.de', 'Super', 'Streber'),
    ('stud.über.schätzt@stud.hwr-berlin.de', 'Über', 'Schätzt'),
    ('mcopin0@stud.hwr-berlin.de', 'Morse', 'Copin'),
    ('sbangs1@stud.hwr-berlin.de', 'Sadie', 'Bangs'),
    ('aellacombe2@stud.hwr-berlin.de', 'Athena', 'Ellacombe'),
    ('ayerrall3@stud.hwr-berlin.de', 'Ariela', 'Yerrall'),
    ('jmatley4@stud.hwr-berlin.de', 'Jackie', 'Matley'),
    ('zsabey5@stud.hwr-berlin.de', 'Zacharia', 'Sabey'),
    ('lhinkens6@stud.hwr-berlin.de', 'Lesley', 'Hinkens'),
    ('bhellewell7@stud.hwr-berlin.de', 'Bo', 'Hellewell'),
    ('zsanton8@stud.hwr-berlin.de', 'Zarah', 'Santon'),
    ('mspark9@stud.hwr-berlin.de', 'Melesa', 'Spark'),
    #BWL
    ('asaigera@stud.hwr-berlin.de', 'Annie', 'Saiger'),
    ('tclixbyb@stud.hwr-berlin.de', 'Thalia', 'Clixby'),
    ('ahairec@stud.hwr-berlin.de', 'Annaliese', 'Haire'),
    ('idenisotd@stud.hwr-berlin.de', 'Izzy', 'Denisot'),
    ('dmore@stud.hwr-berlin.de', 'Dorolice', 'Mor'),
    ('tbranef@stud.hwr-berlin.de', 'Tammara', 'Brane'),
    ('gbanaszczykg@stud.hwr-berlin.de', 'Gilberte', 'Banaszczyk'),
    ('wdmitrh@stud.hwr-berlin.de', 'Walt', 'Dmitr'),
    ('dedwickei@stud.hwr-berlin.de', 'Desmund', 'Edwicke'),
    #Etechnik Studenten
    ('igwyther0@stud.hwr-berlin.de', 'Iolande', 'Gwyther'),
    ('rscarth1@stud.hwr-berlin.de', 'Revkah', 'Scarth'),
    ('gburdess2@stud.hwr-berlin.de', 'Gib', 'Burdess'),
    ('eheggadon3@stud.hwr-berlin.de', 'Ethan', 'Heggadon'),
    ('jmichelle4@stud.hwr-berlin.de', 'Jeane', 'Michelle'),
    ('bhelks5@stud.hwr-berlin.de', 'Barbe', 'Helks'),
    ('dwilce6@stud.hwr-berlin.de', 'Dukey', 'Wilce'),
    ('adellenbrok7@stud.hwr-berlin.de', 'Andrea', 'Dellenbrok'),
    ('spagram8@stud.hwr-berlin.de', 'Sanderson', 'Pagram'),
    ('cjickells9@stud.hwr-berlin.de', 'Caryn', 'Jickells'),
    ('cworsnupa@stud.hwr-berlin.de', 'Catrina', 'Worsnup'),
    ('pstilingb@stud.hwr-berlin.de', 'Pearline', 'Stiling'),
    ('mwathanc@stud.hwr-berlin.de', 'Maia', 'Wathan'),
    ('btideyd@stud.hwr-berlin.de', 'Breanne', 'Tidey'),
    ('nrosenhause@stud.hwr-berlin.de', 'Nicolas', 'Rosenhaus'),
    ('jgabef@stud.hwr-berlin.de', 'Jamie', 'Gabe');

INSERT INTO dozent (fk_person)
VALUES ('doz.super.man@doz.hwr-berlin.de'),
    ('doz.micky.mouse@doz.hwr-berlin.de'),
    ('doz.james.bond@doz.hwr-berlin.de'),
    ('doz.bugs.bunny@doz.hwr-berlin.de'),
    ('doz.dorothy.gale@doz.hwr-berlin.de'),
    ('yhawtry0@doz.hwr-berlin.de'),
    ('pspon1@doz.hwr-berlin.de'),
    ('awayne2@doz.hwr-berlin.de'),
    ('kmacritchie3@doz.hwr-berlin.de');

INSERT INTO student (fk_mail, fk_fachrichtung, matnr)
VALUES
    #Etechnik
    ('igwyther0@stud.hwr-berlin.de', 'Etechnik', '711110'),
    ('rscarth1@stud.hwr-berlin.de', 'Etechnik', '711111'),
    ('gburdess2@stud.hwr-berlin.de', 'Etechnik', '711112'),
    ('eheggadon3@stud.hwr-berlin.de', 'Etechnik', '711113'),
    ('jmichelle4@stud.hwr-berlin.de', 'Etechnik', '711114'),
    ('bhelks5@stud.hwr-berlin.de', 'Etechnik', '711115'),
    ('dwilce6@stud.hwr-berlin.de', 'Etechnik', '711116'),
    ('adellenbrok7@stud.hwr-berlin.de', 'Etechnik', '711117'),
    ('spagram8@stud.hwr-berlin.de', 'Etechnik', '711118'),
    ('cjickells9@stud.hwr-berlin.de', 'Etechnik', '711119'),
    ('cworsnupa@stud.hwr-berlin.de', 'Etechnik', '711120'),
    ('pstilingb@stud.hwr-berlin.de', 'Etechnik', '711121'),
    ('mwathanc@stud.hwr-berlin.de', 'Etechnik', '711122'),
    ('btideyd@stud.hwr-berlin.de', 'Etechnik', '711123'),
    ('nrosenhause@stud.hwr-berlin.de', 'Etechnik', '711124'),
    ('jgabef@stud.hwr-berlin.de', 'Etechnik', '711125'),
    #WI Kurs C
    ('stud.darth.vader@stud.hwr-berlin.de', 'WI', 511126),
    ('stud.indiana.jones@stud.hwr-berlin.de', 'WI', 511127),
    ('stud.rocky.balboa@stud.hwr-berlin.de', 'WI', 511128),
    ('stud.vito.corleone@stud.hwr-berlin.de', 'WI', 511129),
    ('stud.princess.leia@stud.hwr-berlin.de', 'WI', 511130),
    ('stud.scarlett.ohara@stud.hwr-berlin.de', 'WI', 511131),
    ('stud.the.joker@stud.hwr-berlin.de', 'WI', 511132),
    ('stud.hannibal.lector@stud.hwr-berlin.de', 'WI', 511133),
    ('stud.tony.montana@stud.hwr-berlin.de', 'WI', 511134),
    ('stud.mary.poppins@stud.hwr-berlin.de', 'WI', 511135),
    ('stud.black.widow@stud.hwr-berlin.de', 'WI', 511136),
    ('stud.cosmo.cramer@stud.hwr-berlin.de', 'WI', 511137),
    ('stud.ellen.ripley@stud.hwr-berlin.de', 'WI', 511138),
    ('stud.marge.simpson@stud.hwr-berlin.de', 'WI', 511139),
    ('stud.mutti@stud.hwr-berlin.de', 'WI', 511140),
    #WI Kurs A
    ('stud.captain.america@stud.hwr-berlin.de', 'WI', 511141),
    ('stud.greta.thunberg@stud.hwr-berlin.de', 'WI', 511142),
    ('stud.fauler.sack@stud.hwr-berlin.de', 'WI', 511143),
    ('stud.super.streber@stud.hwr-berlin.de', 'WI', 511144),
    ('stud.über.schätzt@stud.hwr-berlin.de', 'WI', 511145),
    ('mcopin0@stud.hwr-berlin.de', 'WI', 511146),
    ('sbangs1@stud.hwr-berlin.de', 'WI', 511147),
    ('aellacombe2@stud.hwr-berlin.de', 'WI', 511148),
    ('ayerrall3@stud.hwr-berlin.de', 'WI', 511149),
    ('jmatley4@stud.hwr-berlin.de', 'WI', 511150),
    ('zsabey5@stud.hwr-berlin.de', 'WI', 511151),
    ('lhinkens6@stud.hwr-berlin.de', 'WI', 511152),
    ('bhellewell7@stud.hwr-berlin.de', 'WI', 511153),
    ('zsanton8@stud.hwr-berlin.de', 'WI', 511154),
    ('mspark9@stud.hwr-berlin.de', 'WI', 511155),
    #BWL
    ('asaigera@stud.hwr-berlin.de', 'BWL', 611156),
    ('tclixbyb@stud.hwr-berlin.de', 'BWL', 611157),
    ('ahairec@stud.hwr-berlin.de', 'BWL', 611158),
    ('idenisotd@stud.hwr-berlin.de', 'BWL', 611159),
    ('dmore@stud.hwr-berlin.de', 'BWL', 611160),
    ('tbranef@stud.hwr-berlin.de', 'BWL', 611161),
    ('gbanaszczykg@stud.hwr-berlin.de', 'BWL', 611162),
    ('wdmitrh@stud.hwr-berlin.de', 'BWL', 611163),
    ('dedwickei@stud.hwr-berlin.de', 'BWL', 611164);


INSERT INTO student_in_team (fk_matnr, fk_team)
VALUES
    #Etechnik Studenten in Teams Gruppe 1-4
    (711110, 1),
    (711111, 1),
    (711112, 1),
    (711113, 1),
    (711114, 2),
    (711115, 2),
    (711116, 2),
    (711117, 2),
    (711118, 3),
    (711119, 3),
    (711120, 3),
    (711121, 3),
    (711122, 4),
    (711123, 4),
    (711124, 4),
    (711125, 4),
    #WI Kurs C DB Projektarbeit
    (511126, 5),
    (511127, 5),
    (511128, 5),
    (511129, 5),
    (511130, 5),
    (511131, 6),
    (511132, 6),
    (511133, 6),
    (511134, 6),
    (511135, 6),
    (511136, 7),
    (511137, 7),
    (511138, 7),
    (511139, 7),
    (511140, 7),
    #WI Kurs C DB Projektarbeit
    (511141, 8),
    (511142, 8),
    (511143, 8),
    (511144, 8),
    (511145, 8),
    (511146, 9),
    (511147, 9),
    (511148, 9),
    (511149, 9),
    (511150, 9),
    (511151, 10),
    (511152, 10),
    (511153, 10),
    (511154, 10),
    (511155, 10);


INSERT INTO zugriffsrecht (abkuerzung, beschreibung)
VALUES ('ur', 'nur Leserecht eigene Nutzerdaten'),
    ('urw', 'Lese- und Schreibrecht eigene Nutzerdaten'),
    ('urd', 'Lese- Schreib- und Löschrecht eigene Nutzerdaten'),
    ('kr', 'nur Leserecht eigene Kursdaten (aller Teilnehmer)'),
    ('krw', 'Lese- und Schreibrecht eigene Kursdaten (aller Teilnehmer)'),
    ('krd', 'Lese- Schreib- und Löschrecht eigene Kursdaten (aller Teilnehmer)'),
    ('gr', 'nur Leserecht alle Nutzerdaten (global)'),
    ('grw', 'Lese- und Schreibrecht alle Nutzerdaten (global)'),
    ('grd', 'Lese- Schreib- und Löschrecht alle Nutzerdaten (global --> Superadmin)'),
    ('kwd', 'Schreib- und Löschrecht eigene Kursdaten (aller Teilnehmer --> Studentadmin)');

INSERT INTO kurs (beschreibung, fk_jahrgang, fk_kurs_buchstabe, fk_modul, modul_gewichtung, latedays_verfuegbar)
VALUES
    #Etechnik kurse jahrgang C
    ('Mathematik für Ingenieure', 3, 'C', 6, 1, 0),
    ('theoretische Einführung in die Regelungstechnik', 1, 'C', 7, 0.5, 9),
    ('praktische Einführung in die Regelungstechnik', 1, 'C', 7, 0.5, 5),
    ('theoretische Einführung in die Halbleitertechnik', 1, 'C', 8, 0.5, 6),
    ('praktische Einführung in die Halbleitertechnik', 1, 'C', 8, 0.5, 4),
    # WI jahrgang 3 kurs c
    ('Volkswirtschaftslehre 2', 3, 'C', 1, 1, 0),
    ('Einführung DB', 3, 'C', 2, 1, 6),
    ('Einführung OOP', 3, 'C', 3, 0.5, 6),
    ('Softwarearchitektur', 3, 'C', 3, 0.5, 6),
    ('Einführung BWL', 3, 'C', 4, 1, 0),
    # WI jahrgang 4 kurs A
    ('Volkswirtschaftslehre 2', 4, 'A', 1, 1, 0),
    ('Einführung DB', 4, 'A', 2, 1, 6),
    ('Einführung OOP', 4, 'A', 3, 0.5, 3),
    ('Softwarearchitektur', 4, 'A', 3, 0.5, 6),
    ('Einführung BWL', 4, 'A', 4, 1, 0),
    # BWL Kurse
    ('Einführung in die BWL', 1, 'A', 4, 1, 0),
    ('Einführung in die VWL', 1, 'A', 5, 1, 0);


INSERT INTO student_in_kurs (fk_kurs, fk_matnr, fk_zugriffsrechte)
VALUES
    #Etechnik Studenten eingeordnet in ETechnik Kurse, xxxx10-17 nicht in 10, xxxx18-25 nicht in 11
    (1, 711110, 'kwd'),
    (2, 711110, 'kwd'),
    (3, 711110, 'kwd'),
    (5, 711110, 'kwd'),
    (1, 711111, 'urw'),
    (2, 711111, 'urw'),
    (3, 711111, 'urw'),
    (5, 711111, 'urw'),
    (1, 711112, 'urw'),
    (2, 711112, 'urw'),
    (3, 711112, 'urw'),
    (5, 711112, 'urw'),
    (1, 711113, 'urw'),
    (2, 711113, 'urw'),
    (3, 711113, 'urw'),
    (5, 711113, 'urw'),
    (1, 711114, 'urw'),
    (2, 711114, 'urw'),
    (3, 711114, 'urw'),
    (5, 711114, 'urw'),
    (1, 711115, 'urw'),
    (2, 711115, 'urw'),
    (3, 711115, 'urw'),
    (5, 711115, 'urw'),
    (1, 711116, 'urw'),
    (2, 711116, 'urw'),
    (3, 711116, 'urw'),
    (5, 711116, 'urw'),
    (1, 711117, 'urw'),
    (2, 711117, 'urw'),
    (3, 711117, 'urw'),
    (5, 711117, 'urw'),
    (1, 711118, 'urw'),
    (2, 711118, 'urw'),
    (3, 711118, 'urw'),
    (4, 711118, 'urw'),
    (1, 711119, 'urw'),
    (2, 711119, 'urw'),
    (3, 711119, 'urw'),
    (4, 711119, 'urw'),
    (1, 711120, 'urw'),
    (2, 711120, 'urw'),
    (3, 711120, 'urw'),
    (4, 711120, 'urw'),
    (1, 711121, 'urw'),
    (2, 711121, 'urw'),
    (3, 711121, 'urw'),
    (4, 711121, 'urw'),
    (1, 711122, 'urw'),
    (2, 711122, 'urw'),
    (3, 711122, 'urw'),
    (4, 711122, 'urw'),
    (1, 711123, 'urw'),
    (2, 711123, 'urw'),
    (3, 711123, 'urw'),
    (4, 711123, 'urw'),
    (1, 711124, 'urw'),
    (2, 711124, 'urw'),
    (3, 711124, 'urw'),
    (4, 711124, 'urw'),
    (1, 711125, 'urw'),
    (2, 711125, 'urw'),
    (3, 711125, 'urw'),
    (4, 711125, 'urw'),
    #WI Kurs C Studenten
    (6, 511126, 'kwd'),
    (7, 511126, 'kwd'),
    (8, 511126, 'kwd'),
    (9, 511126, 'kwd'),
    (10, 511126, 'kwd'),
    (6, 511127, 'urw'),
    (7, 511127, 'urw'),
    (8, 511127, 'urw'),
    (9, 511127, 'urw'),
    (10, 511127, 'urw'),
    (6, 511128, 'urw'),
    (7, 511128, 'urw'),
    (8, 511128, 'urw'),
    (9, 511128, 'urw'),
    (10, 511128, 'urw'),
    (6, 511129, 'urw'),
    (7, 511129, 'urw'),
    (8, 511129, 'urw'),
    (9, 511129, 'urw'),
    (10, 511129, 'urw'),
    (6, 511130, 'urw'),
    (7, 511130, 'urw'),
    (8, 511130, 'urw'),
    (9, 511130, 'urw'),
    (10, 511130, 'urw'),
    (6, 511131, 'urw'),
    (7, 511131, 'urw'),
    (8, 511131, 'urw'),
    (9, 511131, 'urw'),
    (10, 511131, 'urw'),
    (6, 511132, 'urw'),
    (7, 511132, 'urw'),
    (8, 511132, 'urw'),
    (9, 511132, 'urw'),
    (10, 511132, 'urw'),
    (6, 511133, 'urw'),
    (7, 511133, 'urw'),
    (8, 511133, 'urw'),
    (9, 511133, 'urw'),
    (10, 511133, 'urw'),
    (6, 511134, 'urw'),
    (7, 511134, 'urw'),
    (8, 511134, 'urw'),
    (9, 511134, 'urw'),
    (10, 511134, 'urw'),
    (6, 511135, 'urw'),
    (7, 511135, 'urw'),
    (8, 511135, 'urw'),
    (9, 511135, 'urw'),
    (10, 511135, 'urw'),
    (6, 511136, 'urw'),
    (7, 511136, 'urw'),
    (8, 511136, 'urw'),
    (9, 511136, 'urw'),
    (6, 511137, 'urw'),
    (7, 511137, 'urw'),
    (8, 511137, 'urw'),
    (9, 511137, 'urw'),
    (6, 511138, 'urw'),
    (7, 511138, 'urw'),
    (8, 511138, 'urw'),
    (9, 511138, 'urw'),
    (6, 511139, 'urw'),
    (7, 511139, 'urw'),
    (8, 511139, 'urw'),
    (9, 511139, 'urw'),
    (6, 511140, 'urw'),
    (7, 511140, 'urw'),
    (8, 511140, 'urw'),
    (9, 511140, 'urw'),
    #WI Kurs A Studenten
    (11, 511141, 'kwd'),
    (12, 511141, 'kwd'),
    (13, 511141, 'kwd'),
    (14, 511141, 'kwd'),
    (15, 511141, 'kwd'),
    (11, 511142, 'urw'),
    (12, 511142, 'urw'),
    (13, 511142, 'urw'),
    (14, 511142, 'urw'),
    (15, 511142, 'urw'),
    (11, 511143, 'urw'),
    (12, 511143, 'urw'),
    (13, 511143, 'urw'),
    (14, 511143, 'urw'),
    (15, 511143, 'urw'),
    (11, 511144, 'urw'),
    (12, 511144, 'urw'),
    (13, 511144, 'urw'),
    (14, 511144, 'urw'),
    (15, 511144, 'urw'),
    (11, 511145, 'urw'),
    (12, 511145, 'urw'),
    (13, 511145, 'urw'),
    (14, 511145, 'urw'),
    (15, 511145, 'urw'),
    (11, 511146, 'urw'),
    (12, 511146, 'urw'),
    (13, 511146, 'urw'),
    (14, 511146, 'urw'),
    (15, 511146, 'urw'),
    (11, 511147, 'urw'),
    (12, 511147, 'urw'),
    (13, 511147, 'urw'),
    (14, 511147, 'urw'),
    (15, 511147, 'urw'),
    (11, 511148, 'urw'),
    (12, 511148, 'urw'),
    (13, 511148, 'urw'),
    (14, 511148, 'urw'),
    (15, 511148, 'urw'),
    (11, 511149, 'urw'),
    (12, 511149, 'urw'),
    (13, 511149, 'urw'),
    (14, 511149, 'urw'),
    (15, 511149, 'urw'),
    (11, 511150, 'urw'),
    (12, 511150, 'urw'),
    (13, 511150, 'urw'),
    (14, 511150, 'urw'),
    (11, 511151, 'urw'),
    (12, 511151, 'urw'),
    (13, 511151, 'urw'),
    (14, 511151, 'urw'),
    (11, 511152, 'urw'),
    (12, 511152, 'urw'),
    (13, 511152, 'urw'),
    (14, 511152, 'urw'),
    (11, 511153, 'urw'),
    (12, 511153, 'urw'),
    (13, 511153, 'urw'),
    (14, 511153, 'urw'),
    (11, 511154, 'urw'),
    (12, 511154, 'urw'),
    (13, 511154, 'urw'),
    (14, 511154, 'urw'),
    (11, 511155, 'urw'),
    (12, 511155, 'urw'),
    (13, 511155, 'urw'),
    (14, 511155, 'urw'),
    #BWL Studenten
    (16, 611156, 'kwd'),
    (17, 611156, 'kwd'),
    (16, 611157, 'urw'),
    (17, 611157, 'urw'),
    (16, 611158, 'urw'),
    (17, 611158, 'urw'),
    (16, 611159, 'urw'),
    (17, 611159, 'urw'),
    (16, 611160, 'urw'),
    (17, 611160, 'urw'),
    (16, 611161, 'urw'),
    (17, 611161, 'urw'),
    (16, 611162, 'urw'),
    (17, 611162, 'urw'),
    (16, 611163, 'urw'),
    (17, 611163, 'urw'),
    (16, 611164, 'urw'),
    (17, 611164, 'urw');


INSERT INTO dozent_in_kurs (fk_zugriffsrecht, fk_mail, fk_kurs)
VALUES ('grd', 'doz.super.man@doz.hwr-berlin.de', 1),
    ('krd', 'doz.micky.mouse@doz.hwr-berlin.de', 2),
    ('krw', 'doz.james.bond@doz.hwr-berlin.de', 3),
    ('krd', 'doz.james.bond@doz.hwr-berlin.de', 4),
    ('krd', 'doz.bugs.bunny@doz.hwr-berlin.de', 5),
    ('krd', 'doz.dorothy.gale@doz.hwr-berlin.de', 6),
    ('grd', 'doz.super.man@doz.hwr-berlin.de', 7),
    ('krd', 'doz.micky.mouse@doz.hwr-berlin.de', 8),
    ('krw', 'doz.james.bond@doz.hwr-berlin.de', 9),
    ('krd', 'doz.james.bond@doz.hwr-berlin.de', 10),
    ('krd', 'doz.bugs.bunny@doz.hwr-berlin.de', 11),
    ('krd', 'doz.dorothy.gale@doz.hwr-berlin.de', 12),
    ('krd', 'doz.dorothy.gale@doz.hwr-berlin.de', 13),
    ('krd', 'yhawtry0@doz.hwr-berlin.de', 14),
    ('krd', 'pspon1@doz.hwr-berlin.de', 15),
    ('krd', 'awayne2@doz.hwr-berlin.de', 16),
    ('krd', 'kmacritchie3@doz.hwr-berlin.de', 17);


INSERT INTO leistungstyp (bezeichnung)
VALUES ('Klausur'),
    ('Arbeitsblatt'),
    ('Quiz'),
    ('Vortrag'),
    ('Projektarbeit');


INSERT INTO leistung_template (fk_leistungstyp, latedays, gewichtung, teiler)
VALUES ('Klausur', 0, 0.60, 1), #1
    ('Arbeitsblatt', 3, 0.15, 3),
    ('Quiz', 0, 0.05, 9),       #3
    ('Projektarbeit', 3, 0.20, 1),
    ('Klausur', 0, 0.80, 1),    #5
    ('Quiz', 3, 0.20, 2),
    ('Klausur', 0, 1.00, 1),    #7
    ('Arbeitsblatt', 2, 0.40, 4),
    ('Vortrag', 0, 0.60, 2),    #9
    ('Projektarbeit', 7, 1.00, 1),
    #von nico für praktische regelungstechnik
    ('Projektarbeit', 5, 1.00, 1);


INSERT INTO abgabe_in_kurs (frist, fk_leistung_template, fk_kurs, teamarbeit_max_erlaubt)
VALUES
    ##Etechnik
    (STR_TO_DATE('23.12.21', '%d.%m.%y'), 7, 1, 0),              # Mathe Klausur
    (STR_TO_DATE('01.01.22', '%d.%m.%y'), 11, 3, 4),             # prakt. Regelungstechnik Projektarbeit
    #WI Kurs C
    (STR_TO_DATE('10.12.21 16:00', '%d.%m.%y %H:%i'), 7, 6, 0),  #Vwl2 klausur
    (STR_TO_DATE('13.12.21', '%d.%m.%y'), 4, 7, 5),              #Einführung DB Projektarbeit
    (STR_TO_DATE('20.12.21', '%d.%m.%y'), 6, 7, 0),              #Einführung DB Quiz1
    (STR_TO_DATE('21.12.21', '%d.%m.%y'), 6, 7, 0),              #Einführung DB Quiz2
    (STR_TO_DATE('22.12.21', '%d.%m.%y'), 1, 7, 5),              #Einführung DB Klausur
    #WI Kurs A
    (STR_TO_DATE('10.12.21 16:00', '%d.%m.%y %H:%i'), 7, 11, 0), # VWL2 Klausur
    (STR_TO_DATE('13.12.21', '%d.%m.%y'), 4, 12, 5),             #Einführung DB Projektarbeit
    (STR_TO_DATE('20.12.21', '%d.%m.%y'), 6, 12, 0),             #Einführung DB Quiz1
    (STR_TO_DATE('21.12.21', '%d.%m.%y'), 6, 12, 0),             #Einführung DB Quiz2
    (STR_TO_DATE('22.12.21', '%d.%m.%y'), 1, 12, 0),             #Einführung DB Klausur
    #BWL Einführung BWL
    (STR_TO_DATE('18.12.21 12:00', '%d.%m.%y %H:%i'), 7, 16, 0); #Einführung BWL Klausur


INSERT INTO aktive_mitarbeit (zeitpunkt, nachweis, bezeichnung)
VALUES (STR_TO_DATE('14.11.21 11:20', '%d.%m.%y %H:%i'), 'www.moodle-forum-link.de/dsjhg', 'Hilfe für Gruppe Alteheim bei ÜB 2'),
    (STR_TO_DATE('02.12.21 10:30', '%d.%m.%y %H:%i'), 'Vortrag Präsenz', 'Vorstellung Gruppenstatus Gruppe 1'),
    (STR_TO_DATE('18.12.21 22:22', '%d.%m.%y %H:%i'), 'www.one.google.com/dsfhsjf', 'Zusatzaufgabe ERM'),
    (STR_TO_DATE('25.11.21 10:30', '%d.%m.%y %H:%i'), 'Vortrag Online', 'Vorstellung Gruppenstatus 2.0 Gruppe 1'),
    (STR_TO_DATE('02.12.21 10:30', '%d.%m.%y %H:%i'), 'Vortrag Online', 'Vorstellung Gruppenstatus Gruppe 2'),
    (STR_TO_DATE('08.12.21 10:30', '%d.%m.%y %H:%i'), 'Vortrag Online', 'Vorstellung Gruppenstatus Gruppe 3'),
    (STR_TO_DATE('02.12.21 10:30', '%d.%m.%y %H:%i'), 'Vortrag Präsenz', 'Vorstellung Gruppenstatus Gruppe 1'),
    (STR_TO_DATE('02.12.21 10:30', '%d.%m.%y %H:%i'), 'Vortrag Online', 'Vorstellung Gruppenstatus Gruppe 2'),
    (STR_TO_DATE('02.12.21 10:30', '%d.%m.%y %H:%i'), 'Vortrag Online', 'Vorstellung Gruppenstatus Gruppe 3'),
    (STR_TO_DATE('15.11.21 10:30', '%d.%m.%y %H:%i'), 'Übungsblatt', 'Vorstellung Übungsblatt 1 Aufgabe 1'),
    (STR_TO_DATE('15.11.21 10:35', '%d.%m.%y %H:%i'), 'Übungsblatt', 'Vorstellung Übungsblatt 1 Aufgabe 2'),
    (STR_TO_DATE('15.11.21 10:40', '%d.%m.%y %H:%i'), 'Übungsblatt', 'Vorstellung Übungsblatt 1 Aufgabe 3'),
    (STR_TO_DATE('15.11.21 10:45', '%d.%m.%y %H:%i'), 'Übungsblatt', 'Vorstellung Übungsblatt 1 Aufgabe 4'),
    (STR_TO_DATE('22.11.21 10:30', '%d.%m.%y %H:%i'), 'Übungsblatt', 'Vorstellung Übungsblatt 2 Aufgabe 1'),
    (STR_TO_DATE('22.11.21 10:35', '%d.%m.%y %H:%i'), 'Übungsblatt', 'Vorstellung Übungsblatt 2 Aufgabe 2'),
    (STR_TO_DATE('22.11.21 10:40', '%d.%m.%y %H:%i'), 'Übungsblatt', 'Vorstellung Übungsblatt 2 Aufgabe 3'),
    (STR_TO_DATE('22.11.21 10:45', '%d.%m.%y %H:%i'), 'Übungsblatt', 'Vorstellung Übungsblatt 2 Aufgabe 4'),
    (STR_TO_DATE('22.11.21 10:50', '%d.%m.%y %H:%i'), 'Übungsblatt', 'Vorstellung Übungsblatt 2 Aufgabe 5'),
    (STR_TO_DATE('27.11.21 10:30', '%d.%m.%y %H:%i'), 'Übungsblatt', 'Vorstellung Übungsblatt 3 Aufgabe 1-5'),
    (STR_TO_DATE('27.11.21 10:40', '%d.%m.%y %H:%i'), 'Übungsblatt', 'Vorstellung Übungsblatt 3 Aufgabe 6-9'),
    (STR_TO_DATE('27.11.21 10:45', '%d.%m.%y %H:%i'), 'Übungsblatt', 'Vorstellung Übungsblatt 3 Aufgabe 10-15'),
    (STR_TO_DATE('27.11.21 10:50', '%d.%m.%y %H:%i'), 'Übungsblatt', 'Vorstellung Übungsblatt 3 Aufgabe 16-22'),
    (STR_TO_DATE('27.11.21 10:55', '%d.%m.%y %H:%i'), 'Übungsblatt', 'Vorstellung Übungsblatt 3 Aufgabe 23-28'),
    (STR_TO_DATE('27.11.21 11:00', '%d.%m.%y %H:%i'), 'Übungsblatt', 'Vorstellung Übungsblatt 3 Aufgabe 29-32'),
    (STR_TO_DATE('27.11.21 11:05', '%d.%m.%y %H:%i'), 'Übungsblatt', 'Vorstellung Übungsblatt 3 Aufgabe 33-36'),
    (STR_TO_DATE('27.11.21 11:10', '%d.%m.%y %H:%i'), 'Übungsblatt', 'Vorstellung Übungsblatt 3 Aufgabe 37-40'),
    (STR_TO_DATE('27.11.21 11:15', '%d.%m.%y %H:%i'), 'Übungsblatt', 'Vorstellung Übungsblatt 3 Aufgabe 41-44'),
    (STR_TO_DATE('27.11.21 11:20', '%d.%m.%y %H:%i'), 'Übungsblatt', 'Vorstellung Übungsblatt 3 Aufgabe 45-50'),
    (STR_TO_DATE('27.11.21 11:25', '%d.%m.%y %H:%i'), 'Übungsblatt', 'Vorstellung Übungsblatt 3 Aufgabe 51'),
    (STR_TO_DATE('27.11.21 11:30', '%d.%m.%y %H:%i'), 'Übungsblatt', 'Vorstellung Übungsblatt 3 Aufgabe 52-53'),
    (STR_TO_DATE('15.11.21 11:20', '%d.%m.%y %H:%i'), 'www.moodle-forum-link.de/liearb', 'Hilfe für Gruppe Alteheim bei ÜB 2'),
    (STR_TO_DATE('03.11.21 10:30', '%d.%m.%y %H:%i'), 'Vortrag Präsenz', 'Vorstellung Gruppenstatus Gruppe 4'),
    (STR_TO_DATE('12.11.21 22:22', '%d.%m.%y %H:%i'), 'www.docs.google.de/lsajdbgh', 'Zusatzaufgabe 3NF'),
    (STR_TO_DATE('25.11.21 10:30', '%d.%m.%y %H:%i'), 'Vortrag Online', 'Vorstellung Gruppenstatus 2.0 Gruppe 4'),
    (STR_TO_DATE('02.12.21 10:30', '%d.%m.%y %H:%i'), 'Vortrag Online', 'Vorstellung Gruppenstatus Gruppe 5'),
    (STR_TO_DATE('08.12.21 10:30', '%d.%m.%y %H:%i'), 'Vortrag Online', 'Vorstellung Gruppenstatus Gruppe 6'),
    (STR_TO_DATE('02.12.21 10:30', '%d.%m.%y %H:%i'), 'Vortrag Präsenz', 'Vorstellung Gruppenstatus Gruppe 4'),
    (STR_TO_DATE('02.12.21 10:30', '%d.%m.%y %H:%i'), 'Vortrag Online', 'Vorstellung Gruppenstatus Gruppe 5'),
    (STR_TO_DATE('02.12.21 10:30', '%d.%m.%y %H:%i'), 'Vortrag Online', 'Vorstellung Gruppenstatus Gruppe 6'),
    (STR_TO_DATE('14.11.21 10:30', '%d.%m.%y %H:%i'), 'Übungsblatt', 'Vorstellung Übungsblatt 1 Aufgabe 1'),
    (STR_TO_DATE('14.11.21 10:35', '%d.%m.%y %H:%i'), 'Übungsblatt', 'Vorstellung Übungsblatt 1 Aufgabe 2'),
    (STR_TO_DATE('14.11.21 10:40', '%d.%m.%y %H:%i'), 'Übungsblatt', 'Vorstellung Übungsblatt 1 Aufgabe 3'),
    (STR_TO_DATE('14.11.21 10:45', '%d.%m.%y %H:%i'), 'Übungsblatt', 'Vorstellung Übungsblatt 1 Aufgabe 4'),
    (STR_TO_DATE('21.11.21 10:30', '%d.%m.%y %H:%i'), 'Übungsblatt', 'Vorstellung Übungsblatt 2 Aufgabe 1'),
    (STR_TO_DATE('21.11.21 10:35', '%d.%m.%y %H:%i'), 'Übungsblatt', 'Vorstellung Übungsblatt 2 Aufgabe 2'),
    (STR_TO_DATE('21.11.21 10:40', '%d.%m.%y %H:%i'), 'Übungsblatt', 'Vorstellung Übungsblatt 2 Aufgabe 3'),
    (STR_TO_DATE('21.11.21 10:45', '%d.%m.%y %H:%i'), 'Übungsblatt', 'Vorstellung Übungsblatt 2 Aufgabe 4'),
    (STR_TO_DATE('21.11.21 10:50', '%d.%m.%y %H:%i'), 'Übungsblatt', 'Vorstellung Übungsblatt 2 Aufgabe 5'),
    (STR_TO_DATE('25.11.21 10:30', '%d.%m.%y %H:%i'), 'Übungsblatt', 'Vorstellung Übungsblatt 3 Aufgabe 1-5'),
    (STR_TO_DATE('25.11.21 10:40', '%d.%m.%y %H:%i'), 'Übungsblatt', 'Vorstellung Übungsblatt 3 Aufgabe 6-9'),
    (STR_TO_DATE('25.11.21 10:45', '%d.%m.%y %H:%i'), 'Übungsblatt', 'Vorstellung Übungsblatt 3 Aufgabe 10-15'),
    (STR_TO_DATE('25.11.21 10:50', '%d.%m.%y %H:%i'), 'Übungsblatt', 'Vorstellung Übungsblatt 3 Aufgabe 16-22'),
    (STR_TO_DATE('25.11.21 10:55', '%d.%m.%y %H:%i'), 'Übungsblatt', 'Vorstellung Übungsblatt 3 Aufgabe 23-28'),
    (STR_TO_DATE('25.11.21 11:00', '%d.%m.%y %H:%i'), 'Übungsblatt', 'Vorstellung Übungsblatt 3 Aufgabe 29-32'),
    (STR_TO_DATE('25.11.21 11:05', '%d.%m.%y %H:%i'), 'Übungsblatt', 'Vorstellung Übungsblatt 3 Aufgabe 33-36'),
    (STR_TO_DATE('25.11.21 11:10', '%d.%m.%y %H:%i'), 'Übungsblatt', 'Vorstellung Übungsblatt 3 Aufgabe 37-40'),
    (STR_TO_DATE('25.11.21 11:15', '%d.%m.%y %H:%i'), 'Übungsblatt', 'Vorstellung Übungsblatt 3 Aufgabe 41-44'),
    (STR_TO_DATE('25.11.21 11:20', '%d.%m.%y %H:%i'), 'Übungsblatt', 'Vorstellung Übungsblatt 3 Aufgabe 45-50'),
    (STR_TO_DATE('25.11.21 11:25', '%d.%m.%y %H:%i'), 'Übungsblatt', 'Vorstellung Übungsblatt 3 Aufgabe 51'),
    (STR_TO_DATE('25.11.21 11:30', '%d.%m.%y %H:%i'), 'Übungsblatt', 'Vorstellung Übungsblatt 3 Aufgabe 52-53');


INSERT INTO aktive_mitarbeit_in_kurs (fk_matnr, fk_kurs, fk_aktive_mitarbeit)
VALUES (511126, 7, 7),
    (511127, 7, 2),
    (511128, 7, 3),
    (511129, 7, 4),
    (511130, 7, 15),
    (511131, 7, 5),
    (511132, 7, 1),
    (511133, 7, 8),
    (511134, 7, 11),
    (511135, 7, 13),
    (511136, 7, 6),
    (511137, 7, 9),
    (511138, 7, 10),
    (511139, 7, 12),
    (511140, 7, 14),
    (511126, 7, 16),
    (511127, 7, 17),
    (511128, 7, 18),
    (511129, 7, 19),
    (511130, 7, 20),
    (511131, 7, 21),
    (511132, 7, 22),
    (511133, 7, 23),
    (511134, 7, 24),
    (511135, 7, 25),
    (511136, 7, 26),
    (511137, 7, 27),
    (511138, 7, 28),
    (511139, 7, 29),
    (511140, 7, 30),
    (511141, 12, 37),
    (511142, 12, 32),
    (511143, 12, 33),
    (511144, 12, 34),
    (511145, 12, 45),
    (511146, 12, 35),
    (511147, 12, 31),
    (511148, 12, 38),
    (511149, 12, 41),
    (511150, 12, 43),
    (511151, 12, 36),
    (511152, 12, 39),
    (511153, 12, 40),
    (511154, 12, 42),
    (511155, 12, 44),
    (511141, 12, 46),
    (511142, 12, 47),
    (511143, 12, 48),
    (511144, 12, 49),
    (511145, 12, 50),
    (511146, 12, 51),
    (511147, 12, 52),
    (511148, 12, 53),
    (511149, 12, 54),
    (511150, 12, 55),
    (511151, 12, 56),
    (511152, 12, 57),
    (511153, 12, 58),
    (511154, 12, 59),
    (511155, 12, 60);


INSERT INTO leistung (fk_matnr, wert, fk_abgabe_in_kurs, abgabe_ist, frist_verlaengerung_tage, fk_team, festgesetzt)
VALUES
    #Etechnik Studenten Leistungen in Mathe und praktische Regelungstechnik
    (711110, 1.0, 1, STR_TO_DATE('23.12.21 16:00', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (711111, 2.0, 1, STR_TO_DATE('23.12.21 16:00', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (711112, 2.3, 1, STR_TO_DATE('23.12.21 16:00', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (711113, 1.3, 1, STR_TO_DATE('23.12.21 16:00', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (711114, 1.7, 1, STR_TO_DATE('23.12.21 16:00', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (711115, 2.3, 1, STR_TO_DATE('23.12.21 16:00', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (711116, 1.3, 1, STR_TO_DATE('23.12.21 16:00', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (711117, 2.7, 1, STR_TO_DATE('23.12.21 16:00', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (711118, 2.0, 1, STR_TO_DATE('23.12.21 16:00', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (711119, 1.0, 1, STR_TO_DATE('23.12.21 16:00', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (711120, 1.7, 1, STR_TO_DATE('23.12.21 16:00', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (711121, 2.3, 1, STR_TO_DATE('23.12.21 16:00', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (711122, 2.0, 1, STR_TO_DATE('23.12.21 16:00', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (711123, 3.7, 1, STR_TO_DATE('23.12.21 16:00', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (711124, 3.3, 1, STR_TO_DATE('23.12.21 16:00', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (711125, 3.0, 1, STR_TO_DATE('23.12.21 16:00', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    #ab hier praktische regelungstechnik
    (711110, 1.3, 2, STR_TO_DATE('02.01.22 23:59', '%d.%m.%y %H:%i'), 0, 1, FALSE),
    (711111, 1.3, 2, STR_TO_DATE('02.01.22 23:59', '%d.%m.%y %H:%i'), 0, 1, FALSE),
    (711112, 1.3, 2, STR_TO_DATE('02.01.22 23:59', '%d.%m.%y %H:%i'), 0, 1, FALSE),
    (711113, 1.3, 2, STR_TO_DATE('02.01.22 23:59', '%d.%m.%y %H:%i'), 0, 1, FALSE),
    (711114, 1.0, 2, STR_TO_DATE('01.01.22 17:00', '%d.%m.%y %H:%i'), 0, 2, FALSE),
    (711115, 1.0, 2, STR_TO_DATE('01.01.22 17:00', '%d.%m.%y %H:%i'), 0, 2, FALSE),
    (711116, 1.0, 2, STR_TO_DATE('01.01.22 17:00', '%d.%m.%y %H:%i'), 0, 2, FALSE),
    (711117, 1.0, 2, STR_TO_DATE('01.01.22 17:00', '%d.%m.%y %H:%i'), 0, 2, FALSE),
    (711118, 2.0, 2, STR_TO_DATE('01.01.22 12:00', '%d.%m.%y %H:%i'), 0, 3, FALSE),
    (711119, 2.0, 2, STR_TO_DATE('01.01.22 12:00', '%d.%m.%y %H:%i'), 0, 3, FALSE),
    (711120, 2.0, 2, STR_TO_DATE('01.01.22 12:00', '%d.%m.%y %H:%i'), 0, 3, FALSE),
    (711121, 2.0, 2, STR_TO_DATE('01.01.22 12:00', '%d.%m.%y %H:%i'), 0, 3, FALSE),
    (711122, 1.7, 2, STR_TO_DATE('04.01.22 19:54', '%d.%m.%y %H:%i'), 0, 4, FALSE),
    (711123, 1.7, 2, STR_TO_DATE('04.01.22 19:54', '%d.%m.%y %H:%i'), 0, 4, FALSE),
    (711124, 1.7, 2, STR_TO_DATE('04.01.22 19:54', '%d.%m.%y %H:%i'), 0, 4, FALSE),
    (711125, 1.7, 2, STR_TO_DATE('04.01.22 19:54', '%d.%m.%y %H:%i'), 0, 4, FALSE),
    #VWL2 Klausur Kurs C
    (511126, 1.7, 3, STR_TO_DATE('10.12.21 15:59', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (511127, 1.7, 3, STR_TO_DATE('10.12.21 15:54', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (511128, 2.0, 3, STR_TO_DATE('10.12.21 15:55', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (511129, 2.3, 3, STR_TO_DATE('10.12.21 15:59', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (511130, 4.0, 3, STR_TO_DATE('10.12.21 15:58', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (511131, 2.0, 3, STR_TO_DATE('10.12.21 15:59', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (511132, 1.7, 3, STR_TO_DATE('10.12.21 15:59', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (511133, 3.3, 3, STR_TO_DATE('10.12.21 15:59', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (511134, 1.0, 3, STR_TO_DATE('10.12.21 15:50', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (511135, 1.7, 3, STR_TO_DATE('10.12.21 15:55', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (511136, 1.0, 3, STR_TO_DATE('10.12.21 15:53', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (511137, 3.7, 3, STR_TO_DATE('10.12.21 15:54', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (511138, 1.0, 3, STR_TO_DATE('10.12.21 15:55', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (511139, 1.7, 3, STR_TO_DATE('10.12.21 15:52', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (511140, 2.3, 3, STR_TO_DATE('10.12.21 15:59', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    #VWL2 Klausur Kurs A
    (511141, 1.7, 8, STR_TO_DATE('10.12.21 15:59', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (511142, 1.7, 8, STR_TO_DATE('10.12.21 15:54', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (511143, 2.0, 8, STR_TO_DATE('10.12.21 15:55', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (511144, 2.3, 8, STR_TO_DATE('10.12.21 15:59', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (511145, 4.0, 8, STR_TO_DATE('10.12.21 15:58', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (511146, 2.0, 8, STR_TO_DATE('10.12.21 15:59', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (511147, 1.7, 8, STR_TO_DATE('10.12.21 15:59', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (511148, 3.3, 8, STR_TO_DATE('10.12.21 15:59', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (511149, 1.0, 8, STR_TO_DATE('10.12.21 15:50', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (511150, 1.7, 8, STR_TO_DATE('10.12.21 15:55', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (511151, 1.0, 8, STR_TO_DATE('10.12.21 15:53', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (511152, 3.7, 8, STR_TO_DATE('10.12.21 15:54', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (511153, 1.0, 8, STR_TO_DATE('10.12.21 15:55', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (511154, 1.7, 8, STR_TO_DATE('10.12.21 15:52', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (511155, 2.3, 8, STR_TO_DATE('10.12.21 15:59', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    #Einführung DB Projektarbeit C
    (511126, 1.7, 4, STR_TO_DATE('13.12.21 23:59', '%d.%m.%y %H:%i'), 0, 5, FALSE),
    (511127, 1.7, 4, STR_TO_DATE('13.12.21 23:59', '%d.%m.%y %H:%i'), 0, 5, FALSE),
    (511128, 1.7, 4, STR_TO_DATE('13.12.21 23:59', '%d.%m.%y %H:%i'), 0, 5, FALSE),
    (511129, 1.7, 4, STR_TO_DATE('13.12.21 23:59', '%d.%m.%y %H:%i'), 0, 5, FALSE),
    (511130, 1.7, 4, STR_TO_DATE('13.12.21 23:59', '%d.%m.%y %H:%i'), 0, 5, FALSE),
    (511131, 2.3, 4, STR_TO_DATE('12.12.21 23:55', '%d.%m.%y %H:%i'), 0, 6, FALSE),
    (511132, 2.3, 4, STR_TO_DATE('12.12.21 23:55', '%d.%m.%y %H:%i'), 0, 6, FALSE),
    (511133, 2.3, 4, STR_TO_DATE('12.12.21 23:55', '%d.%m.%y %H:%i'), 0, 6, FALSE),
    (511134, 2.3, 4, STR_TO_DATE('12.12.21 23:55', '%d.%m.%y %H:%i'), 0, 6, FALSE),
    (511135, 2.3, 4, STR_TO_DATE('12.12.21 23:55', '%d.%m.%y %H:%i'), 0, 6, FALSE),
    (511136, 2.0, 4, STR_TO_DATE('12.12.21 23:53', '%d.%m.%y %H:%i'), 0, 7, FALSE),
    (511137, 2.0, 4, STR_TO_DATE('12.12.21 23:53', '%d.%m.%y %H:%i'), 0, 7, FALSE),
    (511138, 2.0, 4, STR_TO_DATE('12.12.21 23:53', '%d.%m.%y %H:%i'), 0, 7, FALSE),
    (511139, 2.0, 4, STR_TO_DATE('12.12.21 23:53', '%d.%m.%y %H:%i'), 0, 7, FALSE),
    (511140, 2.0, 4, STR_TO_DATE('12.12.21 23:53', '%d.%m.%y %H:%i'), 0, 7, FALSE),
    #Einführung DB Projektarbeit A
    (511141, 2.7, 9, STR_TO_DATE('15.12.21 23:55', '%d.%m.%y %H:%i'), 0, 8, FALSE),
    (511142, 2.7, 9, STR_TO_DATE('15.12.21 23:55', '%d.%m.%y %H:%i'), 0, 8, FALSE),
    (511143, 2.7, 9, STR_TO_DATE('15.12.21 23:55', '%d.%m.%y %H:%i'), 0, 8, FALSE),
    (511144, 2.7, 9, STR_TO_DATE('15.12.21 23:55', '%d.%m.%y %H:%i'), 0, 8, FALSE),
    (511145, 2.7, 9, STR_TO_DATE('15.12.21 23:55', '%d.%m.%y %H:%i'), 0, 8, FALSE),
    (511146, 3.7, 9, STR_TO_DATE('12.12.21 22:59', '%d.%m.%y %H:%i'), 0, 9, FALSE),
    (511147, 3.7, 9, STR_TO_DATE('12.12.21 22:59', '%d.%m.%y %H:%i'), 0, 9, FALSE),
    (511148, 3.7, 9, STR_TO_DATE('12.12.21 22:59', '%d.%m.%y %H:%i'), 0, 9, FALSE),
    (511149, 3.7, 9, STR_TO_DATE('12.12.21 22:59', '%d.%m.%y %H:%i'), 0, 9, FALSE),
    (511150, 3.7, 9, STR_TO_DATE('12.12.21 22:59', '%d.%m.%y %H:%i'), 0, 9, FALSE),
    (511151, 1.0, 9, STR_TO_DATE('12.12.21 21:59', '%d.%m.%y %H:%i'), 0, 10, FALSE),
    (511152, 1.0, 9, STR_TO_DATE('12.12.21 21:59', '%d.%m.%y %H:%i'), 0, 10, FALSE),
    (511153, 1.0, 9, STR_TO_DATE('12.12.21 21:59', '%d.%m.%y %H:%i'), 0, 10, FALSE),
    (511154, 1.0, 9, STR_TO_DATE('12.12.21 21:59', '%d.%m.%y %H:%i'), 0, 10, FALSE),
    (511155, 1.0, 9, STR_TO_DATE('12.12.21 21:59', '%d.%m.%y %H:%i'), 0, 10, FALSE),
    # Einführung in die BWL Klausur
    (611156, 1.0, 13, STR_TO_DATE('19.12.21 11:59', '%d.%m.%y %H:%i'), 1, NULL, FALSE),
    (611157, 2.0, 13, STR_TO_DATE('18.12.21 11:58', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (611158, 2.7, 13, STR_TO_DATE('18.12.21 11:57', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (611159, 1.3, 13, STR_TO_DATE('18.12.21 11:55', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (611160, 3.3, 13, STR_TO_DATE('18.12.21 11:53', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (611161, 3.0, 13, STR_TO_DATE('18.12.21 11:59', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (611162, 1.3, 13, STR_TO_DATE('18.12.21 11:55', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (611163, 1.0, 13, STR_TO_DATE('18.12.21 11:50', '%d.%m.%y %H:%i'), 0, NULL, FALSE),
    (611164, 1.7, 13, STR_TO_DATE('18.12.21 11:59', '%d.%m.%y %H:%i'), 0, NULL, FALSE);


INSERT INTO account (fk_mail, password_hash)
VALUES
    #Dozenten
    ('doz.bugs.bunny@doz.hwr-berlin.de', 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'),
    ('doz.dorothy.gale@doz.hwr-berlin.de', 'ca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb'),
    ('doz.james.bond@doz.hwr-berlin.de', '70ba33708cbfb103f1a8e34afef333ba7dc021022b2d9aaa583aabb8058d8d67'),
    ('doz.micky.mouse@doz.hwr-berlin.de', 'c7d3776f235966314be6e72521d2802dca96ed8d5c0d89b9962360b9f13a0ea7'),
    ('doz.super.man@doz.hwr-berlin.de', '7031a423aa40a32f119b2b17e4278cbf2293fc036061c24deb1c7ad1d8ffcc64'),
    ('yhawtry0@doz.hwr-berlin.de', 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'),
    ('pspon1@doz.hwr-berlin.de', '7930035759caad0d6502908dd93d80ee6127121b1c404fa72d227e409d2aa720'),
    ('awayne2@doz.hwr-berlin.de', 'd9c64ce420476f82982214e25b785427c7c3e5f62c9f798ac20eb2a423673127'),
    ('kmacritchie3@doz.hwr-berlin.de', 'fa16dba3e305ace8414f3b7d5184e2942cc7e21dc7318188e310bdb08fd9cbd3'),
    #Studenten
    ('stud.bat.man@stud.hwr-berlin.de', '4dcc41d82b3d729ec999955d61de26a0e7b0badfbcc10339b0beb64a06909fca'),
    ('stud.black.widow@stud.hwr-berlin.de', '494fc4689701205276e443ef15b26cbb3675cf74ea48f115dc603ea608c4d12f'),
    ('stud.captain.america@stud.hwr-berlin.de', '6046d43a0ee25eaa163038a48edc36c42544e842765a5de1adc9c0cdc578b3ce'),
    ('stud.cosmo.cramer@stud.hwr-berlin.de', 'c0f3496fca22f6ba3274c0c1d3bb85b95998ee99d641409d38e0ceb5f36c87e8'),
    ('stud.darth.vader@stud.hwr-berlin.de', '2dfd7f53670d371c180b3954d1b8dfbdbd47ccebaac217bea41c1eb4a1b2b573'),
    ('stud.ellen.ripley@stud.hwr-berlin.de', '4056fc1d04987627c592920e0660f21f0ed0c8f573d465fb627b5f251230a79d'),
    ('stud.fauler.sack@stud.hwr-berlin.de', 'da586a30006b4d7b675d5a2c0863885a0266994b1c3d9521fb9c094e3fe6eb12'),
    ('stud.greta.thunberg@stud.hwr-berlin.de', '0a84f6b57c47ae9337ab98a46affd05a9edea3abb1ad14b0b633a8674a70d37d'),
    ('stud.hannibal.lector@stud.hwr-berlin.de', 'c64c8432dd4a8ca28dd7fc334f400808043a55b8b5c267fcd7028236a687d297'),
    ('stud.indiana.jones@stud.hwr-berlin.de', '66ecfd2c0f7d01a0a00e534a80ecb1de41cecec69ef5e3eb8097407b03e1293f'),
    ('stud.marge.simpson@stud.hwr-berlin.de', 'c734ae4bc04e82d134ebb249086fea417c2b3f00a8ab10bc7df1bb5cbc4dd281'),
    ('stud.mary.poppins@stud.hwr-berlin.de', '6bf1250000d56d0678a93c8c5f8f9c75b1604ca11e0eae93f9bd6e3aabaee27c'),
    ('stud.mutti@stud.hwr-berlin.de', '630ba8cabb188f1808000924f1bad2e14d8ee79b790d772b75344d7dd7cfb1ca'),
    ('stud.princess.leia@stud.hwr-berlin.de', '2baeb3f6577a248a57cd702509eab0f578a2df91dbf3c2539d79660827410fc6'),
    ('stud.rocky.balboa@stud.hwr-berlin.de', '5135c296df5394f847d0215aac988dafde80ef596400fd3cfba8e5a8f3322bb8'),
    ('stud.scarlett.ohara@stud.hwr-berlin.de', 'baf2d6d8117a387896a972bdc0d7f2f08531bc61eaea8236712a8fd2dd02d090'),
    ('stud.super.streber@stud.hwr-berlin.de', '29024edc04c6d467012dac2f156771d2f01453c6d33415cbff157fa7955db832'),
    ('stud.the.joker@stud.hwr-berlin.de', '17e492be914fecdf07c268c9290793fbdb1826436ce21c2221eff4b6dc51b891'),
    ('stud.tony.montana@stud.hwr-berlin.de', '74f476e0d8f671ca46fe6be4d7b71327092b6af0e81572d19c1ddfec70da7b14'),
    ('stud.vito.corleone@stud.hwr-berlin.de', 'aec95a56259c02c3719a4a10872c054111e98b834b651a68c99e1f8a0ea7d714'),
    ('stud.über.schätzt@stud.hwr-berlin.de', 'ddafe91ee665547f9694ae027583a6cd7d2c1c72883711816ecd2eb11ebcb8c5'),
    ('mcopin0@stud.hwr-berlin.de', '3ec326615b5538d1df5e60a4e4a11c496e52eed9e65a9448e85edc0926794d6e'),
    ('sbangs1@stud.hwr-berlin.de', '64800a01060ef108ee758d3f8519b961bbc9d1ccd866037b38ac774b49db896d'),
    ('aellacombe2@stud.hwr-berlin.de', '9912ee93bfa9b16d2f60e01e8c6bcd473abdceb9be6b1e7659399dfeb5a8f696'),
    ('ayerrall3@stud.hwr-berlin.de', '6c9bdcda35ce78c90cb6efa43e5be618fb441ae990673ad5baafd77c4f5a72e5'),
    ('jmatley4@stud.hwr-berlin.de', 'ce78800b36f7fc1158f591a255f85d57315a38c27c36d33aeb525a475ab5bc33'),
    ('zsabey5@stud.hwr-berlin.de', 'b1ca38f6438feec61adad28fad98d1f0365921b4e3aed6e90de97c80afe9e0f5'),
    ('lhinkens6@stud.hwr-berlin.de', '4be4df28a26d604ba04912eb5b7909b83728a593d6e871295bf2b9c26b224c3b'),
    ('bhellewell7@stud.hwr-berlin.de', '8110b120c7a20bdfb325a235f6806dadb2c8e5d843e35dcd158b427382c01ad4'),
    ('zsanton8@stud.hwr-berlin.de', '3baac0a9979fc9496278a61c07fa4194d508778f4b535cc8b56e5f64b6582edd'),
    ('mspark9@stud.hwr-berlin.de', '49ab09ed771dd5eb6f8bc0be4420f92a41437b54910f4215663c9bf410457d03'),
    ('asaigera@stud.hwr-berlin.de', '8768fe0d97803d995d384afe7e39e4042220daf00468cd7cb870c79c116163f7'),
    ('tclixbyb@stud.hwr-berlin.de', 'dfca1eb87a4f9def14834f64afc4d8e435bcbad0530797dc6be0d7a389af9c24'),
    ('ahairec@stud.hwr-berlin.de', 'ebfc3a5e9c9efa2090f624f520808a60ceab7ed3f6d8f14c3b777de4d8e884b6'),
    ('idenisotd@stud.hwr-berlin.de', 'd897eff70c90cebc3e7b51b4d3dae0fe9f0d77d12f17a9fa08cc48909fe526a4'),
    ('dmore@stud.hwr-berlin.de', '092d7525e20d7c3620bf0c9141e4ab0277ba86905c0bda4a2e48c6aa4635ff78'),
    ('tbranef@stud.hwr-berlin.de', '4274e30e4551b15791b4741295f4682048a23a1cd8c44f9f08b6256445400a1a'),
    ('gbanaszczykg@stud.hwr-berlin.de', 'aaece9ced03e00f26ddbdd755b8335e3541d84ff6a4e9812d0629155eadeb5e6'),
    ('wdmitrh@stud.hwr-berlin.de', '40fd382c4117e7be6db10152fa1c329d263cc528443ff1cfc2c9636f3fa82784'),
    ('dedwickei@stud.hwr-berlin.de', '77d014019c19aba92c3b4d801dec5395eada013f1a3a9c00587745966ae027cd'),
    ('igwyther0@stud.hwr-berlin.de', '09e07ccb003ee188a4ea239f7d45c9dc148b88de3596a5ef01dcf9d47cfb498d'),
    ('rscarth1@stud.hwr-berlin.de', '3bece569d5f4b3e9d9369da0b4a4c1ab59badf50e83f43d360296c53bf7d0f3d'),
    ('gburdess2@stud.hwr-berlin.de', '372b8961715c1fcac1152ce5fd5d6e1045301e7500bf6f00f5f09329b9c241b2'),
    ('eheggadon3@stud.hwr-berlin.de', '2c488fbf229cfa3ea44313dd472dd112a96d2a0a77aadf5ff1279640496b324a'),
    ('jmichelle4@stud.hwr-berlin.de', '9f64bea4eeea8912fe14047c75278a66a2f7c760daa9324e468b1c49811a05d2'),
    ('bhelks5@stud.hwr-berlin.de', '5a2e7df870292c3a642a6101b74592c7c5063c1d799194dc8959ec1212375296'),
    ('dwilce6@stud.hwr-berlin.de', '2c45bd2be9cd5ce11dace52ebe6d8fc1197470d392420fe222f757581e1944df'),
    ('adellenbrok7@stud.hwr-berlin.de', 'bd0cc4dca91adf16f4beaa9461eaee9cbc230fe57ef712535f37b3dca073ed69'),
    ('spagram8@stud.hwr-berlin.de', 'c7828d7d7307d6014178be482b73234e55d0ccc31d7a0b44f350a965d0ab4fb0'),
    ('cjickells9@stud.hwr-berlin.de', '35106dc12dfcef37e2d877f10df92a7336632e41fe22d9b564786d5a2358bc91'),
    ('cworsnupa@stud.hwr-berlin.de', '1c6cdd173dbb7288dfc6e83b9e5d78af7c1653f3fa97065bf38f47299b59f7af'),
    ('pstilingb@stud.hwr-berlin.de', '67a0c5bbfd865fdecaa5aab7c4c8ce99d122492120d0d2b02709a941811b6769'),
    ('mwathanc@stud.hwr-berlin.de', 'c0f41b43b256a0db15c7edff37f66ddb7d26c8b35c6b4ce14dded0c275e1eabb'),
    ('btideyd@stud.hwr-berlin.de', '95e3fac9ac5e7b39dadda55367cd5ce1ccc878274de49549bfcb8e8f36bca3b9'),
    ('nrosenhause@stud.hwr-berlin.de', '497b4315737f161ceb1d8188f7bdf10cca77ae699cf3195125a67fab893ac26c'),
    ('jgabef@stud.hwr-berlin.de', 'fee5e31f3d3728be1a44be0a35da1111ae2d4f78adeb33cb54f1ec1821ec2e61');

INSERT INTO anfrageaufnahme (fk_kurs, fk_matnr)
VALUES
    #Etechnik Studenten anfragen 711110-17 sind nciht in 4 (prak. halbleiter), 711118-25 sind nicht in 5(theor. halbleiter)
    (4, 711110),
    (4, 711111),
    (4, 711112),
    (4, 711113),
    (4, 711114),
    (4, 711115),
    (4, 711116),
    (4, 711117),
    (5, 711118),
    (5, 711119),
    (5, 711120),
    (5, 711121),
    (5, 711122),
    (5, 711123),
    (5, 711124),
    (5, 711125),
    #WI Studenten Anfragen 511136-40 sind nicht in Kurs 10 (Einführung BWL C), 511150-55 sind nciht in Kurs 15 (Einführung BWL A)
    (10, 511136),
    (10, 511137),
    (10, 511138),
    (10, 511139),
    (10, 511140),
    (15, 511150),
    (15, 511151),
    (15, 511152),
    (15, 511153),
    (15, 511154),
    (15, 511155);


/*
--------------------------------------------------
    ABFRAGEN
--------------------------------------------------
*/

-- Abruf Abgabe mit Frist und noch min verfügbaren Latedays in Team
-- inkl Berechnung von Härtefällen, Kurslatedays und Leistungslatedays
SELECT MIN(l.ld_calc) AS latedaysuebrig, l.frist
FROM (
    SELECT calc_latedays_left_total(verbrauchteld, latedays_verfuegbar) AS ld_calc, ak.frist
    FROM latedays_merged_overvies lo
             JOIN abgabe_in_kurs ak ON ak.id = lo.abgabe_id
    WHERE fk_team = 5
      AND kurs_id = 7) l;


-- Einzelaufruf Funktion für Berechnung der Strafe auf die Note, Berechnung wie oben
SELECT calc_penalty_on_course_grade(1, 711110);


##Dozent lässt sich alle nicht eingereichten Arbeiten anzeigen = Name und Kategorie
SELECT DISTINCT abgabe_in_kurs.*
FROM (
    SELECT *
    FROM leistung
) AS leistung
    RIGHT JOIN abgabe_in_kurs ON abgabe_in_kurs.id = leistung.fk_abgabe_in_kurs
WHERE abgabe_in_kurs.fk_kurs = 12
  AND frist <= '2021-12-10';


-- Abgabe von Student in Kurs mit Berechnung der Differenz früher oder später Abgaben
SELECT l.wert, lt.fk_leistungstyp, aik.frist, l.abgabe_ist,
       round_days_diff(aik.frist, l.abgabe_ist) as abgabe_differenz
FROM leistung l
JOIN abgabe_in_kurs aik on l.fk_abgabe_in_kurs = aik.id
JOIN leistung_template lt on aik.fk_leistung_template = lt.id
WHERE fk_matnr = 711110 AND fk_kurs = 3;

/*
SELECT frist, fk_leistungstyp, a.id FROM abgabe_in_kurs a
INNER JOIN leistung_template lt
    ON a.fk_leistung_template = lt.id
WHERE a.id NOT IN (
    SELECT fk_abgabe_in_kurs
    FROM leistung) AND a.fk_kurs = 7;

SELECT frist, fk_leistungstyp FROM abgabe_in_kurs a
    INNER JOIN leistung_template lt ON a.fk_leistung_template = lt.id
WHERE a.id
          NOT IN (SELECT fk_abgabe_in_kurs FROM leistung
WHERE fk_kurs = 7)
AND fk_kurs = 7;

SELECT frist, fk_leistungstyp, a.id FROM abgabe_in_kurs a
    INNER JOIN leistung_template lt ON a.fk_leistung_template = lt.id
WHERE fk_kurs = 7;

SELECT fk_abgabe_in_kurs, fk_matnr FROM leistung WHERE fk_matnr = 511126;


SELECT * FROM
SELECT frist, fk_leistungstyp, a.fk_kurs, l.fk_matnr
FROM abgabe_in_kurs a
    JOIN leistung_template lt ON a.fk_leistung_template = lt.id
LEFT JOIN leistung l ON a.id = l.fk_abgabe_in_kurs
WHERE fk_kurs = 7
GROUP BY a.id, fk_matnr;

-- 1 Abgabe für Kurs 7 (4)
SELECT fk_abgabe_in_kurs, fk_matnr FROM leistung WHERE fk_matnr = 511126;
*/


##alle Studenten in Teams
SELECT DISTINCT fk_matnr, fk_team
FROM student_in_team
         JOIN student_in_kurs USING (fk_matnr)
WHERE fk_kurs = 1
ORDER BY student_in_team.fk_team
DESC;


##Student lässt sich alle Kurse anzeigen, für die er Admin ist
SELECT fk_kurs,
    beschreibung
FROM student_in_kurs
         JOIN student ON student_in_kurs.fk_matnr = student.matnr
         JOIN kurs ON kurs.id = student_in_kurs.fk_kurs
WHERE matnr = 262728
  AND fk_zugriffsrechte = 'kwd';


##Dozent lässt sich alle E-Mail-Adressen eines Kurses im Jahrgang anzeigen
SELECT fk_kurs,
    fk_mail
FROM student_in_kurs
         JOIN student ON student_in_kurs.fk_matnr = student.matnr
         JOIN kurs ON kurs.id = student_in_kurs.fk_kurs
WHERE fk_jahrgang = 3
  AND fk_kurs = 2;


##Dozent lässt sich Studenten mit Aktiver Mitarbeit anzeigen
## in eigenen Kursen anzeigen mit ANzahl der MA (absteigend)
SELECT DISTINCT fk_matnr, vorname, nachname, kurs.id, COUNT(fk_aktive_mitarbeit) AS anzahl_mitarbeiten
FROM aktive_mitarbeit_in_kurs a
         JOIN kurs ON kurs.id = a.fk_kurs
         JOIN dozent_in_kurs ON dozent_in_kurs.fk_kurs = kurs.id
         JOIN student ON student.matnr = a.fk_matnr
         JOIN person ON person.mail = student.fk_mail
WHERE dozent_in_kurs.fk_mail = 'doz.super.man@doz.hwr-berlin.de'
GROUP BY fk_matnr, kurs.id
ORDER BY fk_matnr
DESC;


-- Abfrage einer Studentin ihrer bisher erbrachten Aktiven MA in einem Kurs
SELECT bezeichnung, zeitpunkt, nachweis FROM aktive_mitarbeit_von_studenten
WHERE matnr = 511142 AND fk_kurs = 12;


##Dozent lässt sich alle Teams anzeigen, in denen ein bestimmter Student war
SELECT matnr, vorname, nachname, team.id, max_mitglieder, kommentar
FROM student_in_team
         JOIN team ON student_in_team.fk_team = team.id
         JOIN student ON student.matnr = student_in_team.fk_matnr
         JOIN person ON person.mail = student.fk_mail
WHERE matnr = 123456;


##Dozent lässt sich alle Kategorien und deren Gewichtung anzeigen (absteigend)
SELECT fk_leistungstyp, gewichtung
FROM leistung_template
ORDER BY gewichtung
DESC;


##Dozent lässt sich alle Studenten offene Anfrage für ein Modul anzeigen
SELECT student.matnr, person.vorname, person.nachname
FROM student
         JOIN person ON person.mail = student.fk_mail
         LEFT JOIN anfrageaufnahme ON student.matnr = anfrageaufnahme.fk_matnr
WHERE anfrageaufnahme.fk_kurs = 6;


##Student lässt sich offene Anfragen für Module anzeigen
SELECT kursname_voll.vollname
FROM anfrageaufnahme
         JOIN kursname_voll ON kursname_voll.fk_kurs_id = anfrageaufnahme.fk_kurs
WHERE anfrageaufnahme.fk_matnr = 123456;


##Student (nur eigener Kurs), Dozent: Welche Studenten sind in Kurs XY?
SELECT student.matnr, person.vorname, person.nachname, student.fk_mail
FROM student
         JOIN student_in_kurs ON student_in_kurs.fk_matnr = student.matnr
         JOIN person ON person.mail = student.fk_mail
WHERE fk_kurs = 4;


##Student (nur er selbst), Dozent: Welche Leistungen hat Student XY bisher erbracht?
SELECT leistung.wert, leistung.abgabe_ist, leistung.frist_verlaengerung_tage, leistung_template.fk_leistungstyp
FROM leistung
         JOIN abgabe_in_kurs ON abgabe_in_kurs.id = leistung.fk_abgabe_in_kurs
         JOIN leistung_template ON abgabe_in_kurs.fk_leistung_template = leistung_template.id
WHERE leistung.fk_matnr = 123456
  AND abgabe_in_kurs.fk_kurs = 1;


##Dozent: Welche Leistungstemplates gibt es?
SELECT fk_leistungstyp, latedays, gewichtung, teiler
FROM leistung_template
ORDER BY fk_leistungstyp;


##update (Student): Noten
UPDATE  leistung
SET wert                     = '3.70',
    abgabe_ist               = '2021-12-01 00:01:00'
WHERE id = 5;


##update (Dozent): Noten, Festsetzung
UPDATE  leistung
SET wert        = '3.70',
    festgesetzt = '1'
WHERE id = 5;


INSERT INTO leistung(fk_matnr, fk_abgabe_in_kurs, wert, festgesetzt, abgabe_ist, frist_verlaengerung_tage)
VALUES ('511151', '11', '1.0', false, '2021-11-17 07:52:55.000000', '0');


##insert, update, delete (Student): Team (nur eigenes oder delete trigger wenn keine Mitglieder)
INSERT INTO team(id, max_mitglieder, kommentar)
VALUES (NULL, '3', 'super Team');


UPDATE team
SET max_mitglieder = '3',
    kommentar      = 'super Team'
WHERE id = 1;

DELETE
FROM team
WHERE id = 1;

##neuen Leistungstyp eintragen
INSERT INTO leistungstyp (bezeichnung) VALUES ('Hausarbeit');

##update, insert (Dozent): Leistungstemplate
INSERT INTO leistung_template(fk_leistungstyp, latedays, gewichtung,  teiler)
VALUES ('Hausarbeit', '14', '1', '1');

UPDATE leistung_template
SET fk_leistungstyp = 'Projektarbeit',
    latedays        = '5',
    gewichtung      = '0.45',
    teiler          = '1'
WHERE id = 1;


## Beitrittsanfrage für einen Kurs stellen
INSERT INTO anfrageaufnahme (fk_kurs, fk_matnr)
VALUES ('4', '711110');

