include <./config/small-player-token-tray-config.scad>
include <../../lib/tray/tile_tray_v2.scad>

$fn = 50;

tile_tray_lid_v2(slim_tile_size, matrix, matrix_counts, wall_inset_length);
