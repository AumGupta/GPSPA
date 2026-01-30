-- SPATIAL SQL

-- Show everything from a table 
SELECT *
FROM public.nyc_census_blocks;

-- Show only some columns
SELECT blkid, boroname, popn_total,geom
FROM nyc_census_blocks;

-- Show only some of the rows
SELECT blkid, boroname, popn_total,geom
FROM nyc_census_blocks
WHERE boroname = 'Manhattan';

-- You can visualize the data using the load as new layer
SELECT blkid, boroname, popn_total,geom
FROM nyc_census_blocks
WHERE boroname = 'Manhattan';

-- Check the type of geometry
--> https://postgis.net/docs/reference.html
SELECT blkid, boroname, popn_total, ST_GeometryType(geom)
FROM nyc_census_blocks
LIMIT 10;

-- Show geometry in Well Know Text - Polygons
SELECT id, blkid,  ST_AsText(geom)
FROM nyc_census_blocks
LIMIT 10;

-- Show geometry in Well Know Text - Linestrings
SELECT id, name, type, ST_AsText(geom)
FROM nyc_streets;

-- Show geometry in Well Know Text - Points
SELECT id, name, ST_AsText(geom)
FROM nyc_subway_stations;

-- Show the geometry SRID (kind of the same as CRS)
SELECT id, blkid,  ST_SRID(geom)
FROM nyc_census_blocks
LIMIT 10;

-- Show enhanced well know text which shows the SRID and the wkt
SELECT id, blkid,  ST_AsEWKT(geom)
FROM nyc_census_blocks
LIMIT 10;

-- Show the description of the SRID
SELECT proj4text
FROM spatial_ref_sys
WHERE srid = 26918;

-- Calculate the area of the polygons using CRS units
SELECT id, blkid,  geom, ST_area(geom) as area
FROM nyc_census_blocks
LIMIT 10;

-- Calculate the area of the polygons using square kilometers
SELECT id, blkid,  geom, ST_area(geom)/1000000 as area
FROM nyc_census_blocks
LIMIT 10;

-- Calculate the area of the polygons using square kilometers
SELECT id, blkid,  geom, (ST_area(geom)/1000000)::numeric(15,5) as area_km2
FROM nyc_census_blocks
LIMIT 10;

-- Calculate the area of the polygons using square kilometers and order them
SELECT id, blkid,  geom, ST_area(geom) as area
FROM nyc_census_blocks
ORDER BY area
LIMIT 10;

-- Show the 5 biggest blocks
SELECT id, blkid,  geom, ST_area(geom) as area
FROM nyc_census_blocks
ORDER BY area DESC
LIMIT 10;

-- Aggregation - Sum
SELECT sum(ST_Area(geom)) AS area_ha
FROM nyc_census_blocks;

-- Aggregation grouping by boroname
SELECT boroname, sum(ST_Area(geom)) AS area
FROM nyc_census_blocks
GROUP BY boroname
ORDER BY area DESC;

-- Aggregation grouping by boroname and counting
SELECT boroname, count(blkid), sum(ST_Area(geom)) AS area
FROM nyc_census_blocks
GROUP BY boroname
ORDER BY area DESC;

-- Linestrings length
SELECT id, name, type, ST_Length(geom) as lenght
FROM nyc_streets;

--> Getting the centroid of polygons
SELECT id, boroname, name, ST_Centroid(geom) as geom
FROM nyc_neighborhoods;

--> Getting the centroid of polygons on surface
SELECT id, boroname, name, st_pointonsurface(geom) as geom
FROM nyc_neighborhoods;

-- Getting the X and Y coordinates of a point
-- This one has an error, try to fix it!!
SELECT id,
	name,
	geom, 
	st_x(geom) as x
	st_y(geom) as y
FROM nyc_subway_stations;

-- Getting the X and Y coordinates of a point in latitude and longitude
SELECT id, 
	name, 
	geom, 
	st_x(st_transform(geom, 4326)) as x,
	st_y(st_transform(geom, 4326)) as y
FROM nyc_subway_stations;

-- Another way of retriving latitude and longitude
SELECT id, 
	name, 
	geom, 
    ST_AsLatLontext(ST_transform(geom,4326)) as lat_long
FROM nyc_subway_stations;

-- Until now, we have only been quering the data, but we stored nothing
-- We can store a new geometry column for the same table

-- create a new column of the type point geometry
ALTER TABLE nyc_neighborhoods
ADD COLUMN centroid geometry(Point, 4326);

-- Update the centroid column
UPDATE nyc_neighborhoods set 
centroid = st_transform(st_centroid(geom), 4326);

-- Remove the extra column
ALTER TABLE nyc_neighborhoods
DROP COLUMN centroid;

-- Determine areas at 300 m of a subway station
-- Load it on QGIS
-- What happens to these buffers if you edit and save a subway station?
SELECT id, 
	name, 
	st_buffer(geom,300) as geom
