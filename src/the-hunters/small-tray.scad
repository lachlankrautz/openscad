include <../../lib/scoop_tray.scad>
include <../../lib/tray_lid.scad>

// Config
// $fn = 10;
$fn = 50;
$wall_thickness = 2;
$bleed = 0.01;

// Honeycomb size
$spacing_fraction = 10;

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
// scoop_tray(tray_size, matrix);

// lid
tray_lid(tray_size, matrix, honeycomb=true);
