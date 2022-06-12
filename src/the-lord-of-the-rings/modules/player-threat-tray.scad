include <../config/token-config.scad>
include <../../../lib/layout/layout.scad>
include <../../../lib/tray/tile_tray_v2.scad>
include <../../../lib/config/card_sizes.scad>

side_scheme_size = [
  standard_sleeved_card_size[1],
  standard_sleeved_card_size[0],
  1.8,
];

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

  box_size = tile_tray_box_size(matrix, matrix_counts);
  inset_size = [
    (box_size[0] - (pad(tile_size[0]) * 2 + $wall_thickness * 5)) / 2,
    pad(tile_size[1]),
    image_inset_height + $bleed,
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

    translate([0, $wall_thickness * 2 + pad(tile_size[1]), box_size[2] - image_inset_height]) {
      translate([$wall_thickness, 0, 0]) {
        cube(inset_size);
      }
      translate([box_size[0] - inset_size[0] - $wall_thickness, 0, 0]) {
        cube(inset_size);
      }
    }
  }
}
