include<params.scad>
use<oring_holder.scad>
use<oring.scad>
use<base_plate.scad>
use<arm.scad>

$fn = 3600;

module dxf()
{
    translate([DOME_DIA/2-10,-50])
        arm_2D();
}

dxf();
