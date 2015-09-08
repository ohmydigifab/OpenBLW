include<params.scad>
use<dome.scad>
use<seal_assembly.scad>

module base_plate_bottom()
{
    linear_extrude(height = 2, twist = 0, slices = 0)
    {
        base_plate_bottom_2D();
    }
}
module base_plate_bottom_2D()
{
    hole_pos = DOME_DIA*15/50;
    difference()
    {
        translate([0, 0, 0])
	        circle(r = r_from_dia(DOME_DIA+30));
        translate([0, 0, 0])
	        circle(r = r_from_dia(20), center=true);
//	    for(i=[0:7])
//	    {
//	        translate([(DOME_DIA+20)/2*cos(i*45), (DOME_DIA+20)/2*sin(i*45), 0])
//		        circle(r = r_from_dia(3.1), center=true);
//	    }
    }
}

$fn=1000;
base_plate_bottom_2D();
