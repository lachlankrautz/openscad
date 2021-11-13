include <./house-tray-config.scad>
include <../../lib/primitive/rounded_cube.scad>
include <../../lib/compound/tile_stack.scad>
include <../../lib/lid/dovetail_lid.scad>

$fn = 50;

difference() {
  rounded_cube(box_size, flat_top=true, $rounding=1);

  translate([$wall_thickness, $wall_thickness, 0]) {
    for(i=[0:1]) {
      translate([0, padded_offset(resturant_size[1], i), 0]) {
        tile_stack(
          resturant_size,
          resturant_counts[i],
          box_size[2],
          top_cutout=i == 1,
          bottom_cutout=i == 0,
          lid_height=$lid_height
        );
      }
    }

    translate([
      (padded_rect(resturant_size)[0] - padded_rect(square_size)[0]) / 2,
      padded_offset(resturant_size[1]) + padded_rect(resturant_size)[0] * 0.2,
      box_size[2] - stack_height(square_size[2], resturant_counts[1]) - square_size[2] - $wall_thickness
    ]) {
      rounded_cube(padded_rect(square_size) + [0, 0, $bleed], flat=true, $rounding=1);
      translate([
        0,
        padded_rect(square_size)[1] - padded_rect(square_size)[1] * 0.4,
        -$wall_thickness
      ]) {
        linear_extrude($wall_thickness + $bleed) {
          rounded_square([
            padded_rect(square_size)[0],
            padded_rect(square_size)[1] * 0.4
          ], flat_bottom=true, $rounding=1);
        }
      }
    }

    translate([padded_offset(resturant_size[0]), 0, 0]) {
      translate([0, padded_offset(garden_size[1]), 0]) {
        tile_stack(
          house_size,
          house_count,
          box_size[2],
          top_cutout=true,
          lid_height=$lid_height
        );
      }
      tile_stack(
        garden_size,
        garden_count,
        box_size[2],
        bottom_cutout=true,
        lid_height=$lid_height
      );
    }
  }

  dovetail_lid_cutout(box_size);
}
