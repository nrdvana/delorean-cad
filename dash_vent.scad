/* This models the plastic vent inserts that fit between the dashboard
 * and the windshield.
 *
 * The "vent_cutout()" is a solid shape to be used when subtracting
 * a hole for the vent from some other solid.
 */

dash_vent_flange_dx=275;
dash_vent_flange_dy=30.3;
dash_vent_flange_dz=2.4;
dash_vent_flange_overhang_y=4.54;
dash_vent_flange_overhang_x=3.45;
dash_vent_flange_corner_rad=11.4;
dash_vent_corner_rad= 7.1;
dash_vent_body_angle= 40; // relative to top flange surface
dash_vent_mount_angle= 50; // relative to top flange surface
dash_vent_flange_curve_dz= 1.1; // height of middle above ends, in the (non-)plane of the flange
dash_vent_flange_curve_dy= 1.4; // depth of front beyond ends, in the (non-)plane of the flange

module mirrored(vec) {
	children();
	mirror(vec) children();
}

// origin is center of the windshield-facing/top edge of the vent
module dash_vent(
	flange_dx=         dash_vent_flange_dx,
	flange_dy=         dash_vent_flange_dy,
	flange_dz=         dash_vent_flange_dz,
	flange_overhang_y= dash_vent_flange_overhang_y,
	flange_overhang_x= dash_vent_flange_overhang_x,
	flange_corner_rad= dash_vent_flange_corner_rad,
	corner_rad=        dash_vent_corner_rad,
	body_angle=        dash_vent_body_angle,
	mount_angle=       dash_vent_mount_angle,
	flange_curve_dz=   dash_vent_flange_curve_dz,
	flange_curve_dy=   dash_vent_flange_curve_dy,
	o=0.00,
	cutout=false
) {
	// surface of vent is two rounded front corners, a square back edge
	mirrored([1,0,0]) {
		// extrude from outline underneath flange to outline against fiberglass
		linear_extrude(flange_dz) {
			translate([ flange_dx/2 - flange_corner_rad, -flange_dy + flange_corner_rad ])
				circle(flange_corner_rad);
			translate([ 0, -flange_dy ]) square([ flange_dx/2 - flange_corner_rad, flange_dy ]);
			translate([ 0, -flange_dy + flange_corner_rad ]) square([ flange_dx/2, flange_dy - flange_corner_rad ]);
		}
		// extrude from outline underneath flange to outline against fiberglass
		extrude() {
			for (t=[-1,0], union=false) {
				translate([ 0, -t*cos(mount_angle)*18, t*sin(mount_angle)*18 ])
				mirror([0,1]) {
					translate([
							flange_dx/2 - flange_overhang_x - corner_rad,
							flange_dy - flange_overhang_y - corner_rad,
							-flange_dz + o
						])
						circle(r=corner_rad);
					square([ flange_dx/2 - flange_overhang_x - corner_rad, flange_dy - flange_overhang_y ]);
					square([ flange_dx/2 - flange_overhang_x, flange_dy - flange_overhang_y - corner_rad ]);
				}
			}
		}
	}
}
