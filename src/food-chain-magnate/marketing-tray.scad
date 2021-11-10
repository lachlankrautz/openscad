include <../../lib/primitive/rounded_cube.scad>
include <../../lib/compound/tile_stack.scad>
include <../../lib/layout/grid_utils.scad>
include <../../lib/lid/dovetail_lid.scad>
include <./config.scad>

$fn = 50;

difference() {
  rounded_cube(box_size, flat_top=true, $rounding=1);
  translate([$wall_thickness, 0]) {
    for (x=[0:len(tile_map)-1]) {
      for (y=[0:len(tile_map[x])-1]) {
        translate([
          padded_offset(tile_sizes[4][0], x)
            + align_x(x, tile_size_map[x][y][0]),
          reverse_padded_list_offset(box_size[1], tile_size_map[x], y, 1),
          0,
        ]) {
          tile_cutout_with_slant(tile_size_map[x][y], box_size[2]);
          tile_cutout_with_slant(tile_sizes[1], box_size[2] - square_size[2]);
        }
      }
    }
  }
  dovetail_lid_cutout(box_size);
}
