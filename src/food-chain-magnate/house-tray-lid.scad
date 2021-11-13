include <./house-tray-config.scad>
include <../../lib/lid/dovetail_lid.scad>

$fn = 50;

dovetail_lid(box_size, honeycomb_diameter=15);
