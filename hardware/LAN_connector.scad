include<params.scad>

module LAN_connector()
{
    color([0.2,0.2,0.2,1])
    union()
    {
        translate([0,0,0])
            cylinder(r=r_from_dia(30), h=1.5);
        translate([0,0,1.5])
            cylinder(r=r_from_dia(30), h=5, $fn = 6);
    }
    color([0.2,0.2,0.2,1]) translate([0,0,-5]) mirror([0,0,1])
    union()
    {
        translate([0,0,-10])
            cylinder(r=r_from_dia(20), h=10);
        translate([0,0,0])
            cylinder(r=r_from_dia(30), h=6, $fn = 6);
        translate([0,0,2.5])
            cylinder(r=r_from_dia(7), h=5, center=true);
        translate([0,0,6])
            cylinder(r=r_from_dia(25), h=6);
        translate([0,0,12])
            cylinder(r=r_from_dia(30), h=3);
        translate([0,0,15])
            cylinder(r=r_from_dia(30), h=12, $fn = 6);
        translate([0,0,27])
        	resize(newsize=[26,26,10]) sphere(r=r_from_dia(26));
    }
}

LAN_connector();

