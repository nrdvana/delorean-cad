__="NA";
dash_mount_slices= [
  // x     windshield  fbase    ledge_u1    ledge_l1   ledge_u2   ledge l2   front      lip
  [ -738,  193,  34,   155, 3,   __,   __,   __,  __,   __,  __,   __,  __,   __,  __,   __,   __ ],
  [ -711,  210,  34,   170, 3,   __,   __,   __,  __,   __,  __,   __,  __,   __,  __,   __,   __ ],
  [ -684,  223,  31.5, 179, 3,   __,   __,   __,  __,   48,   3,   40,   0,   35,   0,   __,   __ ],
  [ -650,  228,  31,   189, 3,   __,   __,   __,  __,   48,   3,   40,   0,  -32,   0,  -47,  -30   ],
  [ -635,  233.5,29.5, 200, 7.5,200,    9,  192,   3,   48,   3,   40,   0,  -30,   0,  -45.5,-26.5 ],
  [ -607,  241  ,29,   204, 9,  200,    9,  190,   3,   48,   3,   40,   0,  -28.5, 0,  -43,  -27   ],
  [ -600,  243  ,28,   209, 9,  200,    9,  189,   3,   48,   3,   40,   0,  -28,   0,  -41.5,-26.5 ],
  [ -595,  245,  27,   212, 9,  200,    9,  188,   3,   48,   3,   40,   0,  -27.5, 0,  -41,  -26.5 ],
  [ -512,  254,  29,   222, 9,  185,    9,  177,   3,   48,   3,   40,   0,  -18,   0,  -30,  -30   ],
  [ -491,  257,  29,   224, 9,  184,    9,  176,   3,   48,   3,   40,   0,    5,   0,   -1.9,-12.5 ],  
  [ -460,  258.7,29,   227, 9,  185,    9,  177,   3,   48,   3,   40,   0,    5,   0,   -1.9,-12.5 ],
  [ -302,  274,  24.8, 247, 9,  199,    9,  191,   3,   48,   3,   40,   0,    5,   0,   -1.9,-12.5 ],
  [ -300,  275,  25,   247, 9,  199.1,  9,  191.1, 3,   48,   3,   40,   0,    5,   0,   -1.9,-12.5 ],
  [ -290,  273,  26,   245.7,9, 200,    9,  192,   3,   48,   3,   40,   0,    5,   0,   -1.9,-12.5 ],
  [ -273,  275,  26,   246, 9,  201.5,  9,  193.5, 3,   48,   3,   40,   0,    5,   0,   -1.9,-12.5 ],
  [ -254,  276,  25,   248, 9,  202,    9,  194,   3,   48,   3,   40,   0,   -3.7, 0,  -18,  -29   ],
  [ -162,  281,  24.5, 252, 9,  206,    9,  198,   3,   50,   3,   42,   0,   -3.7*(162-114)/(254-114), 0,  -16-2*(162-130)/(254-130), -29 ],
  [ -151,  281,  23,   257, 9,  206.3,  9,  198.3, 3,   51,   3,   43,   0,   -3.7*(151-114)/(254-114), 0,  -16-2*(151-130)/(254-130), -29 ],
  [ -130,  282,  23,   257, 9,  207,    9,  199,   3,   55.5, 3,   47.5, 0,   -3.7*(130-114)/(254-114), 0,  -16, -29 ],
  [ -114,  282.5,23,   257, 9,  208,    9,  200,   3,   59.5, 3,   51.5, 0,    0,   0,  -11,  -17.5 ],
  [    0,  282.6,24,   257, 9,  209.5,  9,  201.5, 3,  103,   3,   95,   0,    0,   0,  -11,  -17.5 ],
];
dash_mount_left_edge= [ [ -650, -32 ], [ -711, 93 ] ];
dash_mount_fbglass_thick=2.8;

module dash_mount() {
	ws_y_arc_rad= 355961/88;
	ws_y_arc_origin_y= 282.6 - ws_y_arc_rad;
	difference() {
		extrude(convexity=6) {
			for (slice= dash_mount_slices, union= false) {
				slice_x= slice[0];
				slice_ws= [ slice[1], slice[2] ];
				slice_fbase=    slice[5] == "NA"? [ slice[3]-.0, slice[4]+.3 ] : [ slice[3], slice[4] ];
				slice_ledge_u1= slice[5] == "NA"? [ slice[3]-.1, slice[4]+.1 ] : [ slice[5], slice[6] ];
				slice_ledge_l1= slice[7] == "NA"? [ slice[3]-.3, slice[4]+.0 ] : [ slice[7], slice[8] ];
				slice_ledge_u2= slice[9] == "NA"? [ 48, 3 ] : [ slice[9], slice[10] ];
				slice_ledge_l2=slice[11] == "NA"? [ 40, 0 ] : [ slice[11], slice[12] ];
				slice_front=   slice[13] == "NA"? [ 35, 0 ] : [ slice[13], slice[14] ];
				slice_lip=     slice[15] == "NA"? [ 35, -3 ] : [ slice[15], slice[16] ];
				slice_lip_back= [ slice_lip[0] + dash_mount_fbglass_thick, slice_lip[1] ];
				slice_front_back= [ slice_front[0] + dash_mount_fbglass_thick, slice_front[1] - dash_mount_fbglass_thick ];
				slice_ws_front_a= asin(slice_x / ws_y_arc_rad);
				slice_ws_front_y= ws_y_arc_origin_y + cos(slice_ws_front_a)*(ws_y_arc_rad+15);
				poly= [ slice_ws, slice_fbase,
					slice_ledge_u1, slice_ledge_l1, slice_ledge_u2, slice_ledge_l2,
					slice_front, slice_lip, slice_lip_back, slice_front_back,
					[100, -dash_mount_fbglass_thick],
					[slice_ws_front_y, -dash_mount_fbglass_thick], [slice_ws_front_y, 0]
				];
				
				translate([ slice[0], 0, 0 ]) rotate(90, [0,0,1]) rotate(90, [1,0,0]) {
					echo(poly);
					polygon(points=poly, convexity=6);
				}
			}
		}
		
		// clip off left and right edge
		translate([0,0,-50]) linear_extrude(height=55) {
			polygon([ each(dash_mount_left_edge), [-800,dash_mount_left_edge[1][1]], [-800,-50], [dash_mount_left_edge[0][0],-50] ]); 
		}
		
		// round off the left-hand lip corner
		corner_rad= 15;
		corner_p=[ dash_mount_slices[3][0], dash_mount_slices[3][15], dash_mount_slices[3][16] ];
		translate(corner_p)
			difference() {
				translate([ -10, -50, -10 ]) cube([ 10 + corner_rad, 100, 10 + corner_rad ]);
				translate([ corner_rad, 51, corner_rad ]) rotate(90, [1,0,0]) cylinder(r=corner_rad,h=102);
			}
	}
}
rotate(18.5, [1,0,0])
	dash_mount();
