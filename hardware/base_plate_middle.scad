include<params.scad>
use<tools.scad>

module base_plate_middle()
{
    linear_extrude(height = 3, twist = 0, slices = 0)
    {
        base_plate_middle_2D();
    }
}
module base_plate_middle_2D()
{
    roundess=3;
    hole_pos = r_from_dia(DOME_DIA)-DOME_THICK-r_from_dia(14)-2;
    difference()
    {
        union()
        {
            difference()
            {
                translate([0, 0, 0])
                    circle(r = r_from_dia(DOME_DIA+16));
                minkowski()
                {
                    $fn=100;
                    difference()
                    {
                        circle(r = r_from_dia(DOME_DIA+16-1));
                        base_plate_inner_2D(margin=roundess);
                    }
                    circle(r = roundess, center=true);
                }
            }
            //bolt hole for raspi
            translate([0, 0, 0])
                union()
                {
                    for(i=[0,1])
                    for(j=[0,1])
                    minkowski()
                    {
                        $fn=100;
                        rotate([j*180,i*180,0])
                        translate([-56/2, -56/2, 0])
                        rotate([0,0,45])
                            square([2,4],center=true);
                        circle(r = 6, center=true);
                    }
                }
        }
        for(i=[0,1])
        {
            mirror([i,0])
            translate([-hole_pos, 0, 0])
                union()
                {
                    circle(r = r_from_dia(14), center=true);
                    translate([-20, 0])
                        square([40,14], center=true);
                }
        }
        //bolt hole for raspi
        //translate([-2, 0, 0])
        for(i=[0,1])
            mirror([0,i]) for(j=[0,1])
                mirror([j,0]) translate([-58/2, -49/2, 0])
                    circle(r = r_from_dia(3.5), center=true);
        for(i=[0,1])
            mirror([0,i]) for(j=[0,1])
                mirror([j,0]) translate([-49/2, -58/2, 0])
                    circle(r = r_from_dia(3.5), center=true);
    }
}
module base_plate_inner_2D(margin=0)
{
    hole_pos = r_from_dia(DOME_DIA)-DOME_THICK-r_from_dia(14)-2;
    difference()
    {
        translate([0, 0, 0])
            circle(r = r_from_dia(DOME_DIA+16));
        translate([0, 0, 0])
            circle(r = r_from_dia(DOME_DIA)-DOME_THICK-margin);
    }
    //hole
    for(i=[0,1])
    {
        mirror([i,0])
        translate([-hole_pos, 0, 0])
            union()
            {
                circle(r = r_from_dia(16)+5+margin, center=true);
                translate([-10, 0])
                    square([20,(r_from_dia(16)+5+margin)*2], center=true);
            }
     }
    //bolt hole for raspi
    translate([0, 0, 0])
        union()
        {
            for(i=[0,1])
            for(j=[0,1])
            rotate([j*180,i*180,0])
            translate([-56/2, -56/2, 0])
            {
                //circle(r = r_from_dia(17)+margin, center=true);
                rotate([0,0,45])
                translate([-5, 0, 0])
                    square([15,16+margin*2],center=true);
            }
        }
}

$fn=360;
//base_plate_inner_2D();
base_plate_middle_2D();