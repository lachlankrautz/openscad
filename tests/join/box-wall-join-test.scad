include <../../lib/join/box-wall-join.scad>
include <../../lib/primitive/rounded_cube.scad>

$fn = 50;

size = [
  10,
  10,
  5
];

box_rounding = 1;

box_wall_join(size) {
  rounded_cube(size, flat_top = true, $rounding=box_rounding);
}

