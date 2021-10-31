include <../../lib/primitive/rounded_cube.scad>

$rounding = 2;
$wall_thickness = 2;
$fn = 50;
$bleed = 0.01;

length = 118;
width = 118;
height = 20.8;

rounded_cube([length, width, height], flat=true, $rounding=2);
