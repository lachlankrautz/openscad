echo(version=version());

include <../../lib/rounded_cube.scad>

// Config
// $fn = 50;
$fn = 10;
$wall_thickness = 2;
$bleed = 0.01;
tile_gap = 0.5;

tile_cols = 3;
order_tile_count = 8;

order_tile_size = [
  35, 
  30, 
  2.2,
];
order_height = order_tile_size[2] * order_tile_count + tile_gap;

cutout_size = [
  order_tile_size[0] + tile_gap * 2,
  order_tile_size[1] + tile_gap * 2,
  order_height + $bleed,
];

box_size = [
  cutout_size[0] * tile_cols + $wall_thickness * (tile_cols + 1),
  cutout_size[1] + $wall_thickness * 2,
  order_height + $wall_thickness,
];

col_width = cutout_size[0] + $wall_thickness * 2;

cutout_fraction = 0.5;
side_cutout = [
  col_width * cutout_fraction,
  box_size[1] * cutout_fraction,
  box_size[2] + $bleed * 2,
];
side_cutout_width_offset = (col_width - side_cutout[0]) / 2;
side_cutout_length_offset = (box_size[1] - side_cutout[1]) / 2;
inset = 6;

difference() {
  rounded_cube(box_size, flat_top=true, $rounding=2);

  for(i=[0:tile_cols-1]) {
    translate([(cutout_size[0] + $wall_thickness) * i, 0, 0]) {
      // Tile tray
      translate([$wall_thickness, $wall_thickness, $wall_thickness]) {
        rounded_cube(cutout_size, flat=true, $rounding=1);
      }

      // Bottom cutout
      translate([side_cutout_width_offset, -side_cutout[1] + inset, 0]) {
        rounded_cube(side_cutout, flat=true);
      }
    }
  }
}
