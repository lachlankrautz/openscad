include <../../lib/decorator/cutout_children.scad>
include <../../lib/layout/grid_layout.scad>
include <../../lib/primitive/dish.scad>
include <../../lib/primitive/group/grid_dish.scad>
include <../../lib/layout/layout.scad>

// Config
// $fn = 10;
$fn = 50;

function get_offset (size, index=1) = (size + $wall_thickness) * index;

// Attributes
size = [
  60,
  60,
  23 + $bleed,
];
small_size = [
  size[0],
  50,
  size[2],
];

cols = 2;
rows = 2;

row_size_map = [
  size,
  small_size,
];

// Derived attributes

box_size = [
  (size[0] + $wall_thickness) * cols + $wall_thickness,
  size[1] + small_size[1] + cols * $wall_thickness + $wall_thickness,
  size[2] + $wall_thickness - $bleed,
];
short_dish_height = box_size[2] - 8;

// Model
cutout_children(box_size) {
  for (i=[0:rows-1]) {
    for (j=[0:cols-1]) {
      translate([
        get_offset(size[0], j),
        get_offset(size[1], i),
        (i == 1 && j == 1) ? row_size_map[i][2] - short_dish_height: 0,
      ]) {
        dish([
          row_size_map[i][0],
          row_size_map[i][1],
          (i == 1 && j == 1) ? short_dish_height: row_size_map[i][2],
        ]);
      }
    }
  }
}
