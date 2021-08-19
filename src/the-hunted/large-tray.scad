include <../../lib/scoop_tray.scad>

// Config
// $fn = 10;
$fn = 50;
$wall_thickness = 2;

// TODO measure
size = [
  // 104,
  // 156,
  // 29.7,
];

roof_gap = 2.2;

tray_size = [
  size[0],
  size[1],
  size[2] - roof_gap,
];

scoop_tray(tray_size, [2, 3]);
