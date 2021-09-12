include <../orientation.scad>
include <../dovetail_lid.scad>

size = [
  140.5,
  125,
  29
];

for(i=[0:3]) {
  o_size = orientation_size(size, i);

  translate([0, 0, 10 * i]) {
    orientation(size, i) {
      cube(o_size);
    }
  }
}
