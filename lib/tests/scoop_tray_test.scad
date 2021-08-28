include <../../lib/dovetail_scoop_tray.scad>

// Config
// fn fails at small sizes
// $fn = 10;
$fn = 50;
$wall_thickness = 2;
$bleed = 0.01;

size = [
  15,
  20,
  8,
];

model_gap = $wall_thickness * 2;

matrix = [1, 1];

// tray
dovetail_scoop_tray(size, matrix);

// lid
translate([size[0] + model_gap, 0, 0]) {
  dovetail_lid(size, honeycomb_diameter=10);
}
