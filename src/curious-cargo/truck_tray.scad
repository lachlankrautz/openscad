echo(version=version());

include <../../lib/rounded_cube.scad>
include <../../lib/layout.scad>
include <../../lib/tile_tray.scad>

// Config
$fn = 50;
// $fn = 10;

truck_6_size = [
  114,
  24,
  1.85
];

truck_5_size = [
  95,
  24,
  1.85
];

truck_4_size = [
  76,
  24,
  1.85
];

truck_3_size = [
  57.5,
  24,
  1.85
];

truck_2_size = [
  38.5,
  24,
  1.85
];

truck_count = 5;

box_size = [
  max(
    padded_offset(truck_6_size[0]),
    padded_offset(truck_5_size[0]) + padded_offset(truck_2_size[0]),
    padded_offset(truck_4_size[0]) + padded_offset(truck_3_size[0])
  ) + $wall_thickness,
  padded_offset(truck_6_size[1], 3) + $wall_thickness,
  tile_stack_height(truck_6_size, truck_count) + $wall_thickness,
];

difference() {
  rounded_cube(box_size, flat_top=true, $rounding=2);

  translate([$wall_thickness, $wall_thickness, 0]) {
    // Bottom row
    tile_cutout(
      truck_4_size, 
      truck_count, 
      roof_height=box_size[2],
      left_cutout=true
    );
    translate([padded_offset(truck_4_size[0]), 0, 0]) {
      tile_cutout(
        truck_3_size, 
        truck_count, 
        roof_height=box_size[2],
        right_cutout=true
      );
    }

    // Middle row
    translate([0, padded_offset(truck_6_size[1]), 0]) {
      tile_cutout(
        truck_5_size, 
        truck_count, 
        roof_height=box_size[2],
        left_cutout=true
      );
    }
    translate([padded_offset(truck_5_size[0]), padded_offset(truck_6_size[1]), 0]) {
      tile_cutout(
        truck_2_size, 
        truck_count, 
        roof_height=box_size[2],
        right_cutout=true
      );
    }

    // Top row
    translate([0, padded_offset(truck_6_size[1], 2), 0]) {
      tile_cutout(
        truck_6_size, 
        truck_count, 
        roof_height=box_size[2],
        left_cutout=true
      );
    }
  }
}
