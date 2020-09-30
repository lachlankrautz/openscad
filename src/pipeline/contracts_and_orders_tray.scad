echo(version=version());

include <../../lib/rounded_cube.scad>
include <../../lib/tile_tray.scad>

// Config
// $fn = 50;
$fn = 10;

tile_rows = 3;

// Orders
order_tile_count = 8;
order_tile_size = [
  35, 
  30, 
  2.2,
];

// Contracts
contract_tile_count = 10;
contract_tile_size = [
  30, 
  30, 
  2.2,
];

box_size = [
  get_tile_offset(contract_tile_size[0]) + get_tile_offset(order_tile_size[0]) + $wall_thickness,
  get_tile_offset(contract_tile_size[1], 3) + $wall_thickness,
  contract_tile_size[2] * contract_tile_count + $wall_thickness,
];

height_diff = contract_tile_size[2] * contract_tile_count - order_tile_size[2] * order_tile_count;

difference() {
  rounded_cube(box_size, flat_top=true, $rounding=2);

  translate([$wall_thickness, $wall_thickness, 0]) {
    for(i=[0:tile_rows-1]) {
      translate([0, get_tile_offset(order_tile_size[1], i), 0]) {
        tile_cutout(contract_tile_size, 10, left_cutout=true);

        translate([get_tile_offset(contract_tile_size[0], 1), 0, 0]) {
          tile_cutout(order_tile_size, 10, height_diff + $wall_thickness, right_cutout=true);
        }
      }
    }
  }
}
