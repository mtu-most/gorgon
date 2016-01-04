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
  
  if (part_to_render == 13) carriage_wire_bearing();

	if (part_to_render == 99) sandbox();

}

layer_height = 0.33;

module sandbox() {
	  b = 5;
  h = 8;
  r = 8;
  h2 = 2;
  h3 = 1;
  bearing_points = bearing_shape_points(
    b = b,
    h = h,
    r = r,
    h2 = h2,
    h3 = h3
  );
 bearing_shape(bearing_points);
}
