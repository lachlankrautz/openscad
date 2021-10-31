include <../../lib/config/card_sizes.scad>
include <../../lib/tray/card_tray.scad>

tile_size = [
  20.5,
  20.5,
  2.2,
];
round_tile_diameter = 25;
tile_stack_count = 5;

cards = [
  [standard_usa_card_size],
  [mini_euro_card_size],
];
card_stack_height = 16;

card_tray_size = card_tray_grid_size(cards, card_stack_height);
token_tray_size = [0, padded_offset(tile_size[1]), 0];

lid_height = $wall_thickness;

box_size = [
  max(card_tray_size[0], token_tray_size[0]),
  card_tray_size[1] + token_tray_size[1],
  max(card_tray_size[2], token_tray_size[2])
    + lid_height,
];
