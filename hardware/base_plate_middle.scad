include<params.scad>
use<tools.scad>
use<dome.scad>
use<seal_assembly.scad>

module base_plate_middle()
{
    linear_extrude(height = 3, twist = 0, slices = 0)
    {
        base_plate_middle_2D();
    }
}
module base_plate_middle_2D()
{
    hole_pos = r_from_dia(DOME_DIA-16-14);
    difference()
    {
        union()
        {
            difference()
            {
                translate([0, 0, 0])
                    circle(r = r_from_dia(DOME_DIA+16));
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
            rotate([j*180,i*180,0]) translate([-65/2, -56.5/2, 0])
                difference()
                {
                    union()
                    {
                        translate([3.5, 3.5, 0])
                            circle(r = r_from_dia(13), center=true);
                        translate([3.5-5.925, 3.5+7.42, 0])
                            round_corner(r1=3,r2=6,t1=205,t2=310,debug=false);
                        translate([3.5+6.35, 3.5-7.05, 0])
                            round_corner(r1=3,r2=6,t1=132,t2=232,debug=false);
                    }
                    translate([3.5, 3.5, 0])
                        circle(r = r_from_dia(2.1), center=true);
                }
            for(i=[0,1])
            for(j=[0,1])
            rotate([j*180,i*180,0]) translate([-17.98, -34.6, 0])
                round_corner(r1=3,r2=6,t1=245,t2=355,debug=false);
        }
        translate([0, -hole_pos, 0])
            union()
            {
	            circle(r = r_from_dia(14), center=true);
                translate([0, -20])
                    square([14,40], center=true);
            }
        
        translate([0, hole_pos, 0])
            rotate([0,0,180]) union()
            {
	            circle(r = r_from_dia(14), center=true);
                translate([0, -20])
                    square([14,40], center=true);
            }
	    for(i=[0:7])
	    {
	        translate([(DOME_DIA+20)/2*cos(i*45), (DOME_DIA+20)/2*sin(i*45), 0])
		        circle(r = r_from_dia(3.1), center=true);
	    }
    }
}

$fn=100;
base_plate_middle_2D();
