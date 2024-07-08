include <../../lib/config/token_sizes.scad>
include <../../lib/layout/layout.scad>
include <../../lib/primitive/rounded_cube.scad>
include <../../lib/compound/tile_stack.scad>
include <../../lib/compound/tile_stack_round.scad>
include <../../lib/lid/dovetail_lid.scad>
include <./tile_tray_config.scad>

difference() {
  rounded_cube(box_size, flat_top=true, $rounding=1);

  translate([$wall_thickness, $wall_thickness]) {
    for (i=[0:len(token_stack_counts)-1]) {
      translate([padded_offset(tile_size[0], i), 0, 0]) {
        tile_stack(
          tile_size,
          token_stack_counts[i],
          box_size[2],
          bottom_cutout=true,
          lid_height=$lid_height
        );
      }
    }

    centre_bullets = (
      padded_offset(tile_size[0], len(token_stack_counts))
      - padded_offset(bullet_diameter, len(bullet_stack_counts))
    ) / 2;

    translate([centre_bullets, padded_offset(tile_size[1]), 0]) {
      for (i=[0:len(bullet_stack_counts)-1]) {
        translate([padded_offset(bullet_diameter, i), 0, 0]) {
          tile_stack_round(
            bullet_diameter,
            bullet_height,
            bullet_stack_counts[i],
            box_size[2],
            top_cutout=true,
            lid_height=$lid_height
          );
        }
      }
    }
  }

  rotate([0, 0, 90]) {
    translate([0, -rotated_box_size[1], 0]) {
      dovetail_lid_cutout(rotated_box_size);
    }
  }
}
