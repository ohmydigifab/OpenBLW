include<params.scad>

module prop_nose(radius=25)
{
	difference()
	{
		translate([0,0,-10])
			resize([radius,radius,radius*2]) sphere(r = 1);
		translate([0,0,-50])
			cube([100,100,100], center=true);
	}
}

$fn = 100;
prop_nose();

