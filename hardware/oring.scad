include<params.scad>

module oring()
{
    color([0,0,0,1])
    {
        rotate_extrude(convexity = 10)
        translate([r_from_dia(DOME_DIA+ORING_DIA), 0, 0])
        circle(r = r_from_dia(ORING_DIA));
    }
}

oring();

