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
    ('WI'), ('Angela'), ('BWL');

INSERT INTO modul (fk_fachrichtung, modulnummer, beschreibung)
VALUES
    ('WI', 103, null),
    ('WI', 602, 'Datenbanken'),
    ('WI', 301, 'Oldschool Java'),
    ('BWL', 10, 'Die Kunst, Leute zu überreden, Dinge zu kaufen, die sie nicht brauchen (Marketing)'),
    ('BWL', 12, 'Pseudowissenschaft für junge Gründer');

INSERT INTO team (max_mitglieder, kommentar)
VALUES
    (3, null),
    (3, 'Altenheim :-) '),
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
    ('stud.über.schätzt@hwr.de', 'Über', 'Schätzt');

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
    ('stud.über.schätzt@hwr.de', 'BWL', 232425);

INSERT INTO student_in_team (fk_matnr, fk_team)
VALUES
    (123456, 1), (789010, 1), (111213, 1), (141516, 2), (171819, 2),
    (123456, 2), (232425, 3), (262728, 3), (293031, 3), (171819, 3),
    (123456, 3), (383940, 3), (414243, 4), (141516, 4);

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
    ('Softwarearchitektur', 3, 'C', 3, 6);

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
    (1, 505152, 'kwd'), (1, 535455, 'urw'), (1, 565758, 'urw'), (1, 596061, 'urw');

INSERT INTO dozent_in_kurs (fk_zugriffsrecht, fk_mail, fk_kurs)
VALUES
    ('grd', 'doz.super.man@hwr.de', 4),
    ('krd', 'doz.micky.mouse@hwr.de', 1),
    ('krw', 'doz.james.bond@hwr.de', 1),
    ('krd', 'doz.james.bond@hwr.de', 2),
    ('krd', 'doz.bugs.bunny@hwr.de', 3),
    ('krd', 'doz.dorothy.gale@hwr.de', 4);

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
    (STR_TO_DATE('01.12.21','%d.%m.%y'), 5, 3, 1);

INSERT INTO aktive_mitarbeit (zeitpunkt, nachweis, bezeichnung)
VALUES
    (STR_TO_DATE('14.11.21 11:20','%d.%m.%y %H:%i'), 'www.moodle-forum-link.de', 'Hilfe für Gruppe Alteheim bei ÜB 2'),
    (STR_TO_DATE('18.11.21 04:03','%d.%m.%y %H:%i'), 'www.moodle-forum-link.de', 'Hilfe für Gruppe Alteheim bei ÜB 2'),
    (STR_TO_DATE('02.12.21 10:30','%d.%m.%y %H:%i'), 'Vortrag Präsenz', 'Vorstellung Gruppenstatus'),
    (STR_TO_DATE('18.12.21 22:22','%d.%m.%y %H:%i'), 'www.one.google.com/ddhfhrg56647474hfhghfhfhfhf7939857345hwfkjsdf', 'Zusatzaufgabe ERM');

INSERT INTO aktive_mitarbeit_in_kurs (fk_matnr, fk_kurs, fk_aktive_mitarbeit)
VALUES
    (123456, 1, 1), (789010, 1, 1), (789010, 1, 2),
    (111213, 2, 3), (141516, 2, 3), (171819, 2, 3), (171819, 2, 4);

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
    (789010, 1.7, 36, STR_TO_DATE('01.12.21 00:01','%d.%m.%y %H:%i'), 0, null, false);





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



