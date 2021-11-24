##Dozent fragt alle Noten des Kurses ab = Noten je Name
SELECT
    fk_matnr,
    vorname,
    nachname,
    KursID,
    AVG(Note) AS 'KursNote'
FROM
    (
    SELECT
        leistung_template_id,
        vorname,
        nachname,
        fk_matnr,
        KursID,
        AVG(wert) AS 'Note'
    FROM
        leistung_mit_kurs_und_student
    WHERE
        KursID = 3
    GROUP BY
        fk_matnr,
        id
) AS KategorieNoten
GROUP BY
    fk_matnr,
    KursID;



##Dozent lässt sich alle nicht eingereichten Arbeiten anzeigen = Name und Kategorie
SELECT DISTINCT
    abgabe_in_kurs.*
FROM
    (
    SELECT
        *
    FROM
        leistung
    WHERE
        fk_matnr = 123456
) AS leistung
RIGHT JOIN abgabe_in_kurs ON abgabe_in_kurs.id = leistung.fk_abgabe_in_kurs
WHERE
    abgabe_in_kurs.fk_kurs = 1
GROUP BY
    abgabe_in_kurs.id
HAVING
    COUNT(leistung.fk_matnr) < 1;



##alle Studenten in Teams
SELECT
    matnr,
    teamId,
    kommentar
FROM
    team_mit_studenten
ORDER BY
    teamId
DESC
    ;



## Latedays anzeigen
SELECT
    (
        latedays_verfuegbar - SUM(
            frist_verlaengerung_tage
        )
    ) AS 'Verbleibende Latedays'
FROM
    leistung_mit_kurs
WHERE
    fk_matnr = 123456 AND fk_kurs = 1;



##Student lässt sich alle Module anzeigen, für die er Admin ist
SELECT
    *
FROM
    kurs_mit_studenten
WHERE
    matnr = 262728 AND fk_zugriffsrechte = 'kwd';



##Dozent lässt sich alle E-Mails eines Kurses im Jahrgang anzeigen
SELECT
    fk_kurs,
    fk_mail
FROM
    kurs_mit_studenten
WHERE
    fk_jahrgang = 3 AND fk_modul = 2;



##Dozent lässt sich Studenten mit Aktiver Mitarbeit anzeigen (absteigend)
SELECT DISTINCT
    fk_matnr,
    vorname,
    nachname,
    fk_kurs,
    COUNT(
        fk_aktive_mitarbeit
    )
FROM
    aktive_mitarbeit_mit_kurs_und_student
WHERE
    Dozent_mail = 'doz.micky.mouse@hwr.de'
GROUP BY
    fk_matnr,
    fk_kurs
ORDER BY
    fk_matnr
DESC;



##Dozent lässt sich alle Teams anzeigen, in denen ein bestimmter Student war
SELECT
    matnr,
    vorname,
    nachname,
    teamId,
    max_mitglieder,
    kommentar
FROM
    team_mit_studenten
WHERE
    matnr = 123456;



##Dozent lässt sich alle Kategorien und deren Gewichtung anzeigen (absteigend)
SELECT
    fk_leistungstyp,
    gewichtung
FROM
    leistung_template
ORDER BY
    gewichtung
DESC
    ;



##Dozent lässt sich alle Studenten ohne Anfrage für ein Modul anzeigen
SELECT
    student.matnr,
    person.vorname,
    person.nachname
FROM
    student
JOIN person ON person.mail = student.fk_mail
LEFT JOIN anfrageaufnahme ON student.matnr = anfrageaufnahme.fk_matnr
WHERE
    anfrageaufnahme.fk_kurs IS NULL;



##Student lässt sich seine erreichten Noten aus allen Modulen absteigend anzeigen = Modul Gesamtnote
SELECT
    KursNote.fk_matnr,
    modul.*,
    AVG(KursNote.KursNote)
FROM
    (
    SELECT
        fk_matnr,
        fk_kurs,
        fk_modul,
        AVG(Note) AS 'KursNote'
    FROM
        (
        SELECT
            fk_leistung_template,
            fk_matnr,
            fk_kurs,
            fk_modul,
            AVG(wert) AS 'Note'
        FROM
            leistung_mit_kurs
        WHERE
            fk_matnr = 123456
        GROUP BY
            fk_kurs,
            fk_leistung_template
    ) AS KategorieNoten
GROUP BY
    fk_matnr,
    fk_kurs
) AS KursNote
JOIN modul ON modul.id = fk_modul
GROUP BY
    fk_modul,
    fk_matnr;



