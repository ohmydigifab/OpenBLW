include<params.scad>

module prop_shroud(height=85)
{
    color([1,1,1,0.3])
    difference()
    {
		translate([0, 0, height/2])
        	cylinder(r=r_from_dia(100), h=height, center=true, $fn = 100);
		translate([0, 0, height/2])
        	cylinder(r=r_from_dia(90), h=height+1, center=true, $fn = 100);
    }
}

prop_shroud();

