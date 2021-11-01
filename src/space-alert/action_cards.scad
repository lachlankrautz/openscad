include <../../lib/compound/notched_cube.scad>
include <../../lib/primitive/rounded_cube.scad>
include <../../lib/layout/layout.scad>
include <../../lib/tile_stack.scad>

// Config
$fn = 50;
$padding = 2;
$rounding = 2;

card_size = [
  40,
  67.5,
  33,
];

box_size = [
  padded_offset(card_size[0]) + $wall_thickness,
  padded_offset(card_size[1]) + $wall_thickness,
  stack_height(card_size[2]) + $wall_thickness,
];

difference() {
  rounded_cube(box_size, flat_top=true);

  translate([$wall_thickness, $wall_thickness, 0]) {
    tile_stack(card_size, 1, box_size[2], left_cutout=true, right_cutout=true);
  }
}
