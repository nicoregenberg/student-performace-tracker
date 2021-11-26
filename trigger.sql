DROP TRIGGER IF EXISTS
    `check_Student_in_Kurs_before_insert_on_leistung`;
DELIMITER &&
CREATE TRIGGER check_Student_in_Kurs_before_insert_on_leistung BEFORE INSERT ON leistung 
FOR EACH ROW 
Begin
	DECLARE kursa integer;
    DECLARE count_kurse integer;
    
    set @kursa = (SELECT fk_kurs FROM abgabe_in_kurs WHERE abgabe_in_kurs.id = NEW.fk_abgabe_in_kurs);
  
    set @count_kurse  = (SELECT SUM(student_in_kurs.fk_kurs) FROM student_in_kurs WHERE student_in_kurs.fk_kurs = @kursa AND student_in_kurs.fk_matnr = NEW.fk_matnr);
    set @count_kurse = IFNULL(@count_kurse, 0); 
    
    if (@count_kurse<1) then
		SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'Fehler: Der Student ist nicht in dem Kurs, für den Er versucht eine Leistung einzutragen!';
	end if;
End&&