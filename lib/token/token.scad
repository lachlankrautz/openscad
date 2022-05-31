include <../../lib/primitive/rounded_cube.scad>
include <../../lib/util/elephant_foot_compensation.scad>

$fn = 50;

module token(size, foot_offset=default_foot_offset) {
  difference() {
    rounded_cube(size, flat=true, $rounding=1);

    elephant_foot_compensation(size, foot_offset);
  }
}
