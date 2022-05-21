include <./notched_cube.scad>
include <../config/constants.scad>
include <./functions/tile_stack_functions.scad>

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
  use_rounded_cube=true,
  notch_inset_length=undef
) {
  size = tile_stack_size(tile_size, height, tile_count, top_padding, lid_height);

  floor_height = tile_stack_floor_height(tile_size, tile_count, top_padding, height, lid_height);

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
      use_rounded_cube=use_rounded_cube,
      notch_inset_length=notch_inset_length
    );
  }
}
