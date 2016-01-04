include <fasteners.scad>
include <electronics_mounts.scad>
include <cable_carrier.scad>

$fn = 24;

//[l, w, h] = [x, y, z]

// limit switch dims
l_limit_switch = 24;
w_limit_switch = 6;
t_limit_switch = 14;
cc_limit_mounts = 9.5;

y_switch_offset = 34.76 - 3.125; // distance from inside of side plate to outside y-end truck

h_belt_cog = 1.12;
d_belt_cog = 2;
t_belt_back = 1.35;

// makerslide dims
d_makerslide_eccentric = 7.14;
d_makerslide_axle = 5.1;
cc_v_makerslide_axles = 64.6;
cc_h_makerslide_axles = 1.375 * 25.4 + 1;

// x-carriage dims
w_carriage = 2 * 25.4;
l_carriage = 3.125 * 25.4;
h_carriage = 4;
dog_offset_from_axle = 43;

// dovetail dims
l_dovetail = l_carriage;
w_dovetail = w_carriage - 22;
h_dovetail = 5;

// hexagon dims
h_hexagon_slot = 4.41;
d_hexagon_slot = 11.95;
d_hexagon_large = 15.9;
d_hotend_mount = 2 * 25.4 - 22 - h_dovetail;

// RAMPS2x board dims (second RAMPS board)
RAMPS2x = [86, 51, 2.85]; // RAMPS2x board for using 2 RAMPS with one Arduino Mega
RAMPS2x_mount_0 = [4.75, 8]; // [x, y] of individual mounting holes
RAMPS2x_mount_1 = [4.75, 43];
RAMPS2x_mount_2 = [59.75, 8];
RAMPS2x_mount_3 = [59.75, 43];
RAMPS2x_mounts = [RAMPS2x_mount_0, RAMPS2x_mount_1, RAMPS2x_mount_2, RAMPS2x_mount_3];

// carriage wiring board (the head of The Gorgon)
Gorgon = [51, 38, 3.2];
Gorgon_mount_0 = [5, 3.4];
Gorgon_mount_1 = [45, 3.4];
Gorgon_mount_2 = [45, 33.4];
Gorgon_mount_3 = [5, 33.4];
Gorgon_mounts = [Gorgon_mount_0, Gorgon_mount_1, Gorgon_mount_2, Gorgon_mount_3];

module gorgon_stanchion() {
	t_mount = 5;
	h_stanchion = 30;
  t_stanchion = 8;

	union() {
    // base for mounting offsets for gorgon board
		mirror([0, 0, 1])
			standoff_mount(
				board = Gorgon,
				mounts = Gorgon_mounts,
				num_mounts = 4,
				h_base = t_mount,
				h_standoff = 2,
				r_corner = 2,
				pad = 2
			);

    // stanchion
		rotate([90, 0, 0])
			translate([0, h_stanchion / 2 - 4, 0])
				difference() {
					rounded_box(
						length = Gorgon[0] + 4,
						width = h_stanchion,
						height = t_stanchion,
						r_corner = 2
					);

          // mounting holes for carriage attachment
  				for (i = [-1, 1])
  					translate([i * cc_h_makerslide_axles / 2, 8, 0])
  						cylinder(r = 2.6, h = 10, center = true);

          // cutout for x-carriage
          translate([0, h_stanchion / 2, t_stanchion / 2])
            cube([Gorgon[0] + 5, 30, t_stanchion], center = true);
				}
	}
}

module bowden_wire_guide() {
	d_mount = 10;
	t_mount = 3;
	offset_opening = 15 - h_dovetail - t_mount / 2 + 2;

	difference() {
		union() {
			hull()
				for (i = [-1, 1])
					translate([0, i * cc_h_makerslide_axles / 2, 0])
						cylinder(r = d_mount / 2, h = t_mount, center = true);

				rotate([0, 90, 0])
					difference() {
						hull() {
							cube([0.1, 2 * (cc_h_makerslide_axles / 2 - 6), d_mount], center = true);

							translate([-offset_opening, 0, 0])
								cylinder(r = cc_h_makerslide_axles / 2 - 6, h = d_mount, center = true);
						}

							translate([-offset_opening, 0, 0]) {
								cylinder(r = 6, h = d_mount + 1, center = true);

								rotate([0, 0, 180])
									linear_extrude(convexity = 10, height = d_mount + 0.5, twist = 100, slices = 50, center = true)
										translate([1, 0, 0])
											square([15, 15]);
							}
					}
		}

		for (i = [-1, 1])
			translate([0, i * cc_h_makerslide_axles / 2, 0])
				cylinder(r = 2.6, h = 4, center = true);
	}
}

