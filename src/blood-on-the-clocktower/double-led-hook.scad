include <./config/led-hook-config.scad>

left_side_height = box_right_gap_drop - box_inner_wall_inset;

linear_extrude(clip_width) {
  //   #####
  // # ## ##
  // # #  ## #
  // ###   # #
  //       ###
  polygon([
    // starting bottomg left and headed clockwise
    [0, left_side_height],
    [0, left_side_height + clip_thickness + strip_front_width],
    [clip_thickness, left_side_height + clip_thickness + strip_front_width],
    [clip_thickness, left_side_height + clip_thickness],
    [clip_thickness + strip_height, left_side_height + clip_thickness],
    [
      clip_thickness + strip_height,
      left_side_height + strip_width + box_inner_wall_inset + clip_thickness
    ],
    [
      clip_thickness + strip_height + clip_thickness + double_wall_width + clip_thickness,
      strip_width + box_right_gap_drop + clip_thickness,
    ],
    [clip_thickness + strip_height + clip_thickness + double_wall_width + clip_thickness, clip_thickness],
    [clip_thickness + strip_height + clip_thickness + double_wall_width + clip_thickness + strip_height, clip_thickness],
    [clip_thickness + strip_height + clip_thickness + double_wall_width + clip_thickness + strip_height, clip_thickness + strip_front_width],
    [clip_thickness + strip_height + clip_thickness + double_wall_width + clip_thickness + strip_height + clip_thickness, clip_thickness + strip_front_width],
    [clip_thickness + strip_height + clip_thickness + double_wall_width + clip_thickness + strip_height + clip_thickness, 0],
    [clip_thickness + strip_height + clip_thickness + double_wall_width, 0],
    [
      clip_thickness + strip_height + clip_thickness + double_wall_width,
      strip_width
    ],
    [clip_thickness + strip_height + clip_thickness + box_wall_thickness + box_gap + box_inner_wall_thickness, strip_width],
    [clip_thickness + strip_height + clip_thickness + box_wall_thickness + box_gap + box_inner_wall_thickness, strip_width + box_right_gap_drop],
    [clip_thickness + strip_height + clip_thickness + box_inner_wall_thickness, strip_width + box_right_gap_drop],
    [clip_thickness + strip_height + clip_thickness + box_inner_wall_thickness, strip_width + box_inner_wall_inset],
    [clip_thickness + strip_height + clip_thickness, strip_width + box_inner_wall_inset],
    [clip_thickness + strip_height + clip_thickness, left_side_height],
  ]);
}
