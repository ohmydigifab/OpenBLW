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
	        circle(r = r_from_dia(DOME_DIA+30), h = 5, $fn = 100);
        translate([0, -45, 0])
	        circle(r = r_from_dia(20), h = 20, center=true, $fn = 100);
        translate([15, 45, 0])
	        circle(r = r_from_dia(20), h = 20, center=true, $fn = 100);
    }
}

base_plate();