##Student lässt sich offene Anfragen für Module anzeigen
SELECT
    *
FROM
    anfrageaufnahme
WHERE
    anfrageaufnahme.fk_matnr = 123456;



##Student lässt sich alle Noten eines Kurses anzeigen = Note je Kategorie
SELECT
    fk_leistung_template,
    fk_leistungstyp,
    latedays,
    gewichtung,
    teiler,
    fk_matnr,
    AVG(wert) AS 'Note'
FROM
    leistung_mit_kurs
WHERE
    fk_matnr = 123456 AND fk_kurs = 3
GROUP BY
    id;



##Student lässt sich seine verbliebenen LateDays anzeigen
SELECT
    fk_kurs,
    beschreibung,
    fk_jahrgang,
    fk_kurs_buchstabe,
    fk_modul,
    latedays_verfuegbar,
    (
        latedays_verfuegbar - SUM(frist_verlaengerung_tage)
    ) AS 'Verbleibende Latedays'
FROM
    leistung_mit_kurs
WHERE
    fk_matnr = 123456
GROUP BY
    fk_kurs;



##Student/Team lässt sich LateDays der Mitglieder anzeigen
SELECT DISTINCT
    kurs_mit_studenten.matnr,
    (
        kurs_mit_studenten.latedays_verfuegbar - SUM(
            leistung.frist_verlaengerung_tage
        )
    ) AS 'Verbleibende Latedays'
FROM
    kurs_mit_studenten
JOIN student_in_team ON student_in_team.fk_matnr = kurs_mit_studenten.matnr
LEFT JOIN leistung ON kurs_mit_studenten.matnr = leistung.fk_matnr
WHERE
    student_in_team.fk_team = 3 AND kurs_mit_studenten.fk_kurs = 4
GROUP BY
    kurs_mit_studenten.matnr,
    kurs_mit_studenten.latedays_verfuegbar;



##Student lässt sich Kategorien ohne Note anzeigen
SELECT DISTINCT
    leistung_template.*
FROM
    (
    SELECT
        *
    FROM
        leistung
    WHERE
        leistung.fk_matnr = 123456
) AS leistung
RIGHT JOIN abgabe_in_kurs ON abgabe_in_kurs.id = leistung.fk_abgabe_in_kurs
JOIN leistung_template ON leistung_template.id = abgabe_in_kurs.fk_leistung_template
WHERE abgabe_in_kurs.fk_kurs = 1
GROUP BY
    abgabe_in_kurs.fk_leistung_template
HAVING
    COUNT(leistung.fk_matnr) < 1;



##Student, Dozent: Welches Team hat Aufgabe XY bearbeitet (Team, Studenten, Aufgabe)?
SELECT
    id AS Aufgabe,
    fk_team AS Team,
    teamKommentar,
    Teammitglied
FROM
   leistung_mit_team
WHERE
    id = 1;



##Student (nur eigener Kurs), Dozent: Welche Studenten sind in Kurs XY?
SELECT
    fk_kurs,
    matnr,
    vorname,
    nachname,
    fk_mail,
    studiengang
FROM
    kurs_mit_studenten
WHERE
    fk_kurs = 4;



##Student (nur er selbst), Dozent: Welche Leistungen hat Student XY bisher erbracht?
SELECT
    fk_kurs,
    fk_team,
    wert,
    frist_verlaengerung_tage,
    frist,
    fk_leistung_template,
    fk_leistungstyp,
    latedays,
    gewichtung,
    teiler
FROM
    leistung_mit_kurs
WHERE
    fk_matnr = 123456 AND fk_kurs = 1;



##Student (nur er selbst), Dozent: Mit welcher Verspätung wurde Leistung XY abgegeben (Leistung, Template, Kurs)?
SELECT
    id,
    frist_verlaengerung_tage,
    fk_kurs,
    fk_leistung_template
FROM
    leistung_mit_kurs
WHERE
    id = 1;



