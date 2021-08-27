include <../../lib/rounded_cube.scad>

$fn = 50;
$rounding = 1;

size = [
  118,
  130,
  2.8
];

rounded_cube(size, flat=true);
