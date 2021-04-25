echo(version=version());

include <../../lib/cutout_tray.scad>
include <../../lib/grid_layout.scad>
include <../../lib/dish.scad>
include <../../lib/grid_dish.scad>
include <../../lib/layout.scad>

tile_height = 2;

small_square_tile_size = [
  20,
  20,
  tile_height,
];
small_square_count = 2;

large_square_tile_size = [
  20,
  20,
  tile_height,
];

circle_diameter = 30;
circle_stack = 2;

circle_cylinder_height = stack_height();

long_tile_size = [
  20,
  20,
  tile_height,
];

box_size = [
  100,
  100,
  20,
];

cutout_tray(box_size) {

}
