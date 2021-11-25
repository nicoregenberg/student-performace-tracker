USE performancetracker;

INSERT INTO kurs_buchstabe (wert)
VALUES
    ('A'), ('B'), ('C');

INSERT INTO jahrgang (jahr, sem_so_wi)
VALUES
    ('19', 'W'), ('19', 'S'),
    ('20', 'W'), ('20', 'S'),
    ('21', 'W'), ('21', 'S');

INSERT INTO fachrichtung (bezeichnung)
VALUES
    ('WI'), ('Elektrotechnik'), ('BWL');

INSERT INTO modul (fk_fachrichtung, modulnummer, beschreibung)
VALUES
    ('WI', 103, null),
    ('WI', 602, 'Datenbanken'),
    ('WI', 301, 'Oldschool Java'),
    ('BWL', 10, 'Die Kunst, Leute zu überreden, Dinge zu kaufen, die sie nicht brauchen (Marketing)'),
    ('BWL', 12, 'Pseudowissenschaft für junge Gründer'),
    ('Elektrotechnik', 47, 'Mathematik')
    ('Elektrotechnik', 48, 'Regelungstechnik')
    ('Elektrotechnik', 51, 'Halbleitertechnik');

INSERT INTO team (max_mitglieder, kommentar)
VALUES
    (3, 'Die zwei lustigen Drei'),
    (3, 'Die Helmers'),
    (3, null),
    (4, 'Die fantastischen Vier'),
    (3, 'Team 50/50'),
    (3, null),
    (3, 'Havana Club'),
    (3, null),
    (3, 'Altenheim :-) '),
    (6, 'Landliebe Sahnepuddig'),
    (6, 'die Unkreativen'),
    (6, null),
    (6, 'The Big Beer Theory'),
    (6, null),
    (6, 'Stuzubis'),
    (6, null),
    (2, 'Just married');

INSERT INTO person (mail, vorname, nachname)
VALUES
    ('doz.super.man@hwr.de', 'Super', 'Man'),
    ('doz.micky.mouse@hwr.de', 'Micky', 'Mouse'),
    ('doz.james.bond@hwr.de', 'James', 'Bond'),
    ('doz.bugs.bunny@hwr.de', 'Bugs', 'Bunny'),
    ('doz.dorothy.gale@hwr.de', 'Dorothy', 'Gale'),
    ('stud.bat.man@hwr.de', 'Bat', 'Man'),
    ('stud.darth.vader@hwr.de', 'Darth', 'Vader'),
    ('stud.indiana.jones@hwr.de', 'Indiana', 'Jones'),
    ('stud.rocky.balboa@hwr.de', 'Rocky', 'Balboa'),
    ('stud.vito.corleone@hwr.de', 'Vito', 'Corleone'),
    ('stud.princess.leia@hwr.de', 'Prinzessin', 'Leia'),
    ('stud.scarlett.ohara@hwr.de', 'Scarlett', 'OHara'),
    ('stud.the.joker@hwr.de', 'The', 'Joker'),
    ('stud.hannibal.lector@hwr.de', 'Hannibal', 'Lector'),
    ('stud.tony.montana@hwr.de', 'Tony', 'Montana'),
    ('stud.mary.poppins@hwr.de', 'Mary', 'Poppins'),
    ('stud.black.widow@hwr.de', 'Black', 'Widow'),
    ('stud.cosmo.cramer@hwr.de', 'Cosmo', 'Cramer'),
    ('stud.ellen.ripley@hwr.de', 'Ellen', 'Ripley'),
    ('stud.marge.simpson@hwr.de', 'Marge', 'Simpson'),
    ('stud.mutti@hwr.de', 'Angela', 'Merkel'),
    ('stud.captain.america@hwr.de', 'Captain', 'America'),
    ('stud.greta.thunberg@hwr.de', 'Greta', 'Thunberg'),
    ('stud.fauler.sack@hwr.de', 'Fauler', 'Sack'),
    ('stud.super.streber@hwr.de', 'Super', 'Streber'),
    ('stud.über.schätzt@hwr.de', 'Über', 'Schätzt'),
    ('mcopin0@spiegel.de', 'Morse', 'Copin'),
    ('sbangs1@fastcompany.com', 'Sadie', 'Bangs'),
    ('aellacombe2@skyrock.com', 'Athena', 'Ellacombe'),
    ('ayerrall3@yahoo.co.jp', 'Ariela', 'Yerrall'),
    ('jmatley4@weebly.com', 'Jackie', 'Matley'),
    ('zsabey5@businesswire.com', 'Zacharia', 'Sabey'),
    ('lhinkens6@furl.net', 'Lesley', 'Hinkens'),
    ('bhellewell7@1und1.de', 'Bo', 'Hellewell'),
    ('zsanton8@tinypic.com', 'Zarah', 'Santon'),
    ('mspark9@ucoz.com', 'Melesa', 'Spark'),
    ('asaigera@cargocollective.com', 'Annie', 'Saiger'),
    ('tclixbyb@state.tx.us', 'Thalia', 'Clixby'),
    ('ahairec@amazon.com', 'Annaliese', 'Haire'),
    ('idenisotd@themeforest.net', 'Izzy', 'Denisot'),
    ('dmore@dailymail.co.uk', 'Dorolice', 'Mor'),
    ('tbranef@prweb.com', 'Tammara', 'Brane'),
    ('gbanaszczykg@wordpress.org', 'Gilberte', 'Banaszczyk'),
    ('wdmitrh@flavors.me', 'Walt', 'Dmitr'),
    ('dedwickei@nih.gov', 'Desmund', 'Edwicke');

