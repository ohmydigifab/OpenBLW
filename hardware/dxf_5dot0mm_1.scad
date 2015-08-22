include<params.scad>
use<oring_holder.scad>
use<oring.scad>
use<base_plate.scad>
use<arm.scad>


module dxf()
{
    translate([DOME_DIA/2+20,DOME_DIA/2+20,5])
        oring_holder_2D();
}

$fn = 3600;
dxf();
