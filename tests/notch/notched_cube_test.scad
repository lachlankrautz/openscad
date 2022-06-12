include <../../lib/compound/notched_cube.scad>

cube_size = [17, 17, 8];

notched_cube(cube_size, top_cutout=true, use_rounded_cube=false, notch_style="square");
