include <./config/small-player-token-tray-config.scad>
include <../../lib/tray/tile_tray_v2.scad>

$fn = 50;

tile_tray_v2(
  matrix,
  matrix_counts,
  wall_inset_length,
  notch_style="square"
);
