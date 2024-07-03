include <./config/config.scad>
include <./config/game_data.scad>
include <../../lib/tray/card_sideloader.scad>
include <../../lib/config/card_sizes.scad>

$fn = 50;

standard_card_count = villager_card_count + aid_card_count;

card_sideloader(
  standard_sleeved_card_size,
  standard_card_count,
  create_display_indent=true,
  create_access_cutout=true,
  wall_thickness=wall_thickness,
  padding=card_padding
);
