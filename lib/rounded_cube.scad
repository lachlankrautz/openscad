$bleed = 1;
$rounding = 3;

module rounded_cube(size) {
  width = size[0] - $rounding * 2;
  length = size[1] - $rounding * 2;
  height = size[2] - $rounding * 2;

  minkowski() {
    translate([$rounding, $rounding, $rounding]) {
      cube([width, length, height]);
    }
    sphere($rounding);
  }
}
