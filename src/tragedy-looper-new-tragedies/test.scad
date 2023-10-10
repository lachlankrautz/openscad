grid = [
  [ [0, 0], [2, 2], [2, 2] ],
  [ [0, 0], [2, 2], [2, 2] ],
  [ [0, 0], [2, 2], [2, 2] ],
  [ [0, 0], [2, 2], [2, 2] ],
  [ [0, 0], [2, 2]  ],
];

function grid_max_column_size(matrix) = max([for(x=[0:len(matrix)-1]) len(matrix[x])]);

// Return a single row from a grid
function grid_row(grid, row) = [for(i=[0:len(grid)-1]) grid[i][row]];

module print_grid(grid) {
  max_y = grid_max_column_size(grid);
  for(i=[max_y-1:-1:0]) {
    echo(i, grid_row(grid, i));
  }
  echo("");
}

module print_grid_code_orientation(grid) {
  for(x=[0:len(grid)-1]) {
    echo(grid[x]);
  }
  echo("");
}

print_grid(grid);
print_grid_code_orientation(grid);
