echo(version=version());

include <../../lib/square_torus.scad>

$fn = 50;
$rounding = 3;

square_torus([80, 80, 10], 10);

translate([100, 0, 0]) {
  square_torus([80, 80, 20], 8, flat_top=true);
}

translate([200, 0, 0]) {
  square_torus([80, 80, 10], 15, flat_bottom=true);
}
