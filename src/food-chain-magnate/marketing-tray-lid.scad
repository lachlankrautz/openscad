include <../../lib/primitive/rounded_cube.scad>
include <../../lib/compound/tile_stack.scad>
include <../../lib/layout/grid_utils.scad>
include <../../lib/lid/dovetail_lid.scad>
include <./config/marketing-config.scad>

$fn = 50;

dovetail_lid(box_size, honeycomb_diameter=15);
