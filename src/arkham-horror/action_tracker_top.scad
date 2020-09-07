echo(version=version());

include <../../lib/rounded_cube.scad>
include <../../lib/elephant_foot.scad>

// Config
$fn = 50;
$bleed = 1;
$rounding = 3;

// From dashboard bottom
size = [
  32, 
  70.5, 
  5
];

inner_size = [
  23.2, 
  61.7, 
  2.7
];

// Attributes
inset = 1;
min_magnet_height_buffer = 0.5;
magnet_height = 1;
magnet_diameter = 3.4;
corner_magnet_buffer = 1;
border_width = 4.5;
card_width = size[0];
card_length = size[1];
window_buffer = 1;
foot_rounding = 3;

// Derived Attributes
base_height = magnet_height + min_magnet_height_buffer;
corner_magnet_offset = corner_magnet_buffer + magnet_diameter / 2;

base_size = [
  size[0],
  size[1],
  base_height
];

snap_inset_size = [
  inner_size[0],
  inner_size[1],
  inset
];

foot_size = [
  snap_inset_size[0] + window_buffer * 2,
  snap_inset_size[1] + window_buffer * 2,
  base_height + inset + $bleed
];

snap_inset_offset = [
  (base_size[0] - snap_inset_size[0]) / 2,
  (base_size[1] - snap_inset_size[1]) / 2,
  base_height
];

foot_offset = [
  snap_inset_offset[0] + (snap_inset_size[0] - foot_size[0]) / 2,
  snap_inset_offset[1] + (snap_inset_size[1] - foot_size[1]) / 2,
  0
];

corner_hole_offsets = [
  [corner_magnet_offset, corner_magnet_offset],
  [base_size[0] - corner_magnet_offset, corner_magnet_offset],
  [corner_magnet_offset, base_size[1] - corner_magnet_offset],
  [base_size[0] - corner_magnet_offset, base_size[1] - corner_magnet_offset],
];

// TODO z-tearing why? probs the union gap from foot module

// Model
difference() {
  // Base
  union() {
    rounded_cube(base_size, flat=true);

    // Square 3 corners
    cube([$rounding, $rounding, base_height]);
    translate([0, base_size[1] - $rounding, 0]) {
      cube([$rounding, $rounding, base_height]);
      translate([base_size[0] - $rounding, 0, 0]) {
        cube([$rounding, $rounding, base_height]);
      }
    }

    translate(snap_inset_offset) {
      cube(snap_inset_size);
    }
  }
  // Cut out window
  translate(foot_offset) {
    // TODO foot curves back down in corner wtf
    elephant_foot(foot_size, flat_top=true, use_bleed=true, $rounding=foot_rounding);
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
