module metric_screw(len=10, pitch=.8, diam=5, $fn=20) {
	height=.866*pitch;
	poly=[ // x tracks "height" and y tracks "pitch"
		[diam/2-height, 0 ],
		// This draws a sawtooth with as many iterations needed to cover the 'len'
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
			// Extrude each half of the screw separately, and let "Union" work its magic to
			// assemble them.  Can't be done in a single 360* extrusion because it would end
			// with two faces facing eachother on same plane.
			extrude(convexity=10) for(t=[0:ceil($fn/2)], union=false)
				translate([0,0,(t/$fn-1)*pitch]) rotate(t*360/$fn, [0,0,1]) rotate(90, [1,0,0]) polygon(points=poly);
			extrude(convexity=10) for(t=[ceil($fn/2):$fn], union=false)
				translate([0,0,(t/$fn-1)*pitch]) rotate(t*360/$fn, [0,0,1]) rotate(90, [1,0,0]) polygon(points=poly);

			// That extrusion needed a hollow center, else there would be polygons at the axis
			// of the extrusion that "went sideways" (all points along same vector)
			// So, fill the center with a cylinder.
			cylinder(r=diam/2-height*3/4, h=len);
		}

		// Clip the above to the exact requested length
		cylinder(r=diam,h=len);
	}
}

metric_screw();
