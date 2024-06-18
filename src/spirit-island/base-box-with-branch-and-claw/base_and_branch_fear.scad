include <../config/config.scad>
include <../config/game_data.scad>
include <../../../lib/tray/card_sideloader.scad>
include <../../../lib/config/card_sizes.scad>

$fn = 50;

card_sideloader(
  standard_sleeved_card_size,
  terror_level_count
    + base_game_fear_card_count
    + branch_fear_count
    + base_game_blight_count
    + branch_blight_count,
  create_display_indent=true,
  create_access_cutout=true,
  wall_thickness=wall_thickness,
  padding=card_padding
);
