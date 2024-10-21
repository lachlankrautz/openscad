include <config/config.scad>
include <config/game_data.scad>
include <../../lib/tray/card_sideloader.scad>
include <../../lib/config/card_sizes.scad>

$fn = 50;

card_stack_list = [
  [
    standard_sleeved_card_size,
    guild_card_count
     + vox_card_count,
  ],
];

card_sideloader_stacked(
  card_stack_list,
  create_display_indent=true,
  create_access_cutout=true
);
