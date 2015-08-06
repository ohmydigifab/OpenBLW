include<params.scad>

module camera()
{
    color([0,1,0,1])
    difference()
    {
        translate([0,0,0.5])
            cube([25,24,1], center=true);
        translate([-11,-10,0])
            cylinder(r=r_from_dia(2), h=10, center=true, $fn = 20);
        translate([11,-10,0])
            cylinder(r=r_from_dia(2), h=10, center=true, $fn = 20);
        translate([-11,2.5,0])
            cylinder(r=r_from_dia(2), h=10, center=true, $fn = 20);
        translate([11,2.5,0])
            cylinder(r=r_from_dia(2), h=10, center=true, $fn = 20);
    }
    color([0.2,0.2,0.2,1]) translate([0,2.5,1])
    union()
    {
        translate([0,0,1.5])
            cube([8,8,3], center=true);
        translate([0,0,2])
            cylinder(r=r_from_dia(8), h=4, center=true, $fn = 20);
        translate([0,0,2.5])
            cylinder(r=r_from_dia(7), h=5, center=true, $fn = 20);
    }
    color([0.7,0.6,0.3,1])
        translate([0,9.5,-1])
            cube([20,5,2], center=true);
}

camera();

