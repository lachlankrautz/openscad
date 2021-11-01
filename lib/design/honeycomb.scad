include <../../vendor/honeycomb.scad>
include <../primitive/rounded_cube.scad>
include <../config/constants.scad>

function relative_diameter(dimensions, hexagons_per_size=2) = (
  min(
    dimensions[0],
    dimensions[1]) + $wall_thickness
  ) / hexagons_per_side;

function honeycomb_inset_size(size, inset = $wall_thickness) = [
    size[0] - $wall_thickness,
    size[1] - inset * 2,
    size[2] + $bleed * 2,
];

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

module negative_honeycomb_cube(dimensions, diameter=-1) {
  honeycomb_size = [
    dimensions[0],
    dimensions[1],
    dimensions[2] + $bleed * 2,
  ];

  difference() {
    cube(dimensions);
    translate([0, 0, -$bleed]) {
      honeycomb_cube(dimensions, diameter);
    }
  }
}

module honeycomb_cube(dimensions, diameter=-1) {
  _diameter = diameter > 0
    ? diameter
    : relative_diameter(dimensions);

  linear_extrude(dimensions[2]) {
    honeycomb(dimensions[0], dimensions[1], _diameter, $wall_thickness);
  }
}

module honeycomb_spacer(dimensions) {
  honeycomb_cube(dimensions);

  block_border(dimensions);
}
