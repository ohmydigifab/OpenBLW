include<params.scad>
use<fish_eye_lens.scad>
use<camera.scad>
use<amp.scad>
use<base_plate_assembly.scad>
use<LAN_connector.scad>
use<dome.scad>

module assembly()
{
    translate([0, 0, 45])
        fish_eye_lens();
    translate([0, -2.5, 33])
        camera();
    translate([-38, 20, 25])
        import("raspberry_pi_model_B.stl");
    translate([0, 0, 15])
        amp();
    translate([0, 0, 0])
        base_plate_assembly();
    translate([0, -45, 0])
      LAN_connector();
    translate([0, 0, 0])
      dome();
}

assembly();