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

// can render flat top and flat bottom shorter than or equal to rounding*2
translate([120, 40, 0]) {
  rounded_cube([30, 30, 2], flat=true);
}
