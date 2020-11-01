echo(version=version());

include <../../lib/rounded_cube.scad>

$fn = 50;
$rounding = 3;

// can render all rounded
rounded_cube([30, 30, 20]);

// can render flat bottom
translate([40, 0, 0]) {
  rounded_cube([30, 30, 20], flat_bottom=true);
}

// can render flat top
translate([80, 0, 0]) {
  rounded_cube([30, 30, 20], flat_top=true);
}

// can render flat top and flat bottom
translate([120, 0, 0]) {
  rounded_cube([30, 30, 20], flat=true);
}

// can render cube with different side and top rounding
translate([80, 40, 0]) {
  rounded_cube([30, 30, 2], flat_bottom=true, side_rounding=2, $rounding=1);
}

// can render flat top and flat bottom that is short
translate([120, 40, 0]) {
  rounded_cube([30, 30, 1], flat=true);
}