##Student: Wieviel Zeit bleibt für die Abgabe einer Leistung nur eigene Latedays
SELECT
    (
        DATEDIFF(
            abgabe_in_kurs.frist,
            CURDATE()) +(
            SELECT
                (
                    CASE WHEN Verbleibende_Latedays < 0 THEN 0 ELSE Verbleibende_Latedays
                END
        )
    FROM
        (
        SELECT
            (
                leistung_template.latedays -(
                    IFNULL(
                        (
                        SELECT
                            SUM(
                                leistung.frist_verlaengerung_tage
                            )
                        FROM
                            leistung
                        JOIN abgabe_in_kurs ON leistung.fk_abgabe_in_kurs = abgabe_in_kurs.id
                        WHERE
                            abgabe_in_kurs.fk_leistung_template =(
                            SELECT
                                (
                                    abgabe_in_kurs.fk_leistung_template
                                )
                            FROM
                                abgabe_in_kurs
                            WHERE
                                abgabe_in_kurs.id = 2
                        ) AND abgabe_in_kurs.fk_kurs =(
                        SELECT
                            (abgabe_in_kurs.fk_kurs)
                        FROM
                            abgabe_in_kurs
                        WHERE
                            abgabe_in_kurs.id = 2
                    ) AND leistung.fk_matnr = 171819
                    ),
                    0
                    )
                )
            ) AS Verbleibende_Latedays
        FROM
            leistung_template
        JOIN abgabe_in_kurs ON abgabe_in_kurs.fk_leistung_template = leistung_template.id
        JOIN kurs ON kurs.id = abgabe_in_kurs.fk_kurs
        WHERE
            abgabe_in_kurs.id = 2
    ) AS Latedays
        )
    ) AS 'verbleibende Tage'
FROM
    abgabe_in_kurs
WHERE
    abgabe_in_kurs.id = 2;


##Student: Wieviel Zeit bleibt für die Abgabe einer Leistung mit LateDays der Gruppenmitglieder
SELECT
    (
        DATEDIFF(
            abgabe_in_kurs.frist,
            CURDATE()) +(
            SELECT
                (
                    CASE WHEN Verbleibende_Latedays < 0 THEN 0 ELSE Verbleibende_Latedays
                END
        )
    FROM
        (
        SELECT
            MIN(abc.Verbleibende_Latedays) AS Verbleibende_Latedays
        FROM
            (
            SELECT
                student_in_team.fk_matnr,
                (
                    leistung_template.latedays -(
                        IFNULL(
                            (
                            SELECT
                                SUM(
                                    leistung.frist_verlaengerung_tage
                                )
                            FROM
                                leistung
                            JOIN abgabe_in_kurs ON leistung.fk_abgabe_in_kurs = abgabe_in_kurs.id
                            WHERE
                                abgabe_in_kurs.fk_leistung_template =(
                                SELECT
                                    (
                                        abgabe_in_kurs.fk_leistung_template
                                    )
                                FROM
                                    abgabe_in_kurs
                                WHERE
                                    abgabe_in_kurs.id = 14
                            ) AND abgabe_in_kurs.fk_kurs =(
                            SELECT
                                (abgabe_in_kurs.fk_kurs)
                            FROM
                                abgabe_in_kurs
                            WHERE
                                abgabe_in_kurs.id = 14
                        ) AND leistung.fk_matnr = student_in_team.fk_matnr
                        ),
                        0
                        )
                    )
                ) AS Verbleibende_Latedays
            FROM
                leistung_template
            JOIN abgabe_in_kurs ON abgabe_in_kurs.fk_leistung_template = leistung_template.id
            JOIN kurs ON kurs.id = abgabe_in_kurs.fk_kurs
            JOIN student_in_kurs ON student_in_kurs.fk_kurs = kurs.id
            JOIN student ON student.matnr = student_in_kurs.fk_matnr
            JOIN student_in_team ON student_in_kurs.fk_matnr = student.matnr
            WHERE
                abgabe_in_kurs.id = 14 AND student_in_team.fk_team = 1
            GROUP BY
                student_in_team.fk_matnr
        ) AS abc
    ) AS Latedays
        )
    ) AS 'verbleibende Tage'
FROM
    abgabe_in_kurs
WHERE
    abgabe_in_kurs.id = 14;



## Student, Dozent: Welche Durchschnittsnote inkl. Berücksichtigung der Gewichtung hat Student XY?
SELECT
    fk_matnr,
    fk_kurs,
    AVG(Note) AS 'KursNote'
FROM
    (
    SELECT
        fk_matnr,
        fk_kurs,
        AVG(wert) AS 'Note'
    FROM
        leistung_mit_kurs
    WHERE
        fk_matnr = 123456 AND fk_kurs = 3
    GROUP BY
        fk_kurs,
        id
) AS KategorieNoten
GROUP BY
    fk_matnr,
    fk_kurs;



