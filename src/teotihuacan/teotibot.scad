include <../../lib/rounded_cube.scad>
include <../../lib/cutouts.scad>
include <../../lib/layout.scad>

// Config
$fn = 50;
// $fn = 10;
$wall_thickness = 2;

// Player powers
player_power_count = 6;
player_power_size = [
  120, 
  80, 
  2.2,
];

// AI tile
ai_tile_count = 5;
ai_tile_size = [
  50,
  23.5,
  2.2,
];

box_size = [
  padded_offset(player_power_size[0])
    + $wall_thickness,
  padded_offset(player_power_size[1])
    + padded_offset(ai_tile_size[1])
    + $wall_thickness,
  stack_height(player_power_size[2], player_power_count)
    + $wall_thickness,
];

difference() {
  rounded_cube(box_size, flat_top=true, $rounding=2);

  translate([$wall_thickness, $wall_thickness, 0]) {
    tile_cutout(ai_tile_size, ai_tile_count, box_size[2], bottom_cutout=true);

    // Align right side
    translate([box_size[0] - padded_offset(ai_tile_size[0]) - $wall_thickness, 0, 0]) {
      tile_cutout(ai_tile_size, ai_tile_count - 1, box_size[2], bottom_cutout=true);
    }

    // Above ai tiles
    translate([0, padded_offset(ai_tile_size[1]), 0]) {
      tile_cutout(player_power_size, player_power_count, box_size[2], top_cutout=true);
    }
  }
}
