include <../lib/primitive/trapezoid.scad>
include <../lib/util/elephant_foot_compensation.scad>

size = [
  20,
  20,
  3
];

difference() {
  trapezoid_prism(size, 2);
  elephant_foot_compensation(size);
}
