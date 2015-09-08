include<params.scad>
use<prop_shroud_flange.scad>

module arm()
{
    linear_extrude(height = 5, twist = 0, slices = 0)
    {
        arm_2D();
    }
}
module arm_2D()
{
	prop_shroud_flange_2D();
	translate([0,-100/2])
	difference()
	{
	    union()
	    {
		   	//base plate joint
	   		translate([0,0])
	    	difference()
	    	{
                if(DOME_DIA == 150)
                {
                    translate([0,1])
                        square([49,20], center=true);
                }
                else if(DOME_DIA == 100)
                {
                    translate([0,1])
                        square([48,20], center=true);
                }
                if(DOME_DIA == 150)
                {
                    translate([26.95,0.93])
                        circle(r=r_from_dia(10));
                    translate([-26.95,0.93])
                        circle(r=r_from_dia(10));
                    translate([0,r_from_dia(100)-2])
                        circle(r=r_from_dia(100)-2);
                }
                else if(DOME_DIA == 100)
                {
                    translate([25.8,0.2])
                        circle(r=r_from_dia(10.25));
                    translate([-25.8,0.2])
                        circle(r=r_from_dia(10.25));
                    translate([0,r_from_dia(100)-2])
                        circle(r=r_from_dia(100)-2);
                }
	  	 	}
	        translate([0,-(DOME_DIA+30)/2])
		    intersection()
		    {
			    polygon(points=[[0,0],[-100,100],[100,100]],paths=[[0,1,2]]);
		    	difference()
		    	{
			    	circle(r=r_from_dia(DOME_DIA+30));
		    		circle(r=r_from_dia(DOME_DIA));
			    }
		    }
		}
	   	translate([0,-(DOME_DIA+30)/2])
	    for(i=[0:7])
	    {
	        translate([(DOME_DIA+20)/2*cos(i*45), (DOME_DIA+20)/2*sin(i*45), 0])
		        circle(r = r_from_dia(3.1), center=true, $fn = 100);
	    }
	}
}

$fn = 1000;
arm_2D();

