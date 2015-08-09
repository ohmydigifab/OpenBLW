include<params.scad>

module prop_shroud()
{
    color([1,1,1,0.3])
    difference()
    {
		translate([0, 0, 50/2])
        	cylinder(r=r_from_dia(100), h=50, center=true, $fn = 100);
		translate([0, 0, 50/2])
        	cylinder(r=r_from_dia(90), h=51, center=true, $fn = 100);
    }
}

prop_shroud();

