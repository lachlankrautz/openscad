include <../layout/layout.scad>
include <../design/honeycomb.scad>

$wall_thickness = 2;
$bleed = 0.01;
$padding = 0.5;
$inset = 6;
$cutout_fraction = 0.6;
$cutout_lid_height = $wall_thickness;

// I have no idea why it needs to be this vaule
// Seems to be to do with how the cube handles rounding
magic_pill_number = 0.4;

// TODO review pill feature, it's been changed to include padding so
// the magic pill number might no longer be needed
function cutout_rounding (size, pill=false) = pill
  ? min(size[0], size[1]) / 2  + magic_pill_number:
  1;

function cutout_fraction_size(length) = length * $cutout_fraction;

function cutout_fraction_rect(rect) = [
  cutout_fraction_size(rect[0]),
  cutout_fraction_size(rect[1]),
];

module notched_cube(
  size,
  floor_height=$wall_thickness,
  left_cutout=false,
  right_cutout=false,
  top_cutout=false,
  bottom_cutout=false,
  honeycomb_diameter=undef,
  pill=false,
  floor_cutout=false,
  cutout_size=undef,
  bounding_box=undef,
) {
  _bounding_box = bounding_box == undef ? size : bounding_box;
  cutout_fraction = cutout_fraction_size(cutout_size == undef ? size : cutout_size);

  assert(size[2] > floor_height, "Box height shorter than floor height");
  assert(size[0] <= _bounding_box[0], "Bounding box must be greater than or equal to size");
  assert(size[1] <= _bounding_box[1], "Bounding box must be greater than or equal to size");

  honeycomb_base = honeycomb_diameter != undef;
  inset_length = $inset * 2 + $wall_thickness;
  box_offset = offset_centre_in_box(size, _bounding_box);

  cutout_size = [
    size[0],
    size[1],
    size[2] - floor_height + $bleed,
  ];

  translate(box_offset) {
    translate([0, 0, floor_height]) {
      rounded_cube(cutout_size, flat = true, $rounding = cutout_rounding(size, pill));
    }

    if (left_cutout) {
      left_cutout_size = [
        inset_length + box_offset[0],
        cutout_fraction[1],
        size[2] + $cutout_lid_height + $bleed * 2,
      ];

      translate([
        - left_cutout_size[0] + $inset,
        (size[1] - left_cutout_size[1]) / 2,
        0
      ]) {
        rounded_cube(left_cutout_size, flat = true);
      }
    }

    if (right_cutout) {
      right_cutout_size = [
        inset_length + box_offset[0],
        cutout_fraction[1],
        size[2] + $cutout_lid_height + $bleed * 2,
      ];

      translate([
        size[0] - $inset,
        (size[1] - right_cutout_size[1]) / 2,
        0
      ]) {
        rounded_cube(right_cutout_size, flat = true);
      }
    }

    if (top_cutout) {
      top_cutout_size = [
        cutout_fraction[0],
        inset_length + box_offset[1],
        size[2] + $cutout_lid_height + $bleed * 2,
      ];

      translate([
        (size[0] - top_cutout_size[0]) / 2,
        size[1] - $inset,
        0
      ]) {
        rounded_cube(top_cutout_size, flat = true);
      }
    }

    if (bottom_cutout) {
      bottom_cutout_size = [
        cutout_fraction[0],
        inset_length + box_offset[1],
        size[2] + $cutout_lid_height + $bleed * 2,
      ];

      translate([
        (size[0] - bottom_cutout_size[0]) / 2,
        - bottom_cutout_size[1] + $inset,
        0
      ]) {
        rounded_cube(bottom_cutout_size, flat = true);
      }
    }

    // clearences to help place things inside without hitting the other cutouts
    frame_thickness = honeycomb_base ? $wall_thickness : ($wall_thickness * 3);

    left_clearance = (left_cutout ? $inset : 0) + frame_thickness;
    right_clearance = (right_cutout ? $inset : 0) + frame_thickness;
    top_clearance = (top_cutout ? $inset : 0) + frame_thickness;
    bottom_clearance = (bottom_cutout ? $inset : 0) + frame_thickness;

    floor_cutout_size = [
      size[0] - left_clearance - right_clearance,
      size[1] - top_clearance - bottom_clearance,
      floor_height + $bleed * 2,
    ];

    if (honeycomb_base || floor_cutout) {
      translate([left_clearance, bottom_clearance, - $bleed]) {
        if (honeycomb_base) {
          negative_honeycomb_cube(floor_cutout_size, honeycomb_diameter);
        } else if (floor_cutout) {
          rounded_cube(floor_cutout_size, flat = true);
        }
      }
    }
  }
}
