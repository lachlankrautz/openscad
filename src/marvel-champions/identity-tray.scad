include <./config/cosmic-token-config.scad>
include <../../lib/layout/layout.scad>
include <../../lib/tray/tile_tray_v2.scad>
include <../../lib/config/card_sizes.scad>
include <../../lib/config/magnet-sizes.scad>
include <../../lib/magnet/magnet.scad>

$fn = 50;

module identity_tray() {
  matrix = [
    [slim_tile_size, slim_tile_size],
    [slim_tile_size, slim_tile_size],
    [slim_tile_size, slim_tile_size],
    [slim_tile_size, slim_tile_size],
    [slim_tile_size, slim_tile_size],
  ];
  matrix_counts = [
    [1, 1],
    [1, 1],
    [1, 1],
    [1, 1],
    [1, 1],
  ];

  difference() {
    tile_tray_v2(
      matrix,
      matrix_counts,
      wall_inset_length,
      with_lid=false,
      slim_fit=false,
      centre_rows=true,
      $top_padding = 0,
      notch_style="square"
    );
  }
}

identity_tray();
