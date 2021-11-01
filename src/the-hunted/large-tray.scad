include <../../lib/primitive/scoop_tray.scad>
include <../../lib/lid/dovetail_lid.scad>

// Config
$fn = 50;

size = [
  104,
  154,
  20,
];

matrix = [2, 4];

/*
difference() {
  scoop_tray(size, matrix);
  dovetail_lid_cutout(size);
}
*/

dovetail_lid(size, honeycomb_diameter=12);
