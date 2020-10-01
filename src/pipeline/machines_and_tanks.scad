echo(version=version());

include <../../lib/rounded_cube.scad>
include <../../lib/tile_tray.scad>

// Config
$fn = 50;
// $fn = 10;

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
  get_tile_offset(machine_tile_size[0], machine_cols) + $wall_thickness,
  get_tile_offset(machine_tile_size[1]) + get_tile_offset(tank_tile_size[1], tank_rows) + $wall_thickness,
  tank_tile_size[2] * tank_tile_count + $wall_thickness,
];

height_diff = tank_tile_size[2] * tank_tile_count - machine_tile_size[2] * machine_tile_count;
machine_height = height_diff + $wall_thickness;

difference() {
  rounded_cube(box_size, flat_top=true, $rounding=2);

  translate([$wall_thickness, $wall_thickness, 0]) {
    tile_cutout(machine_tile_size, machine_tile_count, machine_height, left_cutout=true);

    // Layout right of first machine tray
    translate([get_tile_offset(machine_tile_size[0]), 0, 0]) {
      tile_cutout(machine_tile_size, machine_tile_count, machine_height, right_cutout=true);
    }

    // Layout above machines
    translate([0, get_tile_offset(machine_tile_size[1]), 0]) {
      for(i=[0:tank_rows-1]) {
        // Layout tank row
        translate([0, get_tile_offset(tank_tile_size[1], i), 0]) {
          tile_cutout(tank_tile_size, tank_tile_count, left_cutout=true);

          
          // Layout align tank to right side
          translate([box_size[0] - get_tile_offset(tank_tile_size[0]) - $wall_thickness, 0, 0]) {
            tile_cutout(tank_tile_size, tank_tile_count, right_cutout=true);
          }
        }
      }
    }
  }
}