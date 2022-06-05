include <../layout/layout.scad>
include <../config/magnet-sizes.scad>

function magnet_cutout_diameter(diameter) = diameter + magnet_diameter_tolerance;

function magnet_cutout_height(height) = height + magnet_height_tolerance;

module vertical_magnet_cutout (diameter, height) {
  _diameter = magnet_cutout_diameter(diameter);
  _height = magnet_cutout_height(height);

  translate([0, _diameter/2, _diameter/2]) {
    rotate([0, 90, 0]) {
      cylinder(d=_diameter, h=_height);
    }
  }
}

function translation_left(box_size, diameter, height, floor_compensation = 0) = [
  -$bleed,
  (box_size[1] - magnet_cutout_diameter(diameter)) / 2,
  (box_size[2] - floor_compensation - magnet_cutout_diameter(diameter)) / 2 + floor_compensation,
];

function translation_right(box_size, diameter, height, floor_compensation = 0) = [
  box_size[0] - magnet_cutout_height(height) + $bleed,
  (box_size[1] - magnet_cutout_diameter(diameter)) / 2,
  (box_size[2] - floor_compensation - magnet_cutout_diameter(diameter)) / 2 + floor_compensation,
];

module vertical_magnet_sockets(
  box_size,
  diameter,
  height,
  positions=["left"],
  floor_compensation = 0
) {
  for(i=[0:len(positions)-1]) {
    let (position=positions[i]) {
      vertical_magnet_socket(box_size, diameter, height, position, floor_compensation);
    }
  }
};

module vertical_magnet_socket(
  box_size,
  diameter,
  height,
  position="left",
  floor_compensation = 0
) {
  assert(position == "left" || position == "right", "valid positions: (left | right)");

  _height = height + $bleed;

  translation = position == "left"
    ? translation_left(box_size, diameter, _height, floor_compensation)
    : translation_right(box_size, diameter, _height, floor_compensation);

  translate(translation) {
    vertical_magnet_cutout(diameter, _height);
  }
}
