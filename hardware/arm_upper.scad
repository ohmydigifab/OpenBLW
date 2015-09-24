include<params.scad>
use<prop_shroud_flange.scad>

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
	    prop_shroud_flange_2D();
        circle(r=r_from_dia(PROP_SHROUD_DIA)-2);
    }
	translate([0,-PROP_SHROUD_DIA/2])
	difference()
	{
	    union()
	    {
		   	//base plate joint
	   		translate([0,0])
	    	difference()
	    	{
                if(DOME_DIA == 150)
                {
                    translate([0,1])
                        square([49,20], center=true);
                }
                else if(DOME_DIA == 100)
                {
                    translate([0,1])
                        square([51.5,20], center=true);
                }
                if(DOME_DIA == 150)
                {
                    translate([26.95,0.93])
                        circle(r=r_from_dia(10));
                    translate([-26.95,0.93])
                        circle(r=r_from_dia(10));
                    translate([0,r_from_dia(PROP_SHROUD_DIA)-PROP_SHROUD_THICK])
                        circle(r=r_from_dia(PROP_SHROUD_DIA)-PROP_SHROUD_THICK);
                }
                else if(DOME_DIA == 100)
                {
                    translate([27.5,2.85])
                        circle(r=r_from_dia(7.25));
                    translate([-27.5,2.85])
                        circle(r=r_from_dia(7.25));
                    translate([0,r_from_dia(PROP_SHROUD_DIA)-PROP_SHROUD_THICK])
                        circle(r=r_from_dia(PROP_SHROUD_DIA)-PROP_SHROUD_THICK);
                }
	  	 	}
	        translate([0,-(DOME_DIA+30)/2+5])
		    intersection()
		    {
			    polygon(points=[[0,0],[-100,100],[100,100]],paths=[[0,1,2]]);
		    	difference()
		    	{
			    	circle(r=r_from_dia(DOME_DIA+30));
	        		translate([0,-ORING_DIA])
		    		circle(r=r_from_dia(DOME_DIA)+ORING_DIA);
	        		translate([0,(DOME_DIA+30)/2-5+PROP_SHROUD_DIA/2])
		    			circle(r=r_from_dia(PROP_SHROUD_DIA));
			    }
		    }
		}
		bolt_size = 2.6;
	   	translate([0,-(DOME_DIA+30)/2+5])
	    for(i=[1,2,3,4])
	    {
	        translate([(DOME_DIA+20)/2*cos(i*30+15), (DOME_DIA+20)/2*sin(i*30+15), 0])
		        circle(r = r_from_dia(bolt_size+0.1), center=true, $fn = 100);
	    }
	   	translate([0,-(DOME_DIA+30)/2+5])
	    for(i=[2,3])
	    {
	        translate([(DOME_DIA+20)/2*cos(i*30+15), (DOME_DIA+20)/2*sin(i*30+15)-5, 0])
		        circle(r = r_from_dia(bolt_size+0.1), center=true, $fn = 100);
	        translate([(DOME_DIA+20)/2*cos(i*30+15), (DOME_DIA+20)/2*sin(i*30+15)-3, 0])
		        circle(r = r_from_dia(bolt_size+0.1), center=true, $fn = 100);
	        translate([(DOME_DIA+20)/2*cos(i*30+15), (DOME_DIA+20)/2*sin(i*30+15)-1.5, 0])
		        square([bolt_size+0.1,3], center=true);
	        translate([(DOME_DIA+20)/2*cos(i*30+15), (DOME_DIA+20)/2*sin(i*30+15)-4, 0])
		        square([bolt_size-0.1,2], center=true);
	    }
	}
}

$fn = 1000;
arm_upper_2D();

