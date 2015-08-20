include<params.scad>

module seal2()
{
    linear_extrude(height = 5, twist = 0, slices = 0)
    {
        seal2_2D();
    }
}
module seal2_2D()
{
    difference()
    {
    	echo(seal2_dia=DOME_DIA-DOME_THICK*2-ORING_DIA*2);
        translate([0, 0, 0])
	    	circle(r = r_from_dia(DOME_DIA-DOME_THICK*2-ORING_DIA*2), h = 5);
        translate([0, -45, 0])
	        circle(r = r_from_dia(31), h = 20, center=true);
        translate([-15, 45, 0])
	        circle(r = r_from_dia(20), h = 20, center=true);
        translate([0, 45, 0])
	        square([30,20], center=true);
        translate([15, 45, 0])
	        circle(r = r_from_dia(20), h = 20, center=true);
    }
}

seal2();

