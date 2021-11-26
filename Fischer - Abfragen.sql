##Dozent fragt alle Noten des Kurses ab = Noten je Name
CREATE View Kursnote AS
SELECT DISTINCT
    fk_kurs,
    fk_matnr,
    FORMAT(
        Kursnote -(1 / 15) *(
            IFNULL(aktive_mitarbeit_in_Prozent, 0) +( CASE WHEN berechne_latedays_aggregiert(fk_kurs, fk_matnr) >= 0 THEN 0 ELSE berechne_latedays_aggregiert(fk_kurs, fk_matnr) END)
        ),
        1
    )  AS Kursnote
FROM
    (
    SELECT
        fk_kurs,
        fk_matnr,
        (
            FORMAT((SUM(NoteGewichtet)),
            2)
        ) AS Kursnote
    FROM
        (
        SELECT
            fk_kurs,
            fk_matnr,
            fk_leistungstyp,
            (
                Note *(
                    gewichtung /(
                    SELECT
                        SUM(N.gewichtung)
                    FROM
                        Note_nach_Leistungstyp AS N
                    WHERE
                        N.fk_kurs = Note_nach_Leistungstyp.fk_kurs AND N.fk_matnr = Note_nach_Leistungstyp.fk_matnr
                )
                )
            ) AS NoteGewichtet
        FROM
            Note_nach_Leistungstyp
    ) AS abc
GROUP BY
    fk_kurs,
    fk_matnr
) AS def
INNER JOIN student_in_kurs USING(fk_matnr, fk_kurs);




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
    abgabe_in_kurs.fk_kurs = 1 and
      frist <= '2021-10-10'
GROUP BY
    abgabe_in_kurs.id
HAVING
    COUNT(leistung.fk_matnr) < 1;


##alle Studenten in Teams
SELECT DISTINCT
    fk_matnr, fk_team
FROM
    student_in_team JOIN student_in_kurs USING (fk_matnr)
WHERE
    fk_kurs = 1
ORDER BY
    student_in_team.fk_team
DESC;


## Latedays anzeigen
call berechne_latedays(1, 123456);



##Student lässt sich alle Kurse anzeigen, für die er Admin ist
SELECT
    fk_kurs,
    beschreibung
FROM
    student_in_kurs
JOIN student ON student_in_kurs.fk_matnr = student.matnr
JOIN kurs ON kurs.id = student_in_kurs.fk_kurs
WHERE
    matnr = 262728 AND fk_zugriffsrechte = 'kwd';



##Dozent lässt sich alle E-Mail-Adressen eines Kurses im Jahrgang anzeigen
SELECT
    fk_kurs,
    fk_mail
FROM
    student_in_kurs
JOIN student ON student_in_kurs.fk_matnr = student.matnr
JOIN kurs ON kurs.id = student_in_kurs.fk_kurs
WHERE
    fk_jahrgang = 3 AND fk_kurs = 2;



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
    aktive_mitarbeit_in_kurs
JOIN kurs ON kurs.id = aktive_mitarbeit_in_kurs.fk_kurs
JOIN dozent_in_kurs ON dozent_in_kurs.fk_kurs = kurs.id
JOIN student ON student.matnr = aktive_mitarbeit_in_kurs.fk_matnr
JOIN person ON person.mail = student.fk_mail
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
    team.id,
    max_mitglieder,
    kommentar
FROM
    student_in_team
JOIN team ON student_in_team.fk_team = team.id
JOIN student ON student.matnr = student_in_team.fk_matnr
JOIN person ON person.mail = student.fk_mail
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

##Dozent lässt sich alle Studenten offene Anfrage für ein Modul anzeigen
SELECT
    student.matnr,
    person.vorname,
    person.nachname
FROM
    student
JOIN person ON person.mail = student.fk_mail
LEFT JOIN anfrageaufnahme ON student.matnr = anfrageaufnahme.fk_matnr
WHERE
    anfrageaufnahme.fk_kurs = 6;



##Student lässt sich seine erreichten Noten aus allen Modulen anzeigen = Modul Gesamtnote
CREATE VIEW Modulnote AS
SELECT fk_matnr, fk_modul , FORMAT(Sum(a),1) AS Modulnote

