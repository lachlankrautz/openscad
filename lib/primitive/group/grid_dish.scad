include <../dish.scad>
include <../../layout/grid_layout.scad>
include <../../config/constants.scad>

module grid_dish(grid, pos) {
  translate(grid_offset(grid, pos)) {
    dish(grid_size(grid, pos));
  }
}
