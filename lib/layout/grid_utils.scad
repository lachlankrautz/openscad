include <../util/util_functions.scad>
include <./flow-utils.scad>
include <../config/constants.scad>

// DEPENDS ON:
// - $padding
// - $wall_thickness

// Grids neatly align x and y all rows or columns are offset to the size of the
// largest item in the row or column. Grids are not space efficient.

function padded_list_offset(list, index, key) = index == 0 ? 0 : sum_to(list, index-1, key)
  + ($padding * 2 + $wall_thickness) * index;

function reverse_padded_list_offset(length, list, index, key) = length - (sum_to(list, index, key)
  + ($padding * 2 + $wall_thickness) * (index+1));

function padded_grid(matrix) = add_grid_xy(matrix, [$padding * 2, $padding * 2]);

function sum_to(list, index, key) = sum(slice_to(pick_list(list, key), index));

/**
 * Make a grid with the given rows and columns all filled with the same item.
 */
function make_grid_of(matrix, item) = [for(x=[0:matrix[0]-1]) [for(y=[0:matrix[1]-1]) item]];

// Return a single row from a grid
function grid_row(grid, row) = [for(i=[0:len(grid)-1]) grid[i][row]];

// Map to just the given index of a list of arrays
//
// list = [
//   [1, 2],
//   [3, 4],
// ];
// pick_list(list, 0) -> [1, 3]
// pick_list(list, 1) -> [2, 4]
function pick_list(list, index) = [for(i=[0:len(list)-1]) list[i][index]];

// Map to just the given index of a grid row
//
// grid = [
//   [[1, 2,], [3, 4]],
//   [[5, 6,], [7, 8]],
// ];
// pick_row(grid, 0, 1) -> [2, 6]
// pick_row(grid, 1, 0) -> [3, 7]
function pick_row(grid, row, key) = pick_list(grid_row(grid, row), key);

// Map to just the given index of a grid column
//
// grid = [
//   [[1, 2,], [3, 4]],
//   [[5, 6,], [7, 8]],
// ];
// pick_col(grid, 0, 1) -> [2, 4]
// pick_col(grid, 1, 0) -> [5, 7]
function pick_col(grid, col, key) = pick_list(grid[col], key);

function pick_grid(grid, key) = [for(i=[0:len(grid)-1]) for(j=[0:len(grid[i])-1]) grid[i][j][key]];

function sum_row(grid, row, key) = sum(pick_row(grid, row), key);
function sum_col(grid, col, key) = sum(pick_col(grid, col), key);

function slice_to(list, end) = [for(i=[0:end]) list[i]];
function slice_from(list, start) = [for(i=[start:len(list)-1]) list[i]];

function accumulate(list) = [for(i=[0:len(list)-1]) sum(slice_to(list, i))];

function add_grid_xy(grid, add) = [for(x=[0:len(grid)-1]) [for(y=[0:len(grid[x])-1]) [
    grid[x][y][0] + add[0],
    grid[x][y][1] + add[1],
]]];
function add_grid_xyz(grid, add) = [for(x=[0:len(grid)-1]) [for(y=[0:len(grid[x])-1]) [
    grid[x][y][0] + add[0],
    grid[x][y][1] + add[1],
    add[2],
]]];

function max_grid(grid) = [for(x=[0:len(grid)-1]) [for(y=[0:x < 0 ? 0 : len(grid[x])-1]) [
    max(pick_col(grid, x, 0)),
    max(pick_row(grid, y, 1)),
]]];

function median_grid(grid) = [for(x=[0:len(grid)-1]) [for(y=[0:x < 0 ? 0 : len(grid[x])-1]) [
  (max(pick_col(grid, x, 0)) + min(pick_col(grid, x, 0))) / 2,
  (max(pick_row(grid, y, 1)) + min(pick_row(grid, y, 1))) / 2,
]]];

function walled_grid(grid) = add_grid_xy(grid, [$wall_thickness, $wall_thickness]);

function accumulated_grid(grid) = [for(x=[-1:len(grid)-1]) [for(y=[-1:x < 0 ? matrix_max_y_len(grid)-1 : len(grid[x])-1]) [
  x < 0 ? 0 : sum([for(i=[0:x]) max(filter(pick_col(grid, i, 0)))]),
  y < 0 ? 0 : sum([for(i=[0:y]) max(filter(pick_row(grid, i, 1)))]),
]]];

function filter(list) = [for (n=[0:len(list)-1]) if (list[n] != undef) list[n]];

// TODO rename
// these grab the hightest x / y values from an accumlation grid
// they do not actually accumulate the grid
function accumulated_grid_x(grid) = grid[len(grid)-1][0][0];
function accumulated_grid_y(grid) = max(
  [for(i=[0:len(grid)-1]) grid[i][len(grid[i])-1][1]]
);
function accumulated_grid_rect(grid) = [
  accumulated_grid_x(grid),
  accumulated_grid_y(grid),
];
function accumulated_grid_cube(grid, height=0) = [
  accumulated_grid_x(grid),
  accumulated_grid_y(grid),
  height
];

module print_grid(grid) {
  max_y = matrix_max_y_len(grid);
  for(i=[max_y-1:-1:0]) {
    echo(i, grid_row(grid, i));
  }
  echo("");
}

module print_sideways_grid(grid) {
  for(x=[0:len(grid)-1]) {
    echo(grid[x]);
  }
  echo("");
}
