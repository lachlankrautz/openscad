echo(version=version());

include <../../lib/rounded_cube.scad>
include <../../lib/layout.scad>
include <../../lib/tile_tray.scad>

// Config
$fn = 50;
// $fn = 10;
$wall_thickness = 2;
$gap = 0.5;
$rounding = 2;
$cutout_fraction = 0.4;

// Damage
damage_tile_size = [
  38,
  38,
  2.2,
];
damage_tile_count = 6;
damage_stack_count = 3;

box_size = [
  padded_offset(damage_tile_size[0], damage_stack_count) + $wall_thickness,
  padded_offset(damage_tile_size[0]) + $wall_thickness,
  get_tile_stack_height(damage_tile_size, damage_tile_count) + $wall_thickness,
];

difference() {
  rounded_cube(box_size, flat_top=true);

  translate([$wall_thickness, $wall_thickness, 0]) {
    for(i=[0:damage_stack_count-1]) {
      translate([padded_offset(damage_tile_size[0], i), 0, 0]) {
        tile_cutout(
          damage_tile_size, 
          damage_tile_count, 
          roof_height=box_size[2],
          top_cutout=true,
          bottom_cutout=true
        );
      }
    }
  }
}
