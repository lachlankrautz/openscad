echo(version=version());

include <../../lib/cutout_tray.scad>
include <../../lib/layout.scad>
include <../../lib/dish.scad>
include <../../lib/offset_cylinder.scad>

// Config
$fn = 50;
// $fn = 10;
$wall_thickness = 2;
$padding = 0.5;
$rounding = 2;
dish_roundness = 0.8;

tracker_diameter = 12;
tracker_height = 23;
padded_tracker_diameter = tracker_diameter + $padding * 2;

canister_diameter = 7;
canister_height = 13;
padded_canister_diameter = canister_diameter + $padding * 2;
canister_count = 3;

right_dish_size = [
  50,
  50,
  tracker_height,
];
right_dish_rows = 2;
right_side_length = offset(right_dish_size[1], right_dish_rows) + $wall_thickness;

left_dish_rows = 3;
usable_left_size = right_side_length 
  - padded_tracker_diameter
  - $wall_thickness * (left_dish_rows + 3);

left_dish_size = [
  padded_tracker_diameter 
   + padded_canister_diameter * canister_count 
   + $wall_thickness * (canister_count + 1),
  usable_left_size / left_dish_rows,
  12,
];

box_size = [
  offset(right_dish_size[0]) 
    + offset(left_dish_size[0]) 
    + $wall_thickness,
  right_side_length,
  tracker_height + $wall_thickness
];

difference() {
  // Box
  union() {
    rounded_cube(box_size - [0, 0, canister_height / 2], flat_top=true);
    rounded_cube(box_size - [0, padded_tracker_diameter + $wall_thickness * 2, 0], flat_top=true);
    translate([offset(left_dish_size[0]), 0, 0]) {
      rounded_cube(box_size - [
        left_dish_size[0] + $wall_thickness, 
        0, 
        0
      ], flat_top=true);
    }
  }

  translate([$wall_thickness, $wall_thickness, 0]) {
    // Left dishes
    for(i=[0:left_dish_rows-1]) {
      translate([0, offset(left_dish_size[1], i), box_size[2] - left_dish_size[2]]) {
        dish(left_dish_size + [0, 0, $bleed], dish_roundness);
      }
    }

    // Cylinders
    translate([0, offset(left_dish_size[1], left_dish_rows) + $wall_thickness, 0]) {
      translate([0, 0, box_size[2] - tracker_height]) {
        offset_cylinder(d=padded_tracker_diameter, h=tracker_height);
      }

      translate([
        offset(padded_tracker_diameter), 
        (padded_tracker_diameter - padded_canister_diameter) / 2, 
        box_size[2] - canister_height
      ]) {
        for(i=[0:canister_count-1]) {
          translate([offset(padded_canister_diameter, i), 0, 0]) {
            offset_cylinder(d=padded_canister_diameter, h=canister_height);
          }
        }
      }
    }

    // Right dishes
    translate([offset(left_dish_size[0]), 0, 0]) {
      for(i=[0:right_dish_rows-1]) {
        translate([0, offset(right_dish_size[1], i), $wall_thickness]) {
          dish(right_dish_size + [0, 0, $bleed], dish_roundness);
        }
      }
    }
  }
}
