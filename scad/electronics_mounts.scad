include<fasteners.scad>
$fn = 24;

//arduino mega
// [l, w, h] = [x, y, z]
// origin = corner of board nearest power jack
Arduino_mega = [101.6, 53.3, 2.85]; //x, y, diameter of mounting holes (make them smaller to plastiform threads into mount)
Arduino_mega_mount_0 = [14, 2.54];
Arduino_mega_mount_1 = [96.5, 2.54];
Arduino_mega_mount_2 = [90.2, 50.7];
Arduino_mega_mount_3 = [15.3, 50.7];
Arduino_mega_mount_4 = [66.1, 7.6];
Arduino_mega_mount_5 = [66.1, 35.5];
Arduino_mega_mounts = [Arduino_mega_mount_0, Arduino_mega_mount_1, Arduino_mega_mount_2, Arduino_mega_mount_3, Arduino_mega_mount_4, Arduino_mega_mount_5];

// Beaglebone Black
bbb = [89, 55, 3];
bbb_mount0 = [14.61, 3.18];
bbb_mount1 = [14.61 + 66.5, 6.35];
bbb_mount2 = [14.61 + 66.5, 6.35 + 42.6];
bbb_mount3 = [14.61, 3.18 + 48.39];
bbb_mounts = [bbb_mount0, bbb_mount1, bbb_mount2, bbb_mount3];


module standoff_mount(
	board, // array with board dims
	mounts, // array with mount locations
	num_mounts, // number of mounts - must be less than or equal to the number of elements in mounts
	h_base = 4,
	h_standoff = 4,
	d_base_standoff = 7.5,
	d_top_standoff = 5,
	r_corner = 2,
	pad = 0
){
	difference() {
		union() {
			hull()
				for (i = [-1, 1], j = [-1, 1])
					translate([i * (board[0] / 2 - r_corner + pad), j * (board[1] / 2 - r_corner + pad), 0])
						cylinder(r = r_corner, h = h_base);

			translate([-board[0] / 2, -board[1] / 2, h_base - 0.1])
				for(i = [0:num_mounts - 1])
					translate([mounts[i][0], mounts[i][1], 0])
						cylinder(r1 = d_base_standoff / 2, r2 = d_top_standoff / 2, h = h_standoff + 0.1);
		}

			translate([-board[0] / 2, -board[1] / 2, -1])
				for(i = [0:num_mounts - 1])
					translate([mounts[i][0], mounts[i][1], 0])
						cylinder(r = board[2] / 2, h = h_standoff + h_base + 2);
	}
}

module keyhole_mount() {
sockets_up = true; // if true, the keyholes will be oriented such that the usb and power sockets will face upward
offset_key_shaft = (sockets_up) ? 0 : 10;
// this doesn't work as well as one might hope:(
	difference() {
	//	translate([-6, -2, 0])
			cube([l_mega + 4, w_mega + 4, h_base]);

		translate([6, 2, 0]) {
			for (i = [0:3])
				translate([mega_mounts[i][0] - mega_mounts[0][0] + offset_key_shaft, mega_mounts[i][1], 1])
					cylinder(r = d_M3_cap / 2 + 0.1, h = h_base + 2);

			for (i = [0:3])
				translate([mega_mounts[i][0] + 10 - mega_mounts[0][0], mega_mounts[i][1], 1]) {
					hull()
						for (j = [0, -10])
							translate([j, 0, 0])
								cylinder(r = d_M3_cap / 2 + 0.1, h = h_M3_cap + 0.5);

					hull()
						for (j = [0, -10])
							translate([j, 0, h_M3_cap + 0.8])
								cylinder(r = d_M3_screw / 2 + 0.1, h = h_base);
				}

			for (i = [-1, 1])
				for (j = [-1, 1])
					translate([i * 40 + l_mega / 2 - 4, j * 15 + w_mega / 2, 0]) {
						translate([0, 0, -1])
							cylinder(r = d_M3_screw / 2, h = h_base + 2);

						translate([0, 0, h_base - h_M3_cap - 0.25])
							cylinder(r = d_M3_cap / 2, h = h_base + 2);
					}

			translate([l_mega / 2 - 4, w_mega / 2, 0]) {
				hull()
					for (i = [-1, 1])
						translate([i * (l_mega / 2 - 18), 0, -1])
							cylinder(r = 10, h = h_base + 2);

				hull()
					for (i = [-1, 1])
						for(j = [-1, 1])
							translate([i * 20, j * 10, -1])
								cylinder(r = 10.1, h = h_base + 2);
			}
		}
	}
}
