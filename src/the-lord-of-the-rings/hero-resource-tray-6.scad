include <../../lib/tray/tile_tray_v2.scad>
include <../../lib/magnet/magnet.scad>
include <../../lib/config/magnet-sizes.scad>
include <./config/token-config.scad>

$fn = 50;

matrix = [
  [cardboard_glued_tile, cardboard_glued_tile],
  [cardboard_glued_tile, cardboard_glued_tile],
  [cardboard_glued_tile, cardboard_glued_tile],
];

matrix_counts = [
  [1, 1],
  [1, 1],
  [1, 1],
];

hero_tray_width = 74;

box_size = tile_tray_box_size(matrix, matrix_counts, hero_tray_width);

difference() {
  tile_tray_v2(
    matrix,
    matrix_counts,
    wall_inset_length,
    minimum_box_width=hero_tray_width,
    with_lid = false,
    notch_style = "square",
    centre_rows=true
  );

  vertical_magnet_sockets(
    box_size,
    small_magnet_diameter,
    small_magnet_height,
    ["left", "right"],
    sml_rounding,
    sml_rounding * 2
  );
}
