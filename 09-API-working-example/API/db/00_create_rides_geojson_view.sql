CREATE VIEW pa.rides_geojson as
SELECT id,
	pickup_datetime, 
	dropoff_datetime,
	passenger_count,
	st_asGeoJSON(st_makeline(pickup, dropoff))::json as geojson
from pa.rides; 
