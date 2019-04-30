// Connector
o= 0.001;
conn_pincount= 6;
conn_pin_spacing= 5.85;
conn_back_dx= 48.53 - (conn_pin_spacing * 2);
conn_back_dy= 18.58;
conn_back_dz= 10.54;
conn_lip_dz= 2.11;
conn_lip_dy= 3.27;
conn_lip_dx= 56.68 - (conn_pin_spacing * 2);
conn_lip_width= 21.58;
conn_front_dx= 50.17 - (conn_pin_spacing * 2);
conn_front_flange_left= 16.47;
conn_front_flange_right= 20.11;
conn_pinarea_dx= conn_back_dx-0.3;
conn_pinarea_dy_back= 13.79;
conn_pinarea_dy_front= 11.51;
conn_pinarea_dz= 10.60;
conn_pin_dx= 3.74;
conn_pin_dy= 1.5+(conn_pinarea_dy_back-conn_pinarea_dy_front)/2;
conn_pin_dx2= 2;
conn_pin_dy2= 2.6+(conn_pinarea_dy_back-conn_pinarea_dy_front)/2;
conn_pin_hole_rad= 1.4/2;
conn_pin_bucket_dx= 4;
conn_pin_bucket_dy= conn_pin_dy2;
conn_side_indent_right= 9.67;
conn_side_indent_left= 10.16;
conn_side_indent_depth= 1;
conn_front_key_y= conn_back_dy/2;
conn_front_key_dy= (23.05-21.58) + (21.58-conn_back_dy)/2;
conn_front_key_dx= 1.85;
conn_front_key_dz= conn_back_dz + conn_lip_dz;
conn_front_key_x= conn_pinarea_dx/2 - 6.10 - conn_front_key_dx;
conn_clip_gap= (58.25 - conn_back_dx - (conn_pin_spacing*2))/2 * .75;
conn_clip_thick= conn_clip_gap / 3;
conn_clip_dy_left= 9.82;
conn_clip_dy_right= 8.54;
conn_clip_tip_dz= 10.33;
conn_clip_dz= conn_back_dz+conn_lip_dz+4.41+conn_clip_tip_dz;

module conn_front_quarter_pin_holes() {
	for (i= [0:2]) { 
		translate([conn_pin_spacing*i + (conn_pin_spacing-conn_pin_dx)/2, conn_pinarea_dy_back/2-conn_pin_dy,-50])
			cube([conn_pin_dx,conn_pin_dy+0.01,100]);
		translate([conn_pin_spacing*i + (conn_pin_spacing-conn_pin_dx2)/2, conn_pinarea_dy_back/2-conn_pin_dy2+0.01,-50])
			cube([conn_pin_dx2,conn_pin_dy2+0.01,100]);
	}
}

module conn_front_quarter_pin_area() {
	difference() {
		cube([conn_front_dx/2, conn_front_flange_right/2, conn_pinarea_dz]);
		translate([-1, conn_pinarea_dy_back/2, 0])
			rotate(asin((conn_pinarea_dy_back-conn_pinarea_dy_front)/2/conn_pinarea_dz), [1,0,0]) {
				cube([1+conn_pinarea_dx/2, 10, conn_pinarea_dz+5]);
			}
		translate([-1, conn_pinarea_dy_back/2, 0])
			cube([1+conn_pinarea_dx/2, 10, 10]);
		conn_front_quarter_pin_holes();
	}
}

module conn_front() {
	difference() {
		union() {
			translate([-0.001,0, 0]) conn_front_quarter_pin_area();
			mirror([1,0,0]) conn_front_quarter_pin_area();
			mirror([0,1,0]) translate([-0.001,0, 0]) conn_front_quarter_pin_area();
			mirror([0,1,0]) mirror([1,0,0]) conn_front_quarter_pin_area();
		}
		translate([-conn_back_dx/2-5, conn_front_flange_left/2, 0])
			cube([10, 5, 50]);
		mirror([0,1,0])
			translate([-conn_back_dx/2-5, conn_front_flange_left/2, 0])
				cube([10, 5, 50]);
	}
}

