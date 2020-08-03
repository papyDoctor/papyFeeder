/*
	Author: papyDoctor
	Contributions By:   Olivier Monnom
	Last Verified On:      1. August 2020
	Version:    2.1
	License:     Creative Commons - Attribution, Non Commercial, Share Alike
*/

// gears library from Jörg Janssen and contibutors Keith Emery, Chris Spencer
// https://github.com/chrisspen/gears
include <gears.scad>
// shape25 library from papyDoctor
// https://github.com/monnoliv/openscad-shape25
include <openscad-shape25.scad>

$fa=0.1;
$fn=200;
  
VersionTxt =  "papyF V2.1";
  
/************************************************************************
* Dimentionnal variables: DO NOT TOUCH UNLESS YOU KNOW WHAT YOU'RE DOING
************************************************************************/
// Main body parameters
bodyThickness = 2;
feederWidth = 14;
mainHeight = feederWidth - bodyThickness;

DJeu = 0.3;

visEmbaseGAP = 4; 

/******************************************************
* TAPE WIDTH, CAN BE 8, 12, 16 and 24
******************************************************/
TAPEW = 8;

/******************************************************
* FLAGS for viewing/printing
******************************************************/
showAssemblyParts = 1; // No printed part, put 1 for viewing
printTheBase = 1; // Put 1 to show and print the feeder base
printTheTape = 1; // Put 1 to show and print the feeder tap
printOtherParts = 0; // Only for printing the small parts

/******************************************************
* Logic for viewing/printing
******************************************************/
if ( printTheBase ) {
	slotWheelBlock();
	tapeHolder();
	bodyUnderTape();
	bodyOverTape();
}

if ( printTheTape )
	tapTape();

if ( printOtherParts ) {
	rotate([0, 180, 0]) translate([0, 0, 0.5-TAPEW]) interfaceSprocket();
	translate([0, 20, 0]) filmSprocket();
	translate([30, 0, 0]) filmWheel();
	translate([-20, 0, 0]) servoPullSprocket();
	translate([-20, 20, 0]) servoPushSprocket();
	translate([-20, 30, 0]) rackSlider();
	translate([35, 40, 0]) slotWheel();
	translate([-10, 55, 0]) slotWheelBlockTAP();
}

/******************************************************
* MODULES
******************************************************/
module bodyOverTape() {
	translate([-80, 24, 0]) rotate([0, 0, 21]) {
		
		// Servo pull base
		difference() {
			translate([0, -12, 0])
				cube([26.5, 22.7, 2]);
			
			translate([5, -7, -0.01])
				cube([16.5, 12.7, 23]);
		}
		
		
		translate([11, -16, 0])
			cube([15, 8, 2]);	
		
		difference() {
			// Leg 1
			translate([22, -11, 0])
				cube([27.5, 10, 2]);
			
			translate([44.7, -6, -0.01])
				cylinder(r=3.2, h=3);
		}

		// Servo Pull
		if(showAssemblyParts)
			translate([0, -12, 13.8]) rotate([180, 0, 90])
				servoPull();
		
		// Servo block 1
		translate([22.5, 10.7, 0]) rotate([0, 0, -90]) {
			difference() {
				color("Gray", 1.0 )
				cube([8, 4, 10]);
			
				translate([3, -.1, 8]) rotate([-90, 0, 0])
					cylinder(r=1, h=5);	
			}
		}
		
		// Servo block 2
		difference() {
			color("Gray", 1.0 )
			translate([18.7, -16, 0])
				cube([7.8, 4, 10]);
			
			translate([18, -14, 8]) rotate([0, 90, 0])
				cylinder(r=1, h=10);	
		}	
		
		// Gear
		translate([44.7, -6, 2])	{		
			if(showAssemblyParts) {
				translate([0, 0, 0])
					filmWheel();
			}		
			// Axe
			translate([0, 0, -2])
				visEmbase2();
		}
	}
}

module tapeHolder() {
	
