include<params.scad>
use<oring_holder.scad>
use<base_plate.scad>
use<prop_shroud_flange.scad>


module dxf()
{
    translate([55,55])
        prop_shroud_flange_2D();
}

$fn = 3600;
dxf();
