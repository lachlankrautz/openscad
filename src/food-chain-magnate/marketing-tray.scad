include <../../lib/primitive/rounded_cube.scad>
include <../../lib/compound/tile_stack.scad>
include <../../lib/layout/grid_utils.scad>

square_size = [
  5,
  5,
  2.2,
];

function tile_size(x = 1, y = 1) = [
  square_size[0] * x,
  square_size[1] * y,
  square_size[2],
];

function align_x(x, width) = x == 0
  ? 0
  : virtual_col_widths[x] - width;

tile_sizes = [
  undef, // Skip 0 so indexes match printed tile numbers
  tile_size(),
  tile_size(),
  tile_size(),
  tile_size(2),
  tile_size(3, 2),
  tile_size(5, 2),
  tile_size(2, 2),
  tile_size(2, 2),
  tile_size(),
  tile_size(),
  tile_size(3, 2),
  tile_size(2, 2),
  tile_size(3),
  tile_size(2),
  tile_size(),
  tile_size(),
];

tile_map = [
  [1, 2, 3, 4, 5, 6],
  [7, 8, 9, 10],
  [11, 12, 13, 14, 15, 16],
];

tile_size_map = [for(x=[0:len(tile_map)-1]) [for(y=[0:len(tile_map[x])-1]) tile_sizes[tile_map[x][y]]]];

virtual_col_widths = [
  tile_sizes[4][0],
  tile_sizes[7][0],
  tile_sizes[11][0],
];

box_size = [
  padded_list_length([
    tile_sizes[4][0],
    tile_sizes[7][0],
    tile_sizes[11][0]
  ]),
  padded_list_length([
    tile_sizes[1][1],
    tile_sizes[2][1],
    tile_sizes[3][1],
    tile_sizes[4][1],
    tile_sizes[5][1],
    tile_sizes[6][1]
  ]),
  square_size[2] * 2 + $wall_thickness,
];

difference() {
  rounded_cube(box_size, flat_top=true, $rounding=1);
  translate([$wall_thickness, 0]) {
    for (x=[0:len(tile_map)-1]) {
      for (y=[0:len(tile_map[x])-1]) {
        translate([
          padded_offset(tile_sizes[4][0], x)
            + align_x(x, tile_size_map[x][y][0]),
          reverse_padded_list_offset(box_size[1], tile_size_map[x], y, 1),
          0,
        ]) {
          tile_stack(
            tile_size_map[x][y],
            1,
            box_size[2],
            left_cutout=false,
            right_cutout=false,
            top_cutout=false,
            bottom_cutout=false
          );
        }
      }
    }
  }
}
