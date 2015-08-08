include<params.scad>
use<fish_eye_lens.scad>
use<camera.scad>
use<amp.scad>
use<base_plate_assembly.scad>
use<LAN_connector.scad>
use<arm.scad>
use<motor.scad>
use<ROVProp.scad>
use<bolt_nut_spacer.scad>
use<dome.scad>

module assembly()
{
    translate([0, 0, 45])
        fish_eye_lens();
    translate([0, -2.5, 33])
        camera();
    translate([-38, 20, 25])
        import("raspberry_pi_model_B.stl");
    translate([0, 0, 15])
        amp();
    translate([0, 0, 0])
        base_plate_assembly();
    translate([0, -45, 0])
		LAN_connector();
    for(i=[0:3])
	{
		rotate([0,0,90*i+45])
		{
		    translate([0, 0, -10])
				arm();
		    translate([0, 135, -5])
				motor();
		    translate([0, 135, 28])
				import("ROVProp.stl");
		}
	}
    for(i=[0:11])
    {
    	color([0,0,1,1])
        translate([(DOME_DIA+15)/2*cos(i*30+45), (DOME_DIA+15)/2*sin(i*30+45), 0])
	        spacer(5,3.1,2.5);
    	color([0.5,0.5,0.5,1])
        translate([(DOME_DIA+15)/2*cos(i*30+45), (DOME_DIA+15)/2*sin(i*30+45), 2.5])
	        spacer(8,3.1,0.5);
        translate([(DOME_DIA+15)/2*cos(i*30+45), (DOME_DIA+15)/2*sin(i*30+45), 3])
	        bolt(5,3,3,16);
        translate([(DOME_DIA+15)/2*cos(i*30+45), (DOME_DIA+15)/2*sin(i*30+45), -10])
	        mirror([0,0,90]) nut(5,3,2.5);
    }
    translate([0, 0, 0])
      dome();
}

assembly();