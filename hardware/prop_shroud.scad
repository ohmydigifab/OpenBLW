include<params.scad>

module prop_shroud(height=40)
{
    color([1,1,1,0.3])
    difference()
    {
		translate([0, 0, height/2])
        	cylinder(r=r_from_dia(PROP_SHROUD_DIA), h=height, center=true);
		translate([0, 0, height/2])
        	cylinder(r=r_from_dia(PROP_SHROUD_DIA)-PROP_SHROUD_THICK, h=height+1, center=true);
    }
}

prop_shroud();

