include <../lib/primitive/scoop.scad>

dimensions = [40, 30, 20];

scoop(dimensions);

translate([dimensions[0] + 10, 0, 0]) {
  scoop(dimensions, rounded=false);
}
