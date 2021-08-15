echo(version=version());

include <../../lib/rounded_cube.scad>

length = 94;
width = 72;
height = 19;

rounded_cube([length, width, height], flat_top=true, flat_bottom=true);
