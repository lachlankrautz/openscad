include <./rounded_cube.scad>
include <./rounded_square.scad>

$rounding = 3;
$bleed = 1;

module rounded_corner(size, flat_top=false, flat_bottom=false) {
  rotate_extrude(angle=90) {
    translate([$rounding, 0, 0]) {
      rounded_square(size, flat_top=flat_top, flat_bottom=flat_bottom);
    }
  }
}

module square_torus(size, girth, flat_top=false, flat_bottom=false) {
  shaft_size = [
    size[0] - ($rounding + girth) * 2,
    size[1] - ($rounding + girth) * 2,
    size[2] - $rounding * 2 ,
  ];

  union() {
    // Bottom
    translate([girth + $rounding, 0, 0]) {
      rotate(a=[90, 0, 90]) {
        linear_extrude(shaft_size[0]) {
          rounded_square([girth, size[2]], flat_top=flat_top, flat_bottom=flat_bottom);
        }
      }
    }
    // Left
    translate([0, shaft_size[1] + girth + $rounding, 0]) {
      rotate(a=[90, 0, 0]) {
        linear_extrude(shaft_size[0]) {
          rounded_square([girth, size[2]], flat_top=flat_top, flat_bottom=flat_bottom);
        }
      }
    }
    // Top 
    translate([girth + $rounding, shaft_size[1] + girth + $rounding * 2, 0]) {
      rotate(a=[90, 0, 90]) {
        linear_extrude(shaft_size[0]) {
          rounded_square([girth, size[2]], flat_top=flat_top, flat_bottom=flat_bottom);
        }
      }
    }
    // Right
    translate([shaft_size[0] + girth + $rounding * 2, shaft_size[1] + girth + $rounding, 0]) {
      rotate(a=[90, 0, 0]) {
        linear_extrude(shaft_size[0]) {
          rounded_square([girth, size[2]], flat_top=flat_top, flat_bottom=flat_bottom);
        }
      }
    }

    translate([girth + $rounding, girth + $rounding, 0]) {
      // Bottom left corner
      rotate(180) {
        rounded_corner([girth, size[2]], flat_top=flat_top, flat_bottom=flat_bottom);
      }
      // Bottom right corner
      translate([shaft_size[0], 0, 0]) {
        rotate(270) {
          rounded_corner([girth, size[2]], flat_top=flat_top, flat_bottom=flat_bottom);
        }
      }
      // Top left corner
      translate([0, shaft_size[1], 0]) {
        rotate(90) {
          rounded_corner([girth, size[2]], flat_top=flat_top, flat_bottom=flat_bottom);
        }
      }
      // Top right corner
      translate([shaft_size[0], shaft_size[1], 0]) {
        rounded_corner([girth, size[2]], flat_top=flat_top, flat_bottom=flat_bottom);
      }
    }
  } 
}
