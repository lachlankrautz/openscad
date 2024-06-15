include <../../lib/tray/card_sideloader.scad>
include <../../lib/config/card_sizes.scad>

$fn = 50;
wall_thickness = 1.5; // possible minimumn possible wall thickness
card_padding = 1; // aiming for snug fit
invader_card_count = 15;

card_sideloader(mini_euro_sleeved_card_size, invader_card_count, wall_thickness, card_padding);
