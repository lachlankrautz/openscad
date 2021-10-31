include <../../lib/card_tray.scad>
include <../../lib/config/card_sizes.scad>

// Config
$fn = 50;
// $fn = 10;
$wall_thickness = 2;

// a 2x1 array of card trays
// twilght struggle needs 4 so print 2 unless printer can handle a bigger one
card_tray(standard_sleeved_card_size, 25, [2, 1], honeycomb_diameter=10);
