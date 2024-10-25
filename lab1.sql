-- zad 1

CREATE TYPE Samochod AS OBJECT (
    marka VARCHAR2(20),
    model VARCHAR2(20),
    kilometry NUMBER,
    data_produkcji DATE,
    cena NUMBER(10, 2)
);

DESC Samochod;

CREATE TABLE Samochody OF Samochod;

INSERT INTO Samochody VALUES
(
    NEW Samochod('FIAT', 'BRAVA', 6000, TO_DATE('1999-11-30', 'YYYY-MM-DD'), 25000)
);

INSERT INTO Samochody VALUES
(
    NEW Samochod('FORD', 'MONDEO', 8000, TO_DATE('1997-05-10', 'YYYY-MM-DD'), 45000)
);

INSERT INTO Samochody VALUES
(
    NEW Samochod('MAZDA', '323', 12000, TO_DATE('2000-09-22', 'YYYY-MM-DD'), 52000)
);

SELECT * FROM Samochody;

-- zad 2

CREATE TABLE Wlasciciele (
    imie VARCHAR2(100),
    nazwisko VARCHAR2(100),
    auto SAMOCHOD
);

INSERT INTO Wlasciciele VALUES('Jan', 'Kowalski', new Samochod('FIAT', 'SEICENTO', 6000, '1999-11-30', 25000));
INSERT INTO Wlasciciele VALUES('Adam', 'Nowak', new Samochod('OPEL', 'ASTRA', 6000, '1999-11-30', 25000));

SELECT * FROM Wlasciciele;

-- zad 3

ALTER TYPE Samochod ADD MEMBER FUNCTION wartosc RETURN NUMBER CASCADE;

CREATE OR REPLACE TYPE BODY Samochod IS
    MEMBER FUNCTION wartosc RETURN NUMBER IS
    BEGIN
        RETURN ROUND(cena * POWER(0.9, (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM data_produkcji))), 2);
    END wartosc;
END;

SELECT s.marka, s.cena, s.wartosc() FROM SAMOCHODY s;

-- zad 4

ALTER TYPE Samochod ADD MAP MEMBER FUNCTION value RETURN NUMBER CASCADE INCLUDING TABLE DATA;


CREATE OR REPLACE TYPE BODY Samochod IS
    MEMBER FUNCTION wartosc RETURN NUMBER IS
    BEGIN
        RETURN ROUND(cena * POWER(0.9, (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM data_produkcji))), 2);
    END wartosc;
    MAP MEMBER FUNCTION value RETURN NUMBER IS
    BEGIN
        RETURN -((EXTRACT (YEAR FROM CURRENT_DATE) - EXTRACT (YEAR FROM DATA_PRODUKCJI))*10000 + KILOMETRY);
    END value;
END;

SELECT * FROM SAMOCHODY s ORDER BY VALUE(s);


-- zad 5

CREATE OR REPLACE TYPE Wlasciciel AS OBJECT
(
    imie VARCHAR(100),
    nazwisko VARCHAR(100),
    auto REF SAMOCHOD
);

CREATE TABLE WlascicieleSamochodow OF Wlasciciel;
ALTER TABLE WlascicieleSamochodow ADD SCOPE FOR(auto) IS SAMOCHODY;

INSERT INTO WlascicieleSamochodow VALUES (NEW Wlasciciel('Jan', 'Kowalski', null));

UPDATE WlascicieleSamochodow w SET w.auto = (select ref(s) FROM Samochody s WHERE s.marka = 'FIAT');


SELECT 
    w.imie,
    w.nazwisko,
    DEREF(w.auto).marka AS marka,
    DEREF(w.auto).model AS model,
    DEREF(w.auto).kilometry AS liczba_kilometrow,
    DEREF(w.auto).data_produkcji AS data_produkcji,
    DEREF(w.auto).cena AS cena
FROM 
    WlascicieleSamochodow w;

-- zad 6

DECLARE
 TYPE t_przedmioty IS VARRAY(10) OF VARCHAR2(20);
 moje_przedmioty t_przedmioty := t_przedmioty('');
BEGIN
 moje_przedmioty(1) := 'MATEMATYKA';
 moje_przedmioty.EXTEND(9);
 FOR i IN 2..10 LOOP
 moje_przedmioty(i) := 'PRZEDMIOT_' || i;
 END LOOP;
 FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
 END LOOP;
 moje_przedmioty.TRIM(2);
 FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
 END LOOP;
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
 moje_przedmioty.EXTEND();
 moje_przedmioty(9) := 9;
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
 moje_przedmioty.DELETE();
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
END;

-- zad 7

