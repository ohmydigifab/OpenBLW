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
		    	translate([0,60])
		    	difference()
		    	{
		    		circle(r=r_from_dia(28), $fn = 100);
		    		circle(r=r_from_dia(8), $fn = 100);
			    	for(i=[0,2])
			    	{
			    		rotate(90*i+45)
					    	translate([0,8])
					    		circle(r=r_from_dia(3.1), $fn = 100);
				    }
			    	for(i=[1,3])
			    	{
			    		rotate(90*i+45)
					    	translate([0,10])
					    		circle(r=r_from_dia(3.1), $fn = 100);
				    }
		    	}
			    translate([0,60])
		    	for(i=[0,2,3,4])
		    	{
		    		rotate(60*i)
			   		translate([0,13+33/2])
			    		square([5,34], center=true);
		    	}
		    	difference()
		    	{
		    		union()
		    		{
				    	translate([0,20])
				    		square([20,50], center=true);
				    	translate([0,60])
				    		circle(r=r_from_dia(100), $fn = 100);
		    		}
			    	translate([0,60])
			    		circle(r=r_from_dia(90), $fn = 100);
			   	}
		    	difference()
		    	{
			    	translate([0,0])
			    		square([42.5,30], center=true);
			    	translate([23.5,6])
			    		circle(r=r_from_dia(18), $fn = 100);
			    	translate([-23.5,6])
			    		circle(r=r_from_dia(18), $fn = 100);
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

