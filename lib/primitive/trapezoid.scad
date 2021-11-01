include <../config/constants.scad>

module trapezoid(size, inset) {
  polygon([
    [0, 0],
    [size[0], 0],
    [size[0] - inset, size[1]],
    [inset, size[1]],
  ]);
}

module trapezoid_prism(size, inset) {
  rotate([90, 0, 90]) {
    linear_extrude(size[0]) {
      trapezoid([size[1], size[2]], inset);
    }
  }
}
