CREATE VIEW pa.rides_geojson as
SELECT id,
	pickup_datetime, 
	dropoff_datetime,
	passenger_count,
	rate_code,
	payment_type,
	tip_amount,
	total_amount,
	st_asGeoJSON(st_makeline(pickup, dropoff))::json as geojson
from pa.rides; 