INSERT INTO dozent (fk_person)
VALUES
    ('doz.super.man@hwr.de'),
    ('doz.micky.mouse@hwr.de'),
    ('doz.james.bond@hwr.de'),
    ('doz.bugs.bunny@hwr.de'),
    ('doz.dorothy.gale@hwr.de');

INSERT INTO student (fk_mail, fk_fachrichtung, matnr)
VALUES
    ('stud.darth.vader@hwr.de', 'WI', 262728),
    ('stud.indiana.jones@hwr.de', 'WI', 293031),
    ('stud.rocky.balboa@hwr.de', 'WI', 323334),
    ('stud.vito.corleone@hwr.de', 'WI', 353637),
    ('stud.princess.leia@hwr.de', 'WI', 383940),
    ('stud.scarlett.ohara@hwr.de', 'WI', 414243),
    ('stud.the.joker@hwr.de', 'WI', 444546),
    ('stud.hannibal.lector@hwr.de', 'WI', 474849),
    ('stud.tony.montana@hwr.de', 'WI', 505152),
    ('stud.mary.poppins@hwr.de', 'WI', 535455),
    ('stud.black.widow@hwr.de', 'WI', 565758),
    ('stud.cosmo.cramer@hwr.de', 'WI', 596061),
    ('stud.ellen.ripley@hwr.de', 'WI', 616263),
    ('stud.marge.simpson@hwr.de', 'BWL', 789010),
    ('stud.mutti@hwr.de', 'BWL', 111213),
    ('stud.captain.america@hwr.de', 'BWL', 123456),
    ('stud.greta.thunberg@hwr.de', 'BWL', 141516),
    ('stud.fauler.sack@hwr.de', 'BWL', 171819),
    ('stud.super.streber@hwr.de', 'BWL', 202122),
    ('stud.über.schätzt@hwr.de', 'BWL', 232425),
    ('mcopin0@spiegel.de', 'Elektrotechnik', 223340),
    ('sbangs1@fastcompany.com', 'Elektrotechnik', 223341),
    ('aellacombe2@skyrock.com', 'Elektrotechnik', 223342),
    ('ayerrall3@yahoo.co.jp', 'Elektrotechnik', 223343),
    ('jmatley4@weebly.com', 'Elektrotechnik', 22335),
    ('zsabey5@businesswire.com', 'Elektrotechnik', 223346),
    ('lhinkens6@furl.net', 'Elektrotechnik', 22337),
    ('bhellewell7@1und1.de', 'Elektrotechnik', 22338),
    ('zsanton8@tinypic.com', 'Elektrotechnik', 22339),
    ('mspark9@ucoz.com', 'Elektrotechnik', 223350),
    ('asaigera@cargocollective.com', 'WI', 223351),
    ('tclixbyb@state.tx.us', 'WI', 223352),
    ('ahairec@amazon.com', 'WI', 223353),
    ('idenisotd@themeforest.net', 'WI', 223354),
    ('dmore@dailymail.co.uk', 'WI', 223355),
    ('tbranef@prweb.com', 'WI', 223356),
    ('gbanaszczykg@wordpress.org', 'WI', 223357),
    ('wdmitrh@flavors.me', 'WI', 223358),
    ('dedwickei@nih.gov', 'WI', 223359);

