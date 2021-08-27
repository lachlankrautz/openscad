include <./scoop.scad>
include <./grid_layout.scad>

module grid_scoop(grid, pos, radius = 0, rounded=true) {
  translate(grid_offset(grid, pos)) {
    scoop(grid_size(grid, pos), radius, rounded=rounded);
  }
}
