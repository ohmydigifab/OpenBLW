include<params.scad>
use<dome.scad>

module base_plate_bottom()
{
    linear_extrude(height = 2, twist = 0, slices = 0)
    {
        base_plate_bottom_2D();
    }
}
module base_plate_bottom_2D()
{
    hole_pos = DOME_DIA/3;
    difference()
    {
        translate([0, 0, 0])
	        circle(r = r_from_dia(DOME_DIA+30));
        translate([hole_pos, 0, 0])
	        circle(r = r_from_dia(20), center=true);
	    for(i=[0:11])
	    {
	        translate([(DOME_DIA+20)/2*cos(i*30), (DOME_DIA+20)/2*sin(i*30), 0])
		        circle(r = r_from_dia(3.5), center=true);
	    }
		//arm
		arm_pos = (DOME_DIA+30)/2-5+PROP_SHROUD_DIA/2;
	    for(i=[0:3])
		{
			rotate([0,0,90*i+45])
			{
			    translate([0, arm_pos])
	        		circle(r = r_from_dia(PROP_SHROUD_DIA));
			}
		}
    }
}

$fn=360;
base_plate_bottom_2D();
