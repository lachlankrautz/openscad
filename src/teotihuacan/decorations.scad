include <../../lib/primitive/rounded_cube.scad>
include <../../lib/compound/notched_cube.scad>
include <../../lib/layout/layout.scad>
include <../../lib/tile_stack.scad>

// Config
$fn = 50;

// Decorations
decoration_tile_count = 18;
decoration_tile_size = [
  35,
  17.5, 
  2.2,
];

box_size = [
  padded_offset(decoration_tile_size[0]) + $wall_thickness,
  padded_offset(decoration_tile_size[1]) + $wall_thickness,
  stack_height(decoration_tile_size[2], decoration_tile_count)
    + $wall_thickness,
];

difference() {
  rounded_cube(box_size, flat_top=true, $rounding=1);

  translate([$wall_thickness, $wall_thickness, 0]) {
    tile_stack(
      decoration_tile_size, 
      decoration_tile_count, 
      box_size[2],
      top_cutout=true,
      bottom_cutout=true
    );
  }
}
