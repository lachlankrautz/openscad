include <../../lib/rounded_cube.scad>
include <../../lib/layout.scad>

$wall_thickness = 2;
$fn = 50;

// from teotibot.scad
// Player powers
player_power_count = 6;
player_power_size = [
  120,
  80,
  2.2,
];
ai_tile_size = [
  50,
  23.5,
  2.2,
];
// end

base_length = 116.5;
base_width = 36;
base_height = 16.5;

top_length = base_length;
top_width = 15.5;
top_height = 20;

front_length = 41.5;
// using length of teotibot because it is on its side
front_width = padded_offset(player_power_size[0]) + $wall_thickness + $rounding + $bleed;
front_height = stack_height(player_power_size[2], player_power_count) + $wall_thickness;

union() {
  rounded_cube([base_length, base_width, base_height], flat_top=true, flat_bottom=true, $rounding=2);

  translate([0, 0, base_height]) {
    rounded_cube([top_length, top_width, top_height], flat_top=true, flat_bottom=true, $rounding=2);
  }

  translate([0, -front_width + $rounding + $bleed, 0]) {
    rounded_cube([front_length, front_width, front_height], flat_top=true, flat_bottom=true, $rounding=2);
  }
}

