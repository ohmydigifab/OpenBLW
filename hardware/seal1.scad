include<params.scad>

module seal1()
{
    linear_extrude(height = 5, twist = 0, slices = 0)
    {
        seal1_2D();
    }
}
module seal1_2D()
{
    difference()
    {
    	echo(seal1_dia=DOME_DIA-DOME_THICK*2-ORING_DIA);
        translate([0, 0, 0])
	        circle(r = r_from_dia(DOME_DIA-DOME_THICK*2-ORING_DIA), $fn = 100);
        translate([0, -45, 0])
	        circle(r = r_from_dia(31), center=true, $fn = 100);
        translate([-15, 45, 0])
	        circle(r = r_from_dia(20), center=true, $fn = 100);
	        
        translate([-40, 40, 0])
	        circle(r = r_from_dia(2.6), center=true, $fn = 100);
        translate([40, 40, 0])
	        circle(r = r_from_dia(2.6), center=true, $fn = 100);
        translate([-40, -40, 0])
	        circle(r = r_from_dia(2.6), center=true, $fn = 100);
        translate([40, -40, 0])
	        circle(r = r_from_dia(2.6), center=true, $fn = 100);
    }
}

seal1();

