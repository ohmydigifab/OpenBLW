include<params.scad>
use<oring_holder.scad>
use<oring.scad>
use<base_plate.scad>
use<arm.scad>


module dxf()
{
    translate([DOME_DIA/2-8,90])
        arm_2D();
}

$fn = 3600;
dxf();
