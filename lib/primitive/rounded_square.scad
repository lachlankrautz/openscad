$bleed = 1;
$rounding = 3;

module rounded_square(size, flat_top=false, flat_bottom=false) {
  assert(!(flat_top && flat_bottom), "Flat top and flat bottom are exclusive");

  rounding_height = flat_top || flat_bottom 
    ? $rounding 
    : $rounding * 2;

  offset = flat_bottom ? 0 : $rounding;

  inner_size = [
    size[0] - $rounding * 2,
    size[1] - rounding_height,
  ];

  minkowski() {
    translate([$rounding, offset]) {
      square(inner_size);
    }
    if (flat_top ) {
      difference() {
        circle($rounding);
        translate([-$rounding, 0]) {
          square([$rounding * 2, $rounding]);
        }
      }
    } else if (flat_bottom) {
      difference() {
        circle($rounding);
        translate([-$rounding, -$rounding]) {
          square([$rounding * 2, $rounding]);
        }
      }
    } else {
      circle($rounding);
    }
  }
}