	translate([0, 0.7, 0]) rotate([0, 0, 0]) {
		
		hs= 5;
		difference() {
			//Support tape
			translate([0, -1.9, 0])
			color("DarkGray", 1.0 )
				oshape25([ [-67.5, 6], [-33, 20], 
						   [20, 20], [30, 15] ],
						  [0, 80, 45, 0],
						  hs, 7.5);
			
			//Slot tape	
			translate([0, 0, 2+2.9])
			color("Gray", 1.0 )
				oshape25([ [-67.5, 4], [-33, 18],
						   [20, 18], [30, 13] ],
						   [ 0, 80,  45, 0 ], 
						   1.4, 2.6 + 0.01);
						  
			//Cleareance specialGear
			translate( [0, -1.5, 2.0] )
				cylinder(r=21, h= 10);
		}
		
		//Ajuster début
		translate([-68.5, 6.65, 2.5]) rotate([0, 0, 21.8]) {
			rotate([0, 90, 0])
			color("DarkGray", 1.0 )
				shape25([ [-5, -1],		[-5, 1.4],
						  [-2.4, 1.4],	[1.5, -1],  ],
						  [0, 0, 0, 0],
						  5 );
		}	
		
		//Ajuster fin
		translate([26.65, 17.6, 2.5]) rotate([0, 0, -26.5]) {	
			rotate([0, 90, 0])
			color("DarkGray", 1.0 )
				shape25([ [-5, -1],		[-5, 1.4],
						  [-2.4, 1.4],	[1.5, -1],  ],
						  [0, 0, 0, 0],
						  5 );
		}
	}	
}
module tapTape() {
	
	translate([0, 0.7, TAPEW+4.5]) {
		
		hs= 5;
		difference() {
			//Support tape
			color("DarkGray", 1.0 )
			translate([0, -1.9, 0])
				oshape25([ [-67.5, 6], [-33, 20], 
						   [20, 20], [30, 15] ],
						  [0, 80, 45, 0],
						  hs, 2.5);
			
			//Slot tape	
			translate([0, 0, -0.01])
				color("Gray", 1.0 )
				oshape25([ [-67.51, 4], [-33, 18],
						   [20, 18], [30, 13] ],
						   [ 0, 80,  45, 0 ], 
						   1.4, 1);		
			
			//Film output
			translate([-10, 18, -4]) 
				cube([3, 3, 5]);	
		}
		
		// Screw
		translate([-36.1, 33.7+0.5, 2.5]) {
			
			visPlug2();
			
			translate([0, 0, -2.5])
				cylinder(r=5, h= 2.5);
			
			translate([0, 0, -2-TAPEW+7.5])
				cylinder(r=4.3, h= TAPEW-8);
			
			// Interface sprocket
			if(showAssemblyParts)
				translate([0, -0.5, -2.2-TAPEW]) rotate([0, 0, 22])
					interfaceSprocket();
		}
		
		// Show example tape
		if(showAssemblyParts)
			translate([-12, 18, 0.5]) rotate([90, 180, 180])
				tape();
			
		//Ajuster début		
		color("DarkGray", 1.0 )
		translate([-68.5, 6.65, 2.5]) rotate([0, 0, 21.8]) {
			
			rotate([0, 90, 0])
				shape25([ [0, -1.885],	[0, 3],
						  [TAPEW+2, 3] ,
						  [TAPEW+5, 0.1], 	
						  [TAPEW+4, 0.1], 
						  [TAPEW+2.5, 1.45], 
						  [TAPEW-0.5, 1.45], 	
						  [TAPEW-0.5, -1.885], ],		
						  [0, 0, 0, 0, 0, 0, 0, 0],
						  5 );			
		}
		
		//Ajuster fin		
		color("DarkGray", 1.0 )
		translate([26.65, 17.6, 2.5]) rotate([0, 0, -26.5]) {
			
			rotate([0, 90, 0])
				shape25([ [0, -1.885],	[0, 3],
						  [TAPEW+2, 3] ,
						  [TAPEW+5, 0.1],
						  [TAPEW+4, 0.1],
						  [TAPEW+2.5, 1.45], 
						  [TAPEW-0.5, 1.45],
						  [TAPEW-0.5, -1.885], ],		
						  [0, 0, 0, 0, 0, 0, 0, 0],
						  5 );	
		}	
		
		//Gauntry
		translate([0, 0, .5])
		oshape25([ [-49, 12.5], [-50, 15], [-36.8, 37], 
				[-15, 20], [-15, 19]  ],
			  [0, 0, 5, 0, 0],
			  5, 2);

		//Spring leg
		color("Gray", 1.0 )
		translate([-38, 16.5, 0]) rotate([0, 0, 10])
			cube([10, 17, 2.5]);
		
		//Spring leg
		color("Gray", 1.0 )
		translate([0, 0, 3.3-TAPEW])
			oshape25([ [-10, 19.65], [-15, 19.6], [-20, 19.6] ],
					   [0, 0, 0],
					   1.9, TAPEW-0.8);
		
		//Film counter wheel Axle
		translate([-34, 23, -TAPEW+1.5]) rotate([0, 0, 10]) {
			
			cylinder(r=2.5, h=TAPEW+1);
						
			if(showAssemblyParts)
				translate([0, 0, 1.5])
				filmSprocket();
		}

		//Film legs
		color("Gray", 1.0 )
		translate([0, 0, 3.3-TAPEW]) {
			
			oshape25([ [-65.2, 10.6], [-60, 8.7],
						[-45, 14.7], [-37, 17.2] ],
				  [0, 10, 10, 0],
				  1.5, TAPEW-0.8);
			
			translate([0, 0, -2.3])
			oshape25([ [-56, 14], [-48, 17], [-41.5, 27] ],
				  [ 0, 10, 0],
				  1, TAPEW+1.5);
		}	
	}	
}

