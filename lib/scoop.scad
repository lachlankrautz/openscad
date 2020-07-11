include <./rounded_cube.scad>

$bleed = 1;
$rounding = 3;
$wall_thickness = 2;

module cylinder_quarter(height, radius) {
  cube_size = (radius + $bleed) * 2;
  cube_height = height + $bleed * 2;
  half_cube_size = cube_size / 2;

  difference() {
    cylinder(height, r=radius);

    translate([0, -half_cube_size, -$bleed]) {
      cube([cube_size, cube_size, cube_height]);
    }
    translate([-half_cube_size, -cube_size, -$bleed]) {
      cube([cube_size, cube_size, cube_height]);
    }
  }
}

module scoop(width, length, height, radius = 0) {
  min_radius = min(
    (radius ? radius : (height - $rounding)), 
    10 / 2
  );
  cube_length = length - $rounding * 2;
  cube_width = width - min_radius - $rounding * 2;
  cube_height = height - $rounding * 2;

  translate([0, 0, $wall_thickness]) {
    difference() {
      translate([$rounding, $rounding, $rounding]) {
        // minkowski() {
          translate([min_radius, 0, 0]) {
            hull() {
              // translate([cube_width - 1, 0, 0]) cube([1, cube_length, cube_height + $bleed]);
              translate([0, 0, cube_height - 1]) cube([width, cube_length, 1]);
              translate([0, 0, min_radius]) rotate([-90, 0, 0]) {
                  cylinder_quarter(cube_length, min_radius);
              }
            }
          }
          // sphere($rounding);
        // }
      }

      translate([-$bleed, -$bleed, height]) {
        cube([
            width + $rounding + $bleed * 2, 
            length + $rounding + $bleed * 2, 
            radius + $rounding + $bleed * 2
        ]);
      }
    }
  }
}

// debug scoop
scoop(30, 20, 30, $fn = 20);
// cylinder_quarter(10, 20);