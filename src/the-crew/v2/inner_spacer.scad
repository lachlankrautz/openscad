include <../config/game_data.scad>
include <../../../lib/primitive/rounded_cube.scad>

$fn = 50;

length = 38.5;
width = box_inner_width;
height = 10;

rounded_cube([width - 2, length, height], flat=true, $rounding=2);
