CREATE DATABASE IF NOT EXISTS performancetracker;
USE performancetracker;

create table performancetracker.aktive_mitarbeit
(
	id int auto_increment
		primary key,
	zeitpunkt datetime not null,
	nachweis char(255) not null,
	bezeichnung char(255) null
);

create table performancetracker.jahrgang
(
	id int auto_increment
		primary key,
	jahr char(2) not null,
	sem_so_wi char not null
);

create table performancetracker.kurs_buchstabe
(
	wert char not null
		primary key
);

create table performancetracker.leistungstyp
(
	bezeichnung char(30) not null
		primary key
);

create table performancetracker.leistung_template
(
	id int auto_increment
		primary key,
	fk_leistungstyp char(30) not null,
	latedays smallint null,
	gewichtung decimal(3,2) null,
	teiler smallint not null,
	constraint leistung_template_leistungstyp_bezeichnung_fk
		foreign key (fk_leistungstyp) references performancetracker.leistungstyp (bezeichnung) on delete cascade on update cascade
);

create table performancetracker.matrikelnummer
(
	matnr int not null
		primary key
);

create table performancetracker.modul
(
	id int auto_increment
		primary key,
	fachbereich char(10) not null,
	modulnummer int(3) not null,
	beschreibung char(255) null
);

create table performancetracker.kurs
(
	id int auto_increment
		primary key,
	beschreibung char(200) null,
	fk_jahrgang int not null,
	fk_kurs_buchstabe char not null,
	fk_modul int not null,
	latedays_verfuegbar smallint null,
	constraint kurs_ibfk_1
		foreign key (fk_jahrgang) references performancetracker.jahrgang (id) on delete cascade on update cascade,
	constraint kurs_ibfk_2
		foreign key (fk_kurs_buchstabe) references performancetracker.kurs_buchstabe (wert) on delete cascade on update cascade,
	constraint kurs_ibfk_3
		foreign key (fk_modul) references performancetracker.modul (id) on delete cascade on update cascade
);

create table performancetracker.abgabe_in_kurs
(
	id int auto_increment
		primary key,
	frist datetime not null,
	teamarbeit_max_erlaubt smallint null,
	fk_leistung_template int not null,
	fk_kurs int not null,
	constraint abgabe_kurs_id_fk
		foreign key (fk_kurs) references performancetracker.kurs (id) on delete cascade on update cascade,
	constraint abgabe_leistung_template_id_fk
		foreign key (fk_leistung_template) references performancetracker.leistung_template (id) on delete cascade on update cascade
);

create table performancetracker.aktive_mitarbeit_in_kurs
(
	fk_matnr int not null,
	fk_kurs int not null,
	fk_aktive_mitarbeit int not null,
	constraint aktive_mitarbeit_in_kurs_ibfk_1
		foreign key (fk_matnr) references performancetracker.matrikelnummer (matnr) on delete cascade on update cascade,
	constraint aktive_mitarbeit_in_kurs_ibfk_2
		foreign key (fk_kurs) references performancetracker.kurs (id) on delete cascade on update cascade,
	constraint aktive_mitarbeit_in_kurs_ibfk_3
		foreign key (fk_aktive_mitarbeit) references performancetracker.aktive_mitarbeit (id) on delete cascade on update cascade
);

create index aktive_mitarbeit_id
	on performancetracker.aktive_mitarbeit_in_kurs (fk_aktive_mitarbeit);

create index kurs_id
	on performancetracker.aktive_mitarbeit_in_kurs (fk_kurs);

create index student_matnr
	on performancetracker.aktive_mitarbeit_in_kurs (fk_matnr);

create table performancetracker.anfrageaufnahme
(
	fk_kurs int not null,
	fk_matnr int not null,
	constraint anfrageaufnahme_ibfk_1
		foreign key (fk_kurs) references performancetracker.kurs (id) on delete cascade on update cascade,
	constraint anfrageaufnahme_ibfk_2
		foreign key (fk_matnr) references performancetracker.matrikelnummer (matnr) on delete cascade on update cascade
);

create index kurs_id
	on performancetracker.anfrageaufnahme (fk_kurs);

create index student_matnr
	on performancetracker.anfrageaufnahme (fk_matnr);

