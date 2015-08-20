include<params.scad>

module prop_shroud(height=60)
{
    color([1,1,1,0.3])
    difference()
    {
		translate([0, 0, height/2])
        	cylinder(r=r_from_dia(100), h=height, center=true);
		translate([0, 0, height/2])
        	cylinder(r=r_from_dia(100)-2, h=height+1, center=true);
    }
}

prop_shroud();

