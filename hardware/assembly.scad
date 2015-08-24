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
use<flow_cylinder.scad>
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
	//bolt & nut
	translate([0, 0, 7.5])
    for(i=[0:7])
    {
    	color([0.5,0.5,0.5,1])
        translate([(DOME_DIA+20)/2*cos(i*45), (DOME_DIA+20)/2*sin(i*45), 2.5])
	        spacer(8,3.1,0.5);
        translate([(DOME_DIA+20)/2*cos(i*45), (DOME_DIA+20)/2*sin(i*45), 3])
	        bolt(5,3,3,17.5);
        translate([(DOME_DIA+20)/2*cos(i*45), (DOME_DIA+20)/2*sin(i*45), -10])
	        mirror([0,0,90]) nut(5,3,2.5);
    }
	//arm
	arm_pos = DOME_DIA-10;
	translate([0, 0, 10])
    for(i=[0:3])
	{
		rotate([0,0,90*i+45])
		{
		    translate([0, arm_pos, -5])
				arm();
		    translate([0, arm_pos, 40])
				prop_shroud_flange();
		    translate([0, arm_pos, 43])
				prop_nose();
		    translate([0, arm_pos, -5])
				mirror([0,0,1]) prop_nose();
		    translate([0, arm_pos, 0])
				motor();
		    translate([0, arm_pos, 15.5+5])
				import("ROVProp.stl");
		    translate([0, arm_pos, 3*15.5/2+10])
				flow_cylinder();
		    translate([0, arm_pos, 0])
				prop_shroud();
		}
	}
    translate([0, 0, 0])
      dome();
}

$fn = 100;
assembly();