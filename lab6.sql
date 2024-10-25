-- zad 1a
select lpad('-',2*(level-1),'|-') || t.owner||'.'||t.type_name||' (FINAL:'||t.final||
', INSTANTIABLE:'||t.instantiable||', ATTRIBUTES:'||t.attributes||', METHODS:'||t.methods||')'
from all_types t
start with t.type_name = 'ST_GEOMETRY'
connect by prior t.type_name = t.supertype_name
 and prior t.owner = t.owner;

-- zad 1b
select distinct m.method_name
from all_type_methods m
where m.type_name like 'ST_POLYGON'
and m.owner = 'MDSYS'
order by 1;

-- zad 1c
CREATE TABLE myst_major_cities (
    fips_cntry VARCHAR2(2),
    city_name VARCHAR2(40),
    stgeom ST_POINT
);

-- zad 1d
INSERT INTO myst_major_cities (
    SELECT fips_cntry, city_name, TREAT(ST_POINT(geom) as ST_POINT) FROM major_cities
);


-- zad 2a
INSERT INTO myst_major_cities VALUES (
    'PL',
    'Szczyrk',
    new ST_POINT(19.036107, 49.718655, 8307)
);

-- zad 3a
CREATE TABLE myst_country_boundaries (
    fips_cntry VARCHAR2(2),
    cntry_name VARCHAR2(40),
    stgeom ST_MULTIPOLYGON
);

-- zad 3b
INSERT INTO myst_country_boundaries (
    SELECT fips_cntry, cntry_name, TREAT(ST_MULTIPOLYGON(geom) AS ST_MULTIPOLYGON) from country_boundaries
);

-- CREATE VIEW myst_country_boundaries AS
-- SELECT fips_cntry, cntry_name, TREAT(ST_MULTIPOLYGON.FROM_SDO_GEOM(geom) AS ST_MULTIPOLYGON) stgeom from country_boundaries; <-- za mało miejsca na utworzenie tabeli

-- zad 3c
SELECT b.stgeom.st_geometrytype() as typ_obiektu, count(*) as ile
FROM myst_country_boundaries b
GROUP BY b.stgeom.st_geometrytype();

-- zad 3d
SELECT b.stgeom.st_issimple()
FROM myst_country_boundaries b;

-- zad 4a
SELECT b.cntry_name, count(*)
FROM myst_country_boundaries b, myst_major_cities c
WHERE c.stgeom.st_within(b.stgeom) = 1
GROUP BY b.cntry_name;

-- zad 4b
SELECT b1.cntry_name
FROM myst_country_boundaries b1, myst_country_boundaries b2
WHERE b1.stgeom.st_touches(b2.stgeom) = 1
AND b2.cntry_name LIKE 'Czech Republic';

-- zad 4c
SELECT b.cntry_name, r.name
FROM myst_country_boundaries b, rivers r
WHERE b.cntry_name LIKE 'Czech Republic'
AND st_linestring(r.geom).st_intersects(b.stgeom) = 1;

-- zad 4d
SELECT TREAT(b1.stgeom.st_union(b2.stgeom) as st_polygon).st_area() as powierzchnia
FROM myst_country_boundaries b1, myst_country_boundaries b2
WHERE b1.cntry_name LIKE 'Slovakia' AND b2.cntry_name LIKE 'Czech Republic';

-- zad 4e
SELECT b.stgeom.st_geometrytype() as obiekt, TREAT(b.stgeom.st_difference(st_geometry(w.geom)) as st_polygon).st_geometrytype() as wegry_bez
FROM myst_country_boundaries b, water_bodies w
WHERE b.cntry_name LIKE 'Hungary' and w.name LIKE 'Balaton';

-- zad 5a
EXPLAIN PLAN FOR
SELECT b.cntry_name, COUNT(*)
FROM myst_major_cities c, myst_country_boundaries b
WHERE sdo_within_distance(c.stgeom, b.stgeom, 'distance=100 unit=km') = 'TRUE'
AND b.cntry_name = 'Poland'
GROUP BY b.cntry_name;

SELECT plan_table_output FROM TABLE(dbms_xplan.display());

-- zad 5b
INSERT INTO user_sdo_geom_metadata (
    SELECT 'MYST_MAJOR_CITIES', 'STGEOM', diminfo,srid
    FROM all_sdo_geom_metadata
    WHERE table_name = 'MAJOR_CITIES'
);

-- zad 5c
CREATE INDEX myst_major_cities_idx
ON myst_major_cities(stgeom)
INDEXTYPE IS mdsys.spatial_index_v2;

-- zad 5d
EXPLAIN PLAN FOR
SELECT b.cntry_name, COUNT(*)
FROM myst_major_cities c, myst_country_boundaries b
WHERE sdo_within_distance(c.stgeom, b.stgeom, 'distance=100 unit=km') = 'TRUE'
AND b.cntry_name = 'Poland'
GROUP BY b.cntry_name;

SELECT plan_table_output FROM TABLE(dbms_xplan.display());
