include<params.scad>

module prop_shroud_flange()
{
    linear_extrude(height = 5, twist = 0, slices = 0)
    {
        prop_shroud_flange_2D();
    }
}
module prop_shroud_flange_2D()
{
	difference(0)
	{
		union()
		{
		    translate([0,DOME_DIA/2+15])
		    union()
		    {
		    	//motor bed
		    	translate([0,60])
		    	difference()
		    	{
		    		circle(r=r_from_dia(28));
		    		circle(r=r_from_dia(8));
			    	for(i=[0,2])
			    	{
			    		rotate(90*i+45)
					    	translate([0,r_from_dia(16)])
					    		circle(r=r_from_dia(3.1));
				    }
			    	for(i=[1,3])
			    	{
			    		rotate(90*i+45)
					    	translate([0,r_from_dia(19)])
					    		circle(r=r_from_dia(3.1));
				    }
		    	}
		    	//support
			    translate([0,60])
		    	for(i=[0,2,4])
		    	{
		    		rotate(60*i)
			   		translate([0,r_from_dia(28-1)+35/2])
			    		square([2.5,35], center=true);
		    	}
		    	//shroud flange
		    	difference()
		    	{
			    	translate([0,60])
			    		circle(r=r_from_dia(100)+0.5);
			    	translate([0,60])
			    		circle(r=r_from_dia(100)-2);
			   	}
		    }
		}
	}
}

prop_shroud_flange();

