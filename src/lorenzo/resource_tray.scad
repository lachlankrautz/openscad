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
  54.5,
  187,
  33,
];
large_dish_share = 0.4;
cols = 3;

// Derived attributes
usable_length = usable_size(size[1], cols);
large_dish_length = usable_length * large_dish_share;
small_dish_length = (usable_length - large_dish_length) / (cols - 1);

grid = [
  [item_size(size[0])],
  [
    large_dish_length, 
    for (i=[0:cols-2]) small_dish_length,
  ],
  [size[2]],
];

large_dish_cell = [0, 0];
small_dish_cells = [for (i = [0:cols-2]) [0,i+1]];

// Model
cutout_tray(size) {
  grid_dish(grid, large_dish_cell);

  for (i=[0:cols-2]) grid_dish(grid, small_dish_cells[i]);
}
