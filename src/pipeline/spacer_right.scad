include <../../lib/primitive/rounded_cube.scad>

$fn = 50;
$rounding = 2;

length = 118;
width = 118;
height = 20.8;

rounded_cube([length, width, height], flat=true, $rounding=2);
