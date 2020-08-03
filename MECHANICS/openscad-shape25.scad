$fn=90;
 
//Example:
//points = [ [0,0], [20,0], [10,10],[20,20], [30,20]];
//rayons = [ 0.5, 2, 4, 20, 0.5 ];
//e = 1;
//h=10;

//shape25(points, rayons, h);

//translate([30,0,0])
//	shape25(points, rayons, e);//, h);
//
//translate([60,0,0])
//	oshape25(points, rayons, e, h);

// Open shape
module oshape25(points, radiuses, thickness, height) {

	// Calculate the angle relative to 0X perpendicular to the segment defined
	// by the two first points
	angPS = atan2( - (points[1][0]-points[0][0]) , 
					(points[1][1]-points[0][1]) );
	
	// calculate the points coordinates (intersection of the perpendicular 
	// and the circle of radius thickness/2)
	PSA = points[0] + [cos(angPS) * thickness/2, sin(angPS) * thickness/2];
	PSB = points[0] - [cos(angPS) * thickness/2, sin(angPS) * thickness/2];
	
	// Calculate the angle relative to 0X perpendicular to the segment defined
	// by the two last points
	angPE = atan2( - (points[len(points)-1][0]-points[len(points)-2][0]) , 
					 (points[len(points)-1][1]-points[len(points)-2][1]) );
	
	// calculate the points coordinates (intersection of the perpendicular 
	// and the circle of radius thickness/2)
	PEA = points[len(points)-1] + [cos(angPE) * thickness/2, sin(angPE) * thickness/2];
	PEB = points[len(points)-1] - [cos(angPE) * thickness/2, sin(angPE) * thickness/2];;
	
	pts = points;
	
	// Build the new vector of points
    ptPoly1A = concat ( [PSA],
						[ for(i = [0 : len(pts)-3])
							let(
								Cx = arc( pts[i], pts[i+1], pts[i+2], thickness/2 )[0],
								Cy = arc( pts[i], pts[i+1], pts[i+2], thickness/2 )[1],
								signCross = arc(pts[i], pts[i+1], pts[i+2], thickness)[2],
								ptX = signCross < 0 ? 2 * points[i+1][0] - Cx: Cx,
								ptY = signCross < 0 ? 2 * points[i+1][1] - Cy: Cy
								)
						  [ptX,ptY] 
						]
					);
						
    ptPoly1B = concat ( ptPoly1A, [PEA], [PEB],
						[ for(i = [len(pts)-3 : -1: 0])
							let(
								Cx = arc( pts[i], pts[i+1], pts[i+2], thickness/2 )[0],
								Cy = arc( pts[i], pts[i+1], pts[i+2], thickness/2 )[1],
								signCross = arc(pts[i], pts[i+1], pts[i+2], thickness)[2],
								ptX = signCross >= 0 ? 2 * points[i+1][0] - Cx: Cx,
								ptY = signCross >= 0 ? 2 * points[i+1][1] - Cy: Cy
								)
						  [ptX,ptY] 
						]
					);	
	
	// Final polygon
	ptPoly = concat ( ptPoly1B,	[PSB] );

	// Calculate the radius with the good order					
	rdPoly = concat ( radiuses[0], 
					  [ for(i = [1: len(radiuses)-2])
							let(
								dxAB = pts[i-1][0] - pts[i][0], 
								dyAB = pts[i-1][1] - pts[i][1],
								dxBC = pts[i+1][0] - pts[i][0], 
								dyBC = pts[i+1][1] - pts[i][1],
								signCross = sign(cross([dxAB, dyAB, 0],[dxBC, dyBC, 0])[2]),
								rP = radiuses[i] > 0 ? radiuses[i] + thickness/2 : 0,
								rM = radiuses[i] - thickness/2 >= 0 ?
									radiuses[i] - thickness/2 : 0
								)
							 signCross < 0 ? rP : rM 
							 ],
					  radiuses[len(radiuses)-1],
					  radiuses[len(radiuses)-1],
					  [ for(i = [len(radiuses)-2 : -1: 1]) 
  							let(
								dxAB = pts[i-1][0] - pts[i][0], 
								dyAB = pts[i-1][1] - pts[i][1],
								dxBC = pts[i+1][0] - pts[i][0], 
								dyBC = pts[i+1][1] - pts[i][1],
								signCross = sign(cross([dxAB, dyAB, 0],[dxBC, dyBC, 0])[2]),
								rP = radiuses[i] > 0 ? radiuses[i] + thickness/2 : 0,
								rM = radiuses[i] - thickness/2 >= 0 ?
									radiuses[i] - thickness/2 : 0
								)
							 signCross >= 0 ? rP : rM 
						      ],
					  radiuses[0]
	);
	  
	shape25(ptPoly, rdPoly, height);
}

