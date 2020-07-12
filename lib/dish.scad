$rounding = 3;
$bleed = 1;

module dish (size) {
  width = size[0];
  length = size[1];
  height = size[2];

  r_width = width - $rounding * 2;
  r_length = length - $rounding * 2;
  r_height = height - $rounding * 2;

  radius = min(r_width,r_length);

  difference() {
    translate([$rounding,$rounding,$rounding]) {
      minkowski() {
        hull() {
          translate([0,0,r_height/2]) {
            cube([r_width,r_length,height/2]);
          }
          translate([r_width/2,r_length/2,height/4]) {
            resize([r_width,r_length,height/2]) {
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
