include <../../lib/cutout_children.scad>
include <../../lib/grid_layout.scad>
include <../../lib/dish.scad>
include <../../lib/grid_dish.scad>
include <../../lib/layout.scad>

// Config
// $fn = 10;
$fn = 50;
$wall_thickness = 2;

function get_offset (size, index=1) = (size + $wall_thickness) * index;

// Attributes
depth = 18 + $bleed;
stamina_size = [
  60,
  60,
  depth,
];
damage_size = [
  60,
  60,
  depth,
];

// Derived attributes

box_size = [
  get_offset(stamina_size[0]) + get_offset(damage_size[0]) + $wall_thickness,
  get_offset(max(stamina_size[1], damage_size[1])) + $wall_thickness,
  depth + $wall_thickness - $bleed,
];
short_dish_height = box_size[2] - 8;

// Model
cutout_children(box_size) {
  dish(stamina_size);

  translate([get_offset(stamina_size[0]), 0, 0,
  ]) {
    dish(damage_size);
  }
}
