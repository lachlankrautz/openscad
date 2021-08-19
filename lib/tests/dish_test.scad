include <../../lib/dish.scad>

dish([40, 30, 20]);

translate([50, 0, 0]) {
  dish([40, 30, 20], 0.9);
}
