module m_screw_cutout(len=10, pitch=.8, diam=5, $fn=20) {
	height=.866*pitch;
	poly=[ // x tracks "height" and y tracks "pitch"
		[diam/2-height, 0 ],
		for (t=[0:ceil(len/pitch)]) each([
			[ diam/2             , pitch*t + 0 ],
			[ diam/2             , pitch*t + pitch* 2/16 ],
			[ diam/2 - height*5/8, pitch*t + pitch* 7/16 ],
			[ diam/2 - height*5/8, pitch*t + pitch*11/16 ],
		]),
		[diam/2-height, pitch*ceil(len/pitch) + pitch*11/16 ]
	];
	intersection() {
		union() {
			cylinder(r=diam/2-height*3/4, h=len);
			extrude(convexity=10) for(t=[0:ceil($fn/2)], union=false)
				translate([0,0,(t/$fn-1)*pitch]) rotate(t*360/$fn, [0,0,1]) rotate(90, [1,0,0]) polygon(points=poly);
			extrude(convexity=10) for(t=[ceil($fn/2):$fn], union=false)
				translate([0,0,(t/$fn-1)*pitch]) rotate(t*360/$fn, [0,0,1]) rotate(90, [1,0,0]) polygon(points=poly);
		}
		cylinder(r=diam,h=len);
	}
}

