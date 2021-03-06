echo(version=version());

include <../../lib/cutout_tray.scad>
include <../../lib/grid_layout.scad>
include <../../lib/dish.scad>
include <../../lib/grid_dish.scad>

// Config
// $fn = 10;
$fn = 50;
$wall_thickness = 2;

function get_offset (size, index=1) = (size + $wall_thickness) * index;

// Attributes
size = [
  118,
  118,
  24,
];

cols = 2;
rows = 2;

// Derived attributes

dish_size = [
  (size[0] - $wall_thickness * (cols + 1)) / cols,
  (size[1] - $wall_thickness * (rows + 1)) / rows,
  size[2] - $wall_thickness + $bleed,
];
short_dish_height = dish_size[2] - 8;

// Model
cutout_tray(size) {
  for (i=[0:rows-1]) {
    for (j=[0:cols-1]) {
      translate([get_offset(dish_size[0], j), get_offset(dish_size[1], i), 0]) {
        if (i == 1 && j == 1) {
          translate([0, 0, dish_size[2] - short_dish_height]) {
            dish([
              dish_size[0],
              dish_size[1],
              short_dish_height,
            ]);
          }
        } else {
          dish(dish_size);
        }
      }
    }
  }
}