DECLARE
TYPE ksiazki IS VARRAY(10) OF VARCHAR(100);
moje_ksiazki ksiazki := ksiazki('');
BEGIN
    moje_ksiazki(1) := 'KSIAZKA 1';
    moje_ksiazki.extend(2);
    
    moje_ksiazki(2) := 'KSIAZKA 2';
    moje_ksiazki(3) := 'KSIAZKA 3';
    
    FOR i IN moje_ksiazki.FIRST()..moje_ksiazki.LAST() LOOP
    DBMS_OUTPUT.PUT_LINE(moje_ksiazki(i));
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('----');
    
    moje_ksiazki.extend(3, 3);
    
    moje_ksiazki.trim(2);
    
    FOR i IN moje_ksiazki.FIRST()..moje_ksiazki.LAST() LOOP
    DBMS_OUTPUT.PUT_LINE(moje_ksiazki(i));
    END LOOP;

END;

-- zad 8

DECLARE
 TYPE t_wykladowcy IS TABLE OF VARCHAR2(20);
 moi_wykladowcy t_wykladowcy := t_wykladowcy();
BEGIN
 moi_wykladowcy.EXTEND(2);
 moi_wykladowcy(1) := 'MORZY';
 moi_wykladowcy(2) := 'WOJCIECHOWSKI';
 moi_wykladowcy.EXTEND(8);
 FOR i IN 3..10 LOOP
 moi_wykladowcy(i) := 'WYKLADOWCA_' || i;
 END LOOP;
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END LOOP;
 moi_wykladowcy.TRIM(2);
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END LOOP;
 moi_wykladowcy.DELETE(5,7);
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 IF moi_wykladowcy.EXISTS(i) THEN
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END IF;
 END LOOP;
 moi_wykladowcy(5) := 'ZAKRZEWICZ';
 moi_wykladowcy(6) := 'KROLIKOWSKI';
 moi_wykladowcy(7) := 'KOSZLAJDA';
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 IF moi_wykladowcy.EXISTS(i) THEN
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END IF;
 END LOOP;
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
END;

-- zad 9

DECLARE
    TYPE t_miesiace IS TABLE OF VARCHAR2(30);
    miesiace t_miesiace := t_miesiace();
BEGIN
    miesiace.extend(12);
    
    miesiace(1) := 'STYCZEŃ';
    miesiace(2) := 'LUTY';
    miesiace(3) := 'MARZEC';
    miesiace(4) := 'KWIECIEŃ';
    miesiace(5) := 'MAJ';
    miesiace(6) := 'CZERWIEC';
    miesiace(7) := 'LIPIEC';
    miesiace(8) := 'SIERPIEŃ';
    miesiace(9) := 'WRZESIEŃ';
    miesiace(10) := 'PAŹDZIERNIK';
    miesiace(11) := 'LISTOPAD';
    miesiace(12) := 'GRUDZIEŃ';
    
    FOR i IN miesiace.FIRST()..miesiace.LAST() LOOP
     IF miesiace.EXISTS(i) THEN
        DBMS_OUTPUT.PUT_LINE(miesiace(i));
     END IF;
     END LOOP;
    
    miesiace.DELETE(3,5);
    
    DBMS_OUTPUT.PUT_LINE('Po usunieciu');
    
    FOR i IN miesiace.FIRST()..miesiace.LAST() LOOP
     IF miesiace.EXISTS(i) THEN
        DBMS_OUTPUT.PUT_LINE(miesiace(i));
     END IF;
     END LOOP;
END;

-- zad 10

CREATE TYPE jezyki_obce AS VARRAY(10) OF VARCHAR2(20);
/
CREATE TYPE stypendium AS OBJECT (
 nazwa VARCHAR2(50),
 kraj VARCHAR2(30),
 jezyki jezyki_obce );
/
CREATE TABLE stypendia OF stypendium;
INSERT INTO stypendia VALUES
('SOKRATES','FRANCJA',jezyki_obce('ANGIELSKI','FRANCUSKI','NIEMIECKI'));
INSERT INTO stypendia VALUES
('ERASMUS','NIEMCY',jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI'));
SELECT * FROM stypendia;
SELECT s.jezyki FROM stypendia s;
UPDATE STYPENDIA
SET jezyki = jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI','FRANCUSKI')
WHERE nazwa = 'ERASMUS';
CREATE TYPE lista_egzaminow AS TABLE OF VARCHAR2(20);
/
CREATE TYPE semestr AS OBJECT (
 numer NUMBER,
 egzaminy lista_egzaminow );
/
CREATE TABLE semestry OF semestr
NESTED TABLE egzaminy STORE AS tab_egzaminy;
INSERT INTO semestry VALUES
(semestr(1,lista_egzaminow('MATEMATYKA','LOGIKA','ALGEBRA')));
INSERT INTO semestry VALUES
(semestr(2,lista_egzaminow('BAZY DANYCH','SYSTEMY OPERACYJNE')));
SELECT s.numer, e.*
FROM semestry s, TABLE(s.egzaminy) e;
SELECT e.*
FROM semestry s, TABLE ( s.egzaminy ) e;
SELECT * FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=1 );
INSERT INTO TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 )
VALUES ('METODY NUMERYCZNE');
UPDATE TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
SET e.column_value = 'SYSTEMY ROZPROSZONE'
WHERE e.column_value = 'SYSTEMY OPERACYJNE';
DELETE FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
WHERE e.column_value = 'BAZY DANYCH';

