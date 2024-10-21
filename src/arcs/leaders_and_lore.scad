include <config/config.scad>
include <config/game_data.scad>
include <../../lib/tray/card_sideloader.scad>
include <../../lib/config/card_sizes.scad>

$fn = 50;

leaders_card_stack = [
  tarot_sleeved_card_size ,
  leaders_card_count,
];

lore_card_stack = [
  standard_sleeved_card_size,
  lore_card_count,
];

card_stack_list = [
  leaders_card_stack,
  lore_card_stack,
];

card_sideloader_stacked(
  card_stack_list,
  create_display_indent=true,
  create_access_cutout=true
);
