include <../config/hero-tray-config.scad>
include <../../../lib/tray/tile_tray_v2.scad>
include <../../../lib/config/card_sizes.scad>
include <../../../lib/magnet/magnet.scad>
include <../../../lib/config/magnet-sizes.scad>
include <../../../lib/lid/dovetail_lid.scad>
include <../../../lib/join/box-wall-join.scad>

floor_rounding = 1;
top_clearance = 8;
rail_length = 5;
rail_width = $wall_thickness + 1;

module rail(rail_size, rounding) {
  _rail_size = [
    rail_size[0],
    rail_size[1] + rounding,
    rail_size[2],
  ];
  translate([0, -rounding, 0]) {
    difference() {
      rounded_cube(_rail_size, flat_top=true, $rounding=rounding);
      cube([_rail_size[0] + $bleed * 2, rounding, _rail_size[2]]);
    }
  }
}

module hero_tray(token_count) {
  matrix = [for(x=[0:token_count-1]) [slim_tile_size]];
  matrix_counts = [for(x=[0:token_count-1]) [1]];

  recommended_box_size = tile_tray_box_size(matrix, matrix_counts);
  box_size = [
    pad(standard_sleeved_card_size[0]) + rail_width * 2,
    recommended_box_size[1] + top_clearance,
    recommended_box_size[2],
  ];
  centre_offset = max(0, (box_size[0] - recommended_box_size[0]) / 2);
  top_row = matrix_max_y_len(matrix) - 1;

  card_row_width = pad(standard_sleeved_card_size[0]) + $wall_thickness * 2;
  card_row_length = 10 - $bleed;

  row = pick_list(matrix, 0);
  row_counts = pick_list(matrix_counts, 0);

  rail_size = [
    rail_width,
    rail_length,
    box_size[2],
  ];

  union() {
    difference() {
        box_wall_join(box_size) {
          union() {
            rounded_cube(box_size, flat_top=true, $rounding=floor_rounding);
            translate([0, box_size[1] - floor_rounding, 0]) {
              rail(rail_size, rounding=floor_rounding);
            }
            translate([box_size[0] - rail_size[0], box_size[1] - floor_rounding, 0]) {
              rail(rail_size, rounding=floor_rounding);
            }
          }
        }

      // Tile stacks
      translate([centre_offset + $wall_thickness, $wall_thickness, 0]) {
        for (x = [0:len(row) - 1]) {
          translate([padded_offset(row[x][0], x), 0, 0]) {
            tile_stack(
              row[x],
              row_counts[x],
              box_size[2],
              bottom_cutout = true,
              floor_cutout = row[x][0] > $floor_cutout_threshold,
              use_rounded_cube = false,
              notch_inset_length = wall_inset_length
            );
          }
        }
      }
    }
  }
}
