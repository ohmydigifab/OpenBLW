include<params.scad>

module motor()
{
    translate([0,0,2.0])
        cylinder(r=r_from_dia(23), h=4, center=true);
    translate([0,0,11.5])
        cylinder(r=r_from_dia(23), h=14, center=true);
    translate([0,0,18.5+1.5])
        cylinder(r=r_from_dia(5), h=3, center=true);
}

motor();

