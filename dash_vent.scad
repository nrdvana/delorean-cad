/* This models the plastic vent inserts that fit between the dashboard
 * and the windshield.
 *
 * Orientation: +y is toward front of the car, +z upward, +x to the right
 * The origin of the model is x=centerline, y=windshield, z=top surface.
 * The vent is installed at an angle, but that is not reflected in this model.
 *
 * The "vent_cutout()" is a solid shape to be used when subtracting
 * a hole for the vent from some other solid.
 */

dash_vent_curve_dx= 251;          // distance from contact point to contact point of body against a ruler
dash_vent_curve_dy= 1.5;           // distance from midpoint of vent to ruler
dash_vent_body_upper_dy= 15.8;     // thickness of portion outside of fiberglass
dash_vent_body_end_rad= dash_vent_body_upper_dy / 2;
dash_vent_body_lower_dy= 13.3;     // thickness of portion through fiberglass
dash_vent_body_lower_dz= 12.2;     // height from base to fiberglass plane
dash_vent_body_horiz_dz= 21.5-5.4; // thickness of horizontal plastic that screws go through
dash_vent_body_fin_dz= 21.5-4.04;  // z-axis height of a fin
dash_vent_body_lower_wall_dy= 1.2; // thickness of vent wall.  upper half is thicker
dash_vent_flange_base_z= 12.4;     // z coordinate of bottom edge of flange
dash_vent_flange_base_y= -5.29;    // y coordinate of flange overhang
dash_vent_flange_angle= atan(17.1 / 25.11);
dash_vent_flange_dh= 30.3;         // hypotenuse distance
dash_vent_flange_thick=2.4;        // thickness of flange
dash_vent_flange_corner_rad= 25.11/2;
dash_vent_fin_thick= 2.05;
dash_vent_fin_slant_dz= 14.5;      // z-axis height of a fin
dash_vent_fin5_slant_dx= 16.2;     // x-axis travel of a fin
dash_vent_fin5_x_from_end= -27.5;   // x coordinate from end of body to near edge of final fin

module mirrored(vec) {
	children();
	mirror(vec) children();
}

/* 2D X is the Y of the 3D model and 2D Y is the Z of the 3D model.
 * Origin is on the short side of the base
 *
 *      /`
 *    /  |
 *  /_  _|
 *   |__|
 *
 */
module dash_vent_body_cross_section(
	curve_dx      = dash_vent_curve_dx,
	curve_dy      = dash_vent_curve_dy,
	body_upper_dy = dash_vent_body_upper_dy,
	body_end_rad  = dash_vent_body_end_rad,
	body_lower_dy = dash_vent_body_lower_dy,
	body_lower_dz = dash_vent_body_lower_dz,
	body_horiz_dz = dash_vent_body_horiz_dz,
	body_fin_dz   = dash_vent_body_fin_dz,
	body_lower_wall_dy= dash_vent_body_lower_wall_dy,
	flange_base_z = dash_vent_flange_base_z,
	flange_base_y = dash_vent_flange_base_y,
	flange_angle  = dash_vent_flange_angle,
	flange_dh     = dash_vent_flange_dh,
	flange_thick  = dash_vent_flange_thick,
	o=0.01,
	cutout=false
) {
	difference() {
		union() {
			// lower body
			square([ body_lower_dy, 100 ]);
			// upper body
			translate([ 0, body_lower_dz ]) square([ body_upper_dy, 20 ]);
			// if making a cutout, fill the overhang of the flange
			if (cutout)
				translate([ flange_base_y+cos(flange_angle)*flange_thick/2, flange_base_z ]) square([ 10, 10 ]);
			// flange
			translate([ flange_base_y+flange_thick/2, flange_base_z+flange_thick/2 ]) // outer "corner" of rounded flange
				rotate(flange_angle, [0,0,1])
					hull() {
						circle(r=flange_thick/2, $fn=40);
						translate([ flange_dh - flange_thick, 0 ]) circle(r=flange_thick/2, $fn=40);
						
						// if making a cutout, then add 1cm height to flange
						if (cutout) {
							translate([ -flange_thick/2, 0 ]) square([ flange_dh, 10 ]);
						}
					}
		}
		
		// If making a cutout, subtract off the surface of the flange + 1cm
		if (cutout) {
			translate([ flange_base_y+flange_thick/2, flange_base_z+flange_thick/2 ]) // outer "corner" of rounded flange
				rotate(flange_angle, [0,0,1])
					translate([ -10, 10-flange_thick/2 ]) square([ 100, 100 ]);
		}
		// else need to subtract out surface of flange and also inner area of air passage
		else {
			translate([ flange_base_y+flange_thick/2, flange_base_z+flange_thick/2 ]) // outer "corner" of rounded flange
				rotate(flange_angle, [0,0,1])
					translate([ -10, flange_thick/2 ]) square([ 100, 100 ]);
			translate([ body_lower_wall_dy, -o ])
				square([ body_lower_dy - body_lower_wall_dy*2, 100 ]);
		}
	}
}

