echo(version=version());

include <../../lib/rounded_cube.scad>
include <../../lib/elephant_foot.scad>

// Config
$fn = 50;
$bleed = 1;
$rounding = 2;

// Attributes
inset = 1;
magnet_height = 1;
magnet_diameter = 3.4;
corner_magnet_buffer = 1;
border_width = 4.5;
card_width = 66;
card_length = 91.8;
window_buffer = 0;
foot_rounding = 3;

// Derived Attributes
base_height = magnet_height + 0.5;
corner_magnet_offset = corner_magnet_buffer + magnet_diameter / 2;

card_size = [
  card_width,
  card_length,
  inset
];

card_window_size = [
  card_size[0] - window_buffer * 2,
  card_size[1] - window_buffer * 2,
  base_height + inset + $bleed
];

base_size = [
  card_size[0] + border_width * 2,
  card_size[1] + border_width * 2,
  base_height
];

card_offset = [
  (base_size[0] - card_size[0]) / 2,
  (base_size[1] - card_size[1]) / 2,
  base_height
];

card_window_offset = [
  card_offset[0] + (card_size[0] - card_window_size[0]) / 2,
  card_offset[1] + (card_size[1] - card_window_size[1]) / 2,
  0
];

corner_hole_offsets = [
  [corner_magnet_offset, corner_magnet_offset],
  [base_size[0] - corner_magnet_offset, corner_magnet_offset],
  [corner_magnet_offset, base_size[1] - corner_magnet_offset],
  [base_size[0] - corner_magnet_offset, base_size[1] - corner_magnet_offset],
];

// Model
difference() {
  // Base
  union() {
    rounded_cube(base_size, flat_top=true, $rounding=1);
    translate(card_offset) {
      cube(card_size);
    }
  }
  // Cut out window
  translate(card_window_offset) {
    elephant_foot(card_window_size, flat_top=true, $rounding=foot_rounding);
  }
  // Cut out corner magnet holes
  translate([0, 0, base_height-magnet_height]) {
    for (i=corner_hole_offsets) {
      translate([i[0], i[1], 0]) {
        cylinder(h=magnet_height + $bleed, d=magnet_diameter);
      }
    }
  }
}
