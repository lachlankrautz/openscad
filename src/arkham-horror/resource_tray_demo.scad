echo(version=version());

include <../../lib/cutout_tray.scad>
include <../../lib/layout.scad>
include <../../lib/dish.scad>
include <../../lib/grid_dish.scad>

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

cutout_tray(size) {
  grid_dish(grid, [0, 0]);
}
