include<params.scad>

module prop_nose()
{
	difference()
	{
		translate([0,0,-10])
			resize([30,30,30*2]) sphere(r = 30);
		translate([0,0,-50])
			cube([100,100,100], center=true);
	}
}

prop_nose();