module conn_back_pinslots() {
	for (i= [0:3]) { 
		translate([ conn_pin_spacing*i + conn_pin_spacing/2, conn_pinarea_dy_back/2 - conn_pin_dy - conn_pin_hole_rad/3, -o ])
			cylinder(r=conn_pin_hole_rad, h=100, $fn=100);
		translate([ conn_pin_spacing*i + conn_pin_spacing/2 - conn_pin_bucket_dx/2, conn_pinarea_dy_back/2 - conn_pin_bucket_dy, -o ])
			cube([ conn_pin_bucket_dx, 100, conn_back_dz*3/4 ]);
	}
}

module conn_back() {
	difference() {
		union() {
			translate([-conn_lip_dx/2, conn_lip_width/2 - conn_lip_dy, conn_back_dz])
				color("silver")
					cube([conn_lip_dx, conn_lip_dy, conn_lip_dz]);
			mirror([ 0, 1, 0 ])
				translate([-conn_lip_dx/2, conn_lip_width/2 - conn_lip_dy, conn_back_dz])
					color("silver")
						cube([conn_lip_dx, conn_lip_dy, conn_lip_dz]);
			translate([-conn_back_dx/2, -conn_back_dy/2, 0])
				color("silver")
					cube([ conn_back_dx, conn_back_dy, conn_back_dz+conn_lip_dz ]);
		}
		conn_back_pinslots();
		mirror([ 1, 0, 0 ]) conn_back_pinslots();
		mirror([ 0, 1, 0 ]) conn_back_pinslots();
		mirror([ 1, 0, 0 ]) mirror([ 0, 1, 0 ]) conn_back_pinslots();
	}
}

module side_indent(width) {
	translate([conn_back_dx/2, -width/2, conn_back_dz])
		rotate(asin(-conn_side_indent_depth / conn_pinarea_dz), [0,1,0])
			cube([ conn_clip_gap, width, 100 ]);
}

module sideclip(width) {
	// Start with origin at side edge of clip
	translate([ 0, -width/2, ])
	difference() {
		// start with a solid shaft and cylindrical hinge
		union() {
			difference() {
				translate([conn_back_dx/2+conn_clip_gap/2, 0, 0])
					rotate(-90, [1,0,0])
						cylinder(r=conn_clip_gap/2 + conn_clip_thick, h=width, $fn=100);
				translate([0, -o, o])
					cube([30,30,10]);
			}
			translate([conn_back_dx/2+conn_clip_gap, 0, 0])
				cube([conn_clip_thick*4, width, conn_clip_dz]);
		}

		// Carve out the inner radius of the hinge
		translate([conn_back_dx/2+conn_clip_gap/2, -o, 0])
			rotate(-90, [1,0,0])
				cylinder(r=conn_clip_gap/2, h=width+o*2, $fn=100);

		// Carve off the top, creating a pointed ramp
		translate([conn_back_dx/2+conn_clip_gap+0.5, -o, conn_clip_dz])
			mirror([1,0,0]) rotate(-165, [0, 1, 0])
				cube([ 10, width+o+o, conn_clip_tip_dz*1.5 ]);

		// carve out the gap between connector and clip
		translate([conn_back_dx/2+conn_clip_gap+conn_clip_thick, -o, -o])
			cube([ 10, 10, conn_clip_dz-conn_clip_tip_dz + o*2 ]);
	}
}

module connector() {
	difference() {
		union() {
			translate([ 0, 0, conn_back_dz + conn_lip_dz ])
				conn_front();
			conn_back();
		}
		side_indent(conn_side_indent_right);
		mirror([ 1, 0, 0 ]) side_indent(conn_side_indent_left);
	}
	sideclip(conn_clip_dy_right);
	mirror([ 1, 0, 0 ]) sideclip(conn_clip_dy_left);
}

//difference() {
connector();
//mirror([0,1,0]) translate([-conn_back_dx/2-conn_clip_gap/2, -50, conn_back_dz-o]) cube([ conn_back_dx+conn_clip_gap, 100, 100 ]);
//mirror([0,1,0]) 
//translate([-50, 0, -50]) cube([ 100, 100, 100 ]);
//mirror([0,1,0]) translate([-50, -conn_side_indent_left/2, conn_back_dz-o]) mirror([0,1,0]) cube([ 100, 100, 100 ]);
//}