INSERT INTO student_in_team (fk_matnr, fk_team)
VALUES
    (123456, 1), (789010, 1), (111213, 1), (141516, 2), (171819, 2),
    (123456, 2), (232425, 3), (262728, 3), (293031, 3), (171819, 4),
    (123456, 4), (383940, 4), (414243, 4), (141516, 5), (223340, 6), 
    (223341, 7), (223342, 7), (223343, 8), (223344, 9), (223345, 10), 
    (223346, 10), (223347, 10), (223348, 11), (223349, 11), (223350, 11), 
    (223351, 12), (223352, 12), (223353, 13), (223354, 14), (223355, 15), 
    (223356, 15), (223357, 15), (223358, 16), (223359, 16);

INSERT INTO zugriffsrecht (abkuerzung, beschreibung)
VALUES
    ('ur', 'nur Leserecht eigene Nutzerdaten'),
    ('urw', 'Lese- und Schreibrecht eigene Nutzerdaten'),
    ('urd', 'Lese- Schreib- und Löschrecht eigene Nutzerdaten'),
    ('kr', 'nur Leserecht eigene Kursdaten (aller Teilnehmer)'),
    ('krw', 'Lese- und Schreibrecht eigene Kursdaten (aller Teilnehmer)'),
    ('krd', 'Lese- Schreib- und Löschrecht eigene Kursdaten (aller Teilnehmer)'),
    ('gr', 'nur Leserecht alle Nutzerdaten (global)'),
    ('grw', 'Lese- und Schreibrecht alle Nutzerdaten (global)'),
    ('grd', 'Lese- Schreib- und Löschrecht alle Nutzerdaten (global --> Superadmin)'),
    ('kwd', 'Schreib- und Löschrecht eigene Kursdaten (aller Teilnehmer --> Studentadmin)');

INSERT INTO kurs (beschreibung, fk_jahrgang, fk_kurs_buchstabe, fk_modul, latedays_verfuegbar)
VALUES
    ('Einführung DB', 3, 'C', 2, 0),
    ('Einführung BWL', 3, 'C', 1, 0),
    ('Einführung OOP', 3, 'C', 3, 6),
    ('Einführung OOP', 4, 'A', 3, 3),
    ('Softwarearchitektur', 3, 'C', 3, 6), 
    ('Mathematik für Ingenieure', 3, 'C', 6, 0),
    ('Einführung in die theoretische Regelungstechnik', 1, 'C', 7, 9),
    ('Einführung in die praktische Regelungstechnik', 1, 'C', 7, 5),
    ('Einführung in die theoretische Halbleitertechnik', 1, 'C', 8, 6);
    ('Einführung in die praktische Halbleitertechnik', 1, 'C', 8, 4);

