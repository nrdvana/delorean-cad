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

dash_vent_flange_dx=275;
dash_vent_flange_dy=30.3;
dash_vent_flange_dz=2.4;
dash_vent_flange_overhang_y=4.54;
dash_vent_flange_overhang_x=3.45;
dash_vent_flange_corner_rad=11.4;
dash_vent_corner_rad= 7.1;
dash_vent_body_angle= 40; // relative to top flange surface
dash_vent_body_dy= dash_vent_corner_rad*2; // in the coordinate space of the body
dash_vent_body_dz= 30; // in the coordinate space of the body TODO: measure
dash_vent_body_wall_thick= 2;
dash_vent_mount_angle= 50; // relative to top flange surface
dash_vent_flange_curve_dz= 1.1; // height of middle above ends, in the (non-)plane of the flange
dash_vent_flange_curve_dy= 1.4; // depth of front beyond ends, in the (non-)plane of the flange

module mirrored(vec) {
	children();
	mirror(vec) children();
}

module dash_vent(
	flange_dx=         dash_vent_flange_dx,
	flange_dy=         dash_vent_flange_dy,
	flange_dz=         dash_vent_flange_dz,
	flange_overhang_y= dash_vent_flange_overhang_y,
	flange_overhang_x= dash_vent_flange_overhang_x,
	flange_corner_rad= dash_vent_flange_corner_rad,
	corner_rad=        dash_vent_corner_rad,
	body_angle=        dash_vent_body_angle,
	body_dy=           dash_vent_body_dy,
	body_dz=           dash_vent_body_dz,
	body_wall_thick=   dash_vent_body_wall_thick,
	mount_angle=       dash_vent_mount_angle,
	flange_curve_dz=   dash_vent_flange_curve_dz,
	flange_curve_dy=   dash_vent_flange_curve_dy,
	o=0.00,
	cutout=false
) {
	// Convert the flange_curve_* distance measurements to angles and radiuses.
	//   sin(za)*zr = ((flange_dx/2)-corner_rad); (1-cos(za))*zr = flange_curve_dy;
	//   sin(ya)*yr = flange_dx/2; (1-cos(ya))*yr = flange_curve_dz;
	//
	za = 180 - 2 * atan( ((flange_dx/2)-flange_corner_rad) / flange_curve_dy );
	zr = flange_curve_dy / (1-cos(za));
	ya = 180 - 2 * atan( (flange_dx/2) / flange_curve_dz );
	yr = flange_curve_dz / (1-cos(ya));
	steps= floor($fn/4)+1;
	echo("za",za,"zr",zr,"ya",ya,"yr",yr,"fn",$fn,"steps",steps);
	
	// Entire shape is mirrored across centerline
	mirrored([1,0,0]) {
		// from origin at [center,windshield,top], the end has rotated toward 

		// extrude from centerline out to this angle, first rotating around z axis
		// and then around y axis.
		//steps= floor($fn/360*(ya+za)/2)+1;
		extrude(convexity=4) for (t=[0:steps], union= false) {
			translate([ 0,-zr,0 ]) rotate(-za*(t/steps), [0,0,1]) translate([ 0,zr,0 ])
				translate([ 0,0,-yr ]) rotate(ya*(t/steps), [0,1,0]) translate([ 0,0,yr ])
					// rotate into yz plane.  The entire model occurs in -y,-z space,
					// so invert axes for convenience.  From here on, x is downward z
					// and y is -y.
					rotate(-90, [0,1,0]) mirror([1,0,0]) mirror([0,1,0]) mirror([0,0,1]) {
						difference() {
							union() {
								square([flange_dz, flange_dy]);
								intersection() {
									translate([ flange_dz-o, flange_dy - flange_overhang_y ]) rotate(-body_angle, [0,0,1])
										translate([ 0, -body_dy ]) square([ body_dz, body_dy ]);
									translate([ o, -100 ])
										square([ 500, 500 ]);
								}
							}
							if (!cutout) {
								translate([ flange_dz-o, flange_dy - flange_overhang_y ]) rotate(-body_angle, [0,0,1])
									translate([ -100, -body_dy + body_wall_thick ]) square([ body_dz+200, body_dy - body_wall_thick*2 ]);
							}
						}
					}
		}
		
		// Now from that angle, draw the rounded end
		translate([ 0,-zr,0 ]) rotate(-za, [0,0,1]) translate([ 0,zr,0 ])
			translate([ 0,0,-yr ]) rotate(ya, [0,1,0]) translate([ 0,0,yr ])
				// truncate to +x -z space
				intersection() {
					translate([ 0, -300, -400 ]) cube([ 400, 400, 400 ]);
					difference() {
						union() {
							// rounded flange
							hull() {
								translate([ 0, -flange_dy+flange_corner_rad, -flange_dz ]) cylinder(r= flange_corner_rad, h=flange_dz);
								translate([ 0, 0, -flange_dz ]) cube([ flange_corner_rad, 1, flange_dz ]);
							}
							// rounded body
							translate([ 0, -flange_dy+flange_overhang_y, -flange_dz ])
								rotate(body_angle, [1,0,0])
									translate([ 0, body_dy/2, -body_dz ])
										cylinder(r=body_dy/2, h=body_dz);
						}
						if (!cutout) {
							// hole in rounded body
							translate([ 0, -flange_dy+flange_overhang_y, -flange_dz ])
								rotate(body_angle, [1,0,0])
									translate([ 0, body_dy/2, -body_dz-1 ])
										cylinder(r=body_dy/2 - body_wall_thick, h=body_dz+2);
						}
					}
				}
	}
}