module slotWheelBlock() {
	// SLOT GEAR BLOCK
	translate([0, 0, 0]) rotate([0, 0, 0]) {
		
		if(showAssemblyParts)
			translate([0, 0, 7.1]) rotate([0, 180, 6]) 
				slotWheel();
		
		difference() {
			union() {
				cylinder(r=12, h= 7.4);
				cylinder(r=15, h= 2.2);
			}
			
			//Slot balls
			translate([-15, -2.1, 2.2])
				cube([30, 4.2, 50.01]);
			//Slot magnets
			translate([-9, -2.6, 2])
				cube([18, 5.2, 20.01]);
			
			//Slot insert
			translate([0, -7, 1])
				cylinder(r=1.9, h= 10);
		}
		
		if(showAssemblyParts) {
			translate([-8.8, 0, 4.5]) rotate([0, 90, 0])
				color("Grey", 1.0)
				cylinder(r=2.5, h=8.5);
			translate([0.3, 0, 4.5]) rotate([0, 90, 0])
				color("Grey", 1.0)
				cylinder(r=2.5, h=8.5);
			translate([-10.8, 0, 4.2])
				stainlessBall();
			translate([10.8, 0, 4.2])
				stainlessBall();
			translate([0, 0, 7.4])
				slotWheelBlockTAP();
		}
	}		
}
module bodyUnderTape() {
	
	//Cable servo pull
	difference() {
		oshape25([ [-70.85, 6.1], [-68.8, 1], [-51, -3], [-49, -9] ],
			   [ 0, 7, 10, 0 ], 
			   5.5, 3);

		translate([0, 0, 1.5]) 
		oshape25([ [-70.85, 6.1], [-68.8, 1], [-51, -3], [-49, -9.1] ],
			   [ 0, 7, 10, 0 ], 
			   3.5, 1.51);		
	}
	translate([-42, -31.1, 0]) rotate([0, 0, 20])
		cube([5, 10, 2.3]);
	translate([-42.5, -31.3, 0]) rotate([0, 0, 20])
		cube([2, 10, 5]);	
	
	if ( showAssemblyParts ) {
		translate([-39, -30, 1]) rotate([0, 0, 20]) {
			
			translate([22.5, 0, 13.1])
				rotate([0, 180, 0])
				servoPush();
			
			translate([5, 27, 1])
				rackSlider();
		}
		translate([-28, -31.3, 4.7]) rotate([0, 0, 0])
			PCB();
	}
	
	// TUBE FIXATION
	translate([0, -35, 0]) {
		
		translate([-18, 3.7, 0])
			cube([36, 12, 4.7]);
		translate([-18, 5.4, 0])
			cube([3, 3.3, 12]);
		translate([12, 3.7, 0])
			cube([3, 5, 12]);
		translate([9, 5.4, 0])
			cube([3, 3.3, 12]);
		
		translate([-13, 10, 4])
		linear_extrude(2)
			text(size = 4, font = "Liberation Sans:style=Bold",
					VersionTxt);
		
		difference() {
			translate([-18, 0, 0])
				cube([36, 3.7, 14.9]);
			
			translate([-14.2, -0.01, 7])
				cube([12, 3.72, 10]);
			
			translate([-15, -0.01, -0.01])
				cube([12, 1.7, 20]);	
		}

		translate([-17.2, -16, 0]) rotate([0, 0, 3]) {
			
			translate([0.5, 0, 0])
				cube([2.5, 19, 14.9]);
			
			// Renfort v2.1
			translate([-4, 15, 0])
				cube([5, 9.7, 4.7]);
			
			shape25([ [3, 6.5], [4, 3.8], [4, 2], [3, 0] ],
			 [0, 0, 0, 0],
			 14.9);
			
			translate([3, 3, 0]) rotate([0, 0, 180])
				hookLegs();
		}
			
		translate([14.2, -16, 0]) rotate([0, 0, -3]) {
			
			cube([2.5, 19, 14.9]);	

			shape25([ [0, 6.5], [-1, 3.8], [-1, 2], [0, 0] ],
			 [0, 0, 0, 0],
			 14.9);
			
			hookLegs();
		}
	}
	
