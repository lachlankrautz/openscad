include <../../lib/primitive/scoop_tray.scad>
include <../../lib/lid/dovetail_lid.scad>

// Config
// $fn = 10;
$fn = 50;
$wall_thickness = 2;
$bleed = 0.01;

size = [
  118,
  130,
  21,
];

tray_size = [
  size[0],
  size[1],
  size[2] + $wall_thickness * 2,
];

matrix = [2, 3];

// tray
/*
difference() {
  scoop_tray(tray_size, matrix);
  dovetail_lid_cutout(tray_size);
}
*/

// lid
dovetail_lid(tray_size, honeycomb_diameter=12);
