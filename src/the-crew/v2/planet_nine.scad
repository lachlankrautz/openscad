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

fit_to_box_size = [0, usable_box_width, 0];

box_size = sideloader_box_size(
  card_stack_list, 
  fit_to_box_size, 
  true, 
  default_indent_depth, 
  wall_thickness,
  padding
); 
natural_box_size = sideloader_natural_box_size(
  card_stack_list, 
  true, 
  default_indent_depth, 
  wall_thickness, 
  padding
);

token_hole_size = [
  box_size[0] - wall_thickness * 2 - default_indent_depth, 
  box_size[1] - natural_box_size[1] - wall_thickness, 
  box_size[2],
];

difference() {
  card_sideloader_stacked(
    card_stack_list,
    fit_to_box_size = fit_to_box_size, 
    fit_width_alignment = "left",
    create_display_indent=true,
    create_access_cutout=true
  );

  translate([wall_thickness, usable_box_width - token_hole_size[1] - wall_thickness, wall_thickness]) {
    cube(token_hole_size);
  }
}
