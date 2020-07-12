include <./dish.scad>
include <./layout.scad>

module grid_dish(grid, pos) {
  translate(grid_offset(grid, pos)) {
    dish(grid_size(grid, pos));
  }
}