FROM (SELECT DISTINCT
    Kursnote.fk_matnr, kurs.fk_modul,
    (
        Kursnote.Kursnote *(
            kurs.modul_gewichtung /(
            SELECT
                SUM(modul_gewichtung)
            FROM
                (
                SELECT DISTINCT
                    *
                FROM
                    kurs AS k
                JOIN student_in_kurs AS sk
                ON
                    sk.fk_kurs = k.id
                WHERE
                    k.fk_modul = kurs.fk_modul AND sk.fk_matnr = Kursnote.fk_matnr
            ) AS abc
        
        )
    )) AS a
FROM
    Kursnote
JOIN kurs ON kurs.id = Kursnote.fk_kurs) as def
GROUP BY fk_modul, fk_matnr;


##Student lässt sich offene Anfragen für Module anzeigen
##TODO Kursname von Moodle nachbauen
SELECT
    fk_kurs, CONCAT(kurs.beschreibung , ' ',kurs.fk_kurs_buchstabe,' Modul ', kurs.fk_modul) AS Kurs
FROM
    anfrageaufnahme
JOIN kurs ON kurs.id = anfrageaufnahme.fk_kurs
WHERE
    anfrageaufnahme.fk_matnr = 123456;



##Student lässt sich alle Noten eines Kurses anzeigen = Note je Kategorie
CREATE VIEW Note_nach_Leistungstyp AS
SELECT fk_kurs,fk_matnr,fk_leistungstyp, FORMAT(AVG(wert),1) AS Note, gewichtung
FROM leistung
JOIN abgabe_in_kurs ON abgabe_in_kurs.id = leistung.fk_abgabe_in_kurs
JOIN leistung_template ON leistung_template.id = abgabe_in_kurs.fk_leistung_template
GROUP By fk_leistungstyp, fk_matnr, gewichtung, fk_leistung_template, fk_kurs;




##Student, Dozent: Welches Team hat Aufgabe XY bearbeitet (Team, Studenten, Aufgabe)?
#TODO Eingrenzung auf  erbrachte Leistung Corentin
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
#TODO View ändern Corentin
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
##TODO View anpassen Corentin
SELECT
    wert,
    frist_verlaengerung_tage,
    frist,
    fk_leistungstyp
FROM
    leistung_mit_kurs
WHERE
    fk_matnr = 123456 AND fk_kurs = 1;





##Student: Wieviel Zeit bleibt für die Abgabe einer Leistung nur eigene Latedays
#TODO in Funktion auslagern Corentin
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
#TODO siehe oben in Funktion dann statt CURDATE() date übergeben Corentin
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









##Student, Dozent: Welche aktiven Mitarbeiten hat Student XY in einem Kurs erbracht?
CREATE VIEW aktive_mitarbeit_von_studenten AS
    SELECT fk_kurs, fk_matnr, vorname, nachname, bezeichnung, zeitpunkt
FROM aktive_mitarbeit_in_kurs ak
JOIN aktive_mitarbeit am on am.id = ak.fk_aktive_mitarbeit
JOIN student s on ak.fk_matnr = s.matnr
JOIN person p on s.fk_mail = p.mail
ORDER BY zeitpunkt;




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




##Student: Fristen
## TODO nicht auf große View
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
DELIMITER $$
create procedure insertAktiveMitarbeit (Matrikelnummer int, Kurs_ID int, Zeitpunkt date, Nachweis char(255), Bezeichnung char(255))
Begin
INSERT INTO aktive_mitarbeit(
    id,
    zeitpunkt,
    nachweis,
    bezeichnung
)
VALUES(
    NULL,
    Zeitpunkt,
    Nachweis,
    Bezeichnung
);
INSERT INTO aktive_mitarbeit_in_kurs(
    fk_matnr,
    fk_kurs,
    fk_aktive_mitarbeit
)
VALUES(Matrikelnummer, Kurs_ID, LAST_INSERT_ID());
End $$

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
create procedure acceptStudent (Matrikelnummer int, Kurs_ID int, Rechte char(3))
Begin
DELETE FROM `anfrageaufnahme` WHERE fk_kurs = Kurs_ID AND fk_matnr = Matrikelnummer;
INSERT INTO `student_in_kurs`(`fk_kurs`, `fk_matnr`, `fk_zugriffsrechte`) VALUES (Kurs_ID,Matrikelnummer,Rechte);
End $$
