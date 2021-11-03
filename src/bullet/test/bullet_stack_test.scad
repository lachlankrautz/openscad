include <../../../lib/config/token_sizes.scad>
include <../../../lib/layout/layout.scad>
include <../../../lib/primitive/rounded_cube.scad>
include <../../../lib/compound/tile_stack.scad>
include <../../../lib/compound/tile_stack_round.scad>
include <../../../lib/lid/dovetail_lid.scad>
include <./../config.scad>

$fn = 50;

echo("rounding: ", $rounding);

test_box_size = [
  padded_offset(bullet_diameter) + $wall_thickness,
  padded_offset(bullet_diameter) + $wall_thickness,
  stack_height(bullet_height, 2) + $wall_thickness,
];

difference() {
  rounded_cube(test_box_size, flat_top=true, $rounding=1);

  translate([$wall_thickness, $wall_thickness, 0]) {
    tile_stack_round(
      bullet_diameter,
      bullet_height,
      2,
      test_box_size[2],
      top_cutout=true
    );
  }
}
