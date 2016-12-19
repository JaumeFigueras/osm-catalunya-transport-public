UPDATE trips
SET trip_headsign = tmp_trips.headsign
FROM tmp_trips
WHERE trips.route_id = tmp_trips.route_id
  AND trips.direction_id = tmp_trips.direction
;

DROP TABLE tmp_trips;
