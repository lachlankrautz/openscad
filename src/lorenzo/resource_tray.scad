echo(version=version());

include <../../lib/dish.scad>
include <../../lib/rounded_cube.scad>
include <../../lib/cutout_tray.scad>
include <../../lib/layout.scad>

// Config
$fn = 50;
$wall_thickness = 2;

// Attributes
length = 187;
width = 54.5;
height = 33;
large_dish_share = 0.4;
cols = 3;

// Derived attributes
small_dish_share = (1 - large_dish_share) / 2;
usable_dish_length = usable_size(length, cols);
small_dish_length = small_dish_share * usable_dish_length;
large_dish_length = large_dish_share * usable_dish_length;

cutout_tray([width, length, height]) {
  dish([item_size(width), small_dish_length, height]);

  translate([0,$wall_thickness + small_dish_length, 0]) {
    dish([item_size(width), small_dish_length, height]);
  }

  translate([0,($wall_thickness + small_dish_length) * 2, 0]) {
    dish([item_size(width), large_dish_length, height]);
  }
}
