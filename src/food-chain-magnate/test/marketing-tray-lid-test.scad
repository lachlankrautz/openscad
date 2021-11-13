include <../../../lib/primitive/rounded_cube.scad>
include <../../../lib/compound/tile_stack.scad>
include <../../../lib/layout/grid_utils.scad>
include <../../../lib/lid/dovetail_lid.scad>
include <../config.scad>

$fn = 50;

test_box_size = [
  padded_list_length([
    tile_sizes[4][0],
  ]),
  padded_list_length([
    tile_sizes[1][1],
    tile_sizes[4][1],
  ]),
  stack_height(square_size[2], 2, top_padding) + $wall_thickness * 2 + $lid_height,
];

dovetail_lid(test_box_size, honeycomb_diameter=20);
