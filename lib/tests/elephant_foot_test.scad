echo(version=version());

include <../../lib/elephant_foot.scad>

$fn = 50;
$rounding = 3;

elephant_foot([30, 30, 20]);

translate([40, 0, 0]) {
  elephant_foot([30, 30, 20], flat_bottom=true);
}

translate([80, 0, 0]) {
  elephant_foot([30, 30, 20], flat_top=true);
}
