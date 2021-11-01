include <../../lib/primitive/scoop_tray.scad>
include <../../lib/lid/dovetail_lid.scad>

// Config
$fn = 50;

size = [
  116,
  128,
  29.7,
];

roof_gap = 2.2;

tray_size = [
  size[0],
  size[1],
  size[2] - roof_gap,
];

matrix = [2, 3];

// tray
difference() {
  scoop_tray(tray_size, matrix);
  dovetail_lid_cutout(tray_size);
}

// lid
// dovetail_lid(tray_size, honeycomb_diameter=12);
