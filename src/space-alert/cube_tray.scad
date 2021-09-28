include <../../lib/cutout_children.scad>
include <../../lib/cutouts.scad>
include <../../lib/layout.scad>
include <../../lib/dish.scad>
include <../../lib/dovetail_lid.scad>
include <../../lib/orientation.scad>

// Config
$fn = 10;
// $fn = 50;
$wall_thickness = 2;
$padding = 0.5;
$rounding = 2;
$bleed = 0.01;
$cutout_fraction = 0.4;
$lid_height = 2;

dish_roundness = 0.8;

box_height = 25;

tracker_diameter = 12;
tracker_height = 23.2;
padded_tracker_diameter = tracker_diameter + $padding * 2;

canister_diameter = 6.5;
canister_height = 13.7;
padded_canister_diameter = canister_diameter + $padding * 2;
canister_count = 3;

// Damage
damage_tile_size = [
  38,
  38,
  2.2,
];
damage_tile_count = 6;
damage_stack_count = 3;

// Required for total box size
max_y = padded_offset(damage_tile_size[1], damage_stack_count) + $wall_thickness;

left_dish_rows = 3;
usable_left_y = max_y
  - padded_tracker_diameter
  - $wall_thickness * (left_dish_rows + 3);

left_dish_size = [
  padded_tracker_diameter
    + padded_canister_diameter * canister_count
    + $wall_thickness * (canister_count + 1),
  usable_left_y / left_dish_rows,
  16,
];

mid_dish_x = 50;

box_size = [
  offset(left_dish_size[0])
    + offset(mid_dish_x)
    + padded_offset(damage_tile_size[0])
    + $wall_thickness,
  max_y,
  box_height + $wall_thickness
] + lid_size;

mid_dish_size = [
  mid_dish_x,
  (max_y - $wall_thickness * 3) / 2,
  box_size[2] - $lid_height - $wall_thickness,
];
mid_dish_rows = 2;


module tray() {
  difference() {
    // Box
    union() {
      // short box on left for canisters
      rounded_cube(box_size - [0, 0, canister_height / 2 + $lid_height], flat_top=true);

      // tall box on left under canisters
      rounded_cube(
        box_size
        - [0, padded_tracker_diameter + $wall_thickness * 2, 0],
        flat_top=true
      );

      // tall box on right (main section)
      translate([offset(left_dish_size[0]), 0, 0]) {
        rounded_cube(box_size - [
          left_dish_size[0] + $wall_thickness,
          0,
          0
        ], flat_top=true);
      }
    }

    translate([$wall_thickness, $wall_thickness, 0]) {
      // Cylinders
      translate([0, offset(left_dish_size[1], left_dish_rows) + $wall_thickness, 0]) {
        translate([0, 0, box_size[2] - tracker_height - $lid_height]) {
          offset_cylinder(d=padded_tracker_diameter, h=tracker_height);
        }

        translate([
          offset(padded_tracker_diameter),
          (padded_tracker_diameter - padded_canister_diameter) / 2,
          box_size[2] - canister_height - $lid_height
        ]) {
          for(i=[0:canister_count-1]) {
            translate([offset(padded_canister_diameter, i), 0, 0]) {
              offset_cylinder(d=padded_canister_diameter, h=canister_height);
            }
          }
        }
      }

      // Left dishes
      for(i=[0:left_dish_rows-1]) {
        translate([0, offset(left_dish_size[1], i), box_size[2] - left_dish_size[2]]) {
          dish(left_dish_size + [0, 0, $bleed], dish_roundness, lid=true);
        }
      }

      // Middle dishes
      translate([offset(left_dish_size[0]), 0, 0]) {
        for(i=[0:mid_dish_rows-1]) {
          translate([0, offset(mid_dish_size[1], i), box_size[2] - mid_dish_size[2]]) {
            dish(mid_dish_size + [0, 0, $bleed], dish_roundness, lid=true);
          }
        }
      }


      // Right damage tile cutout
      translate([offset(left_dish_size[0]) + offset(mid_dish_size[0]), 0, 0]) {
        for(i=[0:damage_stack_count-1]) {
          translate([0, padded_offset(damage_tile_size[1], i), 0]) {
            tile_cutout(
              damage_tile_size,
              damage_tile_count,
              box_size[2],
              right_cutout=true,
              lid=true
            );
          }
        }
      }
    } // end wall thickness
  }
}

echo("box size: ", box_size);
difference() {
  tray();

  dovetail_lid_cutout(box_size, 1);
}

// dovetail_lid(box_size);
