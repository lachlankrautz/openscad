include <./layout.scad>
include <./honeycomb.scad>

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

module cutout(
  size,
  floor_height=$wall_thickness,
  left_cutout=false,
  right_cutout=false,
  top_cutout=false,
  bottom_cutout=false,
  honeycomb_diameter=undef,
  pill=false,
  floor_cutout=false
) {
  assert(size[2] > floor_height, "Box height shorter than floor height");

  honeycomb_base = honeycomb_diameter != undef;

  cutout_size = [
    size[0],
    size[1],
    size[2] - floor_height + $bleed,
  ];

  translate([0, 0, floor_height]) {
    rounded_cube(cutout_size, flat=true, $rounding=cutout_rounding(size, pill));
  }

  if (left_cutout) {
    left_cutout_size = [
      $inset * 2 + $wall_thickness,
      size[1] * $cutout_fraction,
      size[2] + $cutout_lid_height + $bleed * 2,
    ];

    translate([
      -left_cutout_size[0] + $inset,
      (size[1] - left_cutout_size[1]) / 2,
      0
    ]) {
      rounded_cube(left_cutout_size, flat=true);
    }
  }

  if (right_cutout) {
    right_cutout_size = [
      $inset * 2 + $wall_thickness,
      size[1] * $cutout_fraction,
      size[2] + $cutout_lid_height + $bleed * 2,
    ];

    translate([
      size[0] - $inset,
      (size[1] - right_cutout_size[1]) / 2,
      0
    ]) {
      rounded_cube(right_cutout_size, flat=true);
    }
  }

  if (top_cutout) {
    top_cutout_size = [
      size[0] * $cutout_fraction,
      $inset * 2 + $wall_thickness,
      size[2] + $cutout_lid_height + $bleed * 2,
    ];

    translate([
      (size[0] - top_cutout_size[0]) / 2,
      size[1] - $inset,
      0
    ]) {
      rounded_cube(top_cutout_size, flat=true);
    }
  }

  if (bottom_cutout) {
    bottom_cutout_size = [
      size[0] * $cutout_fraction,
      $inset * 2 + $wall_thickness,
      size[2] + $cutout_lid_height + $bleed * 2,
    ];

    translate([
      (size[0] - bottom_cutout_size[0]) / 2,
      -bottom_cutout_size[1] + $inset,
      0
    ]) {
      rounded_cube(bottom_cutout_size, flat=true);
    }
  }

  // clearences to help place things inside without hitting the other cutouts
  frame_thickness = honeycomb_base ? $wall_thickness : $wall_thickness * 3;
  left_clearance = left_cutout
    ? $inset + frame_thickness
    : 0;

  right_clearance = right_cutout
    ? $inset + frame_thickness
    : 0;

  top_clearance = top_cutout
    ? $inset + frame_thickness
    : 0;

  bottom_clearance = bottom_cutout
    ? $inset + frame_thickness
    : 0;

  if (honeycomb_base) {
    honeycomb_size = [
      size[0] - left_clearance - right_clearance,
      size[1] - top_clearance - bottom_clearance,
      floor_height + $bleed * 2,
    ];
    translate([left_clearance, bottom_clearance, -$bleed]) {
      negative_honeycomb_cube(honeycomb_size, honeycomb_diameter);
    }
  }

  if (floor_cutout) {
    honeycomb_size = [
          size[0] - left_clearance - right_clearance,
          size[1] - top_clearance - bottom_clearance,
        floor_height + $bleed * 2,
      ];
    translate([left_clearance, bottom_clearance, -$bleed]) {
      rounded_cube(honeycomb_size, flat=true);
    }
  }
}

module tile_cutout(
  tile_size, 
  tile_count=1,
  height,
  left_cutout=false, 
  right_cutout=false,
  top_cutout=false,
  bottom_cutout=false,
  pill=false
) {
  size = [
    pad(tile_size[0]),
    pad(tile_size[1]),
    height,
  ];

  // floor_height = height - stack_height(tile_size[2], tile_count) + $bleed;
  // TODO do we need bleed?
  floor_height = height - stack_height(tile_size[2], tile_count);

  // No need to render any cutout if the size is zero
  if (tile_count > 0) {
    cutout(
      size,
      floor_height,
      left_cutout,
      right_cutout,
      top_cutout,
      bottom_cutout,
      pill
    );
  }
}
