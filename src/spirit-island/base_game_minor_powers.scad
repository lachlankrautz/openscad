include <../../lib/tray/card_sideloader.scad>
include <../../lib/config/card_sizes.scad>

$fn = 50;
wall_thickness = 1.5; // possible minimumn possible wall thickness
card_padding = 1; // aiming for snug fit
minor_power_count = 36;

card_sideloader(standard_sleeved_card_size, minor_power_count, wall_thickness, card_padding);
