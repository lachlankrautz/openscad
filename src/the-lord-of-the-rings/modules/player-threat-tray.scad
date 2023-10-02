include <../config/token-config.scad>
include <../../../lib/layout/layout.scad>
include <../../../lib/tray/tile_tray_v2.scad>
include <../../../lib/config/card_sizes.scad>
include <../../../lib/config/magnet-sizes.scad>
include <../../../lib/magnet/magnet.scad>

image_cutout_depth = 1;

module player_threat_tray() {
  matrix = [
    [slim_tile_size, slim_tile_size],
    [slim_tile_size, slim_tile_size],
    [slim_tile_size],
    [slim_tile_size],
    [slim_tile_size],
  ];
  matrix_counts = [
    [1, 1],
    [1, 1],
    [1],
    [1],
    [1],
  ];

  recommended_box_width = tile_tray_box_size(matrix, matrix_counts)[0];
  padded_box_width = recommended_box_width + $wall_thickness * 2;
  box_size = tile_tray_box_size(matrix, matrix_counts, padded_box_width);
  inset_size = [
    (recommended_box_width - (pad(slim_tile_size[0]) * 2 + $wall_thickness * 5)) / 2,
    pad(slim_tile_size[1]),
    image_inset_height + $bleed,
  ];

  difference() {
    tile_tray_v2(
      matrix,
      matrix_counts,
      wall_inset_length,
      minimum_box_width = padded_box_width,
      with_lid=false,
      slim_fit=false,
      centre_rows=true,
      $top_padding = 0,
      notch_style="square"
    );

    translate([0, $wall_thickness * 2 + pad(slim_tile_size[1]), box_size[2] - image_inset_height]) {
      translate([$wall_thickness * 2, 0, 0]) {
        cube(inset_size);
      }
      translate([box_size[0] - inset_size[0] - $wall_thickness * 2, 0, 0]) {
        cube(inset_size);
      }
    }

    vertical_magnet_sockets(
      box_size,
      small_magnet_diameter,
      small_magnet_height,
      ["left", "right"],
      sml_rounding,
      sml_rounding * 2
    );
  }
}
