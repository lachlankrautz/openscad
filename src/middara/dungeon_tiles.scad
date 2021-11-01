include <../../lib/decorator/cutout_children.scad>
include <../../lib/layout/grid_layout.scad>
include <../../lib/compound/notched_cube.scad>
include <../../lib/primitive/dish.scad>
include <../../lib/primitive/group/grid_dish.scad>
include <../../lib/layout/layout.scad>
include <../../lib/tile_stack.scad>

// Config
$fn = 50;

tile_height = 2;

// Tiles stack on their side
function make_side_stack (size, count) = [
  stack_height(size[2], count),
  size[1],
  size[0],
];

// Small square tiles
small_square_tile_size = [
  25,
  25,
  tile_height,
];
small_square_count = 2;
small_square_stacks = [
  24,
  25,
];
small_square_box_sizes = [
  for(i=[0:len(small_square_stacks)-1]) make_side_stack(
    small_square_tile_size,
    small_square_stacks[i]
  )
];
small_box_max_width = max([for(i=[0:len(small_square_stacks)-1]) small_square_box_sizes[0]]);

// Long tile size
long_tile_size = [
  25,
  50.5,
  tile_height,
];
long_tile_stack = 21;
long_tile_box_size = make_side_stack(long_tile_size, long_tile_stack);

// Large square and cylinder tile sizes
large_square_tile_size = [
  51,
  51,
  tile_height,
];
circle_diameter = 30;
circle_stack = 2;
circle_cylinder_height = stack_height(tile_height, circle_stack);

box_size = [
  100,
  100,
  long_tile_box_size[2] + $wall_thickness,
];

cutout_children(box_size) {
  tile_stack(long_tile_box_size, 1, box_size[2]);
}
