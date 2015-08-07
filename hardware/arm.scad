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
    union()
    {
    	translate([0,15])
    		circle(r=r_from_dia(20), $fn = 100);
    	translate([0,0])
    		square([20,30], center=true);
    	difference()
    	{
	    	translate([0,-30])
	    		square([40,30], center=true);
	    	translate([25,-15])
	    		circle(r=r_from_dia(30), $fn = 100);
	    	translate([-25,-15])
	    		circle(r=r_from_dia(30), $fn = 100);
	    	translate([0,-92])
	    		circle(r=r_from_dia(100), $fn = 100);
	   	}
    	translate([18,-37])
    		circle(r=r_from_dia(16), $fn = 100);
    	translate([-18,-37])
    		circle(r=r_from_dia(16), $fn = 100);
    }
}

arm();

