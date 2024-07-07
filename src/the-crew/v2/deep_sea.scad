include <../config/game_data.scad>
include <../../../lib/tray/card_sideloader.scad>
include <../../../lib/config/card_sizes.scad>

$fn = 50;

large_card_stack = [
  // TODO wrong card size
  standard_sleeved_card_size,
  deep_sea_playing_card_count
    + deep_sea_communication_card_count 
];

small_card_half_stack = [
  // TODO wrong card size
  mini_euro_sleeved_card_size,
  deep_sea_mission_card_count / 2,
];

card_sideloader_stacked(
  [
    large_card_stack,
    small_card_half_stack,
  ],
  create_display_indent=true,
  create_access_cutout=true
);
