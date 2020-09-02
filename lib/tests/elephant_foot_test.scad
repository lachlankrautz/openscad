echo(version=version());

include <../../lib/elephant_foot.scad>

$fn = 50;
$rounding = 3;

elephant_foot([30, 30, 20]);

translate([40, 0, 0]) {
  elephant_foot([30, 30, 20], flat_bottom=true, use_bleed=true);
}

translate([80, 0, 0]) {
  elephant_foot([30, 30, 20], flat_top=true, use_bleed=true);
}

translate([120, 0, 0]) {
  elephant_foot([30, 30, 20], rounded_bottom=true);
}

translate([160, 0, 0]) {
  elephant_foot([30, 30, 20], rounded_top=true);
}

card_window_size = [
  66,
  91.8,
  $rounding
];
foot_rounding = 3;

translate([0, -100, 0]) {
  elephant_foot(card_window_size, flat_top=true, $rounding=foot_rounding);
}

// Can render with low rounding
translate([80, -30, 0]) {
  elephant_foot([10, 10, 7], rounded_bottom=true, $rounding=1);
}

translate([120, -30, 0]) {
  elephant_foot([20, 20, 10], rounded_bottom=true, $rounding=4);
}
