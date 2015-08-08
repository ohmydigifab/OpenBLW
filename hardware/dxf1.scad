include<params.scad>
use<seal1.scad>
use<seal2.scad>
use<oring.scad>
use<base_plate.scad>
use<arm.scad>

module dxf()
{
    translate([DOME_DIA/2+25,DOME_DIA/2+20,-5])
        base_plate_2D();
    translate([DOME_DIA/2+25,3*DOME_DIA/2+34,5])
        seal1_2D();
    translate([DOME_DIA/2+25,5*DOME_DIA/2+25,0])
        seal2_2D();
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
