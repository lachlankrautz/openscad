include <../config/token-config.scad>
include <../../../lib/layout/layout.scad>
include <../../../lib/tray/tile_tray_v2.scad>
include <../../../lib/config/card_sizes.scad>

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

top_wall_inset_length = 7; // side scheme card needs a deeper inset
matrix_wall_inset_lengths = [
  [undef, top_wall_inset_length]
];

module quest_tray(progress_tiles) {
  matrix = [
  for(i=[0:progress_tiles-1]) i == 0
    ? [slim_tile_size, side_scheme_size]
    : [slim_tile_size]
  ];
  matrix_counts = [
  for(i=[0:progress_tiles-1]) i == 0
    ? [1, 1]
    : [1]
  ];

  tile_tray_v2(
    slim_tile_size,
    matrix,
    matrix_counts,
    wall_inset_length,
    matrix_wall_inset_lengths,
    with_lid=false,
    slim_fit=true,
    $top_padding = 0
  );
}
