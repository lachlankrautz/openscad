include <../../../lib/primitive/rounded_cube.scad>
include <../../../lib/compound/tile_stack.scad>
include <../../../lib/layout/grid_utils.scad>
include <../../../lib/lid/dovetail_lid.scad>
include <./../marketing-config.scad>

$fn = 50;

test_box_size = [
  padded_list_length([
    tile_sizes[4][0],
  ]),
  padded_list_length([
    tile_sizes[1][1],
    tile_sizes[4][1],
  ]),
  stack_height(square_size[2], 2, top_padding) + $wall_thickness * 2 + $lid_height,
];

test_tile_map = [
  [1, 4],
  // [1],
];

test_tile_size_map = [for(x=[0:len(test_tile_map)-1]) [for(y=[0:len(test_tile_map[x])-1]) tile_sizes[test_tile_map[x][y]]]];

difference() {
  rounded_cube(test_box_size, flat_top=true, $rounding=1);
  translate([$wall_thickness, 0]) {
    for (x=[0:len(test_tile_map)-1]) {
      for (y=[0:len(test_tile_map[x])-1]) {
        translate([
          padded_offset(tile_sizes[4][0], x)
            + align_x(x, test_tile_size_map[x][y][0]),
          reverse_padded_list_offset(test_box_size[1], test_tile_size_map[x], y, 1),
          0,
        ]) {
          tile_cutout_with_slant(test_tile_size_map[x][y], test_box_size[2]);
          tile_cutout_with_slant(tile_sizes[1], test_box_size[2] - square_size[2]);
        }
      }
    }
  }
  dovetail_lid_cutout(test_box_size);

  inset = 5;
  translate([inset + $wall_thickness, 0, test_box_size[2] - $lid_height]) {
    cube([
      square_size[0] - inset + $padding * 2,
      test_box_size[1],
      $lid_height+$bleed
    ]);
  }
}
