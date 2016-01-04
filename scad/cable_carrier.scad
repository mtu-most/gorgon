// this is a link for a 10x15 cable carrier link

include <fasteners.scad>
$fn = 96;
// [l, w, h] = [x, y, z] orient link with pin in the z-direction, long axis in x-direction, pin hole in negative x
// male is defined to be the end of the link with the pin

h_link = 21.25; // the largest height of the link
l_link = 35;
w_link = 15; // ends up being the diameter of the link ends
t_link_walls = 1.62;
l_link_bridges = [10.3, 9.3]; // there are two bridges having different dimensions; bridges are in order [-y, +y]
d_pin = 5.85;
h_pin = 22.25;
d_pin_hole = 6;
cc_pins = 20; // distance between pin and pin female on a single link
r_stop = 5.5; // distance from pin to end of stop on male half

//link();

module link() {
	difference() {
		union() {
			link_half(male = true);

			mirror([1, 0, 0])
				link_half(male = false);
		}
	
		// take out thin piece in middle
		cube([cc_pins, w_link - 2 * t_link_walls, h_link - 4 * t_link_walls], center = true);
	}
}

module link_half(male=true) {
	if (male) {
		difference() {
			union() {
				link_body_half(male = male);
			
				translate([cc_pins / 2, 0, 0])
					cylinder(r = d_pin / 2, h = h_pin, center = true);
				
				// the male end has a stop on one side
				translate([cc_pins / 2, -r_stop, 0])
					linear_extrude(height = h_link - 2 * t_link_walls, center = true)
						polygon([[0, 0], [w_link / 2 + 1.5, 0], [w_link / 2 - 1.5, r_stop], [0, r_stop]]);
			}
			
			// open entire center
			translate([cc_pins / 2, 0, 0])
				cube([cc_pins, w_link - 2 * t_link_walls, h_link - 4 * t_link_walls], center = true);
			
			// form bridge on negative side of y:
			translate([cc_pins / 2, -w_link / 2, 0])
				cube([cc_pins - l_link_bridges[0], w_link, h_link - 4 * t_link_walls], center = true);

			// form bridge on positive side of y:
			translate([cc_pins / 2, w_link / 2, 0])
				cube([cc_pins - l_link_bridges[1], w_link, h_link - 4 * t_link_walls], center = true);
		}
	}
	else {
		difference() {
			link_body_half(male = male);
			
			translate([cc_pins / 2, 0, 0])
				cylinder(r = d_pin_hole / 2, h = h_pin, center = true);

			// open entire center
			translate([cc_pins / 2, 0, 0])
				cube([cc_pins, w_link - 2 * t_link_walls, h_link - 2 * t_link_walls], center = true);
			
			// form bridge on negative side of y:
			translate([cc_pins / 2, -w_link / 2, 0])
				cube([cc_pins - l_link_bridges[0], w_link, h_link - 2 * t_link_walls], center = true);

			// form bridge on positive side of y:
			translate([cc_pins / 2, w_link / 2, 0])
				cube([cc_pins - l_link_bridges[1], w_link, h_link - 2 * t_link_walls], center = true);
		}
	}
}

// each link has two halves - a female and a male
module link_body_half(male = true) {
	h_half = (male) ? h_link - 2 * t_link_walls : h_link;
	hull() {
		cube([t_link_walls, w_link, h_half], center = true);
		
		translate([cc_pins / 2, 0, 0])
			cylinder(r = w_link / 2, h = h_half, center = true);
	}
}
