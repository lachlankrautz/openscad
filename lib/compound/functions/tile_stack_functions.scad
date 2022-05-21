include <../../layout/layout.scad>
include <../../config/constants.scad>

function tile_stack_size(tile_size, height=undef, tile_count=1, top_padding=$top_padding, lid_height=0) = [
  pad(tile_size[0]),
  pad(tile_size[1]),
    height != undef
    ? height
    : stack_height(tile_size[2], tile_count, top_padding) + lid_height,
  ];

function tile_stack_floor_height(tile_size, tile_count, top_padding=$top_padding, height=undef, lid_height=0) = height != undef
  ? height - stack_height(tile_size[2], tile_count, top_padding) - lid_height
  : $floor_thickness;
