include <./config/led-hook-config.scad>

linear_extrude(clip_width) {
  // ######  ##
  // ######  ##
  // ##  ##  ##
  // ##  ######
  // ##  ######
  polygon([
    // starting bottomg left and headed clockwise
    [0, 0],
    [0, strip_width + clip_thickness],
    [clip_thickness + box_wall_thickness + clip_thickness, strip_width + clip_thickness],
    [clip_thickness + box_wall_thickness + clip_thickness, clip_thickness],
    [clip_thickness + box_wall_thickness + clip_thickness + strip_height, clip_thickness],
    [clip_thickness + box_wall_thickness + clip_thickness + strip_height, strip_width * strip_width_fraction + clip_thickness],
    [clip_thickness + box_wall_thickness + clip_thickness + strip_height + clip_thickness, strip_width * strip_width_fraction + clip_thickness],
    [clip_thickness + box_wall_thickness + clip_thickness + strip_height + clip_thickness, 0],
    [clip_thickness + box_wall_thickness, 0],
    [clip_thickness + box_wall_thickness, strip_width],
    [clip_thickness, strip_width],
    [clip_thickness, 0],
  ]);
}
