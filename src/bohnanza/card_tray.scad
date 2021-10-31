include <../../lib/card_tray.scad>
include <../../lib/config/card_sizes.scad>

// Config
$fn = 50;
// $fn = 10;
$wall_thickness = 2;

card_tray(standard_usa_card_size, 28, [2, 1]);
