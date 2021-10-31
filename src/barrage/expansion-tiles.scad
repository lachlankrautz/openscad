include <../../lib/primitive/rounded_cube.scad>
include <../../lib/layout/layout.scad>
include <../../lib/compound/notched_cube.scad>
include <../../lib/compound/tile_stack.scad>
include <../../lib/util/util_functions.scad>

// Config
$fn = 50;
// $fn = 10;

dev_tile_size = [
  114,
  50,
  1.64,
];
dev_tile_stack = 10;

external_tile_size = [
  50,
  30,
  1.64,
];

external_tile_map = [
  5, 
  10,
];

max_stack_count = dev_tile_stack;

box_size = [
  padded_offset(dev_tile_size[0]) + $wall_thickness,
  padded_offset(dev_tile_size[1]) + padded_offset(external_tile_size[1]) + $wall_thickness,
  stack_height(dev_tile_size[2], max_stack_count) + $wall_thickness,
];

difference() {
  rounded_cube(box_size, flat_top=true, $rounding=2);

  translate([$wall_thickness, $wall_thickness, 0]) {
    tile_stack(
      external_tile_size, 
      5, 
      box_size[2],
      left_cutout=true
    );
  }
  translate([box_size[0] - padded_offset(external_tile_size[0]), $wall_thickness, 0]) {
    tile_stack(
      external_tile_size, 
      10, 
      box_size[2],
      right_cutout=true
    );
  }
  translate([$wall_thickness, padded_offset(external_tile_size[1]) + $wall_thickness, 0]) {
    tile_stack(
      dev_tile_size, 
      10, 
      box_size[2],
      left_cutout=true,
      right_cutout=true
    );
  }
}
