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

function translation_left(box_size, height) =
  -$bleed;

function translation_right(box_size, height) =
  box_size[0] - magnet_cutout_height(height) + $bleed;

function translation_front(box_size, diameter, side_inset) =
  side_inset;

function translation_back(box_size, diameter, side_inset) =
  (box_size[1] - magnet_cutout_diameter(diameter)) -side_inset;

function translation_z(box_size, diameter, floor_inset) =
    (box_size[2] - floor_inset - magnet_cutout_diameter(diameter)) / 2 + floor_inset;

module vertical_magnet_sockets(
  box_size,
  diameter,
  height,
  sides=["left"],
  floor_inset = 0,
  side_inset = 0
) {
  for(i=[0:len(sides)-1]) {
    let (side=sides[i]) {
      vertical_magnet_socket(
        box_size,
        diameter,
        height,
        side,
        floor_inset,
        side_inset
      );
    }
  }
};

module vertical_magnet_socket(
  box_size,
  diameter,
  height,
  side="left",
  floor_inset = 0,
  side_inset = 0
) {
  assert(side == "left" || side == "right", "valid sides: (left | right)");

  _height = height + $bleed;

  translation_front = [
    side == "left" ? translation_left(box_size, height) : translation_right(box_size, height),
    translation_front(box_size, diameter, side_inset),
    translation_z(box_size, diameter, floor_inset)
  ];

  translation_back = [
    side == "left" ? translation_left(box_size, height) : translation_right(box_size, height),
    translation_back(box_size, diameter, side_inset),
    translation_z(box_size, diameter, floor_inset)
  ];

  translate(translation_front) {
    vertical_magnet_cutout(diameter, _height);
  }

  translate(translation_back) {
    vertical_magnet_cutout(diameter, _height);
  }
}
