include<params.scad>

module flow_cylinder()
{
    translate([0,0,0])
        cylinder(r=r_from_dia(23), h=14.5, center=true);
}

flow_cylinder();

