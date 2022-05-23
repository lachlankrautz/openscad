include <./config/cosmic-token-config.scad>
include <../../lib/layout/layout.scad>
include <../../lib/tray/tile_tray_v2.scad>
include <../../lib/config/card_sizes.scad>

$fn = 50;

side_scheme_size = [
  max(
    standard_sleeved_card_size[1],
    tile_size[0] * 5 + $padding * 8 + $wall_thickness * 4
  ),
  standard_sleeved_card_size[0],
  tile_size[2],
];

matrix = [
  [tile_size, side_scheme_size],
  [tile_size],
  [tile_size],
  [tile_size],
  [tile_size],
];

matrix_counts = [
  [1, 1],
  [1],
  [1],
  [1],
  [1],
];

tile_tray_v2(tile_size, matrix, matrix_counts, wall_inset_length, with_lid=false);