INSERT INTO student_in_kurs (fk_kurs, fk_matnr, fk_zugriffsrechte)
VALUES
    (3, 262728, 'kwd'), (3, 293031, 'kwd'), (3, 323334, 'urw'), (3, 353637, 'urw'),
    (3, 383940, 'urw'), (3, 414243, 'urw'), (3, 444546, 'urw'), (3, 474849, 'urw'),
    (3, 505152, 'urw'), (3, 535455, 'urw'), (3, 565758, 'urw'), (3, 596061, 'urw'),
    (4, 616263, 'kwd'), (4, 789010, 'urw'), (4, 111213, 'urw'), (4, 123456, 'urw'),
    (4, 141516, 'urw'), (4, 171819, 'urw'), (4, 202122, 'urw'), (4, 232425, 'urw'),
    (2, 262728, 'urw'), (2, 293031, 'urw'), (2, 323334, 'urw'), (2, 353637, 'urw'),
    (2, 383940, 'kwd'), (2, 414243, 'urw'), (2, 444546, 'urw'), (2, 474849, 'urw'),
    (2, 505152, 'urw'), (2, 535455, 'urw'), (2, 565758, 'urw'), (2, 596061, 'urw'),
    (1, 262728, 'kwd'), (1, 293031, 'urw'), (1, 323334, 'urw'), (1, 353637, 'urw'),
    (1, 383940, 'kwd'), (1, 414243, 'urw'), (1, 444546, 'urw'), (1, 474849, 'urw'),
    (5, 223340, 'kwd'), (6, 223340, 'urw'), (7, 223340, 'urw'), (8, 223340, 'urw'),
    (9, 223341, 'urw'), (10, 223341, 'urw'), (5, 223341, 'urw'), (6, 223341, 'urw'),
    (7, 223342, 'urw'), (8, 223342, 'urw'), (9, 223342, 'urw'), (10, 223342, 'urw'),
    (5, 223343, 'urw'), (6, 223343, 'urw'), (7, 223343, 'urw'), (8, 223343, 'urw'),
    (9, 223344, 'urw'), (10, 223344, 'urw'), (5, 223344, 'urw'), (6, 223344, 'urw'),
    (7, 223345, 'urw'), (8, 223345, 'urw'), (9, 223345, 'urw'), (10, 223345, 'urw'),
    (5, 223346, 'urw'), (6, 223346, 'urw'), (7, 223346, 'urw'), (8, 223346, 'urw'),
    (9, 223347, 'urw'), (10, 223347, 'urw'), (5, 223347, 'urw'), (6, 223347, 'urw'),
    (7, 223348, 'urw'), (8, 223348, 'urw'), (9, 223348, 'urw'), (10, 223348, 'urw'),
    (5, 223349, 'urw'), (6, 223349, 'urw'), (7, 223349, 'urw'), (8, 223349, 'urw'),
    (5, 223350, 'urw'), (6, 223350, 'urw'), (7, 223350, 'urw'), (8, 223350, 'urw'),
    (9, 223351, 'urw'), (10, 223351, 'urw'), (5, 223351, 'urw'), (6, 223351, 'urw'),
    (7, 223352, 'urw'), (8, 223352, 'urw'), (9, 223352, 'urw'), (10, 223352, 'urw'),
    (5, 223353, 'urw'), (6, 223353, 'urw'), (7, 223353, 'urw'), (8, 223353, 'urw'),
    (9, 223354, 'urw'), (10, 223354, 'urw'), (5, 223354, 'urw'), (6, 223354, 'urw'),
    (7, 223355, 'urw'), (8, 223355, 'urw'), (9, 223355, 'urw'), (10, 223355, 'urw'),
    (5, 223356, 'urw'), (6, 223356, 'urw'), (7, 223356, 'urw'), (8, 223356, 'urw'),
    (9, 223357, 'urw'), (10, 223357, 'urw'), (5, 223357, 'urw'), (6, 223357, 'urw'),
    (7, 223358, 'urw'), (8, 223358, 'urw'), (9, 223358, 'urw'), (10, 223358, 'urw'),
    (7, 223359, 'urw'), (8, 223359, 'urw'), (9, 223359, 'urw'), (10, 223359, 'urw');

INSERT INTO dozent_in_kurs (fk_zugriffsrecht, fk_mail, fk_kurs)
VALUES
    ('grd', 'doz.super.man@hwr.de', 4),
    ('krd', 'doz.micky.mouse@hwr.de', 1),
    ('krw', 'doz.james.bond@hwr.de', 1),
    ('krd', 'doz.james.bond@hwr.de', 2),
    ('krd', 'doz.bugs.bunny@hwr.de', 3),
    ('krd', 'doz.dorothy.gale@hwr.de', 4)
    ('grd', 'doz.super.man@hwr.de', 5),
    ('krd', 'doz.micky.mouse@hwr.de', 6),
    ('krw', 'doz.james.bond@hwr.de', 7),
    ('krd', 'doz.james.bond@hwr.de', 8),
    ('krd', 'doz.bugs.bunny@hwr.de', 9),
    ('krd', 'doz.dorothy.gale@hwr.de', 10);

