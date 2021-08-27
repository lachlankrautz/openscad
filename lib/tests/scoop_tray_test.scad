include <../../lib/scoop_tray.scad>
include <../../lib/tray_lid.scad>
include <../../lib/dovetail_lid.scad>

// Config
// fn fails at small sizes
// $fn = 10;
// $fn = 30;
$fn = 50;
$wall_thickness = 2;
$bleed = 0.01;

size = [
  20,
  20,
  10,
];

matrix = [1, 1];

// tray
difference() {
  scoop_tray(size, matrix);
  dovetail_lid_cutout(size);
}

// lid
translate([size[0] + $wall_thickness * 2, 0, 0]) {
  // tray_lid(size, matrix, honeycomb_diameter=10, left=false, right=false, $rounding=1);
  dovetail_lid(size, honeycomb_diameter=10);
}
