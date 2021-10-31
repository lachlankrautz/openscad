include <../../lib/primitive/rounded_cube.scad>

$wall_thickness = 2;
$rounding = 3;
$bleed = 0.01;

length = 55;
width = 90;
height = 13;

rounded_cube([length, width, height], flat_top=true, flat_bottom=true);