-- zad 11

--CREATE TYPE produkt AS OBJECT {
--    nazwa VARCHAR(30);
--}

CREATE TYPE lista_produktow AS TABLE OF VARCHAR(30);
CREATE TYPE zakup AS OBJECT(
    data DATE,
    koszyk_produktow lista_produktow
);

CREATE TABLE zakupy OF zakup
NESTED TABLE koszyk_produktow STORE AS tab_koszyk_produktow;

INSERT INTO zakupy VALUES(zakup(DATE '2020-01-02', lista_produktow('JAJKA', 'CHLEB', 'MASLO')));

INSERT INTO zakupy VALUES(zakup(DATE '2023-01-02', lista_produktow('PAPIER TOALETOWY', 'BULKI', 'PASTA DO ZEBOW')));

SELECT * FROM zakupy;

DELETE FROM TABLE (SELECT z.koszyk_produktow FROM zakupy z) p WHERE p.column_value = 'JAJKA';

DELETE FROM zakupy z WHERE (SELECT * FROM TABLE(z.koszyk_produktow) p WHERE p.column_value = 'JAJKA') IS NOT NULL;

--zad 12

CREATE TYPE instrument AS OBJECT (
 nazwa VARCHAR2(20),
 dzwiek VARCHAR2(20),
 MEMBER FUNCTION graj RETURN VARCHAR2 ) NOT FINAL;
CREATE TYPE BODY instrument AS
 MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN dzwiek;
 END;
END;
/
CREATE TYPE instrument_dety UNDER instrument (
 material VARCHAR2(20),
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2,
 MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 );
CREATE OR REPLACE TYPE BODY instrument_dety AS
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN 'dmucham: '||dzwiek;
 END;
 MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 IS
 BEGIN
 RETURN glosnosc||':'||dzwiek;
 END;
END;
/
CREATE TYPE instrument_klawiszowy UNDER instrument (
 producent VARCHAR2(20),
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 );
CREATE OR REPLACE TYPE BODY instrument_klawiszowy AS
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN 'stukam w klawisze: '||dzwiek;
 END;
END;
/
DECLARE
 tamburyn instrument := instrument('tamburyn','brzdek-brzdek');
 trabka instrument_dety := instrument_dety('trabka','tra-ta-ta','metalowa');
 fortepian instrument_klawiszowy := instrument_klawiszowy('fortepian','pingping','steinway');
BEGIN
 dbms_output.put_line(tamburyn.graj);
 dbms_output.put_line(trabka.graj);
 dbms_output.put_line(trabka.graj('glosno'));
 dbms_output.put_line(fortepian.graj);
END;

-- zad 13

CREATE TYPE istota AS OBJECT (
 nazwa VARCHAR2(20),
 NOT INSTANTIABLE MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR )
 NOT INSTANTIABLE NOT FINAL;
CREATE TYPE lew UNDER istota (
 liczba_nog NUMBER,
 OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR );
CREATE OR REPLACE TYPE BODY lew AS
 OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR IS
 BEGIN
 RETURN 'upolowana ofiara: '||ofiara;
 END;
END;
DECLARE
 KrolLew lew := lew('LEW',4);
 InnaIstota istota := istota('JAKIES ZWIERZE');
BEGIN
 DBMS_OUTPUT.PUT_LINE( KrolLew.poluj('antylopa') );
END;

-- zad 14

DECLARE
 tamburyn instrument;
 cymbalki instrument;
 trabka instrument_dety;
 saksofon instrument_dety;
BEGIN
 tamburyn := instrument('tamburyn','brzdek-brzdek');
 cymbalki := instrument_dety('cymbalki','ding-ding','metalowe');
 trabka := instrument_dety('trabka','tra-ta-ta','metalowa');
 -- saksofon := instrument('saksofon','tra-taaaa');
 -- saksofon := TREAT( instrument('saksofon','tra-taaaa') AS instrument_dety);
END;

-- zad 15

CREATE TABLE instrumenty OF instrument;
INSERT INTO instrumenty VALUES ( instrument('tamburyn','brzdek-brzdek') );
INSERT INTO instrumenty VALUES ( instrument_dety('trabka','tra-ta-ta','metalowa')
);
INSERT INTO instrumenty VALUES ( instrument_klawiszowy('fortepian','pingping','steinway') );
SELECT i.nazwa, i.graj() FROM instrumenty i;







