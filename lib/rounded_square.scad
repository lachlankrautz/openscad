$bleed = 1;
$rounding = 3;

module rounded_square(size) {
  inner_size = [
    size[0] - $rounding * 2,
    size[1] - $rounding * 2,
  ];

  minkowski() {
    translate([$rounding, $rounding, 0]) {
      square(inner_size);
    }
    circle($rounding);
  }
}
