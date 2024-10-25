-- zad 1
CREATE TABLE dokumenty (
    id NUMBER(13) PRIMARY KEY,
    dokument CLOB
);

-- zad 2
DECLARE
    text CLOB;
BEGIN
    FOR I IN 1..10000
    LOOP
        text := CONCAT(text, 'Oto text. ');
    END LOOP;
    
    INSERT INTO dokumenty VALUES(1, text);
END;

-- zad 3
SELECT * FROM dokumenty;
SELECT UPPER(dokument) FROM dokumenty;
SELECT LENGTH(dokument) FROM dokumenty;
SELECT DBMS_LOB.GETLENGTH(dokument) FROM dokumenty;
SELECT SUBSTR(dokument, 5, 1000) FROM dokumenty;
SELECT DBMS_LOB.SUBSTR(dokument, 1000, 5) FROM dokumenty;

-- zad 4
INSERT INTO dokumenty VALUES(2, EMPTY_CLOB());

-- zad 5
INSERT INTO DOKUMENTY VALUES(3, NULL);
COMMIT;

-- zad 6
SELECT * FROM dokumenty;
SELECT UPPER(dokument) FROM dokumenty;
SELECT LENGTH(dokument) FROM dokumenty;
SELECT DBMS_LOB.GETLENGTH(dokument) FROM dokumenty;
SELECT SUBSTR(dokument, 5, 1000) FROM dokumenty;
SELECT DBMS_LOB.SUBSTR(dokument, 1000, 5) FROM dokumenty;

-- zad 7
DECLARE
    doc CLOB;
    text_file BFILE := BFILENAME('TPD_DIR', 'dokument.txt');
    doffset integer := 1;
     soffset integer := 1;
     langctx integer := 0;
     warn integer := null;
BEGIN
    SELECT dokument INTO doc FROM dokumenty
    WHERE id = 2
    FOR UPDATE;
    
    DBMS_LOB.fileopen(text_file, DBMS_LOB.file_readonly);
    DBMS_LOB.loadclobfromfile(doc, text_file, DBMS_LOB.lobmaxsize, doffset, soffset, 873, langctx, warn);
    DBMS_LOB.fileclose(text_file);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Status operacji: '||warn);
END;

-- zad 8
UPDATE dokumenty
SET dokument = TO_CLOB(BFILENAME('TPD_DIR', 'dokument.txt'), 873)
WHERE id = 3;

-- zad 9
SELECT * FROM dokumenty;

-- zad 10
SELECT DBMS_LOB.GETLENGTH(dokument) FROM dokumenty;

-- zad 11
DROP TABLE dokumenty;

-- zad 12
CREATE OR REPLACE PROCEDURE CLOB_CENSOR(
    clob_object IN OUT CLOB,
    to_censor   VARCHAR2
)
IS
    dotted_text VARCHAR2(256);
    pos         INTEGER := 1;
BEGIN
    dotted_text := LPAD('.', LENGTH(to_censor), '.');
    LOOP
        pos := DBMS_LOB.INSTR(clob_object, to_censor, 1, 1);
        EXIT WHEN pos = 0;
        DBMS_LOB.WRITE(clob_object, LENGTH(to_censor), pos, dotted_text);
    END LOOP;
END CLOB_CENSOR;



-- zad 13
CREATE TABLE biographies AS SELECT * FROM ztpd.biographies;

-- zad 14
DECLARE
    bio_clob CLOB;
BEGIN
    SELECT bio INTO bio_clob
    FROM biographies
    FOR UPDATE;
    CLOB_CENSOR(bio_clob, 'Cimrman');
    COMMIT;
END;

-- zad 15
DROP TABLE biographies;






