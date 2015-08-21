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
	module round_corner(width)
	{	
		difference()
		{
			square([width,width], center=true);
			translate([width/2,width/2])
		   		circle(r=width);
		}
	}
	difference()
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
		    	support_width = 2.5;
			    translate([0,60])
		    	for(i=[0,2,4])
		    	{
		    		rotate(60*i)
		    		{
				   		translate([0,r_from_dia(28-1)+35/2])
				    		square([support_width,35], center=true);
				   		translate([support_width,29.5/2])
				   		mirror([0,0])
				   		difference()
				   		{
				    		round_corner(support_width);
				   			translate([0,-support_width+0.2])
				    			square([support_width,support_width], center=true);
				    	}
				   		translate([-support_width,29.5/2])
				   		mirror([1,0])
				   		difference()
				   		{
				    		round_corner(support_width);
				   			translate([0,-support_width+0.2])
				    			square([support_width,support_width], center=true);
				    	}
				   		translate([support_width,46.75])
				   		mirror([0,1])
				    		round_corner(support_width);
				   		translate([-support_width,46.75])
				   		mirror([1,1])
				    		round_corner(support_width);
		    		}
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

$fn=360;
prop_shroud_flange();

