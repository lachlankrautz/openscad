$fn = 50;
$bleed = 0.01;

module hemisphere(radius, bottom=true, centre=false) {
  cube_size = [radius * 2, radius * 2, radius];

  _rotation = bottom
    ? 0
    : 180;

  _centre_offset = centre
    ? 0
    : radius;

  translate([_centre_offset, _centre_offset, _centre_offset]) {
    rotate([_rotation, 0, 0]) {
      difference() {
        sphere(radius);
        translate([-radius, -radius, 0]) {
          cube(cube_size);
        }
      }
    }
  }
}
