include<params.scad>
use<arm.scad>

module arm_upper()
{
    linear_extrude(height = 5, twist = 0, slices = 0)
    {
        arm_upper_2D();
    }
}
module arm_upper_2D()
{
	difference()
	{
	    arm_2D();
        circle(r=r_from_dia(PROP_SHROUD_DIA)-PROP_SHROUD_THICK);
    }
}

$fn = 1000;
arm_upper_2D();