##Dozent: Welche Durchschnittsnote wurde in einem Kurs für ein bestimmtes Leistungstemplate erreicht?
SELECT
    fk_leistung_template,
    fk_leistungstyp,
    latedays,
    gewichtung,
    teiler,
    AVG(wert) AS 'Durchschnittsnote'
FROM
    leistung_mit_kurs
WHERE
    fk_kurs = 3
GROUP BY
    fk_leistung_template;



##Student, Dozent: Welche aktiven Mitarbeiten hat Student XY in einem Kurs erbracht?
SELECT
    bezeichnung,
   zeitpunkt,
    nachweis
FROM
    aktive_mitarbeit_mit_kurs_und_student
WHERE
   fk_matnr = 123456 AND fk_kurs = 3;



##Dozent: Welche Leistungstemplates gibt es?
SELECT
    fk_leistungstyp,
    latedays,
    gewichtung,
    teiler
FROM
    leistung_template
ORDER BY
    fk_leistungstyp;



##Dozent: Welche Studenten bekommen Abzug (und wieviel) wegen überschrittener Latedays für Leistung XY?
SELECT
    fk_matnr,
    (
        0 - latedays_verfuegbar + SUM(frist_verlaengerung_tage)
    ) AS Abzug_in_Prozent
FROM
    leistung_mit_kurs
WHERE
    fk_kurs = 1
GROUP BY
    fk_kurs,
    fk_matnr
HAVING
    Abzug_in_Prozent > 0;




##Student: Fristen
SELECT
	KursID,
    fk_leistungstyp,
    DATE_FORMAT(frist, "%d %M %Y")
FROM
    leistung_mit_kurs_und_student
WHERE
    fk_matnr = 789010;



##update (Student): Noten
UPDATE
    leistung
SET
    fk_matnr = '123456',
    fk_abgabe_in_kurs = '36',
    fk_team = NULL,
    wert = '3.70',
    abgabe_ist = '2021-12-01 00:01:00',
    frist_verlaengerung_tage = '0'
WHERE
    id = 5;



##update (Dozent): Noten, Festsetzung
UPDATE
    leistung
SET
    wert = '3.70',
    festgesetzt = '1'
WHERE
    id = 5;

INSERT INTO leistung(
    id,
    fk_matnr,
    fk_abgabe_in_kurs,
    fk_team,
    wert,
    festgesetzt,
    abgabe_ist,
    frist_verlaengerung_tage
)
VALUES(
    NULL,
    '171819',
    '3',
    '3',
    '1.0',
    '1',
    '2021-11-17 07:52:55.000000',
    '0'
);




##insert (student): Aktive Mitarbeit
START TRANSACTION
    ;
INSERT INTO aktive_mitarbeit(
    id,
    zeitpunkt,
    nachweis,
    bezeichnung
)
VALUES(
    NULL,
    '2021-11-17 08:52:55.000000',
    'test',
    'ad'
);
INSERT INTO aktive_mitarbeit_in_kurs(
    fk_matnr,
    fk_kurs,
    fk_aktive_mitarbeit
)
VALUES(123456, 3, LAST_INSERT_ID());
COMMIT
    ;

##insert, update, delete (Student): Team (nur eigenes oder delete trigger wenn keine Mitglieder)
INSERT INTO team(id, max_mitglieder, kommentar)
VALUES(NULL, '3', 'super Team');

UPDATE
    team
SET
    max_mitglieder = '3',
    kommentar = 'super Team'
WHERE
    id = 1

DELETE
FROM
    team
WHERE
    id = 1



##update, insert (Dozent): Leistungstemplate
INSERT INTO leistung_template(
    fk_leistungstyp,
    latedays,
    gewichtung,
    teiler
)
VALUES(
    'Projekt',
    '5',
    '0.45',
    '1'
)

UPDATE
    leistung_template
SET
    fk_leistungstyp = 'Projekt',
    latedays = '5',
    gewichtung = '0.45',
    teiler = '1'
WHERE
    id = 1;



## Beitrittsanfrage für einen Kurs stellen
INSERT INTO `anfrageaufnahme` (`fk_kurs`, `fk_matnr`) VALUES ('6', '383940');

## Beitrittsanfrage für einen Kurs annehmen
START Transmission;
DELETE FROM `anfrageaufnahme` WHERE fk_kurs = 6 AND fk_matnr = 383940;
INSERT INTO `student_in_kurs`(`fk_kurs`, `fk_matnr`, `fk_zugriffsrechte`) VALUES ('6','383940','urw');
COMMIT;