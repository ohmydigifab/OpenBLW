include<params.scad>
use<oring_holder.scad>
use<oring.scad>
use<base_plate.scad>
use<arm.scad>

$fn = 360;

module dxf()
{
    translate([DOME_DIA/2+25,DOME_DIA/2+20,-5])
        base_plate_2D();
    translate([DOME_DIA/2+25,3*DOME_DIA/2+55,5])
        oring_holder_2D();
    translate([DOME_DIA-10,68])
        rotate(-90) arm_2D();
    translate([DOME_DIA+250,68+100])
        rotate(90) arm_2D();
    translate([DOME_DIA-10,68+200])
        rotate(-90) arm_2D();
    translate([DOME_DIA+250,68+300])
        rotate(90) arm_2D();
}

dxf();
