include <../../lib/config/card_sizes.scad>
include <../../lib/tray/card_tray.scad>
include <../../lib/lid/dovetail_lid.scad>

card_grid_sizes = [
    [standard_sleeved_card_size],
    [standard_sleeved_card_size],
];

card_stack_height = 43;
box_height = card_stack_height + $wall_thickness * 2;

box_size = card_grid_size(card_grid_sizes, box_height);
