include <../../lib/primitive/rounded_cube.scad>
include <../../lib/layout/layout.scad>

$rounding = 2;
$wall_thickness = 2;
$fn = 50;
$bleed = 0.01;

space_length = 151;
space_width = 114.5;

mid_length = 68.5;
mid_width = space_width;
mid_height = 14.8;

right_length = 72.5;
right_width = space_width;
right_height = 22.8;

left_length = space_length - mid_length - right_length;
left_width = space_width;
left_height = 30;

union() {
  rounded_cube([left_length, left_width, left_height], flat=true, $rounding=2);

  translate([left_length - $rounding * 2, 0, 0]) {
    rounded_cube([mid_length + $rounding * 4, mid_width, mid_height], flat=true, $rounding=2);
  }

  translate([left_length + mid_length, 0, 0]) {
    rounded_cube([right_length, right_width, right_height], flat=true, $rounding=2);
  }
}