module dash_vent(
	curve_dx      = dash_vent_curve_dx,
	curve_dy      = dash_vent_curve_dy,
	body_upper_dy = dash_vent_body_upper_dy,
	body_end_rad  = dash_vent_body_end_rad,
	body_lower_dy = dash_vent_body_lower_dy,
	body_lower_dz = dash_vent_body_lower_dz,
	body_horiz_dz = dash_vent_body_horiz_dz,
	body_fin_dz   = dash_vent_body_fin_dz,
	body_lower_wall_dy= dash_vent_body_lower_wall_dy,
	flange_base_y = dash_vent_flange_base_y,
	flange_base_z = dash_vent_flange_base_z,
	flange_angle  = dash_vent_flange_angle,
	flange_dh     = dash_vent_flange_dh,
	flange_thick  = dash_vent_flange_thick,
	flange_corner_rad= dash_vent_flange_corner_rad,
	fin_thick     = dash_vent_fin_thick,
	fin_slant_dz  = dash_vent_fin_slant_dz,
	fin5_slant_dx = dash_vent_fin5_slant_dx,
	fin5_x_from_end= dash_vent_fin5_x_from_end,
	o=0.01,
	cutout=false
) {
	// Convert the curve distance measurements to angle and radius:
	//   sin(angle)*rad = curve_dx/2;
	//   (1-cos(angle))*rad = curve_dy;
	//
	curve_a= 180 - 2 * atan( curve_dx/2 / curve_dy );
	curve_rad= curve_dy / (1-cos(curve_a));
	
	fin_dy= body_lower_dy - o*2;

	// Entire shape is mirrored across centerline
	mirrored([1,0,0]) {
		difference() {
			union() {
				// extrude from centerline to point at which the body starts to curve
				translate([ 0, -curve_rad, 0 ]) {
					step= 10;
					extrude(convexity=6) for(i=[0:step], union=false)
						rotate(-curve_a * i/step, [0,0,1]) translate([ 0, curve_rad, 0 ])
							rotate(-90, [0,0,1]) rotate(90, [1,0,0]) mirror([0,0,1]) dash_vent_body_cross_section(cutout=cutout);
				
					// This rotate_extrude should work, but gives an error on final rendering
					//mirror([1,0,0]) rotate(90, [0,0,1]) rotate_extrude(angle=curve_a, convexity=6, $fa=.1, $fn=10000)
					//	translate([ curve_rad, 0 ])
					//		mirror([1,0,0]) dash_vent_body_cross_section(cutout=cutout);
				}
				
				// translate to outer edge to draw the corners
				translate([ 0, -curve_rad, 0 ]) rotate(-curve_a, [0,0,1]) translate([ 0, curve_rad, 0 ]) {
					// half-cylinder of the base
					intersection() {
						translate([ 0, -body_upper_dy/2, body_lower_dz ]) cylinder(r=body_upper_dy/2, h=15);
						translate([ 0, -50, -1 ]) cube([ 100, 100, 100 ]); // +x space
						
						// if not making a cutout, clip the cylinder at the top surface of the flange
						if (!cutout) {
							translate([ 0, -flange_base_y-flange_thick/2, flange_base_z+flange_thick/2 ]) rotate(-flange_angle, [1,0,0])
								translate([ 0, -40, -40 ]) cube([ 40, 40, 40 ]);
						}
					}
					// half cylinder of the flange intersected with the plane of the flange
					intersection() {
						hull() {
							translate([ 0, -body_upper_dy/2, 0 ]) cylinder(r=flange_corner_rad, h=100);
							translate([ 0, -body_upper_dy/2 + 20, 0 ]) cube([ flange_corner_rad, 20, 50 ]);
						}
						translate([ 0, -50, -1 ]) cube([ 100, 100, 100 ]); // +x space
						// step into the plane of the flange
						hull() {
							translate([ 0, -flange_base_y-flange_thick/2, flange_base_z+flange_thick/2 ]) rotate(-flange_angle, [1,0,0]) {
								// Make a hull of the outer edge
								rotate(90, [0,1,0]) cylinder(r=flange_thick/2, h=flange_corner_rad);
								translate([ 0, -flange_dh + flange_thick, 0 ])
									rotate(90, [0,1,0]) cylinder(r=flange_thick/2, h=flange_corner_rad);
								
								// if making a cutout, add 1cm height to flange
								if (cutout) {
									translate([ 0, -flange_dh + flange_thick/2, -flange_thick/2 ]) cube([ flange_corner_rad, flange_dh, 10 ]);
								}
							}
						}
					}
					
					// If not a cutout, add interior fins
					if (!cutout) {
					}
				}
			}
			// Subtract the angled edge of the lower vent
			translate([ 0, -curve_rad, 0 ]) rotate(-curve_a, [0,0,1]) translate([ 0, curve_rad, 0 ]) {
				translate([ body_end_rad + fin5_x_from_end + fin5_slant_dx*(body_lower_dz/fin_slant_dz), -body_lower_dy - 5, 0 ]) {
					cube([ 20, 20, body_lower_dz-o ]);
					translate([ 0, 0, body_lower_dz ]) rotate( -atan(fin_slant_dz / fin5_slant_dx), [0,1,0])
						translate([ -50, 0, -50 ]) cube([ 50, 50, 50 ]);
				}
			
				// If not making a cutout, subtract the corner screw wells and holes
				
			}
		}
	}
}

