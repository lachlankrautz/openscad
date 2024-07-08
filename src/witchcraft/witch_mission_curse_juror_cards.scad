include <./config/config.scad>
include <./config/game_data.scad>
include <../../lib/tray/card_sideloader.scad>
include <../../lib/config/card_sizes.scad>

$fn = 50;

total_cards = witch_card_count
  + juror_card_count
  + curse_card_count
  + mission_card_count;

echo("count: ",total_cards);

card_sideloader(
  [large_80_120_sleeved_card_size, total_cards],
  create_display_indent=true,
  create_access_cutout=true,
  wall_thickness=wall_thickness,
  padding=card_padding
);
