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

module slope(slope_surface_size, slope_angle, base_height) {
  sml_rounding = 1;
  slope_hypotenuse = slope_surface_size[1];
  slope_height = slope_hypotenuse * sin(slope_angle);
  slope_length = slope_hypotenuse * cos(slope_angle);

  slope_box_size = [
    slope_surface_size[0],
    slope_length,
    slope_height * 2 // leave plenty of clearence
  ];

  intersection() {
    rounded_cube(slope_box_size, flat_front=true, flat_back=true, $rounding=sml_rounding);

    union() {
      translate([0, 0, base_height]) {
        rotate([slope_angle, 0, 0]) {
          translate([0, 0, - slope_box_size[2]]) {
            cube([slope_box_size[0], slope_surface_size[1], slope_box_size[2]]);
          }
        }
      }
      cube([slope_box_size[0], $rounding * 3, base_height]);
    }
  }
}

module slope_cutout(
  card_size,
  slope_length,
  slope_angle,
  card_cutout_depth,
  base_height
) {
  card_cutout_size = [
    pad(card_size[0]),
    pad(card_size[1]),
    card_cutout_depth + $bleed
  ];

  translate([0, 0, base_height]) {
    rotate([slope_angle, 0, 0]) {
      translate([0, $wall_thickness, - card_cutout_depth]) {
        cube(card_cutout_size);
      }
    }
  }

  flat_card_cutout_length = slope_length * cos(slope_angle);
  flat_wall_thickness = $wall_thickness * cos(slope_angle);

  bottom_cutout_size = [
    card_cutout_size[0] - card_inset_length * 2,
    flat_card_cutout_length - card_inset_length * 2,
    100
  ];

  translate([card_inset_length, flat_wall_thickness + card_inset_length, 0]) {
    rounded_cube(bottom_cutout_size, flat=true);
  }
}

module tile_slope_cutout(
  tile_size,
  length_offset,
  slope_angle,
  base_height,
  clearence=0
) {
  cutout_size = tile_stack_size(tile_size);

  translate([0, 0, base_height - cutout_size[2]]) {
    rotate([slope_angle, 0, 0]) {
      translate([0, length_offset, 0]) {
        cube(cutout_size + [0, clearence, $bleed]);
      }
    }
  }
}

module location_and_quest_tray(location_tile_count, quest_tile_count) {
  sml_rounding = 1;

  // Left measurements
  left_card_size = standard_sleeved_card_size;
  front_left_box_width = pad(slim_tile_size[0]) * location_tile_count + $wall_thickness * (location_tile_count+1);
  top_left_box_width = pad(left_card_size[0]) + $wall_thickness * 2;
  flow_left_width = max(
    pad(left_card_size[0]) + $wall_thickness * 2,
    front_left_box_width
  );
  left_overhang = top_left_box_width > front_left_box_width
    ? 0
    : (front_left_box_width - top_left_box_width) / 2;

  // Right measurements
  right_card_size = spin_orientation_size(standard_sleeved_card_size);
  front_right_box_width = pad(slim_tile_size[0]) * quest_tile_count + $wall_thickness * (quest_tile_count+1);
  top_right_box_width = pad(right_card_size[0]) + $wall_thickness * 2;
  flow_right_width = max(
    pad(right_card_size[0]) + $wall_thickness * 2,
    front_right_box_width
  );
  right_overhang = top_right_box_width > front_right_box_width
    ? 0
    : (front_right_box_width - top_right_box_width) / 2;

  front_box_size = [
    max(
      left_overhang + top_left_box_width + pad(slim_tile_size[0]) + top_right_box_width + right_overhang,
      front_left_box_width + front_right_box_width
    ),
    pad(tile_size[1]) + $wall_thickness * 2,
    stack_height(slim_tile_size[2]) + $wall_thickness
  ];

  difference() {
    union() {
      rounded_cube(front_box_size + [0, $bleed, 0], flat_top=true, flat_back=true, $rounding=sml_rounding);

      slope_angle = 20;
      slope_length = right_card_size[1] * 0.85;

      left_offset = left_overhang + $wall_thickness;
      middle_offset = front_box_size[0]
        - top_right_box_width
        - right_overhang
        - pad(slim_tile_size[0]);
      right_offset = front_box_size[0]
        - top_right_box_width
        - right_overhang
        + $wall_thickness;

      translate([0, front_box_size[1], 0]) {
        difference() {
          slope(
            [front_box_size[0], slope_length],
            slope_angle,
            front_box_size[2]
          );

          // Left card slope cutout
          translate([left_offset, 0, 0]) {
            slope_cutout(
              left_card_size,
              slope_length,
              slope_angle,
              2,
              front_box_size[2]
            );
          }

          translate([middle_offset, 0, 0]) {
            cutout_length = pad(slim_tile_size[0]);
            // No padding so the top edge is flush
            tile_slope_offset = slope_length - slim_tile_size[1];

            tile_slope_cutout(
              slim_tile_size,
              tile_slope_offset,
              slope_angle,
              front_box_size[2],
              clearence=10
            );

            image_cutout = [10, 10];
            slope_cutout(
              [
                slim_tile_size[0],
                slope_length - slim_tile_size[1] - $wall_thickness * 3
              ],
              0,
              slope_angle,
              image_inset_height,
              front_box_size[2]
            );
          }

          // Right card slope cutout
          translate([right_offset, 0, 0]) {
            slope_cutout(
              right_card_size,
              slope_length,
              slope_angle,
              4,
              front_box_size[2]
            );
          }
        }
      }
    }

    // Left token slots
    translate($wall_rect) {
      tile_tray_row_v2(
        [for(i=[0:location_tile_count-1]) slim_tile_size],
        [for(i=[0:location_tile_count-1]) 1],
        flow_left_width,
        front_box_size[2],
        wall_inset_length,
        bottom_cutout=true,
        orientation="centre",
        notch_style="square"
      );
    }

    // Right token slots
    translate([front_box_size[0] - flow_right_width, 0, 0]) {
      translate($wall_rect) {
        tile_tray_row_v2(
          [for(i=[0:quest_tile_count-1]) slim_tile_size],
          [for(i=[0:quest_tile_count-1]) 1],
          flow_right_width,
          front_box_size[2],
          wall_inset_length,
          bottom_cutout=true,
          orientation="centre",
          notch_style="square"
        );
      }
    }
  }
}
