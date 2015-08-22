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
	translate([0,-DOME_DIA+10])
	difference()
	{
	    union()
	    {
		   	//base plate joint
	   		translate([0,78])
	    	difference()
	    	{
		    	translate([0,14])
		    		square([48.5,15], center=true);
		    	translate([26.5,13.2])
		    		circle(r=r_from_dia(10.15));
		    	translate([-26.5,13.2])
		    		circle(r=r_from_dia(10.15));
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
	        translate([(DOME_DIA+20)/2*cos(i*45), (DOME_DIA+20)/2*sin(i*45), 0])
		        circle(r = r_from_dia(3.1), center=true, $fn = 100);
	    }
	}
}

$fn = 360;
arm();

