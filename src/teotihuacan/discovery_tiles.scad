echo(version=version());

include <../../lib/rounded_cube.scad>
include <../../lib/tile_tray.scad>
include <../../lib/disc_socket.scad>
include <../../lib/layout.scad>

// Config
$fn = 50;
// $fn = 10;
$gap = 0.5;
$wall_thickness = 2;
$bleed = 0.01;

// Discovery
discovery_tile_count = 14;
discovery_tile_size = [
  36,
  22.6, 
  2.2,
];
rows = 2;
cols = 2;

box_size = [
  padded_offset(discovery_tile_size[0], cols) + $wall_thickness,
  padded_offset(discovery_tile_size[1], rows) + $wall_thickness,
  get_tile_stack_height(discovery_tile_size, discovery_tile_count) + $wall_thickness,
];

difference() {
  rounded_cube(box_size, flat_top=true, $rounding=2);

  translate([$wall_thickness, $wall_thickness, 0]) {
    for(i=[0:cols-1]) {
      for(j=[0:rows-1]) {
        translate([
          padded_offset(discovery_tile_size[0], i),
          padded_offset(discovery_tile_size[1], j),
          0,
        ]) {
          tile_cutout(
            discovery_tile_size, 
            discovery_tile_count, 
            roof_height=box_size[2],
            bottom_cutout=(j == 0),
            top_cutout=(j == rows - 1)
          );
        }
      }
    }
  }
}
