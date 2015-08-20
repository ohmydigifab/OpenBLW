include<params.scad>
use<oring_holder.scad>
use<base_plate.scad>
use<prop_shroud_flange.scad>

$fn = 3600;

module dxf()
{
    translate([55,-95])
        prop_shroud_flange_2D();
}

dxf();
