include <../../lib/layout/flow-utils.scad>
include <../../lib/layout/grid_utils.scad>

square_matrix = [
  [[1, 1], [2, 2,], [3, 3]],
  [[4, 4], [5, 5,], [6, 6]],
  [[7, 7], [8, 8,], [9, 9]],
];

short_matrix = [
  [[1, 1], [2, 2,], [3, 3]],
  [[4, 4], [5, 5,], [6, 6]],
];

tall_matrix = [
  [[1, 1], [2, 2,]],
  [[3, 3], [4, 4,]],
  [[5, 5], [6, 6,]],
];

module test_matrix(matrix, name) {
  echo(name);
  echo("max matrix x: ", len(matrix));
  echo("max matrix y: ", matrix_max_y_len(matrix));
  row_list = row_list_from_matrix(matrix);
  print_grid(row_list);
}

test_matrix(square_matrix, "square");
test_matrix(short_matrix, "short");
test_matrix(tall_matrix, "tall");
