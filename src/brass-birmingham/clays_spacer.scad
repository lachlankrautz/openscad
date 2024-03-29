include <../../lib/primitive/rounded_cube.scad>

length = 54;
width = 103;
height = 20;

lip_length = 30;
lip_width = 20;

rounded_cube([length, width, height], flat_top=true, flat_bottom=true);

translate([length - $rounding * 2 - $bleed, width-lip_width, 0]) {
  rounded_cube([lip_length + $rounding * 2 + $bleed, lip_width, height], flat_top=true, flat_bottom=true);
}
