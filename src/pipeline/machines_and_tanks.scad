include <../../lib/primitive/rounded_cube.scad>
include <../../lib/compound/notched_cube.scad>
include <../../lib/layout/layout.scad>
include <../../lib/tile_stack.scad>

// Config
$fn = 50;

// Machines
machine_tile_count = 9;
machine_cols = 2;
machine_tile_size = [
  30, 
  30, 
  2.2,
];

// Tanks
tank_tile_count = 10;
tank_rows = 3;
tank_tile_size = [
  20, 
  24, 
  2.2,
];

box_size = [
  padded_offset(machine_tile_size[0], machine_cols) + $wall_thickness,
  padded_offset(machine_tile_size[1]) + padded_offset(tank_tile_size[1], tank_rows) + $wall_thickness,
  tank_tile_size[2] * tank_tile_count + $wall_thickness,
];

height_diff = tank_tile_size[2] * tank_tile_count - machine_tile_size[2] * machine_tile_count;
machine_height = height_diff + $wall_thickness;

difference() {
  rounded_cube(box_size, flat_top=true, $rounding=2);

  translate([$wall_thickness, $wall_thickness, 0]) {
    tile_stack(machine_tile_size, machine_tile_count, box_size[2], machine_height, left_cutout=true);

    // Layout right of first machine tray
    translate([padded_offset(machine_tile_size[0]), 0, 0]) {
      tile_stack(machine_tile_size, machine_tile_count, box_size[2], machine_height, right_cutout=true);
    }

    // Layout above machines
    translate([0, padded_offset(machine_tile_size[1]), 0]) {
      for(i=[0:tank_rows-1]) {
        // Layout tank row
        translate([0, padded_offset(tank_tile_size[1], i), 0]) {
          tile_stack(tank_tile_size, tank_tile_count, box_size[2], left_cutout=true);

          
          // Layout align tank to right side
          translate([box_size[0] - padded_offset(tank_tile_size[0]) - $wall_thickness, 0, 0]) {
            tile_stack(tank_tile_size, tank_tile_count, box_size[2], right_cutout=true);
          }
        }
      }
    }
  }
}