INSERT INTO leistungstyp (bezeichnung)
VALUES
    ('Klausur'),
    ('Arbeitsblatt'),
    ('Quiz'),
    ('Vortrag'),
    ('Projektarbeit');

INSERT INTO leistung_template (fk_leistungstyp, latedays, gewichtung, teiler)
VALUES
    ('Klausur',         0,  0.60,  1),
    ('Arbeitsblatt',    3,  0.15,  3),
    ('Quiz',            0,  0.05,  9),
    ('Projektarbeit',   3,  0.20,  1),
    ('Klausur',         0,  0.80,  1),
    ('Quiz',            0,  0.20, 20),
    ('Klausur',         0,  1.00,  1),
    ('Arbeitsblatt',    2,  0.40,  4),
    ('Vortrag',         0,  0.60,  2),
    ('Projektarbeit',   7,  1.00,  1);

INSERT INTO abgabe_in_kurs (frist, fk_leistung_template, fk_kurs, teamarbeit_max_erlaubt)
VALUES
    (STR_TO_DATE('01.10.21','%d.%m.%y'), 2, 1, 3),
    (STR_TO_DATE('01.11.21','%d.%m.%y'), 2, 1, 3),
    (STR_TO_DATE('01.12.21','%d.%m.%y'), 2, 1, 3),
    (STR_TO_DATE('10.12.21','%d.%m.%y'), 1, 1, 1),
    (STR_TO_DATE('01.10.21','%d.%m.%y'), 3, 1, 1),
    (STR_TO_DATE('05.10.21','%d.%m.%y'), 3, 1, 1),
    (STR_TO_DATE('12.10.21','%d.%m.%y'), 3, 1, 1),
    (STR_TO_DATE('20.10.21','%d.%m.%y'), 3, 1, 1),
    (STR_TO_DATE('28.10.21','%d.%m.%y'), 3, 1, 1),
    (STR_TO_DATE('10.11.21','%d.%m.%y'), 3, 1, 1),
    (STR_TO_DATE('18.11.21','%d.%m.%y'), 3, 1, 1),
    (STR_TO_DATE('30.11.21','%d.%m.%y'), 3, 1, 1),
    (STR_TO_DATE('05.12.21','%d.%m.%y'), 3, 1, 1),
    (STR_TO_DATE('29.11.21','%d.%m.%y'), 4, 1, 6),
    (STR_TO_DATE('01.12.21','%d.%m.%y'), 5, 2, 1),
    (STR_TO_DATE('01.10.21','%d.%m.%y'), 6, 2, 1),
    (STR_TO_DATE('05.10.21','%d.%m.%y'), 6, 2, 1),
    (STR_TO_DATE('07.10.21','%d.%m.%y'), 6, 2, 1),
    (STR_TO_DATE('10.10.21','%d.%m.%y'), 6, 2, 1),
    (STR_TO_DATE('12.10.21','%d.%m.%y'), 6, 2, 1),
    (STR_TO_DATE('15.10.21','%d.%m.%y'), 6, 2, 1),
    (STR_TO_DATE('20.10.21','%d.%m.%y'), 6, 2, 1),
    (STR_TO_DATE('24.10.21','%d.%m.%y'), 6, 2, 1),
    (STR_TO_DATE('28.10.21','%d.%m.%y'), 6, 2, 1),
    (STR_TO_DATE('10.11.21','%d.%m.%y'), 6, 2, 1),
    (STR_TO_DATE('14.11.21','%d.%m.%y'), 6, 2, 1),
    (STR_TO_DATE('18.11.21','%d.%m.%y'), 6, 2, 1),
    (STR_TO_DATE('18.11.21','%d.%m.%y'), 6, 2, 1),
    (STR_TO_DATE('18.11.21','%d.%m.%y'), 6, 2, 1),
    (STR_TO_DATE('25.11.21','%d.%m.%y'), 6, 2, 1),
    (STR_TO_DATE('28.11.21','%d.%m.%y'), 6, 2, 1),
    (STR_TO_DATE('30.11.21','%d.%m.%y'), 6, 2, 1),
    (STR_TO_DATE('05.12.21','%d.%m.%y'), 6, 2, 1),
    (STR_TO_DATE('05.12.21','%d.%m.%y'), 6, 2, 1),
    (STR_TO_DATE('01.11.21','%d.%m.%y'), 4, 3, 4),
    (STR_TO_DATE('01.12.21','%d.%m.%y'), 5, 3, 1),
    (STR_TO_DATE('01.10.21','%d.%m.%y'), 1, 5, 3),
    (STR_TO_DATE('01.11.21','%d.%m.%y'), 2, 5, 3),
    (STR_TO_DATE('01.12.21','%d.%m.%y'), 3, 5, 3),
    (STR_TO_DATE('10.12.21','%d.%m.%y'), 4, 5, 1),
    (STR_TO_DATE('01.10.21','%d.%m.%y'), 5, 5, 1),
    (STR_TO_DATE('05.10.21','%d.%m.%y'), 1, 5, 1),
    (STR_TO_DATE('12.10.21','%d.%m.%y'), 2, 5, 1),
    (STR_TO_DATE('20.10.21','%d.%m.%y'), 3, 6, 1),
    (STR_TO_DATE('28.10.21','%d.%m.%y'), 4, 6, 1),
    (STR_TO_DATE('10.11.21','%d.%m.%y'), 1, 6, 1),
    (STR_TO_DATE('18.11.21','%d.%m.%y'), 2, 6, 1),
    (STR_TO_DATE('30.11.21','%d.%m.%y'), 3, 6, 1),
    (STR_TO_DATE('05.12.21','%d.%m.%y'), 4, 6, 1),
    (STR_TO_DATE('29.11.21','%d.%m.%y'), 1, 7, 6),
    (STR_TO_DATE('01.12.21','%d.%m.%y'), 2, 7, 1),
    (STR_TO_DATE('01.10.21','%d.%m.%y'), 3, 7, 1),
    (STR_TO_DATE('05.10.21','%d.%m.%y'), 4, 7, 1),
    (STR_TO_DATE('07.10.21','%d.%m.%y'), 1, 7, 1),
    (STR_TO_DATE('10.10.21','%d.%m.%y'), 2, 7, 1),
    (STR_TO_DATE('12.10.21','%d.%m.%y'), 3, 7, 1),
    (STR_TO_DATE('15.10.21','%d.%m.%y'), 4, 8, 1),
    (STR_TO_DATE('20.10.21','%d.%m.%y'), 5, 8, 1),
    (STR_TO_DATE('24.10.21','%d.%m.%y'), 1, 8, 1),
    (STR_TO_DATE('28.10.21','%d.%m.%y'), 2, 8, 1),
    (STR_TO_DATE('10.11.21','%d.%m.%y'), 3, 8, 1),
    (STR_TO_DATE('14.11.21','%d.%m.%y'), 4, 8, 1),
    (STR_TO_DATE('18.11.21','%d.%m.%y'), 1, 8, 1),
    (STR_TO_DATE('18.11.21','%d.%m.%y'), 2, 9, 1),
    (STR_TO_DATE('18.11.21','%d.%m.%y'), 3, 9, 1),
    (STR_TO_DATE('25.11.21','%d.%m.%y'), 1, 9, 1),
    (STR_TO_DATE('28.11.21','%d.%m.%y'), 2, 9, 1),
    (STR_TO_DATE('30.11.21','%d.%m.%y'), 3, 9, 1),
    (STR_TO_DATE('05.12.21','%d.%m.%y'), 4, 9, 1),
    (STR_TO_DATE('05.12.21','%d.%m.%y'), 7, 9, 1),
    (STR_TO_DATE('01.11.21','%d.%m.%y'), 8, 10, 4),
    (STR_TO_DATE('01.12.21','%d.%m.%y'), 3, 10, 1),
    (STR_TO_DATE('01.11.21','%d.%m.%y'), 4, 10, 4),
    (STR_TO_DATE('01.12.21','%d.%m.%y'), 10, 10, 1);

