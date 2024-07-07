include <./config/config.scad>
include <./config/game_data.scad>
include <../../lib/tray/card_sideloader.scad>
include <../../lib/config/card_sizes.scad>

$fn = 50;

challenge_card_stack = [standard_sleeved_card_size, challenge_card_count];

card_sideloader_stacked(
  [challenge_card_stack],
  create_display_indent=true,
  create_access_cutout=true,
  wall_thickness=wall_thickness,
  padding=card_padding
);
