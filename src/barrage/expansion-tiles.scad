echo(version=version());

include <../../lib/rounded_cube.scad>
include <../../lib/layout.scad>
include <../../lib/tile_tray.scad>
include <../../lib/util_functions.scad>

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
  tile_stack_height(dev_tile_size, max_stack_count) + $wall_thickness,
];

difference() {
  rounded_cube(box_size, flat_top=true, $rounding=2);

  translate([$wall_thickness, $wall_thickness, 0]) {
    tile_cutout(
      external_tile_size, 
      5, 
      roof_height=box_size[2],
      left_cutout=true
    );
  }
  translate([box_size[0] - padded_offset(external_tile_size[0]), $wall_thickness, 0]) {
    tile_cutout(
      external_tile_size, 
      10, 
      roof_height=box_size[2],
      right_cutout=true
    );
  }
  translate([$wall_thickness, padded_offset(external_tile_size[1]) + $wall_thickness, 0]) {
    tile_cutout(
      dev_tile_size, 
      10, 
      roof_height=box_size[2],
      left_cutout=true,
      right_cutout=true
    );
  }
}
