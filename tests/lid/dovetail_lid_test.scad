include <../../lib/primitive/rounded_cube.scad>
include <../../lib/lid/dovetail_lid.scad>

$fn = 50;
$rounding = 2;

box_size = [50, 50, 20];
$wall_thickness = 1.5;

difference() {
  // rounded_cube(box_size, flat_top=true);
  cube(box_size);
  dovetail_lid_cutout(box_size);
}

translate([60, 0, 0]) {
  dovetail_lid(box_size);
}
