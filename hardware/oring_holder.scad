include<params.scad>

module oring_holder()
{
    linear_extrude(height = 5, twist = 0, slices = 0)
    {
        oring_holder_2D();
    }
}
module oring_holder_2D()
{
    difference()
    {
        translate([0, 0, 0])
	        circle(r = r_from_dia(DOME_DIA+30));
        translate([0, 0, 0])
	        circle(r = r_from_dia(DOME_DIA)+ORING_DIA);
	    for(i=[0:11])
	    {
	        translate([(DOME_DIA+20)/2*cos(i*30+45), (DOME_DIA+20)/2*sin(i*30+45), 0])
		        circle(r = r_from_dia(3.1), center=true);
	    }
    }
}

oring_holder();

