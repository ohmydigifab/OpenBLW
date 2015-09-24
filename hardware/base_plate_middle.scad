include<params.scad>
use<tools.scad>

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
            //hole
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
            //bolt hole for raspi
            for(i=[0,1])
            for(j=[0,1])
            rotate([j*180,i*180,0])
            translate([-58/2, -49/2, 0])
                difference()
                {
                    union()
                    {
                        circle(r = r_from_dia(13), center=true);
                        translate([-6.016, 7.35, 0])
                            round_corner(r1=3,r2=6,t1=205,t2=309,debug=false);
                        translate([6.23, -7.165, 0])
                            round_corner(r1=3,r2=6,t1=132,t2=232,debug=false);
                    }
                    circle(r = r_from_dia(2.1), center=true);
                }
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

$fn=1000;
base_plate_middle_2D();