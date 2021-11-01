include <../../../lib/primitive/rounded_cube.scad>

// Config
$fn = 50;
$rounding = 2;

// Attributes
inset = 1;
magnet_height = 1;
magnet_diameter = 3.4;
corner_magnet_buffer = 1;
border_width = 4.5;
card_width = 15;
card_length = 15;
card_height = 0.7;

// Derived Attributes
card_size = [
  card_width,
  card_length,
  card_height + inset + $bleed
];

base_height = magnet_height + 0.5;
height = base_height + card_height + inset;
corner_magnet_offset = corner_magnet_buffer + magnet_diameter / 2;

base_size = [
  card_size[0] + border_width*2,
  card_size[1] + border_width*2,
  height
];

card_offset = [
  (base_size[0] - card_size[0]) / 2,
  (base_size[1] - card_size[1]) / 2,
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
  rounded_cube(base_size, flat=true);
  translate([0, 0, height-magnet_height]) {
    // Cut out corner magnet holes
    for (i=corner_hole_offsets) {
      translate([i[0], i[1], 0]) {
        cylinder(h=magnet_height + $bleed, d=magnet_diameter);
      }
    }
  }
  translate(card_offset) {
    // Cut out for card
    translate([0, 0, base_height]) {
      cube(card_size);
    }
  }
}
