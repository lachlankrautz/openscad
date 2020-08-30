echo(version=version());

include <../../lib/rounded_square.scad>

$fn = 50;
$rounding = 3;

// can render all rounded
rounded_square([30, 30, 20]);

// can render flat bottom
translate([40, 0, 0]) {
  rounded_square([30, 30, 20], flat_bottom=true);
}

// can render flat top
translate([80, 0, 0]) {
  rounded_square([30, 30, 20], flat_top=true);
}
