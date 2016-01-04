include<gorgon.scad>

render_part(part_to_render = 99);

module render_part(part_to_render) {

	if (part_to_render == 1) hotend_fan_mount();

	if (part_to_render == 2) hotend_holder();

	if (part_to_render == 3) x_carriage_dog();

	if (part_to_render == 4) hotend_retainer();

	if (part_to_render == 5) z_switch_mount();

	if (part_to_render == 6) y_switch_mount();

	if (part_to_render == 7) x_carriage_dovetail();

	if (part_to_render == 8) bowden_wire_guide();

	if (part_to_render == 9) mount_RAMPS2x();

	if (part_to_render == 10) mount_RAMPS();

  if (part_to_render == 11) mount_Gorgon();

  if (part_to_render == 12) gorgon_stanchion();

	if (part_to_render == 99) sandbox();

}

layer_height = 0.33;

module sandbox() {
  b = 5;
  h = 8;
  r = 8;
  h2 = 2;
  h3 = 1;
  latch_points = latch_shape_points(
    b = b,
    h = h,
    r = r,
    h2 = h2,
    h3 = h3
  );

  id_rotating_latch = 20;
  w_recepticle = id_rotating_latch + 2 * r + 6;
  h_recepticle = latch_points[6][1] - 6;

  difference() {
    translate([0, 0, h_recepticle / 2 - 1])
      rotate([0, 0, 90])
        standoff_mount(
          board = Gorgon,
          mounts = Gorgon_mounts,
          num_mounts = 4,
          h_base = h_recepticle,
          h_standoff = 0,
          r_corner = 2,
          pad = 2
        );


      rotating_latch(
        id_rotating_latch = id_rotating_latch,
        recepticle = true,
        latch_points = latch_points
      );

      translate([0, 0, 5])
        cylinder(r = id_rotating_latch / 2, h = h_recepticle + 2);
  }

  difference() {
    union() {
      rotating_latch(
        id_rotating_latch = id_rotating_latch,
        recepticle = false,
        flats = true,
        latch_points = latch_points
      );

      cylinder(r = id_rotating_latch / 2 + 1, h = latch_points[6][1]);

      rotate([0, 0, 90])
        translate([0, -2, -l_cable_carrier_mount / 2])
          rotate([0, 270, 0])
            cable_carrier_mount();
    }

    translate([0, 0, -1])
      cylinder(r = id_rotating_latch / 2 - 2, h = latch_points[6][1] + 2);
  }
}

//
module rotating_latch(
  id_rotating_latch,
  recepticle = false,
  flats = false,
  latch_points
) {
  w_flat_cube = latch_points[3][0] - latch_points[1][0];

  difference() {
    rotate_extrude(convexity = 2, $fn = 96)
      translate([id_rotating_latch / 2, 0, 0])
        offset((recepticle) ? 2 * layer_height : 0)
          latch_shape(latch_points = latch_points);

    if (flats)
      for (i = [-1, 1])
        translate([i * ((id_rotating_latch + w_flat_cube) / 2 + latch_points[1][0]), 0, latch_points[6][1] / 2]) {
          cube([w_flat_cube, id_rotating_latch, latch_points[6][1]], center = true);

          cube([w_flat_cube + 1, 1, latch_points[6][1]], center = true);
        }
  }
}

module latch_shape(
  latch_points
) {
  polygon(latch_points);
}

function latch_shape_points(
  b,
  h,
  r,
  h2,
  h3
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
