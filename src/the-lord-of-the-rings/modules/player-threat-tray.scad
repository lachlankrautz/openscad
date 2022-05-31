include <../config/token-config.scad>
include <../../../lib/layout/layout.scad>
include <../../../lib/tray/tile_tray_v2.scad>
include <../../../lib/image/svg_icon.scad>
include <../../../lib/config/card_sizes.scad>

$fn = 50;

slim_tile_size = [
  tile_size[0],
  tile_size[1],
  tile_size[2] - 0.2 // trying to get the stacks to sit flush since there is no lid
];

side_scheme_size = [
  standard_sleeved_card_size[1],
  standard_sleeved_card_size[0],
  1.8,
];

image_cutout_depth = 1;
fellowship_file = "../../assets/images/the-lord-of-the-rings/fellowship.svg";
fraction = 6;
fellowship_size = [851, 216];
fellowship_target_size = [fellowship_size[0] / 100 * fraction, fellowship_size[1] / 100 * fraction];

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

  difference() {
    tile_tray_v2(
      slim_tile_size,
      matrix,
      matrix_counts,
      wall_inset_length,
      with_lid=false,
      $top_padding = 0
    );

    translate([46, 33, box_size[2] - image_cutout_depth]) {
      svg_icon(fellowship_file, image_cutout_depth + $bleed, fellowship_size, fellowship_target_size);
    }
  }
}
