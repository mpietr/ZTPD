-- zad 1a

CREATE TABLE figury (
    id NUMBER(1) PRIMARY KEY,
    ksztalt MDSYS.SDO_GEOMETRY
);

-- zad 1b

INSERT INTO figury VALUES
(
    1,
    MDSYS.SDO_GEOMETRY(
        2003,
        NULL,
        NULL,
        SDO_ELEM_INFO_ARRAY(1, 1003, 4),
        SDO_ORDINATE_ARRAY(3, 5, 5, 7, 7, 5)
    )
);

INSERT INTO figury VALUES 
(
    2,
    MDSYS.SDO_GEOMETRY(
        2003,
        NULL,
        NULL,
        SDO_ELEM_INFO_ARRAY(1, 1003, 3),
        SDO_ORDINATE_ARRAY(1, 1, 5, 5)
    )
);

INSERT INTO figury VALUES 
(
    3,
    MDSYS.SDO_GEOMETRY(
        2002,
        NULL,
        NULL,
        SDO_ELEM_INFO_ARRAY(1, 4, 2, 1,2,1, 5,2,2),
        SDO_ORDINATE_ARRAY(1,2,6,2,7,3,8,2,7,1)
    )
);

-- zad 1c

INSERT INTO figury VALUES 
(
    4,
    MDSYS.SDO_GEOMETRY(
        2003,
        NULL,
        NULL,
        SDO_ELEM_INFO_ARRAY(1, 1003, 3),
        SDO_ORDINATE_ARRAY(1, 1)
    )
);

-- zad 1d
SELECT id, SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(ksztalt, 0.005) FROM figury;

-- zad 1e

DELETE FROM figury
WHERE SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(ksztalt, 0.005) <> 'TRUE';

-- zad 1f
COMMIT;