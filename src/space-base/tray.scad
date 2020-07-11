echo(version=version());

include <../../lib/dish.scad>
include <../../lib/cutout_tray.scad>
include <../../lib/layout.scad>
include <../../lib/scoop.scad>

// Config
$fn = 50;

// Attributes
length = 100;
width = 100;
height = 30;
rows = 2;
cols = 2;

// Derived attributes
item_width = item_size(width, cols);
item_length = item_size(length, rows);

// Model
cutout_tray(width, length, height) {
  spread_length(length) {
    spread_width(width) {
      scoop(item_size(width), item_length, height);
    }
    spread_width(width) {
      scoop(item_width, item_length, height);
      scoop(item_width, item_length, height);
    }
  }
}
