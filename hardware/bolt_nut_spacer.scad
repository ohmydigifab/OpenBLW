include<params.scad>

module bolt(head_size=5, head_heigt=3, bolt_size=3, bolt_hight=5)
{
	difference()
	{
	    translate([0,0,head_heigt/2])
	        cylinder(r=r_from_dia(head_size), h=head_heigt, center=true, $fn = 100);
	    translate([0,0,head_heigt/2])
	        cylinder(r=r_from_dia(bolt_size), h=head_heigt+2, center=true, $fn = 6);
	}
    translate([0,0,-bolt_hight/2])
        cylinder(r=r_from_dia(bolt_size), h=bolt_hight, center=true, $fn = 100);
}


module spacer(outer=5, inner=3.1, hight=2.5)
{
	difference()
	{
	    translate([0,0,hight/2])
	        cylinder(r=r_from_dia(outer), h=hight, center=true, $fn = 100);
	    translate([0,0,hight/2])
	        cylinder(r=r_from_dia(inner), h=hight+2, center=true, $fn = 100);
	}
}

module nut(outer=5, inner=3.1, hight=2.5)
{
	difference()
	{
	    translate([0,0,hight/2])
	        cylinder(r=r_from_dia(outer), h=hight, center=true, $fn = 6);
	    translate([0,0,hight/2])
	        cylinder(r=r_from_dia(inner), h=hight+2, center=true, $fn = 100);
	}
}

translate([0,0,0.5])
bolt();
spacer(7,3.1,0.5);
translate([0,0,-3])
nut();

