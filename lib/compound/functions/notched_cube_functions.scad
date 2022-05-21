// I have no idea why it needs to be this vaule
// Seems to be to do with how the cube handles rounding
magic_pill_number = 0.4;

// TODO review pill feature, it's been changed to include padding so
// the magic pill number might no longer be needed
function cutout_rounding (size, pill=false) = pill
  ? min(size[0], size[1]) / 2  + magic_pill_number
  : 1;

function cutout_notch_size(size, notch_inset_length = undef) = notch_inset_length == undef
  // multiply the size by a fraction
  ? size * $cutout_fraction
  // subtract an inset from the size
  : [
      size[0] - notch_inset_length * 2,
      size[1] - notch_inset_length * 2
    ];
