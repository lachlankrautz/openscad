
include <../../lib/primitive/rounded_cube.scad>

$fn = 50;

length = 37;
width = 95;
height = 35;

rounded_cube([width, length, height], $rounding=1);
