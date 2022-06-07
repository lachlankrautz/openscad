include <../config/token-config.scad>
include <../../../lib/tray/tile_tray_v2.scad>
include <../../../lib/config/card_sizes.scad>
include <../../../lib/layout/layout.scad>

side_scheme_size = [
  standard_sleeved_card_size[1],
  standard_sleeved_card_size[0],
  1.8,
];

card_inset_length = 7;

module card_slope(card_size, slope_angle, box_height) {
  sml_rounding = 1;
  slope_hypotenuse = card_size[1] * 0.85;
  slope_height = slope_hypotenuse * sin(slope_angle);
  slope_length = slope_hypotenuse * cos(slope_angle);

  slope_box_size = [
    pad(card_size[0]) + $wall_thickness * 2,
    slope_length,
    slope_height * 2
  ];

  card_cutout_depth = 3;
  card_cutout_size = [
    pad(card_size[0]),
    pad(card_size[1]),
    card_cutout_depth + $bleed
  ];
  card_cutout_rotated_height = card_cutout_size[2] * cos(slope_angle);

  virtual_cutout_length = cutout_notch_size(slope_box_size[1]);
  recommended_cutout_size = cutout_notch_size(slope_box_size, card_inset_length);
  bottom_cutout_size = [
    recommended_cutout_size[0],
    recommended_cutout_size[1],
    50
  ];

  difference() {
    intersection() {
      intersection() {
        translate([0, -sml_rounding]) {
          rounded_cube(slope_box_size + [0, sml_rounding, 0], $rounding=sml_rounding);
        }
        cube(slope_box_size);
      }
      union() {
        translate([0, 0, box_height]) {
          rotate([slope_angle, 0, 0]) {
            translate([0, 0, - slope_box_size[2]]) {
              cube([slope_box_size[0], card_size[1], slope_box_size[2]]);
            }
          }
        }
        cube([slope_box_size[0], $rounding, box_height]);
      }
    }

    translate([0, 0, box_height]) {
      rotate([slope_angle, 0, 0]) {
        translate([$wall_thickness, $wall_thickness, - card_cutout_depth]) {
          cube(card_cutout_size);
        }
      }
    }

    centre_offset = [
      (slope_box_size[0] - bottom_cutout_size[0]) / 2,
      (slope_box_size[1] - virtual_cutout_length) / 2
    ];
    translate(centre_offset) {
      rounded_cube(bottom_cutout_size, flat=true);
    }
  }
}

module location_and_quest_tray(location_tile_count, quest_tile_count) {
  sml_rounding = 1;
  // Just register the vertical card as a square so it lines up with the right
  left_card_size = [standard_sleeved_card_size[0], standard_sleeved_card_size[0]];
  right_card_size = spin_orientation_size(standard_sleeved_card_size);

  left_box_size = tile_tray_box_size(
    [[left_card_size], [for(i=[0:location_tile_count-1]) [slim_tile_size]]],
    [[1], [for(i=[0:location_tile_count-1]) [1]]]
  );

  right_box_size = tile_tray_box_size(
    [for(i=[0:quest_tile_count-1]) [slim_tile_size]],
    [for(i=[0:quest_tile_count-1]) [1]]
  );

  box_size = [
    left_box_size[0] + right_box_size[0] - $wall_thickness,
    right_box_size[1],
    right_box_size[2],
  ];

  // TODO join left and right?
  join_size = [
    pad(left_card_size[0]) + pad(right_card_size[0]) + $wall_thickness * 3,
    $wall_thickness * 2,
    box_size[2]
  ];

  difference() {
    union() {
      rounded_cube(box_size, flat_top=true, $rounding=sml_rounding);
      translate([0, box_size[1] - sml_rounding * 2, 0]) {
        rounded_cube(join_size, flat_top=true, $rounding=sml_rounding);
      }
      translate([0, box_size[1], 0]) {
        card_slope(left_card_size, 20, box_size[2]);
      }
      translate([left_box_size[0] - $wall_thickness, box_size[1], 0]) {
        card_slope(right_card_size, 20, box_size[2]);
      }
    }

    // Left token slots
    translate($wall_rect) {
      tile_tray_row_v2(
        [for(i=[0:location_tile_count-1]) slim_tile_size],
        [for(i=[0:location_tile_count-1]) 1],
        box_size[0],
        box_size[2],
        wall_inset_length,
        bottom_cutout=true
      );
    }

    // Right token slots
    translate([left_box_size[0] - $wall_thickness, 0, 0]) {
      translate($wall_rect) {
        tile_tray_row_v2(
          [for(i=[0:quest_tile_count-1]) slim_tile_size],
          [for(i=[0:quest_tile_count-1]) 1],
          box_size[0],
          box_size[2],
          wall_inset_length,
          bottom_cutout=true
        );
      }
    }
  }
}