	translate([-2.5, 10, 0])
		cube([5, 10, 2]);

	translate([-5, -33, 0])
		cube([10, 22, 2]);

	translate([-28, -25, 0]) rotate([0, 0, -20])
		cube([24, 5, 2]);
	
	translate([5, -10, 0]) rotate([0, 0, -20])
		cube([13, 5, 2]);

	translate([12.5, -35, 0]) rotate([0, 0, 70])
		cube([53, 5, 4.7]);
		
	translate([-39, -30, 0]) rotate([0, 0, 20]) {
		
		translate([18, 12.7, 0])
			cube([20, 10, 2]);
		
		translate([0, 26.6, 0])
			cube([50, 4, 2]);
		
		// Servo block 1
		difference() {
			color("Gray", 1.0 )
			translate([0, 22.6, 0])
				cube([8, 4, 10]);
			
			translate([3, 22.5, 8]) rotate([-90, 0, 0])
				cylinder(r=1, h=5);	
		}
		// Servo block 2
		difference() {
			color("Gray", 1.0 )
			translate([22.5, 0, 0])
				cube([3, 26.6, 10]);
			
			translate([22, 7.3, 8]) rotate([0, 90, 0])
				cylinder(r=1, h=10);
		}
		// Servo base
		difference() {
			cube([22.5, 22.7, 2.3]);
			
			translate([5, 5, -0.01])
				cube([12.5, 12.7, 3]);
		}
	}
	
	//
	translate([10, 6, 0]) rotate([0, 0, 20])
		cube([20, 5, 2]);
	//
	translate([-43, 26, 0]) rotate([0, 0, -20])
		cube([43, 5, 2]);
	
	translate([-73, 15, 0]) rotate([0, 0, -20])
		cube([42, 5, 2]);

	translate([-32, -8.5, 0]) rotate([0, 0, 20]) {
		//Leg
		cube([5, 40, 2]);	
		//Servo gear blocking
		translate([0, 12.7, 2])
		color("Gray", 1.0 )
			cube([5, 5, 5]);
	}
}

module hookLegs() {
	shape25([ [0,0],[7,0],[10,-3],[15,-3],
			  [15,6],[10,6], [7,3],[0,3] ],
			 [0,2,2,2,2,2,2,0],
			 14.9);
}
module slotWheelBlockTAP() {
color("Ivory", 0.8 ) {
		difference() {

		cylinder(r=15, h= 2);
			
		translate([-20, 2.5, -0.01])
			cube([40, 20, 20.01]);
			
		//Screw hole
		translate([0, -7, -0.01])
			cylinder(r=1.6, h= 3);
	}
}}
module stainlessBall() {
	color("Grey", 1.0)
		sphere(r = 2);
}
module visEmbase2() {
color("Orange", 1.0 ) {
    
    rext = 4.3;
    
    difference() {
		
//        //Base à extruder
        rotate([0, 0, 45])
            cylinder(r=rext,h=12.4);

        //Extrusion pour visPlug
        translate([0, 0, visEmbaseGAP+2.1])
        rotate([0, 0, 45])
            cylinder(r=3.4,h=visEmbaseGAP+2.1+10);
		
		//Extrusion pour tete de vis
        translate([0, 0, -0.1])
        rotate([0, 0, 45])
            cylinder(r=3.2,h=3.5);
        
		// Trou traversant pour corps de vis
        translate([0, 0, -0.1])
        rotate([0, 0, 45])
            cylinder(r=1.6,h=mainHeight+0.1);
    }
}}
module visPlug2() {
    color("Orange", 1.0 )
		mirror([0, 0, 1])
        difference() {
			
			union() {
				cylinder(r=3.2,h=TAPEW-0.2);
			}
            
            translate([0, 0, TAPEW-6])
				cylinder(r=2, h=10.01);
    } 
}
module servoPush() {
    
