include <./config/token-config.scad>
include <../../lib/tray/tile_tray_v3.scad>

$fn = 10;

tile_tray_v3(matrix, matrix_counts, wall_inset_length);
