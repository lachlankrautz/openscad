include <./rounded_cube.scad>

$bleed = 0.1;
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

module _unrounded_scoop(size, radius) {
  width = size[0];
  length = size[1];
  height = size[2];

  min_radius = min(
    radius ? radius : height,
  height,
    width / 3
  );
  hull() {
    translate([width -1, 0, 0]) {
      cube([1, length, height]);
    }
    translate([0, 0, height - 1]) {
      cube([width, length, 1]);
    }
    translate([min_radius, 0, min_radius]) rotate([-90, 0, 0]) {
      cylinder_quarter(length, min_radius);
    }
  }
}

module scoop(size, radius = 0, rounded=true) {
  min_radius = min(
    radius ? radius : size[2],
    size[2],
    size[0] / 3
  );

  unrounded_size = [
    size[0] - $rounding * 2,
    size[1] - $rounding * 2,
    size[2] - $rounding,
  ];

  if (rounded) {
    difference() {
      translate([$rounding, $rounding, $rounding]) {
        minkowski() {
          _unrounded_scoop(unrounded_size, radius);

          // round with a sphere
          sphere($rounding);
        }
      }

      // slice off the top
      translate([-$bleed, -$bleed, size[2]]) {
        cube([
          size[0] + $bleed * 2,
          size[1] + $bleed * 2,
          $rounding +  $bleed * 2
        ]);
      }
    }
  } else {
    _unrounded_scoop(size, radius);
  }
}