module steering_adapter_6bolt(
	$fn=180,
	o=0.01
) {
	face_rad=85.2/2;          // steering wheel surface
	face_thick=8.5;           // thickness of steering wheel surface, i.e. depth of screw threads
	momo_rad=70/2;
	nardi_rad=73.6/2;
	screw_hole_rad=5/2 - .866*.8*5/8;
	base_rad=90/2;            // where shell meets steering column
	outer_wall_dz=82.9;       // the distance from steering column to steering wheel
	outer_wall_thick=3.1;     // thickness of metal of outer wall
	hollow_ledge_depth=10;    // the first 10mm depth of the pocket is a larger radius than the rest
	hollow_rad1=57.7/2;       // radius of pocket at at steering wheel
	hollow_rad2=56.9/2;       // and the forst 10mm slopes a little
	hollow_rad3=53.9/2;       // the remainder of the pocket appears to be a constant radius
	hollow_depth=64.75;       // overall depth of pocket
	hollow_outer_rad=62.35/2; // the pocket is a separate cylinder from the outer wall
	hollow_base_z=8;          // the lower Z coordinate of the base of the pocket
	hollow_inner_z=outer_wall_dz - hollow_depth;
	wire_gap_dx=11.6;
	wire_gap_y=base_rad-outer_wall_thick-18.3;
	wire_gap_z=hollow_base_z;
	wire_gap_dy=17;
	wire_gap_dz=13.5;
	brace_angle=atan(8.4/hollow_outer_rad);
	brace_dx=3.4;
	brace_z=18.2;
	core_ring1_dz=5;          // this ring fits against the steering column
	core_ring1_rad=34.7/2;
	core_ring1_slot_dx=3.9;
	core_ring1_slot_rad=23.4/2;
	core_ring1_slot_angles=[ 0, 180, atan(9.7/core_ring1_slot_rad), -atan(9.7/core_ring1_slot_rad) ];
	core_ring2_dz=10.1;       // this ring sits between ring1 and the base of the pocket
	core_ring2_rad=43.75/2;
	core_ring1_z=hollow_base_z - core_ring2_dz - core_ring1_dz;
	core_ring2_z=hollow_base_z - core_ring2_dz;
	tspeg_rad=3.25/2;         // turn signal peg reaches down from ring2
	tspeg_dz=14;
	tspeg_y=core_ring1_slot_rad + tspeg_rad;

	shaft_rad=18.7/2;
	spline_teeth=36;          // standard "GM" 36-tooth spline
	spline_dz=8.64;           // length of shaft with spline teeth.
	spline_z=hollow_inner_z-spline_dz;
	spline_tooth_height=.85;  // Not a good measurement...
	spline_polygon=[
		for(i=[0:spline_teeth-1]) each([
			[ sin(i*(360/spline_teeth))*shaft_rad, cos(i*(360/spline_teeth))*shaft_rad ],
			[ sin((i+.5)*(360/spline_teeth))*(shaft_rad-spline_tooth_height), cos((i+.5)*(360/spline_teeth))*(shaft_rad-spline_tooth_height) ]
		])
	];

	// Outer shell
	difference() {
		// Main cylinder
		cylinder(r2=face_rad, r1=base_rad, h=outer_wall_dz);
		
		// Minus first step of hollow
		translate([ 0, 0, outer_wall_dz-hollow_ledge_depth ])
			cylinder(r1=hollow_rad2, r2=hollow_rad1, h=hollow_ledge_depth+o);

		// Minus empty space in shell
		translate([0, 0, -o]) cylinder(r2=face_rad-outer_wall_thick, r1=base_rad-outer_wall_thick, h=outer_wall_dz-face_thick+o);

		// Minus screw holes
		for (a=[0:5]) {
			// Momo
			rotate(a*60, [0,0,1]) translate([ 0, momo_rad, outer_wall_dz - face_thick - o ])
				cylinder(h=face_thick+o*2, r=screw_hole_rad);
				//m_screw_cutout(len=face_thick+o*2, $fn=8);
			// Nardi
			rotate(30+a*60, [0,0,1]) translate([ 0, nardi_rad, outer_wall_dz - face_thick - o ])
				cylinder(h=face_thick+o*2, r=screw_hole_rad);
				//m_screw_cutout(len=face_thick+o*2, $fn=8);
		}
	}
	
	// Inner core
	difference() {
		union() {
			translate([ 0, 0, hollow_base_z ])
				cylinder(r=hollow_outer_rad, h=outer_wall_dz-hollow_base_z);
			// first ring
			translate([ 0, 0, core_ring1_z ])
				cylinder(r=core_ring1_rad, h=core_ring1_dz+o);
			// second ring
			translate([ 0, 0, core_ring2_z ])
				cylinder(r=core_ring2_rad, h=core_ring2_dz+o);
		}

		// Minus first step of hollow
		translate([ 0, 0, outer_wall_dz-hollow_ledge_depth ])
			cylinder(r1=hollow_rad2, r2=hollow_rad1, h=hollow_ledge_depth+o);

		// Minus remainder of hollow
		translate([ 0, 0, outer_wall_dz-hollow_depth ])
			cylinder(r=hollow_rad3, h=hollow_depth+o);
		
		// Minus spline shaft
		linear_extrude(height=hollow_inner_z+o, convexity=10)
			polygon(points=spline_polygon);
		
		// Minus shaft
		translate([ 0, 0, core_ring1_z-o ]) cylinder(r=shaft_rad, h=spline_z - core_ring1_z + o);
		
		// Minus slots in ring1
		translate([ 0, 0, core_ring1_z-o ]) {
			for (a=core_ring1_slot_angles)
				rotate(a, [0,0,1]) translate([ -core_ring1_slot_dx/2, core_ring1_slot_rad, 0 ])
					cube([ core_ring1_slot_dx, core_ring1_slot_rad, core_ring1_dz ]);
		}
		
		// Minus wire gap
		translate([ -wire_gap_dx/2, wire_gap_y, wire_gap_z-o ])
			cube([ wire_gap_dx, wire_gap_dy, wire_gap_dz+o ]);
	}
	// turn signal pegs
	translate([ 0,  tspeg_y, core_ring2_z - tspeg_dz ]) cylinder(r=tspeg_rad, h=tspeg_dz+o);
	translate([ 0, -tspeg_y, core_ring2_z - tspeg_dz ]) cylinder(r=tspeg_rad, h=tspeg_dz+o);
	
	// brace between outer wall and core
	for (a=[brace_angle,180+brace_angle])
		rotate(a, [0,0,1]) translate([ -brace_dx/2, hollow_outer_rad-o, brace_z ])
			cube([ brace_dx, base_rad - outer_wall_thick - hollow_outer_rad, outer_wall_dz - brace_z ]);
}

steering_adapter_6bolt();