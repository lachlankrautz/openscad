include <../compound/notched_cube.scad>
include <../primitive/scoop.scad>
include <../layout/grid_layout.scad>
include <../config/constants.scad>

module scoop_matrix(tray_size, matrix=[1, 1], radius=0, rounded=false) {
  scoop_size = [
    item_size(tray_size[0], matrix[0]),
    item_size(tray_size[1], matrix[1]),
    tray_size[2] - $wall_thickness + $bleed,
  ];

  translate([$wall_thickness, $wall_thickness, $wall_thickness]) {
    for(i=[0:matrix[0]-1]) {
      for(j=[0:matrix[1]-1]) {
        translate([
          offset(scoop_size[0], i),
          offset(scoop_size[1], j),
          0
        ]) {
          scoop(scoop_size, radius, rounded=rounded);
        }
      }
    }
  }
}

/**
 * @param tray_size [x, y, z]
 * @param matrix [x, y] how many scoop divisions on each axis
 */
module scoop_tray(tray_size, matrix=[1, 1], radius=0, rounded=false) {
  difference() {
    rounded_cube(tray_size, flat_top=true, $rounding=1);
    scoop_matrix(tray_size, matrix, radius=radius, rounded=rounded);
  }
}
