include <../lib/config/constants.scad>
include <../lib/design/square-pattern.scad>

size = [
  10,
  10
];

matrix = [
  [size, size],
  [size, size],
];

inset = 1.5;

square_pattern(matrix, $wall_thickness, inset, $wall_thickness);

box_size = [
  30,
  30,
  $wall_thickness,
];
