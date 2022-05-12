include <../../lib/config/constants.scad>
include <../../lib/primitive/rounded_cube.scad>
include <../../lib/primitive/scoop.scad>
include <../../lib/lid/dovetail_lid.scad>
include <../../lib/layout/layout.scad>

$fn = 50;

box_width = 213;
food_type_count = 5;

usable_tray_width = box_width - $wall_thickness * (food_type_count+1);

test_scoop_width = 40.2;

box_size = [
  box_width,
  115,
  30,
];

scoop_size = [
  usable_tray_width / 5,
  box_size[1] - $wall_thickness * 2,
  box_size[2] - $wall_thickness + $bleed,
];

dovetail_lid(spin_orientation_size(box_size), honeycomb_diameter=15);
