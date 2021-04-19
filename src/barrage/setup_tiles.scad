echo(version=version());

include <../../lib/rounded_cube.scad>
include <../../lib/layout.scad>
include <../../lib/tile_tray.scad>
include <../../lib/util_functions.scad>

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
  tile_stack_height(water_tile_size, max_stack_count) + $wall_thickness,
];

difference() {
  rounded_cube(box_size, flat_top=true, $rounding=2);

  translate([$wall_thickness, $wall_thickness, 0]) {
    tile_cutout(
      end_goal_tile_size, 
      end_goal_tile_stack, 
      roof_height=box_size[2],
      top_cutout=true,
      bottom_cutout=true
    );
  }

  translate([padded_offset(end_goal_tile_size[0]) + $wall_thickness, $wall_thickness, 0]) {
    tile_cutout(
      round_goal_tile_size, 
      round_goal_tile_map[1], 
      roof_height=box_size[2],
      bottom_cutout=true
    );
  }

  translate([
    padded_offset(end_goal_tile_size[0]) + $wall_thickness, 
    box_size[1] - padded_offset(round_goal_tile_size[1]), 
    0
  ]) {
    tile_cutout(
      round_goal_tile_size, 
      round_goal_tile_map[0], 
      roof_height=box_size[2],
      top_cutout=true
    );
  }

  translate([
    padded_offset(end_goal_tile_size[0]) + padded_offset(round_goal_tile_size[0]) + $wall_thickness,
    $wall_thickness,
    0,
  ]) {
    tile_cutout(
      water_tile_size,
      water_tile_stack,
      roof_height=box_size[2],
      top_cutout=true,
      bottom_cutout=true
    );
  }
}
