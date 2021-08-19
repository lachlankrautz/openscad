include <../../lib/rounded_cube.scad>
include <../../lib/elephant_foot.scad>
include <../../lib/dish.scad>

// Config
$fn = 50;
// $fn = 10;
$wall_thickness = 2;
$rounding = 2;
$bleed = 0.01;

total_size = [
  84,
  50,
  22
];

die_size = 17;
cube_foot_rounding = 1;
dice_cutout_size = [
  die_size * 2 + cube_foot_rounding * 2,
  die_size * 2 + cube_foot_rounding * 2,
  8,
];

right_box_size = [
  dice_cutout_size[0] + $wall_thickness * 2 + $rounding * 2,
  total_size[1],
  total_size[2] - 8
];

left_box_size = [
  total_size[0] - right_box_size[0] + $rounding * 2,
  50,
  22,
];

dish_size = [
  left_box_size[0] - $wall_thickness * 2,
  left_box_size[1] - $wall_thickness * 2,
  left_box_size[2] - $wall_thickness,
];

difference() {
  union() {
    rounded_cube(left_box_size, flat_top=true, $rounding=2);
    translate([total_size[0] - right_box_size[0], 0, 0]) {
      rounded_cube(right_box_size, $rounding=2);
    }
  }

  translate([$wall_thickness, $wall_thickness, total_size[2] - dish_size[2]]) {
    dish([
      dish_size[0],
      dish_size[1],
      dish_size[2] + $bleed,
    ]);
  }

  translate([
    total_size[0] - right_box_size[0] + $wall_thickness + $rounding * 2,
    (right_box_size[1] - dice_cutout_size[1]) / 2,
    right_box_size[2] - dice_cutout_size[2],
  ]) {
    elephant_foot([
      dice_cutout_size[0],
      dice_cutout_size[1],
      dice_cutout_size[2] + $bleed,
    ], flat_bottom=true, $rounding=cube_foot_rounding);
  }
}
