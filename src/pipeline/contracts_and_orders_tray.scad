echo(version=version());

include <../../lib/rounded_cube.scad>

// Config
// $fn = 50;
$fn = 10;
$wall_thickness = 2;
$bleed = 0.01;
tile_gap = 0.5;
tile_rows = 3;

// Orders
order_tile_count = 8;
order_tile_size = [
  35, 
  30, 
  2.2,
];
order_height = order_tile_size[2] * order_tile_count + tile_gap;
order_cutout_size = [
  order_tile_size[0] + tile_gap * 2,
  order_tile_size[1] + tile_gap * 2,
  order_height + $bleed,
];

// Contracts
contract_tile_count = 10;
contract_tile_size = [
  30, 
  30, 
  2.2,
];
contract_height = contract_tile_size[2] * contract_tile_count + tile_gap;
contract_cutout_size = [
  contract_tile_size[0] + tile_gap * 2,
  contract_tile_size[1] + tile_gap * 2,
  contract_height + $bleed,
];

box_size = [
  contract_cutout_size[0] + order_cutout_size[0] + $wall_thickness * 3,
  order_cutout_size[1] * tile_rows + $wall_thickness * (tile_rows + 1),
  contract_height + $wall_thickness,
];

col_height = order_cutout_size[1] + $wall_thickness * 2;

cutout_fraction = 0.5;
side_cutout = [
  box_size[0] * cutout_fraction,
  col_height * cutout_fraction,
  box_size[2] + $bleed * 2,
];
side_cutout_width_offset = (box_size[0] - side_cutout[0]) / 2;
side_cutout_length_offset = (col_height - side_cutout[1]) / 2;
inset = 6;

difference() {
  rounded_cube(box_size, flat_top=true, $rounding=2);

  for(i=[0:tile_rows-1]) {
    translate([0, (order_cutout_size[1] + $wall_thickness) * i, 0]) {
      // Tile tray
      translate([$wall_thickness, $wall_thickness, $wall_thickness]) {
        rounded_cube(contract_cutout_size, flat=true, $rounding=1);
      }

      // Left cutout
      translate([-side_cutout[0] + inset, side_cutout_length_offset, 0]) {
        rounded_cube(side_cutout, flat=true);
      }

      // Layout right columns
      translate([contract_cutout_size[0] + $wall_thickness, 0, 0]) {
        // Tile tray
        translate([$wall_thickness, $wall_thickness, $wall_thickness + contract_height - order_height]) {
          rounded_cube(order_cutout_size, flat=true, $rounding=1);
        }

        // Right cutout
        translate([order_cutout_size[0] + $wall_thickness * 2 - inset, side_cutout_length_offset, 0]) {
          rounded_cube(side_cutout, flat=true);
        }
      }
    }
  }
}
