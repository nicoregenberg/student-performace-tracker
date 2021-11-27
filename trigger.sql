DROP TRIGGER IF EXISTS
    `check_Student_in_Kurs_before_insert_on_leistung`;
DELIMITER &&
CREATE TRIGGER check_Student_in_Kurs_before_insert_on_leistung BEFORE INSERT ON leistung 
FOR EACH ROW 
Begin
	DECLARE kurs integer;
    DECLARE count_kurse integer;
    DECLARE count_team integer;
    DECLARE max_team_grosse integer;
    DECLARE team_grosse integer;
    DECLARE count_leistung integer;
    
    
    ##Kursprüfung
    set @kurs = (SELECT fk_kurs FROM abgabe_in_kurs WHERE abgabe_in_kurs.id = NEW.fk_abgabe_in_kurs);
    set @count_kurse  = (SELECT COUNT(student_in_kurs.fk_kurs) FROM student_in_kurs WHERE student_in_kurs.fk_kurs = @kurs AND student_in_kurs.fk_matnr = NEW.fk_matnr);
    set @count_kurse = IFNULL(@count_kurse, 0); 
    
    if (@count_kurse<1) then
		SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'Fehler: Der Student ist nicht in dem Kurs, für den Er versucht eine Leistung einzutragen!';
	end if;
    
    
    ##Student in Team Prüfung
    IF (NEW.fk_team IS NOT Null) then
        set @count_team = (SELECT COUNT(student_in_team.fk_team) FROM student_in_team WHERE student_in_team.fk_team = NEW.fk_team AND student_in_team.fk_matnr = NEW.fk_matnr);
        set @count_team = IFNULL(@count_team, 0);

        if (@count_team < 1) then
			SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'Fehler: Der Student ist nicht in dem Team, für das Er versucht eine Leistung einzutragen!';
        end if;
    end if;
    
    
    ##Teamgrößen Prüfung
    set @max_team_grosse = (SELECT abgabe_in_kurs.teamarbeit_max_erlaubt From abgabe_in_kurs WHERE abgabe_in_kurs.id = NEW.fk_abgabe_in_kurs);
    set @max_team_grosse = IFNULL(@max_team_grosse, 0);
    set @team_grosse = (SELECT COUNT(student_in_team.fk_matnr) FROM student_in_team WHERE student_in_team.fk_team = NEW.fk_team);
    set @team_grosse = IFNULL(@team_grosse, 0);
    
    if (@team_grosse > @max_team_grosse) then
		SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'Fehler: Das angegebene Team ist für die Leistung zu groß!';
    end if;
    
    
    ##Leistungsdopplung prüfen
    set @count_leistung = (SELECT COUNT(leistung.fk_matnr) FROM leistung WHERE leistung.fk_matnr = NEW.fk_matnr AND leistung.fk_abgabe_in_kurs = NEW.fk_abgabe_in_kurs);
    set @count_leistung = IFNULL(@count_leistung, 0);
    
    if (@count_leistung > 0) THEN
    	SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'Fehler: Die Abgabe in Kurs wurde bereits für den Studenten eingetragen)';
    end if; 
End&&
