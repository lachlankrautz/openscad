include <../../lib/scoop_tray.scad>
include <../../lib/dovetail_lid.scad>

// Config
// $fn = 10;
$fn = 50;
$wall_thickness = 2;

size = [
  104,
  156,
  20,
];

matrix = [2, 3];

// Tray
difference() {
  scoop_tray(size, matrix, radius=12);
  dovetail_lid_cutout(tray_size);
}

// Lid
// dovetail_lid(size, honeycomb_diameter=12);
