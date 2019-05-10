__="NA";
dash_mount_slices= [
  // x     windshield  fbase    ledge_u1    ledge_l1   ledge_u2   ledge l2   front      lip
  [ -738,  193,  34+3,   155, 3,   __,   __,   __,  __,   __,  __,   __,  __,   __,  __,   __,   __ ],
  [ -711,  208,  34+3,   170, 3,   __,   __,   __,  __,   __,  __,   __,  __,   __,  __,   __,   __ ],
  [ -684,  213,  29+3,   179, 3,   __,   __,   __,  __,   48,   3,   40,   0,   35,   0,   __,   __ ],
  [ -650,  226,  28+3,   189, 3,   __,   __,   __,  __,   48,   3,   40,   0,  -32,   0,  -47,  -30 ],
  [ -635,  
  [ -610,
  [ -600, 
];
dash_mount_left_edge= [ [ -711, 93 ], [ -650, -32 ] ];

module dash_mount() {
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
			slice_rear= [ slice_ws[0], slice_lip[1] ];
			poly= [ slice_ws, slice_fbase, slice_ledge_u1, slice_ledge_l1, slice_ledge_u2, slice_ledge_l2, slice_front, slice_lip, slice_rear ];
			
			translate([ slice[0], 0, 0 ]) rotate(90, [0,0,1]) rotate(90, [1,0,0]) {
				echo(poly);
				polygon(points=poly, convexity=6);
			}
		}
	}
}

dash_mount();
