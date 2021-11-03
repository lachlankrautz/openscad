include <../../lib/config/token_sizes.scad>
include <../../lib/layout/layout.scad>
include <../../lib/primitive/rounded_cube.scad>
include <../../lib/compound/tile_stack.scad>
include <../../lib/compound/tile_stack_round.scad>
include <../../lib/lid/dovetail_lid.scad>
include <./tile_tray_config.scad>

rotate([0, 0, 90]) {
  translate([0, -rotated_box_size[1], 0]) {
    dovetail_lid(rotated_box_size, honeycomb_diameter=20);
  }
}
