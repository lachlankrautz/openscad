include <../../lib/primitive/rounded_cube.scad>
include <../../lib/compound/notched_cube.scad>
include <../../lib/layout/layout.scad>
include <../../lib/tile_stack.scad>

// Config
$fn = 50;
// $fn = 10;

// Player powers
player_power_count = 10;
player_power_size = [
  120, 
  80, 
  2.2,
];

// Starting tiles
starting_tile_count = 10;
starting_tile_stack_count = 3;
starting_tile_size = [
  25, 
  60, 
  2.2,
];

// Player no.
player_number_size = [
  35.5,
  35.5,
  2.2,
];
player_number_count = 4;

box_size = [
  max(
    padded_offset(player_power_size[0]),
    padded_offset(starting_tile_size[0], starting_tile_stack_count)
      + padded_offset(player_number_size[0])
  ) + $wall_thickness,
  padded_offset(player_power_size[1])
    + padded_offset(starting_tile_size[1])
    + $wall_thickness,
  stack_height(player_power_size[2], player_power_count)
    + $wall_thickness
];

difference() {
  rounded_cube(box_size, flat_top=true, $rounding=2);

  translate([$wall_thickness, $wall_thickness, 0]) {
    tile_stack(player_number_size, player_number_count, box_size[2], bottom_cutout=true);

    // Right of player no.
    translate([padded_offset(player_number_size[0]), 0, 0]) {
      for(i=[0:starting_tile_stack_count-1]) {
        translate([padded_offset(starting_tile_size[0], i), 0, 0]) {
          tile_stack(starting_tile_size, starting_tile_count, box_size[2], bottom_cutout=true);
        }
      }
    }

    // Above starting tiles
    translate([0, padded_offset(starting_tile_size[1]), 0]) {
      tile_stack(player_power_size, player_power_count, box_size[2], top_cutout=true);
    }
  }
}
