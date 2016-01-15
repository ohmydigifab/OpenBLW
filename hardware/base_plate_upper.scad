include<params.scad>
use<tools.scad>
use<dome.scad>
use<base_plate_middle.scad>

module base_plate_upper()
{
    linear_extrude(height = 2, twist = 0, slices = 0)
    {
        base_plate_upper_2D();
    }
}
module base_plate_upper_2D()
{
    roundess=3;
    hole_pos = r_from_dia(DOME_DIA)-DOME_THICK-r_from_dia(14)-2;
    difference()
    {
        translate([0, 0, 0])
            circle(r = r_from_dia(DOME_DIA+30));
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
        for(i=[0,1])
        {
            mirror([i,0])
            translate([-hole_pos, 0, 0])
	            circle(r = r_from_dia(14), center=true);
        }
        //bolt hole for raspi
        //translate([-2, 0, 0])
        for(i=[0,1])
            mirror([0,i]) for(j=[0,1])
                mirror([j,0]) translate([-58/2, -49/2, 0])
                    circle(r = r_from_dia(3.5), center=true);
            
//		bolt_size = 3.5;
//	    for(i=[0:11])
//	    {
//	        translate([(DOME_DIA+20)/2*cos(i*30), (DOME_DIA+20)/2*sin(i*30), 0])
//		        circle(r = r_from_dia(bolt_size), center=true);
//	    }
		//arm
		arm_pos = (DOME_DIA+30)/2-5+PROP_SHROUD_DIA/2;
	    for(i=[0:3])
		{
			rotate([0,0,90*i+45])
			{
			    translate([0, arm_pos])
	        		circle(r = r_from_dia(PROP_SHROUD_DIA));
			}
		}
    }
}

$fn=360;
base_plate_upper_2D();