FROM nyc_subway_stations;

-- Save the query as a View so you can load later
-- Try loading it
CREATE VIEW subways_300m as
SELECT id, 
	name, 
	st_buffer(geom,300) as geom
FROM nyc_subway_stations;

-- Fazer o casting para dizer à VIEW qual o tipo de geometria
-- Agora já funciona no browser
CREATE VIEW subways_300m as
SELECT id, 
	name, 
	st_buffer(geom,300)::geometry(polygon,26918) as geom
FROM nyc_subway_stations;

-- Having a VIEW is like having a brand new table
-- Dissolve all buffers
SELECT ST_Union(geom)::geometry(MULTIPOLYGON, 26918) as geom
FROM subways_300m;

-- Split the dissolve all buffers
SELECT (ST_Dump(ST_Union(geom))).geom as geom
FROM subways_300m;


-- Dissolve census block by boroname suming popn_total
-- Very demanding query, maybe it's better to save them permanently
-- This one has an error, try to fix it!!
CREATE TABLE nyc_boroughs AS
SELECT boroname,
popn_total,
(st_union(geom))::geometry(multipolygon, 26918) as geom
FROM nyc_census_blocks
GROUP BY boroname;

-- Join by attributes
-- Add the total population of each borough to the nyc_census_blocks
-- TODO: Fix the query
SELECT cb.*, b.popn_total
FROM nyc_census_blocks as cb, nyc_boroughs as b
;

-- Spatial Join
-- If there are no common attributes, we can use the spatial relations to create a join
-- Determine the borough of each subway station
SELECT ss.id, 
	ss.name, 
	ss.geom,
	b.boroname
FROM nyc_subway_stations as ss 
	LEFT JOIN nyc_boroughs as b ON ST_intersects(ss.geom, b.geom);

-- Count the numbers of homicides victims in each neigborhood
SELECT n.boroname, n.name, sum(h.num_victim::integer) as victims
FROM nyc_neighborhoods as n join nyc_homicides as h on st_within(h.geom, n.geom)
GROUP BY n.boroname, n.name
ORDER BY victims DESC


-- Calculating distante from the street 'W broadway' to the subway stations
-- Notice the iLike operator, which is case insensitive
SELECT ss.id, 
	ss.name, 
	ss.geom,
	st_distance(ss.geom, ns.geom)
FROM nyc_subway_stations as ss, nyc_streets as ns
WHERE ns.name ilike 'w broadway'

-- Calculating distante from the street 'W broadway' to nearby subway stations
-- Notice the iLike operator, which is case insensitive
-- Load in QGIS to see the result
SELECT ss.id, 
	ss.name, 
	ss.geom,
	st_distance(ss.geom, ns.geom)
FROM nyc_subway_stations as ss, nyc_streets as ns
WHERE ns.name ilike 'w broadway' and st_dwithin(ss.geom, ns.geom, 500)

-- We could have used st_distance(ss.geom, ns.geom) < 500
-- But that is ineficient as no indexes are uses in that case
-- How can we know? We can us EXPLAIN ANALYSE to see if the indexes are used or not

EXPLAIN ANALYSE
SELECT ss.id, 
	ss.name, 
	ss.geom,
	st_distance(ss.geom, ns.geom)
FROM nyc_subway_stations as ss, nyc_streets as ns
WHERE ns.name ilike 'w broadway' and st_dwithin(ss.geom, ns.geom, 500);

EXPLAIN ANALYSE
SELECT ss.id, 
	ss.name, 
	ss.geom,
	st_distance(ss.geom, ns.geom)
FROM nyc_subway_stations as ss, nyc_streets as ns
WHERE ns.name ilike 'w broadway' and st_distance(ss.geom, ns.geom) < 500;


-- Closest point in line
-- For each subway station within a 500 m of distance from w broadway
-- Calculate the closed place to it in the street
SELECT ss.id, 
	ss.name, 
	st_closestpoint(ns.geom, ss.geom) as geom
FROM nyc_subway_stations as ss, nyc_streets as ns
WHERE ns.name ilike 'w broadway' and st_dwithin(ss.geom, ns.geom, 500)

-- Now lets create a line between that representes the distance betwwen the subways station and the shortest
-- poin in the W Broadway Street

SELECT ss.id, 
	ss.name,
	st_astext(
	st_makeline(
		st_closestpoint(ns.geom, ss.geom),
		ss.geom)) as geom,
		st_distance(ss.geom, ns.geom) as distance
FROM nyc_subway_stations as ss, nyc_streets as ns
WHERE ns.name ilike 'w broadway' and st_dwithin(ss.geom, ns.geom, 500)

