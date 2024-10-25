
-- zad 1
create table movies as select * from ztpd.movies;

-- zad 2
select * from movies;

desc movies;

-- zad 3
SELECT id, title FROM movies WHERE cover IS NULL;

-- zad 4
SELECT id, title, dbms_lob.getlength(cover) as filesize FROM movies WHERE cover IS NOT NULL;

-- zad 5
select id, title, dbms_lob.getlength(cover) as filesize FROM movies WHERE cover IS NULL;

-- zad 6
SELECT * FROM all_directories;

--zad 7
UPDATE movies
set cover = EMPTY_BLOB(),
mime_type = 'image/jpeg'
WHERE id = 66;

-- zad 8
select id, title, dbms_lob.getlength(cover) as filesize FROM movies WHERE id in (65, 66);

--zad 9
DECLARE
    file_blob blob;
    cover_file BFILE := BFILENAME('TPD_DIR', 'escape.jpg');
BEGIN
    SELECT cover INTO file_blob
    FROM movies
    WHERE id = 66
    FOR UPDATE;
    
    DBMS_LOB.fileopen(cover_file, DBMS_LOB.file_readonly);
    DBMS_LOB.loadfromfile(file_blob, cover_file, DBMS_LOB.getlength(cover_file));
    DBMS_LOB.fileclose(cover_file);
    COMMIT;
END;

-- zad 10
CREATE TABLE temp_covers (
    movie_id NUMBER(12),
    image BFILE,
    mime_type VARCHAR(50)
);

-- zad 11
INSERT into temp_covers VALUES (65, BFILENAME('TPD_DIR', 'eagles.jpg') , 'image/jpeg');

-- zad 12
select movie_id, dbms_lob.getlength(image) as filesize FROM temp_covers;

-- zad 13
DECLARE
    cover_file BFILE;
    mime_type VARCHAR2(20);
    temp BLOB;
BEGIN
    SELECT image, mime_type INTO cover_file, mime_type
    FROM temp_covers
    WHERE movie_id = 65;
    
    DBMS_LOB.createtemporary(temp, TRUE);
    
    DBMS_LOB.fileopen(cover_file, DBMS_LOB.file_readonly);
    DBMS_LOB.loadfromfile(temp, cover_file, DBMS_LOB.getlength(cover_file));
    DBMS_LOB.fileclose(cover_file);
    
    UPDATE movies
    SET cover = temp,
    mime_type = mime_type
    WHERE id = 65;
    
    DBMS_LOB.freetemporary(temp);
    
    COMMIT;
END;

-- zad 14
SELECT id, title, dbms_lob.getlength(cover) AS filesize FROM movies WHERE id in (65, 66);

-- zad 15
DROP TABLE movies;



