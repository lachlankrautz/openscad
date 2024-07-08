include <../config/game_data.scad>
include <../../../lib/tray/card_sideloader.scad>
include <../../../lib/config/card_sizes.scad>

$fn = 50;

wall_thickness = default_wall_thickness;
padding = default_card_padding;

large_card_stack = [
  standard_usa_card_size,
  planet_9_playing_card_count
    + planet_9_communication_card_count 
];

small_card_stack = [
  mini_euro_card_size,
  planet_9_mission_card_count,
];

card_stack_list = [
  large_card_stack,
  small_card_stack,
];

usable_box_width = box_inner_width - box_inner_padding;

difference() {
  card_sideloader_stacked(
    card_stack_list,
    fit_to_box_size = [0, usable_box_width, 0], 
    fit_width_alignment = "left",
    create_remaining_space_token_pocket = true,
    create_display_indent=true,
    create_access_cutout=true
  );
}
