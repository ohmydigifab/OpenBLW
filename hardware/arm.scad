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
	module round_corner(width)
	{	
		difference()
		{
			square([width,width], center=true);
			translate([width/2,width/2])
		   		circle(r=width);
		}
	}
	prop_shroud_flange_2D();
	translate([0,-DOME_DIA+12])
	difference()
	{
	    union()
	    {
		   	//base plate joint
	   		translate([0,78])
	    	difference()
	    	{
		    	translate([0,12])
		    		square([50,10], center=true);
		    	translate([27,12.25])
		    		circle(r=r_from_dia(8.8));
		    	translate([-27,12.25])
		    		circle(r=r_from_dia(8.8));
		    	translate([0,60])
		    		circle(r=r_from_dia(100)-2);
	  	 	}
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
	    for(i=[0:7])
	    {
	        translate([(DOME_DIA+20)/2*cos(i*45+22.5), (DOME_DIA+20)/2*sin(i*45+22.5), 0])
		        circle(r = r_from_dia(3.1), center=true, $fn = 100);
	    }
	}
}

$fn = 360;
arm();

