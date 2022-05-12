include <../../../lib/util/util_functions.scad>

function box_size(tile_size, matrix, matrix_counts) = [
  padded_offset(tile_size[0], len(matrix)) + $wall_thickness,
  padded_offset(tile_size[1], len(matrix[0])) + $wall_thickness,
  stack_height(tile_size[2], max(flatten(matrix_counts))) + $wall_thickness + $lid_height,
];
