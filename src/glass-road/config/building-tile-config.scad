include <../../../lib/layout/layout.scad>
include <../../../lib/primitive/rounded_cube.scad>
include <../../../lib/compound/tile_stack.scad>
include <../../../lib/lid/dovetail_lid.scad>
include <../../../lib/util/util_functions.scad>

$fn = 50;

tile_size = [
  51.5,
  34,
  2,
];

matrix = [
  [tile_size, tile_size, tile_size],
  [tile_size, tile_size, tile_size],
  [tile_size, tile_size, tile_size],
];

matrix_counts = [
  [9, 9, 9],
  [17, 16, 15],
  [17, 17, 15],
];

box_size = [
  padded_offset(tile_size[0], len(matrix)) + $wall_thickness,
  padded_offset(tile_size[1], len(matrix[0])) + $wall_thickness,
  stack_height(tile_size[2], max(flatten(matrix_counts))) + $wall_thickness + $lid_height,
];
