SELECT osm_id, id FROM ways_vertices_pgr
WHERE osm_id IN (
262253861, -- martinho da arcada
1802560212, -- pasteis de belem
776479870 -- entrada da universidade
)

SELECT gid as id, -- Subquery to map our network table to the necessary fields
		source,
		target,
		length_m as cost,
		length_m as reverse_cost
	FROM ways

-- Calculate the shortest path from source to target nodes

SELECT *
FROM pgr_dijkstra(
	'SELECT gid as id, -- Subquery to map our network table to the necessary fields
		source,
		target,
		length_m as cost,
		length_m as reverse_cost
	FROM ways'
	, 6401 -- Source node
	, 10575 -- Target node
	, true); -- directed route
	
/** The result is a list of steps to go from one node to another it includes 
the starting node and the edge id (the street id) of the step, the cost 
of the step and the aggregated cost at the begining of the step.
Since we have the edge id this means that we grab the line geometries */

-- The same function can calculate the shortest paths from several sources and target nodes
-- Besides, having the id's from all the edges needed, we can get the from the ways table

with result as (
SELECT * FROM pgr_dijkstra(
	'SELECT gid as id, -- Subquery to map our network table to the necessary fields
		source,
		target,
		length_m as cost,
		length_m as reverse_cost
	FROM ways'
	, 6401 -- Source node
	, ARRAY[10575,2700] -- Target node
	, true)) -- directed route
SELECT r.*, w.the_geom
FROM ways as w, result as r
WHERE r.edge = w.gid;

-- We can also have different destinations and we can grupo the results

with result as (
    SELECT * 
    FROM pgr_dijkstra(
        -- Subquery to map our network table to the necessary fields
        'SELECT gid as id, 
            source,
            target,
            length_m as cost,
            length_m as reverse_cost
        FROM ways'
        , 6401 -- Single source node
        , ARRAY[10575,2700] -- Multiple target nodes using an array
        , true -- directed route
        )
)
SELECT r.end_vid, sum(r.cost) as cost, st_collect(w.the_geom) as geom
FROM ways as w, result as r
WHERE r.edge = w.gid
GROUP BY r.end_vid; 


-- Now let's find the driving distance. That is all nodes that will be reachable within a certain distance from the source

SELECT * FROM pgr_drivingDistance(
	'   SELECT gid as id, -- Subquery to map our network table to the necessary fields
		source,
		target,
		length_m as cost,
		length_m as reverse_cost
	    FROM ways',
	6376, -- origin
	500 -- distance in meters
	)
	
-- Now getting all the nodes, since from the result we can get the node number and join it to the ways_vertices_pgr table
with result as (	
SELECT * FROM pgr_drivingDistance(
	'   SELECT gid as id, -- Subquery to map our network table to the necessary fields
		source,
		target,
		length_m as cost,
		length_m as reverse_cost
	    FROM ways',
	6401, -- origin
	1000 -- distance
	)
)
SELECT r.node, agg_cost, v.the_geom as geom
FROM ways_vertices_pgr as v, result as r
WHERE r.node = v.id;

-- We can now wrap the nodes in a alphashape polygon, a kind of concavehull that gets all nodes inside.

with result as (	
SELECT * FROM pgr_drivingDistance(
	'   SELECT gid as id, -- Subquery to map our network table to the necessary fields
		source,
		target,
		length_m as cost,
		length_m as reverse_cost
	    FROM ways',
	6401, -- origin
	1000 -- distance
	)
)
SELECT pgr_alphaShape((st_collect(v.the_geom))) as geom
FROM ways_vertices_pgr as v, result as r
WHERE r.node = v.id;


-- Same but using native PostGIS concavehull
with result as (	
SELECT * FROM pgr_drivingDistance(
	'   SELECT gid as id, -- Subquery to map our network table to the necessary fields
		source,
		target,
		length_m as cost,
		length_m as reverse_cost
	    FROM ways',
	6401, -- origin
	1000 -- distance
	)
)
SELECT st_concavehull((st_collect(v.the_geom)),0.8) as geom
FROM ways_vertices_pgr as v, result as r
WHERE r.node = v.id;


