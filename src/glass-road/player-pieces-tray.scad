include <./config/player-pieces-config.scad>

/**
 * Player pieces tray
 *
 * Holds:
 * - 6 forests
 * - 2 of each other terrain
 * - 10 resource disks
 * - 15 player cards
 *
 * 1st player only
 * - room for 1st player token
 *
 * Solo only:
 * - 1 additional player card
 * - solo turn card counter tile
 *
 */

difference() {
  rounded_cube(box_size, flat_top=true, $rounding=1);

  translate($wall_rect) {
    tile_stack(
      terrain_tile_size,
      terrain_tile_count,
      left_cutout = true,
      right_cutout = true,
      lid_height = $lid_height,
      notch_clearence = card_stack_height
    );

    translate([0, padded_offset(terrain_tile_size[1]), $floor_thickness]) {
      scoop([
        terrain_tile_size[0],
        box_size[1] - padded_offset(terrain_tile_size[1]) - $wall_thickness * 2,
        stack_height(terrain_tile_size[2], terrain_tile_count) + $bleed,
      ], edge="bottom", rounded=false);
    }

    translate([padded_offset(terrain_tile_size[0]), 0, 0]) {
      tile_stack(
        forest_tile_size,
        forest_tile_count,
        right_cutout = true,
        lid_height = $lid_height,
        notch_clearence = card_stack_height
      );
    }
  }

  spin_orientation(box_size, 2) {
    dovetail_lid_cutout(spin_orientation_size(box_size, 2), lid_height=card_stack_height + $lid_height);
  }
}
