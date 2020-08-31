include <./rounded_cube.scad>
include <./square_torus.scad>

$rounding = 3;
$bleed = 1;

module elephant_foot(
  size, 
  flat_top=false, 
  flat_bottom=false,
  rounded_top=false,
  rounded_bottom=false
) {
  foot_top = !(flat_top || rounded_top);
  foot_bottom = !(flat_bottom || rounded_bottom);
  assert(foot_top || foot_bottom, "Elephan foot can only have flat/rounded top or bottom not both");

  girth = ($rounding + $bleed) * 2;

  torus_size = [
    size[0] + girth + $rounding - $bleed,
    size[1] + girth + $rounding - $bleed,
    $rounding + $bleed
  ];
  torus_offset = [
    0 - (torus_size[0] - size[0]) / 2,
    0 - (torus_size[1] - size[1]) / 2,
  ];

  foot_size = [
    size[0],
    size[1],
    $rounding
  ];

  foot_top_height = foot_top ? foot_size[2] : 0;
  foot_bottom_height = foot_bottom ? foot_size[2] : 0;

  inner_size = [
    size[0] - $rounding * 2,
    size[1] - $rounding * 2,
    size[2] - foot_top_height - foot_bottom_height,
  ];

  union() {
    if (foot_bottom) {
      difference() {
        rounded_cube(foot_size, flat=true);
        translate(torus_offset) {
          square_torus(torus_size, girth, flat_top=true);
        }
      }
    }

    translate([$rounding, $rounding, foot_bottom_height]) {
      rounded_cube(inner_size, flat_top=flat_top || foot_top, flat_bottom=flat_bottom || foot_bottom);
    }

    if (foot_top) {
      translate([0, 0, inner_size[2] + foot_bottom_height]) {
        difference() {
          translate([0, 0, 0]) rounded_cube(foot_size, flat=true);
          translate([torus_offset[0], torus_offset[1], -$bleed]) {
            square_torus(torus_size, girth, flat_bottom=true);
          }
        }
      }
    }
  }
}
