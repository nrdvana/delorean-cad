vent_flange_dx=275;
vent_flange_dy=30.3;
vent_flange_dz=2.4;
vent_flange_overhang_y=4.54;
vent_flange_overhang_x=3.45;
vent_flange_corner_rad=11.4;
vent_corner_rad= 7.1;
vent_body_angle= 40; // relative to top flange surface
vent_mount_angle= 50; // relative to top flange surface
vent_flange_curve_dz= 1.1; // height of middle above ends, in the (non-)plane of the flange
vent_flange_curve_dy= 1.4; // depth of front beyond ends, in the (non-)plane of the flange

module mirrored(vec) {
	children();
	mirror(vec) children();
}

// origin is center of the windshield-facing/top edge of the vent
module vent(negative=false) {
	// surface of vent is two rounded front corners, a square back edge
	mirrored([1,0,0]) {
		// extrude from outline underneath flange to outline against fiberglass
		linear_extrude(vent_flange_dz) {
			translate([ vent_flange_dx/2 - vent_flange_corner_rad, -vent_flange_dy + vent_flange_corner_rad ])
				circle(vent_flange_corner_rad);
			translate([ 0, -vent_flange_dy ]) square([ vent_flange_dx/2 - vent_flange_corner_rad, vent_flange_dy ]);
			translate([ 0, -vent_flange_dy + vent_flange_corner_rad ]) square([ vent_flange_dx/2, vent_flange_dy - vent_flange_corner_rad ]);
		}
		// extrude from outline underneath flange to outline against fiberglass
		extrude() {
			for (t=[-1,0], union=false) {
				translate([ 0, -t*cos(vent_mount_angle)*18, t*sin(vent_mount_angle)*18 ])
				mirror([0,1]) {
					translate([
							vent_flange_dx/2 - vent_flange_overhang_x - vent_corner_rad,
							vent_flange_dy - vent_flange_overhang_y - vent_corner_rad,
							-vent_flange_dz + o
						])
						circle(r=vent_corner_rad);
					square([ vent_flange_dx/2 - vent_flange_overhang_x - vent_corner_rad, vent_flange_dy - vent_flange_overhang_y ]);
					square([ vent_flange_dx/2 - vent_flange_overhang_x, vent_flange_dy - vent_flange_overhang_y - vent_corner_rad ]);
				}
			}
		}
	}
}
