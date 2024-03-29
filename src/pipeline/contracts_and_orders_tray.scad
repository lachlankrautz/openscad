include <../../lib/primitive/rounded_cube.scad>
include <../../lib/layout/layout.scad>
include <../../lib/compound/notched_cube.scad>
include <../../lib/tile_stack.scad>

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
  padded_offset(contract_tile_size[0]) + padded_offset(order_tile_size[0]) + $wall_thickness,
  padded_offset(contract_tile_size[1], 3) + $wall_thickness,
  stack_height(contract_tile_size[2], contract_tile_count) + $wall_thickness,
];

height_diff = contract_tile_size[2] * contract_tile_count - order_tile_size[2] * order_tile_count;

difference() {
  rounded_cube(box_size, flat_top=true, $rounding=2);

  translate([$wall_thickness, $wall_thickness, 0]) {
    for(i=[0:tile_rows-1]) {
      translate([0, padded_offset(order_tile_size[1], i), 0]) {
        tile_stack(
          contract_tile_size, 
          10, 
          box_size[2],
          left_cutout=true
        );

        translate([padded_offset(contract_tile_size[0], 1), 0, 0]) {
          tile_stack(
            order_tile_size, 
            10, 
            box_size[2],
            right_cutout=true
          );
        }
      }
    }
  }
}
