include <../config/token-config.scad>
include <../../../lib/tray/tile_tray_v2.scad>
include <../../../lib/config/card_sizes.scad>
include <../../../lib/magnet/magnet.scad>
include <../../../lib/config/magnet-sizes.scad>
include <../../../lib/lid/dovetail_lid.scad>
include <../../../lib/join/box-wall-join.scad>

floor_rounding = 1;
top_clearance = 8;
card_buffer = 2;

module hero_resources_long_tray(hero_count = 3, resource_count = 3) {
  hero_wall_count = hero_count * 2;
  token_count = hero_count * resource_count;

  matrix = [for(x=[0:resource_count-1]) [slim_tile_size]];
  matrix_counts = [for(x=[0:resource_count-1]) [1]];

  recommended_box_size = tile_tray_box_size(matrix, matrix_counts);
  box_size = [
    pad(standard_sleeved_card_size[0] + card_buffer) * hero_count
      + $wall_thickness * hero_wall_count,
    recommended_box_size[1] + top_clearance,
    recommended_box_size[2],
  ];
  hero_segment_width = pad(standard_sleeved_card_size[0] + card_buffer)
    + $wall_thickness * 2;

  centre_offset = max(0, (hero_segment_width - recommended_box_size[0]) / 2);
  top_row = matrix_max_y_len(matrix) - 1;

  card_row_width = pad(standard_sleeved_card_size[0]) + $wall_thickness * 2;
  card_row_length = 10 - $bleed;

  row = [slim_tile_size, slim_tile_size, slim_tile_size];
  row_counts = [1, 1, 1];

  slope_length = top_clearance;
  slope_size = [
    box_size[0] + $bleed * 2,
    sqrt(slope_length * slope_length + box_size[2] * box_size[2]),
    box_size[2]
  ];
  slope_angle = atan(box_size[2] / slope_length);

  difference() {
    // union() {
      rounded_cube(box_size, flat_top = true, $rounding = floor_rounding);
      translate([- $bleed, box_size[1] - slope_length, box_size[2]]) {
        rotate([- slope_angle, 0, 0]) {
          cube(slope_size);
        }
      }
      translate([- $bleed, box_size[1] - $wall_thickness * 1.2, 0]) {
        cube([box_size[0] + $bleed * 2, $wall_thickness * 2, $wall_thickness]);
      }
    // }

    // Tile stacks
    for (hero_index = [0:hero_count-1]) {
      translate([
        hero_segment_width * hero_index
          + centre_offset
          + $wall_thickness,
        $wall_thickness,
        0
      ]) {
        for (i = [0:len(row) - 1]) {
          translate([padded_offset(row[i][0], i), 0, 0]) {
            tile_stack(
              row[i],
              row_counts[i],
              box_size[2],
              bottom_cutout = true,
              floor_cutout = row[i][0] > $floor_cutout_threshold,
              use_rounded_cube = false,
              notch_inset_length = wall_inset_length
            );
          }
        }
      }
    }
  }
}
