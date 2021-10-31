include <../../lib/primitive/rounded_cube.scad>
include <../../lib/layout/layout.scad>
include <../../lib/compound/notched_cube.scad>
include <../../lib/compound/tile_stack.scad>
include <../../lib/util/util_functions.scad>

// Config
$fn = 50;
// $fn = 10;

tile_thickness = 1.64;

end_goal_tile_size = [
  35,
  70,
  tile_thickness,
];
end_goal_tile_stack = 6;

round_goal_tile_size = [
  30,
  30,
  tile_thickness,
];

round_goal_tile_map = [
  6, 
  2,
];

water_tile_size = [
  40,
  70,
  tile_thickness,
];
water_tile_stack = 8;

max_stack_count = water_tile_stack;

box_size = [
  padded_offset(end_goal_tile_size[0]) 
    + padded_offset(round_goal_tile_size[0]) 
    + padded_offset(water_tile_size[0]) 
    + $wall_thickness,
  padded_offset(end_goal_tile_size[1]) + $wall_thickness,
  stack_height(water_tile_size[2], max_stack_count) + $wall_thickness,
];

difference() {
  rounded_cube(box_size, flat_top=true, $rounding=2);

  translate([$wall_thickness, $wall_thickness, 0]) {
    tile_stack(
      end_goal_tile_size, 
      end_goal_tile_stack, 
      box_size[2],
      top_cutout=true,
      bottom_cutout=true
    );
  }

  translate([padded_offset(end_goal_tile_size[0]) + $wall_thickness, $wall_thickness, 0]) {
    tile_stack(
      round_goal_tile_size, 
      round_goal_tile_map[1], 
      box_size[2],
      bottom_cutout=true
    );
  }

  translate([
    padded_offset(end_goal_tile_size[0]) + $wall_thickness, 
    box_size[1] - padded_offset(round_goal_tile_size[1]), 
    0
  ]) {
    tile_stack(
      round_goal_tile_size, 
      round_goal_tile_map[0], 
      box_size[2],
      top_cutout=true
    );
  }

  translate([
    padded_offset(end_goal_tile_size[0]) + padded_offset(round_goal_tile_size[0]) + $wall_thickness,
    $wall_thickness,
    0,
  ]) {
    tile_stack(
      water_tile_size,
      water_tile_stack,
      box_size[2],
      top_cutout=true,
      bottom_cutout=true
    );
  }
}
