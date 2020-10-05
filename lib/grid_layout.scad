include <./util_functions.scad>

$wall_thickness = 2;

function total_wall_size(count = 1) = (count + 1) * $wall_thickness;

function usable_size(size, count = 1) = size - total_wall_size(count);

function item_size(size, count = 1, i = 0) = usable_size(size, count) / count;

function axis_offset(v, i) = take_sum(v, i) + $wall_thickness * i;

// Get the offset to place the item at the given grid position
function grid_offset(grid, pos) = [
  axis_offset(grid[0], pos[0] ? pos[0] : 0), 
  axis_offset(grid[1], pos[1] ? pos[1] : 0), 
  axis_offset(grid[2], pos[2] ? pos[2] : 0), 
];

// Get the size of the item at given grid position
function grid_size(grid, pos) = [
  grid[0][pos[0] ? pos[0]: 0],
  grid[1][pos[1] ? pos[1]: 0],
  grid[2][pos[2] ? pos[2]: 0],
];

// Make an evenly split grid
function make_even_grid(size, cols, rows) = [
  [for (i=[0:cols-1]) item_size(size[0], cols)],
  [for (i=[0:rows-1]) item_size(size[1], rows)],
  [size[2]],
];

// TODO items that take 100% of an axis wont ever have a value
// totally unable to handle differing rows / columns
// revert to lower level functions for manual placements
