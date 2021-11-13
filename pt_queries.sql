USE performancetracker;

INSERT INTO student_in_team (fk_matnr, fk_team) VALUES
    (999999, 8);

DELIMITER //
DROP PROCEDURE IF EXISTS drop_tables //
CREATE PROCEDURE drop_tables()
    BEGIN
        DROP TABLE dozent_in_kurs;
        DROP TABLE student_in_kurs;
        DROP TABLE zugriffsrecht;
        DROP TABLE student;
        DROP TABLE dozent;
        DROP TABLE account;
        DROP TABLE person;
        DROP TABLE student_in_team;
        DROP TABLE team;
        DROP TABLE aktive_mitarbeit_in_kurs;
        DROP TABLE aktive_mitarbeit;
        DROP TABLE leistung;
        DROP TABLE abgabe_in_kurs;
        DROP TABLE leistung_template;
        DROP TABLE leistungstyp;
        DROP TABLE anfrageaufnahme;
        DROP TABLE matrikelnummer;
        DROP TABLE kurs;
        DROP TABLE jahrgang;
        DROP TABLE kurs_buchstabe;
        DROP TABLE modul;
        DROP DATABASE performancetracker;
    END //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS reset_tables //
CREATE PROCEDURE reset_tables()
    BEGIN
        DELETE FROM dozent_in_kurs WHERE (SELECT COUNT(*) FROM dozent_in_kurs) >= 1;
        DELETE FROM student_in_kurs WHERE (SELECT COUNT(*) FROM student_in_kurs) >= 1;
        DELETE FROM zugriffsrecht WHERE (SELECT COUNT(*) FROM zugriffsrecht) >= 1;
        DELETE FROM student WHERE (SELECT COUNT(*) FROM student) >= 1;
        DELETE FROM dozent WHERE (SELECT COUNT(*) FROM dozent) >= 1;
        DELETE FROM account WHERE (SELECT COUNT(*) FROM account) >= 1;
        DELETE FROM person WHERE (SELECT COUNT(*) FROM person) >= 1;
        DELETE FROM student_in_team WHERE (SELECT COUNT(*) FROM student_in_team) >= 1;
        DELETE FROM team WHERE (SELECT COUNT(*) FROM team) >= 1;
        DELETE FROM aktive_mitarbeit_in_kurs WHERE (SELECT COUNT(*) FROM aktive_mitarbeit_in_kurs) >= 1;
        DELETE FROM aktive_mitarbeit WHERE (SELECT COUNT(*) FROM aktive_mitarbeit) >= 1;
        DELETE FROM leistung WHERE (SELECT COUNT(*) FROM leistung) >= 1;
        DELETE FROM abgabe_in_kurs WHERE (SELECT COUNT(*) FROM abgabe_in_kurs) >= 1;
        DELETE FROM leistung_template WHERE (SELECT COUNT(*) FROM leistung_template) >= 1;
        DELETE FROM leistungstyp WHERE (SELECT COUNT(*) FROM leistungstyp) >= 1;
        DELETE FROM kurs WHERE (SELECT COUNT(*) FROM kurs) >= 1;
        DELETE FROM jahrgang WHERE (SELECT COUNT(*) FROM jahrgang) >= 1;
        DELETE FROM kurs_buchstabe WHERE (SELECT COUNT(*) FROM kurs_buchstabe) >= 1;
        DELETE FROM modul WHERE (SELECT COUNT(*) FROM modul) >= 1;
        DELETE FROM anfrageaufnahme WHERE (SELECT COUNT(*) FROM anfrageaufnahme) >= 1;
        DELETE FROM matrikelnummer WHERE (SELECT COUNT(*) FROM matrikelnummer) >= 1;
        ALTER TABLE abgabe_in_kurs AUTO_INCREMENT = 1;
        ALTER TABLE leistung_template AUTO_INCREMENT = 1;
        ALTER TABLE team AUTO_INCREMENT = 1;
        ALTER TABLE kurs AUTO_INCREMENT = 1;
        ALTER TABLE jahrgang AUTO_INCREMENT = 1;
        ALTER TABLE modul AUTO_INCREMENT = 1;
        ALTER TABLE leistung AUTO_INCREMENT = 1;
        ALTER TABLE aktive_mitarbeit AUTO_INCREMENT = 1;
        ALTER TABLE leistung AUTO_INCREMENT = 1;
    END;
DELIMITER ;

-- vor Ausführung der Skripte Datenbank auswählen (erste Zeile kompilieren)
-- und Skripte kompilieren

-- Daten löschen und index increment zurücksetzen
CALL reset_tables();

-- Tabellen und Datenbank löschen
CALL drop_tables();

-- Test: kaskadierende Updates
UPDATE matrikelnummer
SET matnr = 111111
WHERE matnr = 123456;