module hotend_fan_mount() {
	difference() {
		union() {
			translate([0, 0, 2.5])
				hull()
					for (i = [-1, 1])
						translate([0, i * (d_hexagon_slot / 2 + 3), 0])
							cylinder(r = d_M3_cap / 2, h = 1.5);

			for (i = [-1, 1])
				translate([0, i * (d_hexagon_slot / 2 + 3), 0])
					hull()
						for (j = [0, -1])
							translate([j * 6, j == 0 ? 0 : i * (10 - (d_hexagon_slot / 2 + 3)), 0])
								cylinder(r = d_M3_cap / 2, h = 4);
		}

			for (i = [-1, 1])
				translate([0, i * (d_hexagon_slot / 2 + 3), 0])
						cylinder(r = 3.2 / 2, h = 40, center = true);

			for (i = [1, -1])
				translate([-6, i * 10, 0])
						cylinder(r = 3.2 / 2, h = 40, center = true);
	}
}

module hotend_holder() {
	difference() {
		union() {
			dovetail(length = l_dovetail - 20, width = w_dovetail, height = h_dovetail);

			translate([(l_dovetail - 20) / 2 - 5, 0, 0])
				hotend_mount_part(part = 1);
		}

		hull()
			for (i = [-1, 1])
				translate([i * (l_dovetail - 50) / 2, 0, 0])
					cylinder(r = d_M3_screw / 2 + 0.2, h = h_dovetail + 1, center = true);
	}
}

module hotend_retainer() {
	hotend_mount_part(part = 0);
}

module x_carriage_dovetail() {
	difference() {
		cube([l_carriage, w_carriage, h_dovetail], center = true);

		dovetail(length = l_dovetail + 1, width = w_dovetail, height = h_dovetail);

		for (i = [-1, 1], j = [-1, 1])
			translate([i * cc_v_makerslide_axles / 2, j * cc_h_makerslide_axles / 2, 0])
				cylinder(r = 2.6, h = h_dovetail + 1, center = true);
	}
}

module x_carriage_dog() {
	difference() {
		translate([cc_v_makerslide_axles / 2 - dog_offset_from_axle, 0, 0])
			translate([0, 0, 4 + h_carriage / 2 - 1])
				rotate([0, 0, 90])
					belt_dog(
						teeth = 10,
						height = 8,
						back_thickness = 1.5
					);

		for (i = [-1, 1])
			translate([-25.4/4, i * 25.4 / 2, -1])
				cylinder(r = d_M3_screw / 2 - 0.15, h = 30);
	}
}

module belt_dog(
	teeth,
	height,
	back_thickness
) {
	difference() {
		cube([3 * teeth + 3, 14, height + back_thickness], center = true);

		translate([0, 0, back_thickness]) {
		for (i = [-teeth / 2:teeth / 2])
			translate([i * 3, 0, 0])
				hull()
					for (j = [-1, 1])
						translate([0, j * (h_belt_cog + t_belt_back - d_belt_cog) / 2, 0])
							cylinder(r = d_belt_cog / 2, h = height, center = true, $fn = 48);

		translate([0, -h_belt_cog / 2, 0])
			cube([3 * teeth + 4, t_belt_back, 10], center = true);
			}
	}
}

module z_switch_mount() {
	difference() {
		cube([l_limit_switch, t_limit_switch, t_limit_switch], center = true);

		translate([4, 4, 4])
			cube([l_limit_switch, t_limit_switch, t_limit_switch], center = true);

		translate([0, t_limit_switch / 2 - 4, t_limit_switch / 2 - 4])
			rotate([0, 90, 0])
				cylinder(r = 2.5, h = l_limit_switch + 1, center = true);

		translate([0, 0, 3])
			rotate([90, 0, 0])
				for (i = [-1, 1])
					translate([i * cc_limit_mounts / 2, 0, 0])
						cylinder(r = 1.75 / 2, h = 20, center = true);

	//	translate([0, 0, 3])
			for (i = [-1, 1])
				translate([i * cc_limit_mounts / 2, 0, 0])
					cylinder(r = 1.75 / 2, h = 20, center = true);
	}
}

