$bleed = 0.01;

module hemisphere(radius) {
  difference() {
    sphere(radius);

    cube([radius * 2, radius * 2, radius]);
  }
}
