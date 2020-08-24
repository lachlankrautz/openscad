echo(version=version());

include <../../lib/flat_rounded_cube.scad>

$rounding = 3;
$fn = 50;

flat_rounded_cube([20, 20, 20]);