-- Distances between elements of the same table
SELECT ss1.id as id1, 
	ss1.name as name1,
	ss2.id as id2,
	ss2.name as name2,
	st_distance(ss1.geom, ss2.geom) as distance
FROM nyc_subway_stations as ss1, nyc_subway_stations as ss2 -- CROSS JOIN

-- Distances between elements of the same table eliminating the duplicates
SELECT ss1.id as id1, 
	ss1.name as name1,
	ss2.id as id2,
	ss2.name as name2,
	st_distance(ss1.geom, ss2.geom) as distance
FROM nyc_subway_stations as ss1, nyc_subway_stations as ss2 -- CROSS JOIN
WHERE ss1.id != ss2.id;

-- Distances between elements of the same table eliminating the duplicates
-- measuring only one time
SELECT ss1.id as id1, 
	ss1.name as name1,
	ss2.id as id2,
	ss2.name as name2,
	st_distance(ss1.geom, ss2.geom) as distance
FROM nyc_subway_stations as ss1, nyc_subway_stations as ss2 -- CROSS JOIN
WHERE ss1.id < ss2.id;

-- Finding the closest subway station of each other
SELECT DISTINCT ON (ss1.id) 
	ss1.id as id1, 
	ss1.name as name1,
	ss2.id as id2,
	ss2.name as name2,
	st_distance(ss1.geom, ss2.geom) as distance
FROM nyc_subway_stations as ss1, nyc_subway_stations as ss2 -- CROSS JOIN
WHERE ss1.id != ss2.id
ORDER BY ss1.id, distance ASC;


-- Overlay Operations
-- Find streets in the chinatown
SELECT s.name, s.geom
FROM nyc_streets as s, nyc_neighborhoods as n
WHERE st_intersects(s.geom, n.geom) and n.name ilike 'chinatown';

-- Clip the street using the chinatwon neighborhod
SELECT s.name, st_intersection(s.geom, n.geom) as geom
FROM nyc_streets as s, nyc_neighborhoods as n
WHERE st_intersects(s.geom, n.geom) and n.name ilike 'chinatown';

-- Add the name of the neighborhood to the homicides table permanently
-- (For some reason this did not work on my QGIS machine)
ALTER TABLE nyc_homicides
ADD COLUMN neighborhood varchar(100);

UPDATE nyc_homicides as h
SET neighborhood = n.name
FROM nyc_neighborhoods as n
WHERE st_within(h.geom, n.geom);

-- Triggers
-- Keep a record of when and who did the last change to a row
-- create the necessary columns to store that information
ALTER TABLE nyc_homicides
ADD COLUMN last_update timestamp,
ADD COLUMN editor varchar(50);

-- correr e mostrar no Pgadmin a nova função
CREATE OR REPLACE FUNCTION get_date_user()
RETURNS trigger AS
$BODY$
    BEGIN
        -- Remember when observation was added/updated
        NEW.last_update := current_timestamp;
        NEW.editor := session_user;
        RETURN NEW;
    END;
$BODY$ LANGUAGE plpgsql;

CREATE TRIGGER get_date_user BEFORE INSERT OR UPDATE ON nyc_homicides
FOR EACH ROW
EXECUTE PROCEDURE get_date_user();

-- Trigger to fillin the neighborhood field automatically
CREATE OR REPLACE FUNCTION get_neigborhood()
RETURNS trigger AS
$BODY$
    BEGIN
		NEW.neighborhood := (SELECT n.name FROM nyc_neighborhoods as n WHERE st_intersects(NEW.geom, n.geom));
		RETURN NEW;
    END;
$BODY$ LANGUAGE plpgsql;

--DROP TRIGGER IF EXISTS get_neigborhood ON nyc_homicides;
CREATE TRIGGER get_neigborhood BEFORE INSERT OR UPDATE ON nyc_homicides
FOR EACH ROW
EXECUTE PROCEDURE get_neigborhood();

-- Recreate the nyc_boroughs table in case there are changes to the nyc_boroughs
-- In case there are changes in the census_blocks table

CREATE OR REPLACE FUNCTION update_nyc_boroughs()
RETURNS trigger AS
$BODY$
    BEGIN
		TRUNCATE TABLE nyc_boroughs;
	
		INSERT INTO nyc_boroughs (boroname, popn_total, geom)
		SELECT boroname,
		sum(popn_total) as popn_total,
		st_multi((st_union(geom)))::geometry(multipolygon, 26918) as geom
		FROM nyc_census_blocks
		GROUP BY boroname;
		
		RETURN NULL;
    END;
$BODY$ LANGUAGE plpgsql;

-- notice the difference in this trigger. It runs after the action has occurred
-- And runs one single time for all rows changed

CREATE TRIGGER update_nyc_boroughs AFTER INSERT OR UPDATE OR DELETE ON nyc_census_blocks
FOR EACH STATEMENT
EXECUTE PROCEDURE update_nyc_boroughs();