    color("Red", 1.0 ) 
        FS90R_CUT();
    
    translate([6, 27, 5.9]) rotate([-90, 0, 0])
        servoPushSprocket();
}
module servoPull() {
    
    color("Red", 1.0 ) 
        FS90R_CUT();
    
    translate([6, 27, 5.9]) rotate([-90, -2, 0])
        servoPullSprocket();
}
module rackSlider() {
color("DarkBlue", 1.0 ) {	
	H = 1.8;
	H2 = 3.2;
	L = 15;
	W = 3.4;
	
	rotate([90, 0, 0])
	translate([L/2+1.95, H,-W])
		rack(modul=.66, length=L, height=H, width=W,
			pressure_angle=20, helix_angle=0);
	
	translate([1.5, W/2, 0]) {
		oshape25([[L, 0],[L+2, 0],[L+3, 0.01]], 
					[0, 0, 0], W, H2);
		oshape25([[L+2, -0.2],[L+10, -0.21],[L+12.5, -0.2]], 
					[0, 0, 0], 2, H2);
	}
}}

module servoPullSprocket() {
color("Blue", 1.0 ) {  
    difference() {
		cylinder(r=5.6, h=3.6);

        translate([0, 0, -0.1])
            cylinder(r=2.45,h=3.2);
		
        translate([0, 0, -0.1])
            cylinder(r=1,h=10);
    }
	
	translate([-2.5, -2.5, 0])
		cube([5, 1, 3.6]);
	
	translate([-2.5, 1.5, 0])
		cube([5, 1, 3.6]);
    
    translate([0, 0, 3])
        bevel_gear(modul=.7, tooth_number=14,  partial_cone_angle=20,
            tooth_width=4.3, bore=3.5, pressure_angle=20, helix_angle=0);
}}
module servoPushSprocket() {
color("Blue", 1.0 ) {
	H = 3.5;
	 
    difference() {
		cylinder(r=3.4, h=H);
		
        translate([0, 0, -0.1])
            cylinder(r=2.45,h=6); 
    }		
		
	intersection() {
		cylinder(r=3.2, h=H);
		
		union() {
			translate([-3, -2.5, 0])
				cube([6, 1.2, H]);
			translate([-3, 1.3, 0])
				cube([6, 2, H]);
		}			
	}

	rotate([0,0,8])
		spur_gear(modul=.66, tooth_number=13, width=H, bore=4.9,
			pressure_angle=20, helix_angle=0, optimized=true);
}}
module interfaceSprocket() {
color("Blue", 1.0 ) {
	rAxle = 4.3;

	// Interface piece
	difference() {
		
		translate([0, 0, 2.9])
			cylinder(r= 6.2, h=TAPEW-3.4);

		cylinder(r=rAxle+DJeu/2, h=50); 
	}
		
	translate([0, 0, 2.9])	
		spur_gear (modul=0.77, tooth_number=18, width=TAPEW-3.4, 
			bore=2*rAxle+DJeu, pressure_angle=10, helix_angle=0,
			optimized=false);
	
	intersection() {	
		difference() {
			cylinder(r= 6.2, h=2.9);
			
			translate([0, 0, -0.1])
				cylinder(r=rAxle+DJeu/2, h=10);  
		}

		union() {
			translate([-8, -1.4, 0])
				cube([16, 2.8, 2.9]);
			rotate([0, 0, 90])  translate([-8, -1.4, 0]) 
				cube([16, 2.8, 2.9]);
		}
    }
}}
module filmSprocket() {
color("DarkBlue", 1.0 ) {	
	rAxle = 2.5;
	
	spur_gear (modul=0.7, tooth_number=11, width=TAPEW-3.4, 
		bore=2*rAxle+DJeu, pressure_angle=10, helix_angle=0,
		optimized=false);
	
	difference() {
		cylinder(r= 3.2, h=TAPEW-3.4);
		
		translate([0, 0, -0.1])
			cylinder(r=rAxle+DJeu/2, h=50);  
	}
}}
module slotWheel() {	
color("Blue", 1.0 ) {
	l=.8;

	pitch = 4; 		// 4mm feed
	numTeeth = 30;	// Number of teeth
	sizeTeeth = 2;
	
	// Radius calculated for the middle of the external teeth
	Rmod = pitch*numTeeth/(2*3.14159);
	echo(Rmod);
	L=Rmod;
	k=L-9;

	difference() {
		union() {
			cylinder(r=Rmod-sizeTeeth/2,h=4.9);
			
			for ( i=[0: 360/numTeeth: 360] ) 
				rotate(i) {
					oshape25( [ [0, Rmod-sizeTeeth/2-.2], 
								[0.001, Rmod], 
								[0, Rmod+sizeTeeth/2] ], 
								[0, 0, 0.5],
								1, 0.8 );
				}
		}

		// External racket slots		
		translate( [0, 0, -0.01] )
		for ( i=[0: 360/numTeeth: 360] ) 
				rotate(i)
				translate( [15.8, 0, 1] ) rotate([0, 0, 180])	
					shape25([[-1,0], [-4,0], [-2,4]],
							 [0,0,0], 4.5);
		
		translate( [0, 0, -0.01] )
			cylinder(r=12+DJeu/2,h=1);
		
		translate( [0, 0, 1-0.02] )
			cylinder(r=13.3,h=10);		
	}
	
	for ( i=[0: 360/numTeeth: 360] ) 
		rotate(i)translate( [13.25, 0, 0] )
			cylinder(r=0.75,h=4.9);
}}
module filmWheel() {
color("DarkBlue", 1.0 ) {
	
	rAxle = 4.3;
	// Small offset
	difference() {
		cylinder(r=13.7,h=0.3);
		
		translate([0, 0, -0.01])	
			cylinder(r=rAxle+DJeu/2, h=0.5); 
	}
	
	// Gear
	translate([0, 0, 0.3]) rotate([0, 0, 30]) 
		bevel_gear(modul=.7, tooth_number=40,  
		partial_cone_angle=70,
		tooth_width=4, bore=2*rAxle+DJeu,
		pressure_angle=20, helix_angle=0);
	
	// Interface piece
	difference() {
        cylinder(r= 6.2, h=5.4);
        
        translate([0, 0, -0.1])
            cylinder(r=rAxle+DJeu/2, h=10);  

		translate([-8, -1.5, 2.4])
			cube([16, 3, 3.01]);
		rotate([0, 0, 90])  translate([-8, -1.5, 2.4]) 
			cube([16, 3, 3.01]);		
    }
}}
module PCB() {	
		color("Green", 1.0 )
		cube([40, 1.6, 10]);
	
