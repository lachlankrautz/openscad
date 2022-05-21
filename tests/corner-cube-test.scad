include <../lib/tray/tile_tray_v2.scad>

$rounding = 2;

size = [
  7,
  5,
  2
];

gap = 2;

corner_cube(size, 1);

translate([0, size[1] + gap, 0]) {
  corner_cube(size, 2);
}

translate([size[0] + gap, size[1] + gap, 0]) {
  corner_cube(size, 3);
}

translate([size[0] + gap, 0, 0]) {
  corner_cube(size, 4);
}
