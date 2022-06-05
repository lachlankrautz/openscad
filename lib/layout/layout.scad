include <../config/constants.scad>
include <../util/util_functions.scad>

function padded_rect(size) = size + (
  size[2] == undef
    ? [$padding * 2, $padding * 2]
    : [$padding * 2, $padding * 2, 0]
);

function padded_cube(size) = size + [$padding * 2, $padding * 2, $padding * 2];

function stack_height (length, count=1, top_padding=$top_padding) = length * count + top_padding;

function padded_offset (length, index=1) = (length + $padding * 2 + $wall_thickness) * index;

function offset (size, index=1) = (size + $wall_thickness) * index;

function pad(length) = length + $padding * 2;

function padded_list_length(list) = sum(
  [for(i=[0:len(list)-1]) list[i] + $padding * 2 + $wall_thickness]
) + $wall_thickness;

function divide_rect(rect, operand) = rect[2] == undef
  ? [rect[0] / operand, rect[1] / operand]
  : [rect[0] / operand, rect[1] / operand, rect[2]];

function multiply_rect(rect, operand) = [rect[0] * operand, rect[1] * operand];

function divide_cube(rect, operand) = [rect[0] / operand, rect[1] / operand, rec[2] / operand];
function multiply_cube(rect, operand) = [rect[0] * operand, rect[1] * operand, rect[2] * operand];

function offset_centre_in_box(size, bounding_box) = divide_rect(bounding_box - size, 2);

function spin_orientation_size(size, orientation=1) = orientation % 2 == 0
  ? size
  : [
    size[1],
    size[0],
    size[2],
  ];

// TODO add support for orientation 3
function spin_orientation_offset(size, orientation=1) = [
  orientation == 2 ? -size[0]: 0,
  orientation == 1 ? -size[0]: (orientation == 2 ? -size[1]: 0),
  0,
];

module spin_orientation(size, orientation=1) {
  assert(orientation >= 0, "Invalid orientation [0, 1, 2, 3] required");
  assert(orientation < 3, "Invalid orientation [0, 1, 2, 3] required");

  rotated_size = spin_orientation_size(size, orientation=1);
  degrees = 90 * orientation;
  spin_offset = spin_orientation_offset(size, orientation);

  rotate([0, 0, 90 * orientation]) {
    translate(spin_offset) {
      children();
    }
  }
}

module offset_cylinder(d, h) {
  translate([d / 2, d / 2, 0]) {
    cylinder(d=d, h=h);
  }
}

module offset_circle(d) {
  translate([d / 2, d / 2, 0]) {
    circle(d=d);
  }
}

module offset_square(size, center=false) {
  translate([size[0] / 2, size[1] / 2, 0]) {
    square(size, center=center);
  }
}
