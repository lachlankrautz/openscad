include <../../lib/rounded_cube.scad>

$fn = 50;
$rounding = 1;

size = [
  104,
  156,
  7,
];

rounded_cube(size, flat=true);
