include <fasteners.scad>

cable_carrier_mount();

t_cable_carrier_mount = 2;
l_cable_carrier_mount = 30;
r_cable_carrier_mount_end = 6;
d_cable_carrier_pivot_opening = 5.9;
d_cable_carrier_pivot = 5.7;
l_cable_carrier_pivot = 22.25;
l_cable_carrier_female = 19; // distance between the pivot pair on the female end
w_cable_carrier_female_end = 15;
t_cable_carrier_link = 15.25; // thickness of link

module cable_carrier_mount() {
//	translate([-(l_cable_carrier_mount - w_cable_carrier_female_end) / 4, 0, 0])
	difference() {
		union() {

			cylinder(r = d_cable_carrier_pivot / 2, h = l_cable_carrier_pivot, center = true, $fn = 96);

//			translate([(l_cable_carrier_mount - w_cable_carrier_female_end) / 2, 0, 0])
				cube([l_cable_carrier_mount, w_cable_carrier_female_end, l_cable_carrier_female], center = true);
		}

		translate([l_cable_carrier_mount - w_cable_carrier_female_end - t_cable_carrier_mount, t_cable_carrier_mount, 0]) {
			translate([-5.5, 0, 0])
			cube([l_cable_carrier_mount + 1, w_cable_carrier_female_end, l_cable_carrier_female - 2 * t_cable_carrier_mount], center = true);

		translate([- w_cable_carrier_female_end / 2 - 1, -t_cable_carrier_mount, 0])
			cube([l_cable_carrier_mount, w_cable_carrier_female_end - 2 * t_cable_carrier_mount, l_cable_carrier_female - 2 * t_cable_carrier_mount], center = true);

/*
			for (i = [-4, 4])
				translate([i, -t_cable_carrier_mount, 0])
					cylinder(r = d_M3_screw / 2, h = l_cable_carrier_female + 1, center = true);

			for (i = [-4, 4])
				translate([i, 0, 0])
					rotate([90, 0, 0])
						cylinder(r = d_M3_screw / 2, h = l_cable_carrier_female + 1, center = true);
*/		}
	}
}
