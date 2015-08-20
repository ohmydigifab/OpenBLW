include<params.scad>
use<dome.scad>
use<seal_assembly.scad>

module base_plate()
{
    linear_extrude(height = 5, twist = 0, slices = 0)
    {
        base_plate_2D();
    }
}
module base_plate_2D()
{
    difference()
    {
        translate([0, 0, 0])
	        circle(r = r_from_dia(DOME_DIA+30));
        translate([0, -45, 0])
	        circle(r = r_from_dia(20), center=true);
        translate([15, 45, 0])
	        circle(r = r_from_dia(20), center=true);
	    for(i=[0:11])
	    {
	        translate([(DOME_DIA+15)/2*cos(i*30+45), (DOME_DIA+15)/2*sin(i*30+45), 0])
		        circle(r = r_from_dia(3.1), center=true);
	    }
    }
}

base_plate();