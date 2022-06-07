include <../../../lib/layout/layout.scad>
include <../../../lib/primitive/rounded_cube.scad>
include <../../../lib/compound/tile_stack.scad>
include <../../../lib/lid/dovetail_lid.scad>

tile_size = [
  17,
  17,
  3,
];

slim_tile_size = [
  tile_size[0],
  tile_size[1],
  tile_size[2] - 0.2 // trying to get the stacks to sit flush since there is no lid
];

wall_inset_length = 1.5;
