include <../../lib/config/token_sizes.scad>
include <../../lib/layout/layout.scad>

$fn = 50;

tile_size = [
  38.5,
  38.5,
  standard_token_height
];
token_stack_counts = [14, 13, 12];

bullet_diameter = 29;
bullet_height = 4.5;
bullet_stack_counts = [5, 5, 3];

box_size = [
    padded_offset(tile_size[0], len(token_stack_counts)) + $wall_thickness,
      padded_offset(tile_size[1])
      + padded_offset(bullet_diameter)
    + $wall_thickness,
      stack_height(tile_size[2], max(token_stack_counts)) + $wall_thickness + $lid_height,
];

rotated_box_size = [
  box_size[1],
  box_size[0],
  box_size[2],
];
