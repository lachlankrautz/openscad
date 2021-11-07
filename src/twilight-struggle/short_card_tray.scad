include <../../lib/tray/card_tray.scad>
include <../../lib/config/card_sizes.scad>

// Config
$fn = 50;

card_grid = make_grid_of([2, 1], standard_sleeved_card_size);

// a 2x1 array of card trays
// twilght struggle needs 4 so print 2 unless printer can handle a bigger one
card_grid(card_grid, 25);
