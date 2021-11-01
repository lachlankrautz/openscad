include <../../lib/tray/card_tray.scad>
include <../../lib/config/card_sizes.scad>

// Config
$fn = 50;

card_tray_top_spacer(standard_usa_card_size, $wall_thickness, [2, 1]);
