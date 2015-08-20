include<params.scad>
use<oring_holder.scad>
use<oring.scad>
use<base_plate.scad>

module base_plate_assembly()
{
    translate([0,0,0])
        oring_holder();
    translate([0,0,r_from_dia(ORING_DIA)])
        oring();
    translate([0, 0, -2.5])
        base_plate();
}

base_plate_assembly();