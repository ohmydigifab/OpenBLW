include<params.scad>

module arm()
{
    linear_extrude(height = 5, twist = 0, slices = 0)
    {
        arm_2D();
    }
}
module arm_2D()
{
	difference(0)
	{
		union()
		{
		    translate([0,DOME_DIA/2+15])
		    union()
		    {
		    	translate([0,45])
		    		circle(r=r_from_dia(20), $fn = 100);
		    	translate([0,20])
		    		square([20,50], center=true);
		    	difference()
		    	{
			    	translate([0,0])
			    		square([42.5,25], center=true);
			    	translate([25,12])
			    		circle(r=r_from_dia(30), $fn = 100);
			    	translate([-25,12])
			    		circle(r=r_from_dia(30), $fn = 100);
			   	}
		    }
		    translate([0,0])
		    intersection()
		    {
			    polygon(points=[[0,0],[-100,100],[100,100]],paths=[[0,1,2]]);
		    	difference()
		    	{
			    	circle(r=r_from_dia(DOME_DIA+30), $fn = 100);
		    		circle(r=r_from_dia(DOME_DIA), $fn = 100);
			    }
		    }
		}
	    for(i=[0:11])
	    {
	        translate([(DOME_DIA+15)/2*cos(i*30), (DOME_DIA+15)/2*sin(i*30), 0])
		        circle(r = r_from_dia(3.1), center=true, $fn = 100);
	    }
	}
}

arm();

