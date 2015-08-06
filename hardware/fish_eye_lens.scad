include<params.scad>

module fish_eye_lens()
{
    color([0.2,0.2,0.2,1])
    union()
    {
        translate([0,0,-3.75])
            cylinder(r=r_from_dia(17), h=6.5, center=true, $fn = 50);
        translate([0,0,2.5])
            cylinder(r=r_from_dia(31), h=6, center=true, $fn = 50);
        translate([0,0,2.75])
            cylinder(r=r_from_dia(35), h=5.5, center=true, $fn = 50);
        translate([0,0,8])
            cylinder(r=r_from_dia(31), h=5, center=true, $fn = 50);
    }
    color([0.5,0.5,0.5,0.9]) translate([0,0,10])
        resize(newsize=[26,26,10]) sphere(r=r_from_dia(26));
}

fish_eye_lens();

