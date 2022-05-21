include <../layout/layout.scad>

function spaced_offset(length, index, spacing) = (length + spacing) * index;

function inset_size(size, inset = 0, height = 0) = [
  pad(size[0] - inset * 2),
  pad(size[1] - inset * 2),
  height
];

module square_pattern(matrix, height, inset = 0, spacing = 0) {
  for (x=[0:len(matrix)-1]) {
    for (y=[0:len(matrix[x])-1]) {
      translate([
        spaced_offset(pad(matrix[x][y][0]), x, spacing) + inset,
        spaced_offset(pad(matrix[x][y][1]), y, spacing) + inset,
        0
      ]) {
        cube(inset_size(matrix[x][y], inset, height));
      }
    }
  }
}

module square_pattern_to_cut(matrix, height, inset, spacing) {
  translate([0, 0, - $bleed]) {
    square_pattern(matrix, height + $bleed * 2, inset, spacing);
  }
}
