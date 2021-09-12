function orientation_size(size, orientation = 0) = [
  size[orientation % 2],
  size[(orientation + 1) % 2],
  size[2],
];

function orientation_vector(size, orientation = 0) = [
  size[orientation % 2] * (orientation == 2 ? -1 : 1),
  size[(orientation + 1) % 2] * (orientation == 3 ? -1 : 1),
  size[2],
];

module orientation(bounding_box_size, orientation = 0) {
  assert(orientation < 4 && orientation >= 0, "orientation must be in range [0,1,2,3]");

  orientation_offset = [
    (orientation == 1 || orientation == 2) ? bounding_box_size[1] : 0,
    (orientation == 2 || orientation == 3) ? bounding_box_size[0] : 0,
    0,
  ];

  translate(orientation_offset) {
    rotate([0, 0, orientation * 90]) {
      children();
    }
  }
}
