echo(version=version());

include <../../lib/rounded_cube.scad>
include <../../lib/tile_tray.scad>

// Config
$fn = 50;
// $fn = 10;

// Decorations
decoration_tile_count = 18;
decoration_tile_size = [
  35,
  17.5, 
  2.2,
];

box_size = [
  get_tile_offset(decoration_tile_size[0]) + $wall_thickness,
  get_tile_offset(decoration_tile_size[1]) + $wall_thickness,
  get_tile_stack_height(decoration_tile_size, decoration_tile_count)
    + $wall_thickness,
];

difference() {
  rounded_cube(box_size, flat_top=true, $rounding=1);

  translate([$wall_thickness, $wall_thickness, 0]) {
    tile_cutout(
      decoration_tile_size, 
      decoration_tile_count, 
      roof_height=box_size[2], 
      top_cutout=true,
      bottom_cutout=true
    );
  }
}
