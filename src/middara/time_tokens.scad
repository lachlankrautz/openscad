include <../../lib/primitive/rounded_cube.scad>
include <../../lib/layout/layout.scad>
include <../../lib/compound/notched_cube.scad>
include <../../lib/tile_stack_round.scad>
include <../../lib/util/util_functions.scad>
include <../../lib/tile_stack.scad>

// Config
$fn = 50;

// Tokens
tile_height = 2;

diameter = 21;
time_tile_stack = 3;

urgency_size = [
  13.5,
  24,
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
    tile_stack_round(
      diameter, 
      tile_height,
      time_tile_stack, 
      box_size[2],
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
          tile_stack(
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
          tile_stack(
            tracker_size,
            tracker_stack,
            box_size[2],
            top_cutout=true,
            bottom_cutout=true,
            // TODO review pill feature, it's been changed to include padding so
            // the magic pill number might no longer be needed
            pill=true
          );
        }
      }
    }
  }
}