// Hollow shape
module hshape25(points, radiuses, thickness, height) {
    
    pts = concat(points, [points[0]], [points[1]]);
    r  =  concat(radiuses, [radiuses[0]], [radiuses[1]]);

    // Calculate internal points
    ptsint = [ for (i = [0 : len(pts)-3])
                let(
                    Cx = arc(pts[i], pts[i+1], pts[i+2], thickness)[0],
                    Cy = arc(pts[i], pts[i+1], pts[i+2], thickness)[1],
                    signCross = arc(pts[i], pts[i+1], pts[i+2], thickness)[2],
                    ptX = signCross >= 0 ? 2*pts[i+1][0] - Cx: Cx,
                    ptY = signCross >= 0 ? 2*pts[i+1][1] - Cy: Cy
                    )
                [ptX,ptY] ];
    
    rint  = [ for (i = [0 : len(pts)-3]) 
               let( signCross = arc(pts[i], pts[i+1], pts[i+2], thickness)[2] )
                    signCross < 0 ? 
                    r[i+1] - thickness >= 0 ? r[i+1] - thickness : 0:
                    r[i+1] + thickness ];

    // Result Original - Calculated
    difference() {
        shape25(points, radiuses, height);
        translate([0,0,-0.1]);
            shape25(ptsint, rint, height+0.2);
    }
}

// Plain shape
module shape25(points, radiuses, height) {

    pts = concat(points, [points[0]], [points[1]]);
    r = concat(radiuses, [radiuses[0]], [radiuses[1]]);

	difference() {
			
		union() {
			
			for(i = [0 : len(pts)-3]) {

				C =  arc(pts[i], pts[i+1], pts[i+2], r[i+1]);

				if (C[2] >= 0)
				translate([C[0], C[1], 0]) {

				DA=0;
				aout =20;
				e=0.1;
				h=sqrt( (pts[i+1][0] - C[0]) * (pts[i+1][0] - C[0]) +
						(pts[i+1][1] - C[1]) * (pts[i+1][1] - C[1]) );

				biss = abs(C[4]-C[3]) > 180  ? (C[3]+C[4])/2 : (C[3]+C[4])/2 + 180;
				DB2 = abs(C[4]-C[3]);

				// Place a # just before the translate (eg #translate ...)
				//to see what's behind
				translate([0, 0, 0])
					rotate([ 0, 0, biss - (90-DB2/2) ])
						rotate_extrude(angle = 2*(90-DB2/2), $fn = 90)
							translate([r[i+1], 0, 0])
								square([h-r[i+1], height]);
				}
			} 	

			linear_extrude(height)
				polygon(points=pts);
		}
			
		// DIFFERENCE
		for(i = [0 : len(pts)-3]) {

			C =  arc(pts[i], pts[i+1], pts[i+2], r[i+1]);
			
			if (C[2] < 0)
			translate([C[0], C[1], 0]) {

				DA=0;
				aout =20;
				e=0.1;
				h=sqrt( (pts[i+1][0] - C[0]) * (pts[i+1][0] - C[0]) +
						(pts[i+1][1] - C[1]) * (pts[i+1][1] - C[1]) );

				biss = abs(C[4]-C[3]) > 180  ? 
						(C[3]+C[4])/2 :
						(C[3]+C[4])/2 + 180;
				
				DB2 = abs(C[4]-C[3]);

				// Place a # just before the translate (eg #translate ...)
				//	to see what's behind
				translate([0, 0, -0.1])
					rotate([ 0, 0, biss - (90-DB2/2) ])
						rotate_extrude(angle = 2*(90-DB2/2), $fn = 90)
							translate([r[i+1], 0, 0])
								square([h-r[i+1], height+0.2]);
			}
		}
		
	}
}



// Calculate the arc that is tangent to two lines: calculate the center point and
// the start/end angles relatives to the line y=0
// ptB is the common point of the two lines
function arc(ptA, ptB, ptC, r) =

	   let( dxAB = ptA[0]-ptB[0], 
			dyAB = ptA[1]-ptB[1],
			dxBC = ptC[0]-ptB[0], 
			dyBC = ptC[1]-ptB[1],
			
			angAB0 = atan2(dyAB, dxAB),
			angBC0 = atan2(dyBC, dxBC),
			signCross = sign(cross([dxAB, dyAB, 0],[dxBC, dyBC, 0])[2]),

			DA = signCross > 0 ?  0 : -180,
			angABC = (angAB0 + angBC0) / 2,
			
			d = -( (r / sin( (angAB0 - angBC0 + 2*DA) / 2 )) ),

			Dx = d * cos(angABC) + ptB[0], 
			Dy = d * sin(angABC) + ptB[1]
		  )
		[Dx, Dy, signCross, angAB0, angBC0];
