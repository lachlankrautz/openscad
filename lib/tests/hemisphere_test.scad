include <../../lib/hemisphere.scad>

hemisphere(10, centre=true);
hemisphere(10, bottom=false, centre=true);

translate([20, 0, 0]) {
  hemisphere(10);
  hemisphere(10, bottom=false);
}
