include <../../lib/decorator/cutout_children.scad>
include <../../lib/primitive/dish.scad>
include <../../lib/primitive/group/grid_dish.scad>
include <../../lib/layout/grid_layout.scad>

// Config
$fn = 50;

// Attributes

size = [
  150,
  100,
  20
];

grid = make_even_grid(size, 3, 2);

// Model

cutout_children(size) {
  grid_dish(grid, [0, 0]);
  grid_dish(grid, [0, 1]);

  grid_dish(grid, [1, 0]);
  grid_dish(grid, [1, 1]);

  grid_dish(grid, [2, 0]);
  grid_dish(grid, [2, 1]);
}
