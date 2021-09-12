include <../../lib/rounded_cube.scad>

$rounding = 3;
$bleed = 0.01;

size = [
  186,
  114,
  13,
];

inset_x = 10;
inset_y = 40;

cutout_size = [
  size[0] - inset_x * 2,
  inset_y + $rounding + $bleed,
  size[2] + $bleed * 2,
];

difference() {
  rounded_cube(size, flat=true);

  translate([inset_x, -$rounding - $bleed, -$bleed]) {
    rounded_cube(cutout_size, flat=true);
  }
}

