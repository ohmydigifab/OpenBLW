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
		bolt_size = 2.1;
	    for(i=[0:11])
	    {
	        translate([(DOME_DIA+20)/2*cos(i*30), (DOME_DIA+20)/2*sin(i*30), 0])
		        circle(r = r_from_dia(bolt_size+0.1), center=true);
	    }
		//arm
		arm_pos = (DOME_DIA+30)/2-5+100/2;
	    for(i=[0:3])
		{
			rotate([0,0,90*i+45])
			{
			    translate([0, arm_pos])
	        		circle(r = r_from_dia(100));
			}
		}
    }
}

$fn=360;
oring_holder_2D();

