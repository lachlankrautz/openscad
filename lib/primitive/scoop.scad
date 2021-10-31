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

module _unrounded_scoop(size, radius, edge="left") {
  _size = edge == "left"
    ? size
    : [size[1], size[0], size[2]];

  rotation = edge == "left"
    ? [0, 0, 0]
    : [0, 0, 90];

  rotation_offset = edge == "left"
    ? [0, 0, 0]
    : [size[0], 0, 0];

  min_radius = min(
    radius ? radius : _size[2],
    _size[2],
    _size[0] / 3
  );

  translate(rotation_offset) {
    rotate(rotation) {
      hull() {
        translate([_size[0] -1, 0, 0]) {
          cube([1, _size[1], _size[2]]);
        }
        translate([0, 0, _size[2] - 1]) {
          cube([_size[0], _size[1], 1]);
        }
        translate([min_radius, 0, min_radius]) rotate([-90, 0, 0]) {
          cylinder_quarter(_size[1], min_radius);
        }
      }
    }
  }
}

module scoop(size, radius = 0, rounded=true, edge="left") {
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
          _unrounded_scoop(unrounded_size, radius, edge=edge);

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
    _unrounded_scoop(size, radius, edge=edge);
  }
}
