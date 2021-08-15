echo(version=version());

include <../vendor/honeycomb.scad>
include <./rounded_cube.scad>

$wall_thickness=2;
$bleed = 0.01;

module block_border(dimensions) {
  inner_dimensions = [
    dimensions[0] - $wall_thickness * 2,
    dimensions[1] - $wall_thickness * 2,
    dimensions[2] + $bleed * 2
  ];

  difference() {
    rounded_cube(dimensions, flat_top=true, flat_bottom=true);

    translate([$wall_thickness, $wall_thickness, -$bleed]) {
      rounded_cube(inner_dimensions, flat_top=true, flat_bottom=true);
    }
  }
}

module honeycomb_spacer(dimensions, spacing_fraction=2) {
  spacing = (min(dimensions[0], dimensions[1]) + $wall_thickness) / spacing_fraction;

  linear_extrude(dimensions[2]) {
    honeycomb(dimensions[0], dimensions[1], spacing, $wall_thickness);
  }

  block_border(dimensions);
}
