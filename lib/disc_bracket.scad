include <./layout.scad>
include <./tile_tray.scad>

$wall_thickness = 2;

module disc_bracket(size, count=1) {
  outter_size = size + [$wall_thickness * 2, $wall_thickness * 2, 0];
  stack_height = stack_height(size[2], count);

  linear_extrude(stack_height) {
    difference() {
      resize([outter_size[0], outter_size[1]]) {
        offset_circle(outter_size[0]);
      }

      translate([$wall_thickness, $wall_thickness, 0]) {
        resize([size[0], size[1]]) {
          offset_circle(size[0]);
        }
      }
      
      translate([0, outter_size[1] / 2, 0]) {
        rotate(45) {
          square([outter_size[1], outter_size[1]], center=true);
        }
      }
      translate([outter_size[0], outter_size[1] / 2, 0]) {
        rotate(45) {
          square([outter_size[1], outter_size[1]], center=true);
        }
      }
    }
  }
}
