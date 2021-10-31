include <../../lib/tray/card_tray.scad>
include <../../lib/compound/notched_cube.scad>
include <../../lib/config/card_sizes.scad>
include <../../lib/compound/tile_stack.scad>
include <../../lib/compound/tile_stack_round.scad>

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
card_stack_height = 28;

card_tray_size = card_tray_grid_size(cards, card_stack_height);
token_tray_size = [0, padded_offset(tile_size[1]), 0];

box_size = [
  max(card_tray_size[0], token_tray_size[0]),
  card_tray_size[1] + token_tray_size[1],
  max(card_tray_size[2], token_tray_size[2]),
];

difference() {
  rounded_cube(box_size + [0, 0, 2], flat_top=true);

  translate([$wall_thickness, card_tray_size[1], 0]) {
    for (i=[0:2]) {
      translate([padded_offset(tile_size[0], i), 0, 0]) {
        if (i < 2) {
          tile_stack(
            tile_size,
            tile_stack_count,
            box_size[2],
            top_cutout = true,
            bottom_cutout = false
          );
        } else {
          tile_stack_round(
            round_tile_diameter,
            tile_size[2],
            tile_stack_count,
            box_size[2],
            top_cutout = true,
            bottom_cutout = false
          );
        }
      }
    }
  }

  card_tray_grid_cutout(cards, card_stack_height, top_cutout=false);
}
