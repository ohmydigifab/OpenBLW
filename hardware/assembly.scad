include<params.scad>
use<fish_eye_lens.scad>
use<camera.scad>
use<amp.scad>
use<base_plate_assembly.scad>
use<LAN_connector.scad>
use<arm.scad>
use<arm_upper.scad>
use<prop_shroud_flange.scad>
use<prop_nose.scad>
use<motor.scad>
use<ROVProp.scad>
use<flow_cylinder.scad>
use<prop_shroud.scad>
use<bolt_nut_spacer.scad>
use<dome.scad>
use<ROVPropAdapter.scad>

module assembly()
{
    base_plate_thick = 7;
    
    translate([0, 0, 30])
        fish_eye_lens();
    translate([0, -2.5, 20])
        camera();
    translate([-65/2, -56.5/2, 10])
        import("a+stl.stl");
//    translate([0, 0, 15])
//        amp();
    translate([0, 0, 0])
        base_plate_assembly();
    translate([DOME_DIA/3, 0, 4-base_plate_thick])
		LAN_connector();
	//bolt & nut
	bolt_size = 2.6;
	translate([0, 0, 7.5])
    for(i=[0:11])
    {
    	color([0.5,0.5,0.5,1])
        translate([(DOME_DIA+20)/2*cos(i*30), (DOME_DIA+20)/2*sin(i*30), 2.5])
	        spacer(7,bolt_size,0.5);
        translate([(DOME_DIA+20)/2*cos(i*30), (DOME_DIA+20)/2*sin(i*30), 3])
	        bolt(5,bolt_size,bolt_size,8);
//        translate([(DOME_DIA+20)/2*cos(i*45), (DOME_DIA+20)/2*sin(i*45), -10])
//	        mirror([0,0,90]) nut(5,3,2.5);
    }
	mirror([0,0,1]) translate([0, 0, 14.5])
    for(i=[0:11])
    {
    	color([0.5,0.5,0.5,1])
        translate([(DOME_DIA+20)/2*cos(i*30), (DOME_DIA+20)/2*sin(i*30), 2.5])
	        spacer(7,bolt_size,0.5);
        translate([(DOME_DIA+20)/2*cos(i*30), (DOME_DIA+20)/2*sin(i*30), 3])
	        bolt(5,bolt_size,bolt_size,8);
//        translate([(DOME_DIA+20)/2*cos(i*45), (DOME_DIA+20)/2*sin(i*45), -10])
//	        mirror([0,0,90]) nut(5,3,2.5);
    }
	//arm
	arm_pos = (DOME_DIA+30)/2+PROP_SHROUD_DIA/2-5;
	translate([0, 0, 10])
    for(i=[0:3])
	{
		rotate([0,0,90*i+45])
		{
		    translate([0, arm_pos, -5])
				arm_upper();
		    translate([0, arm_pos, -15-base_plate_thick])
				rotate([0,180,0]) arm();
		    translate([0, arm_pos, -15-base_plate_thick])
				motor();
            //this is for rendering speed
            if(PROP_SHROUD_DIA == 100)
            {
                translate([0, arm_pos, 8-15-base_plate_thick])
                    import("ROVPropAdapter_100mm.stl");
            }
            else if(PROP_SHROUD_DIA == 110)
            {
                translate([0, arm_pos, 8-15-base_plate_thick])
                    import("ROVPropAdapter_110mm.stl");
            }
            else
            {
                translate([0, arm_pos, 8-15-base_plate_thick])
                    ROVPropAdapter();
            }
//		    translate([0, arm_pos, 40])
//				prop_shroud_flange();
		    translate([0, arm_pos, -5])
				prop_nose();
		    translate([0, arm_pos, -20-base_plate_thick])
				mirror([0,0,1]) prop_nose();
//		    translate([0, arm_pos, 3*15.5/2+10])
//				flow_cylinder();
		    translate([0, arm_pos, -15-base_plate_thick])
				prop_shroud(height=14+base_plate_thick);
		}
	}
    translate([0, 0, 0])
      dome();
    translate([0, 0, -11])
      rotate([180,0,0]) dome();
}

$fn = 100;
assembly();