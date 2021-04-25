echo(version=version());

include <../../lib/rounded_cube.scad>
include <../../lib/layout.scad>
include <../../lib/tile_tray.scad>
include <../../lib/util_functions.scad>

// Config
$fn = 50;
// $fn = 10;

tile_map = [
  [6, 7, 7, 7, 4],
  [8, 5, 6, 7, 7]
];

// test tile map
/*
tile_map = [
  [4]
];
*/

tile_columns = len(tile_map[0]);
tile_rows = len(tile_map);
max_stack_count = max(flatten(tile_map));

// Tokens
// The calipers are actual garbage
tile_size = [
  27, 
  27, 
  2,
];

// test
/*
tile_size = [
  25,
  25,
  2,
];
*/

small_tile_size = [
  25,
  25,
  2,
];

box_size = [
  padded_offset(tile_size[0], tile_columns) + $wall_thickness,
  padded_offset(tile_size[1], tile_rows) + $wall_thickness,
  stack_height(tile_size[2], max_stack_count) + $wall_thickness,
];

difference() {
  rounded_cube(box_size, flat_top=true, $rounding=2);

  translate([$wall_thickness, $wall_thickness, 0]) {
    for(i=[0:tile_rows-1]) {
      for(j=[0:tile_columns-1]) {
        translate([padded_offset(tile_size[0], j), padded_offset(tile_size[1], i), 0]) {
          if (i == 0 && j == 4) {
            translate([(tile_size[0] - small_tile_size[0]) / 2, 0, 0]) {
              tile_cutout(
                small_tile_size, 
                tile_map[i][j], 
                roof_height=box_size[2],
                top_cutout=true,
                bottom_cutout=true,
                $cutout_fraction=0.646 // try to make the cutout match the larger tiles
              );
            }
          } else {
            tile_cutout(
              tile_size, 
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
}
