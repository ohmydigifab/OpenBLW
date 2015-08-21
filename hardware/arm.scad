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
	module round_corner(width)
	{	
		difference()
		{
			square([width,width], center=true);
			translate([width/2,width/2])
		   		circle(r=width);
		}
	}
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
		    	support_width = 2.5;
			    translate([0,60])
		    	for(i=[1,3,5])
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
		    		union()
		    		{
				    	translate([0,20])
				    		square([20,50], center=true);
				    	translate([0,60])
				    		circle(r=r_from_dia(100)+0.5);
		    		}
			    	translate([0,60])
			    		circle(r=r_from_dia(100)-2);
			   	}
			   	//base plate joint
		    	difference()
		    	{
			    	translate([0,0])
			    		square([42.5,28], center=true);
			    	translate([23.5,6])
			    		circle(r=r_from_dia(18));
			    	translate([-23.5,6])
			    		circle(r=r_from_dia(18));
			    	translate([0,60])
			    		circle(r=r_from_dia(100)-2);
			   	}
		    }
		    translate([0,0])
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
	    for(i=[0:11])
	    {
	        translate([(DOME_DIA+20)/2*cos(i*30), (DOME_DIA+20)/2*sin(i*30), 0])
		        circle(r = r_from_dia(3.1), center=true, $fn = 100);
	    }
	}
}

arm();

