include <../../../lib/config/card_sizes.scad>
include <../../../lib/layout/layout.scad>
include <../../../lib/primitive/rounded_cube.scad>
include <../../../lib/primitive/scoop.scad>
include <../../../lib/compound/tile_stack.scad>
include <../../../lib/lid/dovetail_lid.scad>
include <../../../lib/tray/card_tray.scad>

$fn = 50;

tile_height = 2;

terrain_tile_size = [
  34,
  51.5,
  tile_height,
];
terrain_tile_count = 6;

card_stack_height = 12;

forest_tile_size = [
  34,
  106,
  tile_height,
];
forest_tile_count = 6;

box_size = [
  padded_offset(terrain_tile_size[0]) + padded_offset(forest_tile_size[0]) + $wall_thickness,
  padded_offset(forest_tile_size[1]) + $wall_thickness,
  max(
    stack_height(terrain_tile_size[2], terrain_tile_count),
    stack_height(forest_tile_size[2], forest_tile_count)
  ) + card_stack_height + $wall_thickness + $lid_height,
];
