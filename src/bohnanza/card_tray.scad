include <../../lib/tray/card_tray.scad>
include <../../lib/config/card_sizes.scad>

// Config
$fn = 50;

height = 28;

card_grid(make_grid_of([2, 1], standard_sleeved_card_size), height);
