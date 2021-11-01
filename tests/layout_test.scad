include <../lib/layout/grid_layout.scad>

grid_2d = [
  [5, 10, 15],
  [20, 20],
  // deliberately omit 'z'
];
assert(grid_offset(grid_2d, [1, 1, 0]) == [7, 22, 0]);
assert(grid_offset(grid_2d, [1, 1, 0], $wall_thickness=3) == [8, 23, 0]);
assert(grid_offset(grid_2d, [2, 2, 0]) == [19, 44, 0]);

grid = [
  [5, 10, 15],
  [20, 20],
  [7],
];
assert(grid_offset(grid, [1, 1]) == [7, 22, 0]);
assert(grid_offset(grid, [1, 1, 0], $wall_thickness=3) == [8, 23, 0]);
assert(grid_size(grid, [1, 1, 0]) == [10, 20, 7]);
