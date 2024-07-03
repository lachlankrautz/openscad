include <../lib/config/card_sizes.scad>

wall_thickness = 1.5; // possible minimumn possible wall thickness
card_padding = 2; // aiming for snug fit

card_box_size = card_cube_size(large_80_120_sleeved_card_size, 10);

cube(card_box_size);