INSERT INTO aktive_mitarbeit (zeitpunkt, nachweis, bezeichnung)
VALUES
    (STR_TO_DATE('14.11.21 11:20','%d.%m.%y %H:%i'), 'www.moodle-forum-link.de', 'Hilfe für Gruppe Alteheim bei ÜB 2'),
    (STR_TO_DATE('18.11.21 04:03','%d.%m.%y %H:%i'), 'www.moodle-forum-link.de', 'Hilfe für Gruppe Alteheim bei ÜB 2'),
    (STR_TO_DATE('02.12.21 10:30','%d.%m.%y %H:%i'), 'Vortrag Präsenz', 'Vorstellung Gruppenstatus'),
    (STR_TO_DATE('18.12.21 22:22','%d.%m.%y %H:%i'), 'www.one.google.com/ddhfhrg56647474hfhghfhfhfhf7939857345hwfkjsdf', 'Zusatzaufgabe ERM');
    (STR_TO_DATE('15.11.21 11:20','%d.%m.%y %H:%i'), 'www.moodle-forum-link.de', 'Hilfe für Gruppe Alteheim bei ÜB 2'),
    (STR_TO_DATE('20.11.21 04:03','%d.%m.%y %H:%i'), 'www.moodle-forum-link.de', 'Hilfe für Gruppe Alteheim bei ÜB 2'),
    (STR_TO_DATE('21.12.21 10:30','%d.%m.%y %H:%i'), 'Vortrag Präsenz', 'Vorstellung Gruppenstatus'),
    (STR_TO_DATE('18.10.21 22:22','%d.%m.%y %H:%i'), 'www.one.google.com/ddhfhrg56647474hfhghfhfhfhf7939857345hwfkjsdf', 'Zusatzaufgabe ERM');

