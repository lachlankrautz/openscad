include <../../lib/decorator/cutout_children.scad>
include <../../lib/layout/grid_layout/layout.scad>
include <../../lib/primitive/dish.scad>
include <../../lib/primitive/group/grid_dish.scad>

// Config
$fn = 50;
$wall_thickness = 2;

// Attributes

size = [
  50,
  50,
  20
];

grid = make_even_grid(size, 1, 1);

// Model

cutout_children(size) {
  grid_dish(grid, [0, 0]);
}
