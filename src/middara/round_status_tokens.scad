echo(version=version());

include <../../lib/rounded_cube.scad>
include <../../lib/layout.scad>
include <../../lib/round_tile_tray.scad>
include <../../lib/util_functions.scad>

// Config
$fn = 50;
// $fn = 10;

tile_map = [
  [6, 10, 10, 0],
  [6, 8, 8, 6],
];

// test tile map
/*
tile_map = [
  [5]
];
*/

tile_columns = len(tile_map[0]);
tile_rows = len(tile_map);
max_stack_count = max(flatten(tile_map));

// Tokens
diameter = 27;
tile_height = 2.2;

box_size = [
  padded_offset(diameter, tile_columns) + $wall_thickness,
  padded_offset(diameter, tile_rows) + $wall_thickness,
  stack_height(tile_height, max_stack_count) + $wall_thickness,
];

difference() {
  rounded_cube(box_size, flat_top=true, $rounding=2);

  translate([$wall_thickness, $wall_thickness, 0]) {
    for(i=[0:tile_rows-1]) {
      for(j=[0:tile_columns-1]) {
        translate([padded_offset(diameter, j), padded_offset(diameter, i), 0]) {
          round_tile_cutout(
            diameter, 
            tile_height,
            tile_map[i][j], 
            roof_height=box_size[2],
            top_cutout=true,
            bottom_cutout=true
          );
        }
      }
    }
  }
}
