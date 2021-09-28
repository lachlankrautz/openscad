include <../orientation.scad>
include <../dovetail_lid.scad>

size = [
  20,
  80,
  2,
];

for(i=[0:3]) {
  o_size = orientation_size(size, i);

  translate([0, 0, 5 * i]) {
    orientation(size, i) {
      // cube(o_size);

      /*
      translate([0, 0, 5]) linear_extrude(5) {
        polygon([
          [0, 0],
          [0, o_size[1]],
          [o_size[0], o_size[1]],
        ]);
      }
      */

    }
    dovetail_lid_cutout(o_size, i);
  }
}
