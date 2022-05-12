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

difference() {
  rounded_cube(box_size, flat_top=true, $rounding=1);

  translate($wall_cube) {
    for(i=[0:food_type_count-1]) {
      translate([offset(scoop_size[0], i), 0, 0]) {
        scoop(scoop_size, edge="bottom", $rounding=1);
      }
    }
  }

  spin_orientation(box_size) {
    dovetail_lid_cutout(spin_orientation_size(box_size));
  }
}
