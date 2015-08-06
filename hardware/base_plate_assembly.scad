include<params.scad>
use<seal1.scad>
use<seal2.scad>
use<oring.scad>
use<base_plate.scad>

module base_plate_assembly()
{
    translate([0,0,5])
        seal1();
    translate([0,0,0])
        seal2();
    translate([0,0,r_from_dia(ORING_DIA)])
        oring();
    translate([0, 0, -5])
        base_plate();
}

base_plate_assembly();