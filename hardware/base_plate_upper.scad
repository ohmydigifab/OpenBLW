include<params.scad>
use<tools.scad>
use<dome.scad>
use<base_plate_middle.scad>
use<base_plate_bottom.scad>

module base_plate_upper()
{
    linear_extrude(height = 2, twist = 0, slices = 0)
    {
        base_plate_upper_2D();
    }
}
module base_plate_upper_2D()
{
    hole_pos = r_from_dia(DOME_DIA)-DOME_THICK-r_from_dia(8)-0;
    difference()
    {
        base_plate_bottom_2D();
        for(i=[0])
        {
            mirror([i,0])
            translate([-hole_pos, 0, 0])
	            circle(r = r_from_dia(8), center=true);
        }
    }
}

$fn=360;
base_plate_upper_2D();
