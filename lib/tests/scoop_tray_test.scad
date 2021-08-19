include <../../lib/scoop_tray.scad>
include <../../lib/tray_lid.scad>

// Config
// fn fails at small sizes
// $fn = 10;
// $fn = 30;
$fn = 50;
$wall_thickness = 2;
$bleed = 0.01;

size = [
  40,
  40,
  15,
];

matrix = [1, 1];

// tray
scoop_tray(size, matrix);

// lid
translate([size[0] + $wall_thickness * 2, 0, 0]) {
  tray_lid(size, matrix, honeycomb=true);
}
