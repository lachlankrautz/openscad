$bleed = 1;
$rounding = 3;

module rounded_cube(width, length, height) {
  r_length = length-$rounding*2;
  r_width = width-$rounding*2;
  r_height = height-$rounding*2;

  minkowski() {
    translate([$rounding, $rounding, $rounding]) {
      cube([r_width, r_length, r_height]);
    }
    sphere($rounding);
  }
}
