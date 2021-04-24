echo(version=version());

include <../../lib/rounded_cube.scad>
include <../../lib/layout.scad>
include <../../lib/tile_tray.scad>
include <../../lib/round_tile_tray.scad>
include <../../lib/util_functions.scad>

// Config
$fn = 50;
// $fn = 10;

// Tokens
tile_height = 2;

diameter = 21;
time_tile_stack = 3;

urgency_size = [
  13.5,
  24.5,
  tile_height,
];
urgency_count = 2;
urgency_stack = 6;

tracker_size = [
  12,
  25,
  tile_height,
];
tracker_count = 2;
tracker_stack = 6;

max_stack = max(time_tile_stack, urgency_stack, tracker_stack);

box_size = [
  padded_offset(diameter) 
    + padded_offset(urgency_size[0], urgency_count) 
    + padded_offset(tracker_size[0], tracker_count) 
    + $wall_thickness,
  padded_offset(max(
    diameter, 
    urgency_size[1], 
    tracker_size[1]
  )) + $wall_thickness,
  stack_height(tile_height, max_stack) + $wall_thickness,
];

difference() {
  rounded_cube(box_size, flat_top=true, $rounding=2);

  translate([$wall_thickness, $wall_thickness, 0]) {
    // Time
    round_tile_cutout(
      diameter, 
      tile_height,
      time_tile_stack, 
      roof_height=box_size[2],
      top_cutout=true,
      bottom_cutout=true
    );

    // Urgency
    translate([
      padded_offset(diameter),
      0,
      0,
    ]) {
      for(i=[0:urgency_count-1]) {
        translate([
          padded_offset(urgency_size[0], i),
          0,
          0,
        ]) {
          tile_cutout(
            urgency_size,
            urgency_stack,
            box_size[2],
            top_cutout=true,
            bottom_cutout=true
          );
        }
      }
    }

    // Trackers
    translate([
      padded_offset(diameter) + padded_offset(urgency_size[0], urgency_count),
      0,
      0,
    ]) {
      for(i=[0:urgency_count-1]) {
        translate([
          padded_offset(tracker_size[0], i),
          0,
          0,
        ]) {
          tile_cutout(
            tracker_size,
            tracker_stack,
            box_size[2],
            top_cutout=true,
            bottom_cutout=true
          );
        }
      }
    }
  }
}
