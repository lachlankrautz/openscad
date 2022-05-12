include <./notched_cube.scad>
include <../config/constants.scad>

module tile_stack(
  tile_size,
  tile_count=1,
  height = undef, // align to this height if specified, else sit above floor
  left_cutout=false,
  right_cutout=false,
  top_cutout=false,
  bottom_cutout=false,
  pill=false,
  lid_height=0,
  notch_clearence=0,
  top_padding=$top_padding,
  use_rounded_cube=true
) {
  size = [
    pad(tile_size[0]),
    pad(tile_size[1]),
    height != undef
      ? height
      : stack_height(tile_size[2], tile_count, top_padding) + lid_height,
  ];

  floor_height = height != undef
    ? height - stack_height(tile_size[2], tile_count, top_padding) - lid_height
    : $floor_thickness;

  // No need to render any cutout if the size is zero
  if (tile_count > 0) {
    notched_cube(
      size,
      floor_height,
      left_cutout=left_cutout,
      right_cutout=right_cutout,
      top_cutout=top_cutout,
      bottom_cutout=bottom_cutout,
      notch_clearence=notch_clearence,
      pill=pill,
      use_rounded_cube=use_rounded_cube
    );
  }
}
