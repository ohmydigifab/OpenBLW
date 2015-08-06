include<params.scad>

module amp()
{
	cube([60,55,10], center=true);
    translate([4.5,35,0]) rotate([90,0,0])
	    cylinder(r=r_from_dia(10), h=15, center=true);
    translate([15,35,0]) rotate([90,0,0])
	    cylinder(r=r_from_dia(10), h=15, center=true);
}

amp();

