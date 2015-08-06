include<params.scad>

module dome()
{
    color([1,1,1,0.3])
    {
        difference() {
            sphere(r = r_from_dia(DOME_DIA), $fn = 100);
            sphere(r = r_from_dia(DOME_DIA-DOME_THICK), $fn = 100);
            translate([ -100, -100, -200.01 ])
                cube([200,200,200]);
        }

        difference() {
            cylinder(r = r_from_dia(DOME_DIA+10), h = 5, $fn = 100);
            translate([ 0, 0, -1 ])
            cylinder(r = r_from_dia(DOME_DIA-DOME_THICK), h = 7, $fn = 100);
        }
    }
}

dome();

