include <../../lib/rounded_cube.scad>
include <../../lib/layout.scad>
include <../../lib/scoop.scad>

$wall_thickness = 2;
$bleed = 0.01;
$fn = 50;

standee_depth = 10;
wall_offset = [$wall_thickness, $wall_thickness, $wall_thickness];

box_size = [
  186,
  114,
  25,
];

// TODO fix; too short
cardboard_size = [
  125,
  85,
  2,
];

// TODO fix; too short
plastic_grip_size = [
  115,
  10,
  5.5,
];

plastic_stand_size = [
  120,
  2.5,
  11,
];

cutout_size = [136, box_size[1], box_size[2]]
  - [$wall_thickness * 2, $wall_thickness * 2, $wall_thickness]
  + [0, 0, $bleed - standee_depth];

right_cutout_size = [
  box_size[0] - cutout_size[0] - $wall_thickness * 3,
  cutout_size[1],
  20,
];

difference() {
  rounded_cube(box_size, flat_top=true, $rounding=1);

  translate(wall_offset) {
    translate([0, 0, standee_depth]) {

      // Cardboard
      translate([
        (cutout_size[0] - cardboard_size[0]) / 2,
        (cutout_size[1] - cardboard_size[1]) / 2,
        - cardboard_size[2],
      ]) {
        // not sure why it needs a bleed of 1
        rounded_cube(cardboard_size + [0, 0, 1], flat_top=true, $rounding=1);
      }

      // top stands
      translate([
        (cutout_size[0] - plastic_grip_size[0]) / 2,
        cutout_size[1] - (cutout_size[1] - cardboard_size[1]) / 2 - plastic_grip_size[1],
        - plastic_grip_size[2],
      ]) {
        rounded_cube(plastic_grip_size, flat=true, $rounding=1);
      }
      translate([
        (cutout_size[0] - plastic_stand_size[0]) / 2,
        cutout_size[1] - (cutout_size[1] - cardboard_size[1]) / 2 - plastic_stand_size[1],
        - plastic_stand_size[2],
      ]) {
        rounded_cube(plastic_stand_size, flat=true, $rounding=1);
      }

      // bottom stands
      translate([
          (cutout_size[0] - plastic_grip_size[0]) / 2,
          (cutout_size[1] - cardboard_size[1]) / 2,
        - plastic_grip_size[2],
        ]) {
        rounded_cube(plastic_grip_size, flat=true, $rounding=1);
      }
      translate([
          (cutout_size[0] - plastic_stand_size[0]) / 2,
          (cutout_size[1] - cardboard_size[1]) / 2,
        - plastic_stand_size[2],
        ]) {
        rounded_cube(plastic_stand_size, flat=true, $rounding=1);
      }

      rounded_cube(cutout_size, flat_top = true, $rounding = 1);
    }

    translate([offset(cutout_size[0]), 0, 5]) {
      scoop(right_cutout_size, edge="bottom");
    }
  }
}
