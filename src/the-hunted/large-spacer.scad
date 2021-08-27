include <../../lib/rounded_cube.scad>

$fn = 50;
$rounding = 1;

size = [
  104,
  154,
  9.8,
];

rounded_cube(size, flat=true);