INSERT INTO aktive_mitarbeit_in_kurs (fk_matnr, fk_kurs, fk_aktive_mitarbeit)
VALUES
    (123456, 1, 1), (789010, 1, 1), (789010, 1, 2),
    (111213, 2, 3), (141516, 2, 3), (171819, 2, 3), 
    (171819, 2, 4), (223340, 5, 3), (223340, 7, 6), 
    (223340, 6, 5), (223345, 7, 4), (223345, 8, 2), 
    (223345, 9, 5), (223357, 10, 6), (141516, 4, 5),
    (262728, 3, 4);

INSERT INTO leistung (fk_matnr, wert, fk_abgabe_in_kurs, abgabe_ist, frist_verlaengerung_tage, fk_team, festgesetzt)
VALUES
    (123456, 1.0, 1, STR_TO_DATE('02.10.21 11:11','%d.%m.%y %H:%i'), 0, 1, false),
    (123456, 2.0, 2, STR_TO_DATE('01.11.21 23:59','%d.%m.%y %H:%i'), 0, 1, false),
    (123456, 1.5, 3, STR_TO_DATE('01.12.21 00:01','%d.%m.%y %H:%i'), 1, 1, false),
    (123456, 3.0, 35, STR_TO_DATE('01.11.21 00:01','%d.%m.%y %H:%i'), 0, null, false),
    (123456, 3.7, 36, STR_TO_DATE('01.12.21 00:01','%d.%m.%y %H:%i'), 0, null, false),
    (789010, 2.0, 1, STR_TO_DATE('01.10.21 11:11','%d.%m.%y %H:%i'), 0, 1, false),
    (789010, 2.3, 2, STR_TO_DATE('02.11.21 23:59','%d.%m.%y %H:%i'), 0, 1, false),
    (789010, 1.0, 3, STR_TO_DATE('01.12.21 00:01','%d.%m.%y %H:%i'), 1, 1, false),
    (789010, 2.0, 35, STR_TO_DATE('01.11.21 00:01','%d.%m.%y %H:%i'), 0, null, false),
    (789010, 1.7, 36, STR_TO_DATE('01.12.21 00:01','%d.%m.%y %H:%i'), 0, null, false),
    





