$bleed = 1;
$rounding = 3;

min_cylinder_height = 1;

module flat_rounded_cube(size) {
  width = size[0] - $rounding * 2;
  length = size[1] - $rounding * 2;

  // Only 1 count of min_cynlinder_height not 2;
  // cylinder does not extend the bottom because it's flush
  height = size[2] - min_cylinder_height; 

  minkowski() {
    translate([$rounding, $rounding, 0]) {
      cube([width, length, height]);
    }
    cylinder(min_cylinder_height, $rounding, $rounding);
  }
}