	translate([14, -1.7, 10-0.7-6])
		color("Black", 1.0 )
		cube([8, 1.7, 6]);
	
	translate([14.5, -2.7, 6])
		color("Gold", 1.0 )
		cube([1, 1, 2]);
	translate([16.5, -2.7, 6])
		color("Gold", 1.0 )
		cube([1, 1, 2]);
	translate([18.5, -2.7, 6])
		color("Gold", 1.0 )
		cube([1, 1, 2]);
	translate([20.5, -2.7, 6])
		color("Gold", 1.0 )
		cube([1, 1, 2]);

	translate([1, -1.7, 2.5])
		color("Black", 1.0 )
		cube([3.2, 1.7, 4.2]);	
}
module tape() {
color("SaddleBrown", 1.0 ) {	
    composants = 5;
    epp=0.6;
    dt = 1.75;

    A= 3;
    B= 3.8;
    K= 3.4;
	
    difference() {
        
        cube([4*(composants+1), TAPEW, epp]);  
		
        translate([2, TAPEW-dt, -0.5])       
            for(i = [0 : 4 : composants*4])
                translate([i, 0, 0])
                    cylinder(r=0.75,epp+1);
    }
    
    translate([2, TAPEW-dt, epp])
        for(i = [0 : 4 : composants*4-1])
            translate([i+2-A/2, -3.5-2, -K])
                cube([A, B, K]);
}}
module FS90R_CUT() {
    
    translate([0, 0, 0]) {
        // Servo
        color("Red", 1.0 ) {
        
            cube([22.5, 22.7, 11.8]);
            
            translate([5.9, 22.7, 5.9])
            rotate([-90, 0, 0])
                cylinder(h=4, r=5.9);
            
            translate([12.2, 22.7, 5.9])
            rotate([-90, 0, 0])
                cylinder(h=4, r=2.5);  
          
            translate([5.9, 26.7, 5.9])
            rotate([-90, 0, 0])
                cylinder(h=3.2, r=2.3);  
        }
    }
}
