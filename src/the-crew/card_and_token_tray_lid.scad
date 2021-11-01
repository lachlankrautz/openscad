include <./config.scad>
include <../../lib/tray/card_tray.scad>
include <../../lib/compound/notched_cube.scad>
include <../../lib/compound/tile_stack.scad>
include <../../lib/compound/tile_stack_round.scad>
include <../../lib/lid/dovetail_lid.scad>

$fn = 50;

dovetail_lid(box_size, honeycomb_diameter=15);
