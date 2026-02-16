include <../../lib/primitive/rounded_cube.scad>

$fn = 50;
$rounding = 2;

thickness = 15;
bleed = 0.1;

max_print_length = 256;
vent_length = 250;
vent_narrow_width = 24;
short_buffer = 30;
long_buffer = 100;

// Frame block to secure vent
frame_dimensions = [
  max_print_length,
  vent_narrow_width + short_buffer + long_buffer + thickness * 2,
  thickness,
];

// Frame cutout to allow the vent to sit in
frame_cutout_dimensions = [
  vent_length,
  vent_narrow_width + bleed,
  frame_dimensions[2] + bleed * 2,
];
frame_cutout_offset = [
  max(frame_dimensions[0] - frame_cutout_dimensions[0] + bleed, short_buffer),
  short_buffer,
  -bleed,
];

// This was intended to mask the demo design.
// Making it smaller to test the distances.
// It turned out to be 100% effective at this 
// greatly reduced size, so there was no need
// to ever build the full sized one.
module mask() {
  translate([-bleed, 100, -bleed]) {
    cube([200, 200, 100]);
  }
  translate([100, -bleed, -bleed]) {
    cube([200, 200, 100]);
  }
}

difference() {
  rounded_cube(frame_dimensions);
  translate(frame_cutout_offset) {
    rounded_cube(frame_cutout_dimensions, flat_top=true, flat_bottom=true);
  }
  mask();
}
