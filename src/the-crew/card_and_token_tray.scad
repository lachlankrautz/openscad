include <./config.scad>
include <../../lib/tray/card_tray.scad>
include <../../lib/compound/notched_cube.scad>
include <../../lib/compound/tile_stack.scad>
include <../../lib/compound/tile_stack_round.scad>
include <../../lib/lid/dovetail_lid.scad>

$fn = 50;

difference() {
  rounded_cube(box_size, flat_top=true, $rounding=1);

  translate([$wall_thickness, card_tray_size[1], 0]) {
    for (i=[0:2]) {
      translate([padded_offset(tile_size[0], i), 0, 0]) {
        if (i < 2) {
          tile_stack(
            tile_size,
            tile_stack_count,
            box_size[2],
            top_cutout = true,
            bottom_cutout = false,
            lid_height=lid_height
          );
        } else {
          tile_stack_round(
            round_tile_diameter,
            tile_size[2],
            tile_stack_count,
            box_size[2],
            top_cutout = true,
            bottom_cutout = false,
            lid_height=lid_height
          );
        }
      }
    }
  }

  card_tray_grid_cutout(cards, card_stack_height, top_cutout=false);

  dovetail_lid_cutout(box_size);
}