INSERT INTO `account` (`fk_mail`, `password_hash`) VALUES
('doz.bugs.bunny@hwr.de', 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'),
('doz.dorothy.gale@hwr.de', 'ca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb'),
('doz.james.bond@hwr.de', '70ba33708cbfb103f1a8e34afef333ba7dc021022b2d9aaa583aabb8058d8d67'),
('doz.micky.mouse@hwr.de', 'c7d3776f235966314be6e72521d2802dca96ed8d5c0d89b9962360b9f13a0ea7'),
('doz.super.man@hwr.de', '7031a423aa40a32f119b2b17e4278cbf2293fc036061c24deb1c7ad1d8ffcc64'),
('stud.bat.man@hwr.de', '4dcc41d82b3d729ec999955d61de26a0e7b0badfbcc10339b0beb64a06909fca'),
('stud.black.widow@hwr.de', '494fc4689701205276e443ef15b26cbb3675cf74ea48f115dc603ea608c4d12f'),
('stud.captain.america@hwr.de', '6046d43a0ee25eaa163038a48edc36c42544e842765a5de1adc9c0cdc578b3ce'),
('stud.cosmo.cramer@hwr.de', 'c0f3496fca22f6ba3274c0c1d3bb85b95998ee99d641409d38e0ceb5f36c87e8'),
('stud.darth.vader@hwr.de', '2dfd7f53670d371c180b3954d1b8dfbdbd47ccebaac217bea41c1eb4a1b2b573'),
('stud.ellen.ripley@hwr.de', '4056fc1d04987627c592920e0660f21f0ed0c8f573d465fb627b5f251230a79d'),
('stud.fauler.sack@hwr.de', 'da586a30006b4d7b675d5a2c0863885a0266994b1c3d9521fb9c094e3fe6eb12'),
('stud.greta.thunberg@hwr.de', '0a84f6b57c47ae9337ab98a46affd05a9edea3abb1ad14b0b633a8674a70d37d'),
('stud.hannibal.lector@hwr.de', 'c64c8432dd4a8ca28dd7fc334f400808043a55b8b5c267fcd7028236a687d297'),
('stud.indiana.jones@hwr.de', '66ecfd2c0f7d01a0a00e534a80ecb1de41cecec69ef5e3eb8097407b03e1293f'),
('stud.marge.simpson@hwr.de', 'c734ae4bc04e82d134ebb249086fea417c2b3f00a8ab10bc7df1bb5cbc4dd281'),
('stud.mary.poppins@hwr.de', '6bf1250000d56d0678a93c8c5f8f9c75b1604ca11e0eae93f9bd6e3aabaee27c'),
('stud.mutti@hwr.de', '630ba8cabb188f1808000924f1bad2e14d8ee79b790d772b75344d7dd7cfb1ca'),
('stud.princess.leia@hwr.de', '2baeb3f6577a248a57cd702509eab0f578a2df91dbf3c2539d79660827410fc6'),
('stud.rocky.balboa@hwr.de', '5135c296df5394f847d0215aac988dafde80ef596400fd3cfba8e5a8f3322bb8'),
('stud.scarlett.ohara@hwr.de', 'baf2d6d8117a387896a972bdc0d7f2f08531bc61eaea8236712a8fd2dd02d090'),
('stud.super.streber@hwr.de', '29024edc04c6d467012dac2f156771d2f01453c6d33415cbff157fa7955db832'),
('stud.the.joker@hwr.de', '17e492be914fecdf07c268c9290793fbdb1826436ce21c2221eff4b6dc51b891'),
('stud.tony.montana@hwr.de', '74f476e0d8f671ca46fe6be4d7b71327092b6af0e81572d19c1ddfec70da7b14'),
('stud.vito.corleone@hwr.de', 'aec95a56259c02c3719a4a10872c054111e98b834b651a68c99e1f8a0ea7d714'),
('stud.über.schätzt@hwr.de', 'ddafe91ee665547f9694ae027583a6cd7d2c1c72883711816ecd2eb11ebcb8c5');



INSERT INTO `anfrageaufnahme` (`fk_kurs`, `fk_matnr`) VALUES
(5, 565758),
(5, 123456),
(5, 596061),
(5, 596061),
(5, 262728),
(5, 383940);



