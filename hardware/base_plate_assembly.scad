include<params.scad>
use<oring_holder.scad>
use<oring.scad>
use<base_plate_upper.scad>
use<base_plate_middle.scad>
use<base_plate_bottom.scad>

module interface_board()
{
    square([72,56], center=true);
}
module base_plate_assembly()
{
    translate([0,0,0])
        oring_holder();
    translate([0,0,r_from_dia(ORING_DIA)])
        oring();
    translate([0, 0, -2])
        base_plate_upper();
    translate([0, 0, -5])
        base_plate_middle();
    translate([0, 0, -7])
    rotate([0,0,180])
        base_plate_bottom();
    translate([0,0,-12])
        oring_holder();
    translate([0,0,-7-r_from_dia(ORING_DIA)])
        oring();
    
    interface_board();
    
//    translate([-65/2, -56.5/2, 0])
//        color([0,1,0])
//		difference()
//        {
//            cube([65,56.5,2]);
//            translate([3.5, 3.5, 0])
//                cylinder(r=r_from_dia(2.75), h=100, center=true);
//            translate([3.5+58, 3.5, 0])
//                cylinder(r=r_from_dia(2.75), h=100, center=true);
//            translate([3.5, 3.5+49, 0])
//                cylinder(r=r_from_dia(2.75), h=100, center=true);
//            translate([3.5+58, 3.5+49, 0])
//                cylinder(r=r_from_dia(2.75), h=100, center=true);
//        }
}

$fn=360;
base_plate_assembly();