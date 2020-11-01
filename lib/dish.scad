$rounding = 3;
$bleed = 1;

default_dish_ratio = 0.5;

module dish (size, dish_ratio=default_dish_ratio) {
  width = size[0];
  length = size[1];
  height = size[2];

  r_width = width - $rounding * 2;
  r_length = length - $rounding * 2;
  r_height = height - $rounding * 2;
  cube_ratio = 1 - dish_ratio;

  radius = min(r_width,r_length);

  difference() {
    translate([$rounding,$rounding,$rounding]) {
      minkowski() {
        hull() {
          translate([0,0,height * dish_ratio - $rounding]) {
            cube([r_width,r_length,height * cube_ratio]);
          }
          translate([r_width/2,r_length/2,height * dish_ratio / 2]) {
            resize([r_width,r_length,height * dish_ratio]) {
              sphere(radius);
            }
          }
        }
        sphere($rounding);
      }
    }

    translate([-$bleed,-$bleed,height]) {
      cube([
        width + $bleed * 2,
        length + $bleed * 2,
        $rounding + $bleed
      ]);
    }
  }
}
