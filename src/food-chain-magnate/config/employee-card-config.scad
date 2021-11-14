include <../../../lib/tray/card_tray.scad>
include <../../../lib/config/card_sizes.scad>

$fn = 50;

card_stack_height = 40;
spacer_height = 2;
top_gap = 1;
height = card_stack_height + $floor_thickness + spacer_height + top_gap;
