include <./config/config.scad>
include <./config/game_data.scad>
include <../../lib/tray/card_sideloader.scad>
include <../../lib/config/card_sizes.scad>

$fn = 50;

standard_card_stack = [
  standard_sleeved_card_size,
  villager_card_count 
    + aid_card_count,
];

small_card_stack = [
  mini_euro_sleeved_card_size,
  conviction_card_count,
];

card_sideloader_stacked(
  [
    standard_card_stack,
    small_card_stack,
  ],
  create_display_indent=true,
  create_access_cutout=true,
  wall_thickness=wall_thickness,
  padding=card_padding
);
