include<params.scad>
use<fish_eye_lens.scad>
use<camera.scad>
use<amp.scad>
use<base_plate_assembly.scad>
use<LAN_connector.scad>
use<arm.scad>
use<prop_shroud_flange.scad>
use<prop_nose.scad>
use<motor.scad>
use<ROVProp.scad>
use<prop_shroud.scad>
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
    translate([0, 45, 0])
		LAN_connector();
	translate([0, 0, 10])
    for(i=[0:3])
	{
		rotate([0,0,90*i+45])
		{
		    translate([0, 0, -5])
				arm();
		    translate([0, 0, 60])
				prop_shroud_flange();
		    translate([0, 150, 65])
				prop_nose();
		    translate([0, 150, -5])
				mirror([0,0,1]) prop_nose();
		    translate([0, 150, 0])
				motor();
		    translate([0, 150, 29])
				import("ROVProp.stl");
		    translate([0, 150, 0])
				prop_shroud();
		}
	}
	translate([0, 0, 7.5])
    for(i=[0:11])
    {
    	color([0.5,0.5,0.5,1])
        translate([(DOME_DIA+20)/2*cos(i*30+45), (DOME_DIA+20)/2*sin(i*30+45), 2.5])
	        spacer(8,3.1,0.5);
        translate([(DOME_DIA+20)/2*cos(i*30+45), (DOME_DIA+20)/2*sin(i*30+45), 3])
	        bolt(5,3,3,20);
        translate([(DOME_DIA+20)/2*cos(i*30+45), (DOME_DIA+20)/2*sin(i*30+45), -12.5])
	        mirror([0,0,90]) nut(5,3,2.5);
    }
    translate([0, 0, 0])
      dome();
}

$fn = 100;
assembly();