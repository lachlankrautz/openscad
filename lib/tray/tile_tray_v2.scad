include <../compound/functions/notched_cube_functions.scad>
include <../util/util_functions.scad>
include <../design/square-pattern.scad>

// Shrink the notch width to fit in easily
width_tolerance = 0.4;

// Fraction of cylinder to use as a bump e.g. only stick out 30% of the clylinder
bump_cylinder_fraction = 0.25;
bump_drop_height = 0.5;
bump_diameter = 3;

function offset_bump_left() = bump_diameter * bump_cylinder_fraction;
function offset_bump_right() = bump_diameter - bump_diameter * bump_cylinder_fraction;

function box_size(tile_size, matrix, matrix_counts) = [
  padded_offset(tile_size[0], len(matrix)) + $wall_thickness,
  padded_offset(tile_size[1], len(matrix[0])) + $wall_thickness,
  stack_height(tile_size[2], max(flatten(matrix_counts))) + $wall_thickness,
];

module side_notch(diameter, width, fraction = 1, bleed = 0, trim = false) {
  translate([diameter / 2, width, diameter / 2]) {
    rotate([90, 0, 0]) {
      cylinder(d=diameter * fraction, center=true, h=width + bleed * 2);
    }
  }
}

module notch_support(tile_size, wall_inset_length) {
  // No need to pass height based params; size only needs 2d data
  tile_stack_size_2d = tile_stack_size(tile_size);

  width = tile_stack_size_2d[0]
    // Subtract the inset wall length to get the cutout size
    - wall_inset_length * 2
    // Subtract to allow the support block to slide in the cutout
    - width_tolerance;

  height = bump_diameter + bump_drop_height;
  translate([0, 0, $wall_thickness -$bleed]) {
    cube([width, $wall_thickness, height]);
  }
}

module lid_side_notches(box_size, wall_inset_length, bleed=0, trim=false) {
  notch_padding = 0;

  // Front left
  translate([
    $wall_thickness + wall_inset_length - offset_bump_left() + notch_padding,
    - $wall_thickness * 0.5,
    0
  ]) {
    side_notch(bump_diameter, $wall_thickness, bleed=bleed, trim=trim);
  }

  // Back left
  translate([
    $wall_thickness + wall_inset_length - offset_bump_left() + notch_padding,
    box_size[1] - $wall_thickness * 1.5,
    0
  ]) {
    side_notch(bump_diameter, $wall_thickness, bleed=bleed, trim=trim);
  }

  // Front right
  translate([
    box_size[0] - $wall_thickness - wall_inset_length - offset_bump_right() - notch_padding,
    - $wall_thickness * 0.5,
    0
  ]) {
    side_notch(bump_diameter, $wall_thickness, bleed=bleed, trim=trim);
  }

  // Back right
  translate([
    box_size[0] - $wall_thickness - wall_inset_length - offset_bump_right() - notch_padding,
    box_size[1] - $wall_thickness * 1.5,
    0
  ]) {
    side_notch(bump_diameter, $wall_thickness, bleed=bleed, trim=trim);
  }
}

module lid_notch_supports(tile_size, box_size, wall_inset_length) {
  tile_stack_size_2d = tile_stack_size(tile_size);

  // Front left
  translate([
    $wall_thickness + wall_inset_length + width_tolerance / 2,
    0,
    0
  ]) {
    notch_support(tile_size, wall_inset_length);
  }

  // Back left
  translate([
    $wall_thickness + wall_inset_length + width_tolerance / 2,
    box_size[1] - $wall_thickness,
    0
  ]) {
    notch_support(tile_size, wall_inset_length);
  }

  // Front right
  translate([
    box_size[0] - tile_stack_size_2d[0] - $wall_thickness + wall_inset_length + width_tolerance / 2,
    0,
    0
  ]) {
    notch_support(tile_size, wall_inset_length);
  }

  // Back right
  translate([
    box_size[0] - tile_stack_size_2d[0] - $wall_thickness + wall_inset_length + width_tolerance / 2,
    box_size[1] - $wall_thickness,
    0
  ]) {
    notch_support(tile_size, wall_inset_length);
  }
}

module tile_tray_v2(tile_size, matrix, matrix_counts, wall_inset_length) {
  box_size = box_size(tile_size, matrix, matrix_counts);


  difference() {
    rounded_cube(box_size, flat_top=true, $rounding=1);

    translate([0, 0, box_size[2] - bump_diameter - bump_drop_height]) {
      lid_side_notches(box_size, wall_inset_length, bleed=$bleed);
    }

    translate($wall_rect) {
      for(x=[0:len(matrix)-1]) {
        for(y=[0:len(matrix[x])-1]) {
          translate([padded_offset(tile_size[0], x), padded_offset(tile_size[1], y), 0]) {
            tile_stack(
              matrix[x][y],
              matrix_counts[x][y],
              box_size[2],
              top_cutout = y == len(matrix[x])-1,
              bottom_cutout= y == 0,
              use_rounded_cube = false,
              notch_inset_length = wall_inset_length
            );
          }
        }
      }
    }
  }
}

module tile_tray_lid_v2(tile_size, matrix, matrix_counts, wall_inset_length) {
  box_size = [
    box_size(tile_size, matrix, matrix_counts)[0],
    box_size(tile_size, matrix, matrix_counts)[1],
    $wall_thickness
  ];

  union() {
    difference() {
      rounded_cube(box_size, flat_top=true, $rounding=1);
      translate([$wall_thickness, $wall_thickness]) {
        square_pattern_to_cut(matrix, $wall_thickness, wall_inset_length, $wall_thickness);
      }
    }

    translate([0, 0, $wall_thickness + bump_drop_height]) {
      lid_side_notches(box_size, wall_inset_length + width_tolerance / 2, trim=true);
    }
    lid_notch_supports(tile_size, box_size, wall_inset_length);
  }
}
