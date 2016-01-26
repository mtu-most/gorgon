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
  
  if (part_to_render == 14) frame_wire_bearing();

	if (part_to_render == 99) sandbox();

}

layer_height = 0.33;

module sandbox() {

	difference() {
		rotate([0, 90, 0])
			wire_guide_shape(
				h_guide = 11,
				w_guide = 20,
				d_opening = 12,
				offset_opening = 10
			);
			
			translate([0, 0, 2])
				cylinder(r = 5, h = 6);
				
			cylinder(r = 2.6, h = 10, center = true);
	}	
}

module wire_tie_point() {
	difference() {
		union() {
			cylinder(r = 10, h = 4, center = true);
		
			rotate([90, 0, 0])
				scale([1, 1.4, 1])
					rotate_extrude(convexity = 10, $fn = 48)
						translate([8, 0, 0])
							circle(r = 2);
		}
	
		translate([0, 0, -21.5])
			cube([40, 40, 40], center = true);
		
		translate([0, 5, 0]) {
			cylinder(r = 2.6, h = 4, center = true);
			
			cylinder(r = 4.5, h = 4);
		}
	}
}