module y_switch_mount() {
	difference() {
		cube([l_limit_switch + 6, t_limit_switch, y_switch_offset], center = true);

		translate([0, 0, y_switch_offset / 2])
			for (i = [-1, 1])
				translate([i * cc_limit_mounts / 2, 0, 0])
					cylinder(r = 1.75 / 2, h = 20, center = true);

		translate([0, 0, -y_switch_offset / 2])
			for (i = [-1, 1])
				translate([i * 5, 0, 0])
					cylinder(r = 3.2 / 2, h = 20, center = true);

		translate([0, 0, y_switch_offset / 2 - 4])
			rotate([90, 0, 0])
				for (i = [-1, 1])
					translate([i * cc_limit_mounts / 2, 0, 0])
						cylinder(r = 1.75 / 2, h = 20, center = true);

		cube([l_limit_switch - 2, t_limit_switch + 1, y_switch_offset - 16], center = true);
	}
}

/**********

	basic parts for building more complex shapes

**********/
module rounded_box(
	length,
	width,
	height,
	r_corner = 2
){
	hull()
		for (i = [-1, 1])
			for (j = [-1, 1])
				translate([i * (length / 2 - r_corner), j * (width / 2 - r_corner), 0])
					cylinder(r = r_corner, h = height, center = true);
}

module dovetail(length, width, height) {
	hull() {
		translate([0, 0, -height / 2])
			cube([length, width, 0.01], center = true);

		translate([0, 0, height / 2])
			cube([length, width - height, 0.01], center = true);
	}
}

module hotend_mount_part(part) {
	if (part == 1)
		difference() {
			hotend_mount(d_mount_hole = d_M3_screw - 0.3);

			translate([0, 0, 15 + 20])
				cube([d_makerslide_axle + 4, w_carriage, 40], center = true);
		}
	else
		union() {
			intersection() {
				hotend_mount(d_mount_hole = d_M3_screw);

				translate([0, 0, 15 + 20])
					cube([d_makerslide_axle + 4, w_carriage, 40], center = true);
			}
		}
}

module hotend_mount(d_mount_hole = d_M3_screw) {
	union() {
		rotate([0, 270, 0])
			difference() {
				intersection() {
					hull() {
						cube([0.1, d_hotend_mount, d_makerslide_axle + 4], center = true);

						translate([15 + d_hotend_mount / 2, 0, 0])
							cube([0.1, d_hotend_mount, h_hexagon_slot], center = true);
					}

					translate([h_carriage / 2 - 0.05, 0, 0])
						hull() {
							cube([0.1, d_hotend_mount, d_makerslide_axle + 4], center = true);

							translate([15, 0, 0])
								cylinder(r = d_hotend_mount / 2, h = d_makerslide_axle + 4, center = true);
						}
				}

				translate([15, 0, 0]) {
					for (i = [-1, 1])
						translate([0, 0, i * h_hexagon_slot])
							cylinder(r = d_hexagon_large / 2, h = h_hexagon_slot, center = true);

					cylinder(r = d_hexagon_slot / 2, h = h_carriage + 1, center = true);

					for (i = [-1, 1])
						translate([(d_hexagon_large + d_M2_cap) / 2, i * (d_hexagon_slot / 2 + 3), 0])
							rotate([0, 90, 0]) {
								cylinder(r = d_mount_hole / 2, h = 40, center = true);

								cylinder(r = d_M3_cap / 2 + 0.5, h = h_hexagon_slot);
							}
				}
			}
	}
}

/**********

	Mounts for electronics boards

**********/

module mount_RAMPS2x() {
	difference() {
		standoff_mount(
			board = RAMPS2x,
			mounts = RAMPS2x_mounts,
			num_mounts = 4,
			h_base = 5,
			h_standoff = 4,
			r_corner = 2,
			pad = 2
		);

		for (i = [-1, 1])
			translate([i * (RAMPS2x[0] / 2 - 10), i * 10, 0]) {
				translate([0, 0, -1])
					cylinder(r = 2.6, h = 7);

				translate([0, 0, 2])
					cylinder(r = 4.75, h = 5);
			}
	}
}

module mount_RAMPS() {
	difference() {
		standoff_mount(
			board = Arduino_mega,
			mounts = Arduino_mega_mounts,
			num_mounts = 6,
			h_base = 5,
			h_standoff = 4,
			r_corner = 2,
			pad = 2
		);

		for (i = [-1, 1])
			translate([i * (Arduino_mega[0] / 2 - 10), i * 10, 0]) {
				translate([0, 0, -1])
					cylinder(r = 2.6, h = 7);

				translate([0, 0, 2])
					cylinder(r = 4.75, h = 5);
			}
	}
}

module mount_Gorgon() {
	standoff_mount(
		board = Gorgon,
		mounts = Gorgon_mounts,
		num_mounts = 4,
		h_base = 3,
		h_standoff = 4,
		r_corner = 2,
		pad = 2
	);
}
