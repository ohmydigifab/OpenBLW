
module  minkowski_square(dimension, r=2)
{
    minkowski()
    {
        translate([r, r])
        square([dimension.x-r*2,dimension.y-r*2]);
        circle(r=r);
    }
}
module camera_holder()
{
    linear_extrude(height = 2, twist = 0, slices = 0)
    {
        camera_holder_2D();
    }
}
module camera_holder_2D()
{
    difference(){
        r_rad=1;
        minkowski()
        {
            $fn=100;
            r_rad2=r_rad*2;
            translate([r_rad, r_rad])
            difference()
            {
                square([56-r_rad*2,65-r_rad*2]);
//                translate([31-30/2-r_rad2, -r_rad*2])
//                    minkowski_square([24+r_rad2,10+r_rad*2], r=r_rad2);
                translate([56+r_rad2-r_rad, 7-r_rad*2])
                    mirror([1,0])
                    minkowski_square([7+r_rad2+r_rad,51+r_rad*2], r=r_rad2);
                translate([56-7+r_rad2-r_rad, 11+r_rad*2])
                    mirror([1,0])
                    minkowski_square([7+r_rad2+r_rad,20+r_rad*2], r=r_rad2);
            }
            circle(r=r_rad);
        }
        //raspi attachemnt holes
        translate([3.5, 3.5])
        circle(r=2.6/2);
        translate([3.5, 61.5])
        circle(r=2.6/2);
        translate([52.5, 3.5])
        circle(r=2.6/2);
        translate([52.5, 61.5])
        circle(r=2.6/2);
        //flight contrer attachemnt holes
        //translate([43, 8])
        //circle(r=2.2/2);
        //translate([13, 8])
        //circle(r=2.2/2);
        //translate([13, 38])
        //circle(r=2.2/2);
        //translate([43, 38])
        //circle(r=2.2/2);
        //camera attachemnt holes
        translate([18.5, 21.5])
        circle(r=1.75/2);
        translate([39.5, 21.5])
        circle(r=1.75/2);
        translate([39.5, 34])
        circle(r=1.75/2);
        translate([18.5, 34])
        circle(r=1.75/2);
        //camera hole
        translate([25, 29.5])
        {
            square([8,8]);
            translate([4, 4])
            for(i=[0,1])
            {
                mirror([0,i])
                for(j=[0,1])
                {
                    mirror([j,0])
                    translate([3.3, 3.3])
                        circle(r=2/2);
                }
            }
        }
        translate([25-0.25, 20.5])
            minkowski_square([8.5,6.5], r=1);
        
        //camera cable hole
        translate([2.5, 44])
        minkowski_square([17,2.01], r=1);
    }
}
$fn=360;

translate([20, -80, 0])
camera_holder_2D();