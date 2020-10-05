module offset_cylinder(d, h) {
  translate([d / 2, d / 2, 0]) {
    cylinder(d=d, h=h);
  }
}
