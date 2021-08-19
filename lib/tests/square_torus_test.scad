include <../../lib/square_torus.scad>

$fn = 50;
$rounding = 3;
$bleed = 1;

square_torus([80, 40, 10], 10);

translate([100, 0, 0]) {
  square_torus([80, 120, 20], 8, flat_top=true);
}

small_rounding = 1;
translate([200, 0, 0]) {
  square_torus([80, 80, small_rounding + $bleed], 5, flat_bottom=true, $rounding=small_rounding);
}
