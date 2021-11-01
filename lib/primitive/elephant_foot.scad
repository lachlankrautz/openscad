include <./rounded_cube.scad>
include <./square_torus.scad>
include <../config/constants.scad>

// TODO investigate poor performance

// TODO use bleed_top|bottom help with differencing a foot
module elephant_foot(
  size, 
  flat_top=false, 
  flat_bottom=false,
  rounded_top=false,
  rounded_bottom=false,
  use_bleed=false
) {
  foot_top = !(flat_top || rounded_top);
  foot_bottom = !(flat_bottom || rounded_bottom);
  assert(foot_top || foot_bottom, "Foot can only have flat/rounded top or bottom not both");

  girth = ($rounding + $bleed) * 2;

  torus_size = [
    size[0] + (girth - $rounding) * 2,
    size[1] + (girth - $rounding) * 2,
    $rounding + $bleed
  ];

  torus_offset = [
    0 - (torus_size[0] - size[0]) / 2,
    0 - (torus_size[1] - size[1]) / 2,
  ];

  foot_size = [
    size[0],
    size[1],
    $rounding + (use_bleed ? $bleed: 0)
  ];

  foot_top_height = foot_top ? $rounding : 0;
  foot_bottom_height = foot_bottom ? $rounding : 0;

  inner_size = [
    size[0] - $rounding * 2,
    size[1] - $rounding * 2,
    size[2] - max(0, foot_top_height -1) - max(0, foot_bottom_height - 1),
  ];

  union() {
    if (foot_bottom) {
      difference() {
        translate([0, 0, 0 - (use_bleed && foot_bottom ? $bleed: 0)]) {
          rounded_cube(foot_size, flat=true);
        }
        translate(torus_offset) {
          square_torus(torus_size, girth, flat_top=true);
        }
      }
    }

    translate([$rounding, $rounding, foot_bottom_height]) {
      rounded_cube(
        inner_size, 
        flat_top=flat_top || foot_top, 
        flat_bottom=flat_bottom || foot_bottom
      );
    }

    if (foot_top) {
      translate([0, 0, inner_size[2] - 1 + foot_bottom_height]) {
        difference() {
          rounded_cube(foot_size, flat=true);
          translate([torus_offset[0], torus_offset[1], -$bleed]) {
            square_torus(torus_size, girth, flat_bottom=true);
          }
        }
      }
    }
  }
}
