include<params.scad>
use<oring_holder.scad>
use<base_plate.scad>
use<prop_shroud_flange.scad>


module dxf()
{
    translate([DOME_DIA/2+20,DOME_DIA/2+20,-5])
        base_plate_2D();
}

$fn = 3600;
dxf();
