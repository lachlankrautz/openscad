include <../../lib/primitive/disc_bracket.scad>
include <../../lib/layout/layout.scad>
include <../../lib/primitive/rounded_cube.scad>
include <../../lib/util/util_functions.scad>

$fn = 50;
$rounding = 1;

// test = false;
test = true;
verbosity = 1;

poly_padding = 0.3;

poly_stack_count = test ? 3: 8;
poly_count = 2;

poly_width = 14.1 + poly_padding * 2;
poly_short_length = 10 + poly_padding * 2;
poly_long_length = 14 + poly_padding * 2;
cap_ratio = 0.4;
cap_width = poly_width * cap_ratio;
edge_cap_width = cap_width / 2;

poly_coords = flatten([
  [
    [poly_width * poly_stack_count + $wall_thickness, poly_long_length + $wall_thickness], // Left edge of top right
    [poly_width * poly_stack_count + $wall_thickness - edge_cap_width, poly_long_length + $wall_thickness],
    [poly_width * poly_stack_count + $wall_thickness - edge_cap_width, poly_long_length + $wall_thickness * 2],
    [poly_width * poly_stack_count + $wall_thickness * 2, poly_long_length + $wall_thickness * 2],
    [poly_width * poly_stack_count + $wall_thickness * 2, $wall_thickness], 
    [poly_width * poly_stack_count + $wall_thickness, 0], 
    [$wall_thickness, 0], 
    [0, $wall_thickness], 
    [0, poly_long_length + $wall_thickness * 2],
    [edge_cap_width + $wall_thickness, poly_long_length + $wall_thickness * 2],
    [edge_cap_width + $wall_thickness, poly_long_length + $wall_thickness],
    [$wall_thickness, poly_long_length + $wall_thickness],
  ],
  for(i=[0:poly_stack_count-1]) [
    [
      poly_width * i + $wall_thickness, 
      poly_long_length - poly_short_length + $wall_thickness
    ],
    [
      poly_width * (i+0.5) + $wall_thickness, 
      $wall_thickness
    ],
    [
      poly_width * (i+1) + $wall_thickness, 
      poly_long_length - poly_short_length + $wall_thickness
    ],
  ],
]);

disc_size = [
  36.5,
  26.5,
  2.2,
];

row_stack_heights = [
  1,
  2,
  4,
];

cols = test ? 2: 4;
rows = test ? 1: 3;

box_size = [
  padded_offset(disc_size[0], cols) + $wall_thickness,
  (disc_size[1] + $wall_thickness * 2) * rows 
    + poly_long_length 
    + $wall_thickness * 6,
  $wall_thickness + $bleed,
];

if (verbosity > 0) {
  echo("Box size: ", box_size);
}

union() {
  rounded_cube(box_size, flat_bottom=true);

  translate([$wall_thickness, $wall_thickness, box_size[2] - $bleed]) {
    translate([
      (box_size[0] - (poly_width * poly_stack_count + $wall_thickness * 1)) / 2 - $wall_thickness,
      0,
      0,
    ]) {
      // zig zag for timing tokens
      linear_extrude(stack_height(disc_size[2], poly_count)) {
        polygon(poly_coords);
      }

      translate([$wall_thickness, $wall_thickness, 0]) {
        for(i=[0:poly_stack_count-2]) {
          translate([poly_width * (i+1) - cap_width / 2, poly_long_length, 0]) {
            // top tabs to keep timing tokens in place
            rounded_cube([
              cap_width, 
              $wall_thickness, 
              stack_height(disc_size[2], poly_count)
            ], flat_bottom=true, $rounding=0.5);
          }
        }
      }
    }

    // arc token holders
    translate([
      0, 
      poly_long_length + $wall_thickness * 4,
      0
    ]) {
      for(i=[0:cols-1]) {
        for(j=[0:rows-1]) {
          translate([
            padded_offset(disc_size[0], i),
            (disc_size[1] + $wall_thickness) * j,
            0,
          ]) {
            disc_bracket(disc_size, row_stack_heights[j]);
          }
        }
      }
    }
  }
}
