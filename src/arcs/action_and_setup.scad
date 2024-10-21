include <config/config.scad>
include <config/game_data.scad>
include <../../lib/tray/card_sideloader.scad>
include <../../lib/config/card_sizes.scad>

$fn = 50;

action_card_stack = [
  standard_sleeved_card_size ,
  action_card_count,
];

setup_card_stack = [
  standard_sleeved_card_size,
  setup_card_count,
];

card_stack_list = [
  action_card_stack ,
  setup_card_stack ,
];

card_sideloader_stacked(
  card_stack_list,
  create_display_indent=true,
  create_access_cutout=true
);
