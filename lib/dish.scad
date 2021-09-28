include <./rounded_cube.scad>
include <./hemisphere.scad>

$rounding = 3;
$bleed = 1;
$lid_height = 2;
$fn = 50;

default_dish_ratio = 0.5;

module dish (size, dish_ratio=default_dish_ratio, lid=false) {
  width = size[0];
  length = size[1];
  height = size[2];

  r_width = width - $rounding * 2;
  r_length = length - $rounding * 2;
  r_height = height - $rounding * 2;
  cube_ratio = 1 - dish_ratio;

  radius = min(r_width,r_length);

  position = [
    0,
    0,
    lid ? -$lid_height : 0,
  ];

  translate(position) {
    difference() {
      minkowski() {
        hull() {
          translate([0,0,height * dish_ratio - $rounding]) {
            cube([r_width,r_length,height * cube_ratio]);
          }

          resize([r_width,r_length,height / 2 * dish_ratio]) {
            hemisphere(radius, centre=false);
          }
        }

        // Rounding
        hemisphere($rounding);
      }
    }
  }
}
