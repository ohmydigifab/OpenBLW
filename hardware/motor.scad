include<params.scad>

module motor()
{
    translate([0,0,2.5])
        cylinder(r=r_from_dia(26), h=5, center=true);
    translate([0,0,14.75])
        cylinder(r=r_from_dia(26), h=18.5, center=true);
    translate([0,0,27])
        cylinder(r=r_from_dia(7.5), h=6, center=true);
    translate([0,0,33.5])
        cylinder(r=r_from_dia(5), h=7, center=true);
}

motor();

