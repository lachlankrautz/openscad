include <../../lib/primitive/rounded_cube.scad>

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
card_width = 15;
card_length = 15;
window_buffer = 4;

// Derived Attributes
base_height = magnet_height + 0.5;
corner_magnet_offset = corner_magnet_buffer + magnet_diameter / 2;

card_size = [
  card_width,
  card_length,
  inset
];

card_window_size = [
  card_size[0] - window_buffer*2,
  card_size[1] - window_buffer*2,
  base_height + inset + $bleed*2
];

base_size = [
  card_size[0] + border_width*2,
  card_size[1] + border_width*2,
  base_height
];

card_offset = [
  (base_size[0] - card_size[0]) / 2,
  (base_size[1] - card_size[1]) / 2,
  base_height
];

card_window_offset = [
  card_offset[0] + window_buffer,
  card_offset[1] + window_buffer,
  -$bleed
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
    rounded_cube([40, 10, 10]);
    rounded_cube([10, 40, 10]);
    translate([0, 30, 0]) {
      rounded_cube([40, 10, 10]);
    }
    translate([30, 0, 0]) {
      rounded_cube([10, 40, 10]);
    }
    /*
    translate(card_offset) {
      cube(card_size);
    }
    */
  }
  translate(card_window_offset) {
    // rounded_cube(card_window_size, flat=true);
  }
  /*
  translate([0, 0, base_height-magnet_height]) {
    // Cut out corner magnet holes
    for (i=corner_hole_offsets) {
      translate([i[0], i[1], 0]) {
        cylinder(h=magnet_height + $bleed, d=magnet_diameter);
      }
    }
  }
  */
}
