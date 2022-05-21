include <./config/cosmic-token-config.scad>
include <../../lib/tray/tile_tray_v2.scad>

$fn = 50;

matrix = [
  [tile_size],
];

matrix_counts = [
  [2],
];

wall_inset_length = 1.5;

tile_tray_v2(tile_size, matrix, matrix_counts, wall_inset_length);
