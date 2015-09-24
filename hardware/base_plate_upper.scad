include<params.scad>
use<tools.scad>
use<dome.scad>
use<seal_assembly.scad>

module base_plate_upper()
{
    linear_extrude(height = 2, twist = 0, slices = 0)
    {
        base_plate_upper_2D();
    }
}
module base_plate_upper_2D()
{
    hole_pos = r_from_dia(DOME_DIA-16-14);
    difference()
    {
        union()
        {
            difference()
            {
                translate([0, 0, 0])
                    circle(r = r_from_dia(DOME_DIA+30));
                translate([0, 0, 0])
                    circle(r = r_from_dia(DOME_DIA-16));
            }
            translate([0, -hole_pos, 0])
                union()
                {
                    circle(r = r_from_dia(30), center=true);
                    translate([0, -10])
                        square([30,20], center=true);
                }
            translate([0, hole_pos, 0])
                rotate([0,0,180]) union()
                {
                    circle(r = r_from_dia(30), center=true);
                    translate([0, -10])
                        square([30,20], center=true);
                }
            for(i=[0,1])
            for(j=[0,1])
            rotate([j*180,i*180,0]) translate([-17.98, -34.6, 0])
                round_corner(r1=3,r2=6,t1=245,t2=355,debug=false);
        }
        translate([0, -hole_pos, 0])
	        circle(r = r_from_dia(14), center=true);
        translate([0, hole_pos, 0])
	        circle(r = r_from_dia(14), center=true);
//	    for(i=[0:7])
//	    {
//	        translate([(DOME_DIA+20)/2*cos(i*45), (DOME_DIA+20)/2*sin(i*45), 0])
//		        circle(r = r_from_dia(3.1), center=true);
//	    }
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

$fn=1000;
base_plate_upper_2D();
