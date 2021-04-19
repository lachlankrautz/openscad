echo(version=version());

include <../../lib/rounded_cube.scad>
include <../../lib/layout.scad>
include <../../lib/tile_tray.scad>
include <../../lib/util_functions.scad>

// Config
$fn = 50;
// $fn = 10;

tile_map = [
  [18, 18],
  [11, 18],
  // [4], // Test tiles
];

tile_columns = len(tile_map[0]);
tile_rows = len(tile_map);
max_stack_count = max(flatten(tile_map));

// Contract tokens
tile_size = [
  51, 
  35, 
  1.64,
];

box_size = [
  padded_offset(tile_size[0], tile_columns) + $wall_thickness,
  padded_offset(tile_size[1], tile_rows) + $wall_thickness,
  tile_stack_height(tile_size, max_stack_count) + $wall_thickness,
];

difference() {
  rounded_cube(box_size, flat_top=true, $rounding=2);

  translate([$wall_thickness, $wall_thickness, 0]) {
    for(i=[0:tile_rows-1]) {
      for(j=[0:tile_columns-1]) {
        translate([padded_offset(tile_size[0], j), padded_offset(tile_size[1], i), 0]) {
          tile_cutout(
            tile_size, 
            tile_map[i][j], 
            roof_height=box_size[2],
            left_cutout=(j == 0),
            right_cutout=(j == tile_columns-1)
          );
        }
      }
    }
  }
}