create index jahrgangId
	on performancetracker.kurs (fk_jahrgang);

create index kursBuchstabeId
	on performancetracker.kurs (fk_kurs_buchstabe);

create index modulId
	on performancetracker.kurs (fk_modul);

create table performancetracker.team
(
	id int auto_increment
		primary key,
	max_mitglieder smallint default 3 not null,
	kommentar char(255) null
);

create table performancetracker.leistung
(
	id int auto_increment
		primary key,
	fk_matnr int not null,
	fk_abgabe_in_kurs int not null,
	fk_team int null,
	wert decimal(3,2) not null,
	abgabe_ist datetime null,
	frist_verlaengerung_tage smallint null,
	constraint leistung_team_id_fk
		foreign key (fk_team) references performancetracker.team (id) on update cascade,
	constraint leistung_abgabe_id_fk
		foreign key (fk_abgabe_in_kurs) references performancetracker.abgabe_in_kurs (id) on delete cascade on update cascade,
	constraint leistung_matrikelnummer_von_student_matrikelnummer_fk
		foreign key (fk_matnr) references performancetracker.matrikelnummer (matnr) on delete cascade on update cascade
);

create table performancetracker.person
(
	mail char(50) not null
		primary key,
	vorname char(30) null,
	nachname char(30) not null
);

create table performancetracker.account
(
	fk_mail char(50) not null,
	password_hash char(255) not null,
	constraint account_person_mail_fk
		foreign key (fk_mail) references performancetracker.person (mail)
);

create table performancetracker.dozent
(
	fk_person char(50) not null
		primary key,
	constraint dozent_person_mail_fk
		foreign key (fk_person) references performancetracker.person (mail) on delete cascade on update cascade
);

create table performancetracker.student
(
	fk_mail char(50) not null
		primary key,
	studiengang char(30) not null,
	fk_matnr int not null,
	constraint student_matrikelnummer_von_student_matrikelnummer_fk
		foreign key (fk_matnr) references performancetracker.matrikelnummer (matnr) on delete cascade on update cascade,
	constraint student_person_mail_fk
		foreign key (fk_mail) references performancetracker.person (mail) on delete cascade on update cascade
);

create table performancetracker.student_in_team
(
	fk_matnr int not null,
	fk_team int not null,
	constraint student_in_team_matrikelnummer_von_student_matrikelnummer_fk
		foreign key (fk_matnr) references performancetracker.matrikelnummer (matnr) on delete cascade on update cascade,
	constraint student_in_team_team_id_fk
		foreign key (fk_team) references performancetracker.team (id) on delete cascade on update cascade
);

create table performancetracker.zugriffsrecht
(
	abkuerzung char(3) not null,
	beschreibung char(255) null,
	constraint rollen_rechte_uindex
		unique (abkuerzung)
);

alter table performancetracker.zugriffsrecht
	add primary key (abkuerzung);

create table performancetracker.dozent_in_kurs
(
	fk_zugriffsrecht char(3) not null,
	fk_mail char(50) not null,
	fk_kurs int not null,
	constraint dozent_in_kurs_dozent_fk_mail_fk
		foreign key (fk_mail) references performancetracker.dozent (fk_person) on delete cascade on update cascade,
	constraint dozent_in_kurs_kurs_id_fk
		foreign key (fk_kurs) references performancetracker.kurs (id) on delete cascade on update cascade,
	constraint dozent_in_kurs_zugriffsrecht_abkuerzung_fk
		foreign key (fk_zugriffsrecht) references performancetracker.zugriffsrecht (abkuerzung) on update cascade
);

create table performancetracker.student_in_kurs
(
	fk_kurs int null,
	fk_matnr int null,
	fk_zugriffsrechte char(3) null,
	constraint student_in_kurs_kurs_id_fk
		foreign key (fk_kurs) references performancetracker.kurs (id) on delete cascade on update cascade,
	constraint student_in_kurs_matrikelnummer_von_student_matrikelnummer_fk
		foreign key (fk_matnr) references performancetracker.matrikelnummer (matnr) on delete cascade on update cascade,
	constraint student_in_kurs_zugriffsrecht_abkuerzung_fk
		foreign key (fk_zugriffsrechte) references performancetracker.zugriffsrecht (abkuerzung) on update cascade
);

