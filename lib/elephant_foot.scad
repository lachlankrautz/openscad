include <./rounded_cube.scad>
include <./square_torus.scad>

$rounding = 3;
$bleed = 1;

module legacy_square_torus(size, flat_top=false, flat_bottom=false) {
  cutout_girth = $rounding * 2 + 10;

  cutout_width = size[0] + $rounding * 2;
  cutout_length = size[1] + $rounding * 2;

  cutout_top_height = flat_top 
    ? $rounding + $bleed 
    : 0;
  cutout_bottom_height = flat_bottom 
    ? $rounding + $bleed 
    : 0;

  cutout_height = size[2] + cutout_top_height + cutout_bottom_height;

  cutout_height_offset = 0;

  union() {
    // Bottom
    translate([-$rounding, -(cutout_girth - $rounding), cutout_height_offset]) {
        rounded_cube([cutout_width, cutout_girth, cutout_height]);
    }
    // Left
    translate([-(cutout_girth - $rounding), -$rounding, cutout_height_offset]) {
      rounded_cube([cutout_girth, cutout_length, cutout_height]);
    }
    // Top 
    translate([-$rounding, size[1] - $rounding, cutout_height_offset]) {
      rounded_cube([cutout_width, cutout_girth, cutout_height]);
    }
    // Right
    translate([size[0] - $rounding, -$rounding, cutout_height_offset]) {
      rounded_cube([cutout_girth, cutout_length, cutout_height]);
    }
    // Bottom left corner
    translate([$rounding*2, $rounding*2, cutout_height_offset]) {
      rotate(180) {
        rounded_corner([cutout_girth, cutout_height]);
      }
    }
    // Bottom right corner
    translate([size[0] - $rounding*2, $rounding*2, cutout_height_offset]) {
      rotate(270) {
        rounded_corner([cutout_girth, cutout_height]);
      }
    }
    // Top left corner
    translate([$rounding*2, size[1] - $rounding*2, cutout_height_offset]) {
      rotate(90) {
        rounded_corner([cutout_girth, cutout_height]);
      }
    }
    // Top right corner
    translate([size[0] - $rounding*2, size[1] - $rounding*2, cutout_height_offset]) {
      rounded_corner([cutout_girth, cutout_height]);
    }
  }
}

module delgate_square_torus(size, flat_top=false, flat_bottom=false) {
  legacy_square_torus(size, flat_top=flat_top, flat_bottom=flat_bottom);
  // square_torus(size, 10, flat_top=flat_top, flat_bottom=flat_bottom);
}

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

  cutout_bottom_height = flat_bottom 
    ? $rounding + $bleed 
    : 0;

  cutout_height_offset = 0 - cutout_bottom_height;
  
  difference(){
    rounded_cube(size, flat=true);
    translate([0, 0, cutout_height_offset]) {
      delgate_square_torus(size, flat_top=flat_top, flat_bottom=flat_bottom);
    }
  }
}
