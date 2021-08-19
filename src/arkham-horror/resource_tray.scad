include <../../lib/cutout_children.scad>
include <../../lib/grid_layout.scad>
include <../../lib/dish.scad>
include <../../lib/grid_dish.scad>

// Config
$fn = 50;
$wall_thickness = 2;

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
