include <../src/marvel-champions/config/cosmic-token-config.scad>
include <../lib/tray/tile_tray_v2.scad>

$fn = 50;

wall_inset_length = 1.5;

matrix = [
  [tile_size]
  // [tile_size, tile_size],
  // [tile_size, tile_size],
  // [tile_size, tile_size],
];

matrix_counts = [
  [2, 2],
  [2, 2],
  [2, 2],
];

box_size = tile_tray_box_size(tile_size, matrix, matrix_counts);

tile_tray_v2(tile_size, matrix, matrix_counts, wall_inset_length);

translate([0, box_size[1], 10.2]) {
  rotate([180, 0, 0]) {
    tile_tray_lid_v2(tile_size, matrix, matrix_counts, wall_inset_length);
  }
}
