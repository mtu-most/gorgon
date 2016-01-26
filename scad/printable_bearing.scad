
// makes the shape that forms a printable "bearing", which is pretty generous, but it works
module bearing_body(
  id_bearing,
  clearance = 0.0,
  flats = false,
  bearing_points
) {
  w_flat_cube = bearing_points[3][0] - bearing_points[1][0];

  difference() {
    rotate_extrude(convexity = 2, $fn = 96)
      translate([id_bearing / 2, 0, 0])
        offset(clearance)
          bearing_shape(bearing_points = bearing_points);

    if (flats)
      for (i = [-1, 1])
        translate([i * ((id_bearing + w_flat_cube) / 2 + bearing_points[1][0]), 0, bearing_points[6][1] / 2]) {
          cube([w_flat_cube, id_bearing, bearing_points[6][1]], center = true);

          cube([w_flat_cube + 1, 1, bearing_points[6][1]], center = true);
        }
  }
}

module bearing_shape(
  bearing_points
) {
  polygon(bearing_points);
}

function bearing_shape_points(
  b, 		// base dimension
  h, 		// dimension of bottom collar height
  r, 		// outer radius of bearing shape
  h2, 	// dimension of the portion that has radius r
  h3 		// height where the top part of the bearing flats
) =
  [
    [0, 0],
    [b, 0],
    [b, h],
    [r, h + (r - b) * tan(45)],
    [r, h + (r - b) * tan(45) + h2],
    [h3 * tan(45), h + (r - b) * tan(45) + h2 + r * tan(45) - h3],
    [0, h + (r - b) * tan(45) + h2 + r * tan(45) - h3]
  ];
