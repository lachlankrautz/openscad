include <./config.scad>

module tile_cutout_with_slant(size, box_height) {
  tile_stack(
    size,
    1,
    box_height,
    left_cutout = false,
    right_cutout = false,
    top_cutout = false,
    bottom_cutout = false,
    lid_height=$lid_height
  );

  padded_size = padded_rect(size);
  tile_cutout_height = 2.5;

  translate([0, 0, box_height - size[2] - $lid_height - tile_cutout_height]) {
    linear_extrude(tile_cutout_height + $bleed) {
      rounded_square([
        padded_size[0],
        tile_sizes[1][1] / 3,
      ], flat_top=true, $rounding=1);
    }
  }
}

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
  [7, 8, 9],
  [10],
  [11, 12, 13],
  [14, 15, 16, 6],
  [4, 5],
  [1, 2, 3],
];

tile_size_map = [for(x=[0:len(tile_map)-1]) [for(y=[0:len(tile_map[x])-1]) tile_sizes[tile_map[x][y]]]];

virtual_col_widths = [
  tile_sizes[9][0],
  tile_sizes[10][0],
  tile_sizes[11][0],
  tile_sizes[14][0],
  tile_sizes[4][0],
  tile_sizes[1][0],
];

box_size = [
  padded_list_length([
    tile_sizes[7][0],
    tile_sizes[11][0],
    tile_sizes[14][0],
    tile_sizes[4][0],
    tile_sizes[1][0],
  ]),
  padded_list_length([
    tile_sizes[1][1],
    tile_sizes[2][1],
    tile_sizes[3][1],
    tile_sizes[6][1],
  ]),
  stack_height(square_size[2], 2) + $wall_thickness * 2 + $lid_height,
];
