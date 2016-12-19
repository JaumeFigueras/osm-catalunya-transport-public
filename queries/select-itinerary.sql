COPY (SELECT routes.route_id, routes.route_short_name, routes.route_long_name, agency.agency_name,
  CASE WHEN trips.direction_id = 0 THEN TRIM(split_part(routes.route_long_name, '-', 2), ' ')
  ELSE TRIM(split_part(routes.route_long_name, '-', 1), ' ')
  END AS hint, trips.direction_id
FROM routes
INNER JOIN agency ON routes.agency_id = agency.agency_id
INNER JOIN trips ON routes.route_id = trips.route_id
INNER JOIN patterns ON trips.shape_id = patterns.shape_id
GROUP BY routes.route_id, patterns.geom, routes.route_short_name, routes.route_long_name, agency.agency_name, hint, trips.direction_id
ORDER BY routes.route_short_name, agency.agency_name, trips.direction_id)
TO STDOUT
DELIMITER ','
CSV;
