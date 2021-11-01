include <../../lib/primitive/rounded_cube.scad>

length = 65;
width = 81;
height = 30.5;

rounded_cube([length, width, height], flat_top=true, flat_bottom=true);
