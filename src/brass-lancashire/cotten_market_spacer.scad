include <../../lib/rounded_cube.scad>

$wall_thickness = 2;
$rounding = 3;
$bleed = 0.01;

length = 65;
width = 81;
height = 30.5;

rounded_cube([length, width, height], flat_top=true, flat_bottom=true);
