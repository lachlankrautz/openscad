include <../../lib/tray/card_sideloader.scad>
include <../../lib/config/card_sizes.scad>

$fn = 50;
wall_thickness = 1.5;
card_padding = 2;
card_stack_height = 10;

invader_card_count = 15;

// card_sideloader(standard_sleeved_card_size, card_stack_count, wall_thickness, padding);

card_sideloader(mini_euro_sleeved_card_size, invader_card_count, wall_thickness, card_padding);
