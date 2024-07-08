include <../config/game_data.scad>
include <../../../lib/tray/card_sideloader.scad>
include <../../../lib/config/card_sizes.scad>

$fn = 50;

wall_thickness = default_wall_thickness;
padding = default_card_padding;

large_card_stack = [
  standard_usa_card_size,
  deep_sea_playing_card_count
    + deep_sea_communication_card_count 
];

mini_euro_card_size_double = [
  mini_euro_card_size[1], 
  mini_euro_card_size[0] * 2, 
  mini_euro_card_size[2], 
];

small_card_stack = [
  mini_euro_card_size_double,
  deep_sea_mission_card_count / 2,
];

card_stack_list = [
  large_card_stack,
  small_card_stack,
];

usable_box_width = box_inner_width - box_inner_padding;

card_sideloader_stacked(
  card_stack_list,
  fit_to_box_size = [0, usable_box_width, 0], 
  fit_width_alignment = "left",
  create_remaining_space_token_pocket = true,
  create_display_indent=true,
  create_access_cutout=true
);

// card_sideloader_stacked_pocket_lid(
//   card_stack_list,
//   fit_to_box_size=[0, usable_box_width, 0]
// );


