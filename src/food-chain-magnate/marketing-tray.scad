include <../../lib/primitive/rounded_cube.scad>
include <../../lib/primitive/trapezoid.scad>
include <../../lib/compound/tile_stack.scad>
include <../../lib/layout/grid_utils.scad>
include <../../lib/lid/dovetail_lid.scad>
include <./marketing-config.scad>

$fn = 50;

trapezoid_size = [
  square_size[0] + $padding * 2,
  $wall_thickness + $bleed * 2,
  $lid_height + $bleed,
];
trapezoid_inset = 0.8;

difference() {
  rounded_cube(box_size, flat_top=true, $rounding=1);
  translate([$wall_thickness, 0]) {
    for (x=[0:len(tile_map)-1]) {
      for (y=[0:len(tile_map[x])-1]) {
        translate([
          padded_offset(tile_sizes[4][0], x)
            + align_x(x, tile_size_map[x][y][0]),
          reverse_padded_list_offset(box_size[1], tile_size_map[x], y, 1),
          0,
        ]) {
          tile_cutout_with_slant(tile_size_map[x][y], box_size[2]);
          tile_cutout_with_slant(tile_sizes[1], box_size[2] - square_size[2]);
        }
      }
    }
  }
  dovetail_lid_cutout(box_size);

  inset = 4;
  translate([inset + $wall_thickness, 0, box_size[2] - $lid_height]) {
    rotate([180, 0, 0]) {
      translate([0, -trapezoid_size[1], -$lid_height - $bleed]) {
        linear_extrude($lid_height + $bleed) trapezoid(trapezoid_size - [inset, 0, 0], trapezoid_inset);
      }
    }
    translate([0, box_size[1] - trapezoid_size[1], 0]) {
      linear_extrude($lid_height + $bleed) trapezoid(trapezoid_size - [inset, 0, 0], trapezoid_inset);
    }
  }

  translate([box_size[0] - padded_rect(square_size)[0] - $wall_thickness, 0, box_size[2] - $lid_height]) {

    rotate([180, 0, 0]) {
      translate([0, -trapezoid_size[1], -$lid_height - $bleed]) {
        linear_extrude($lid_height + $bleed) trapezoid(trapezoid_size, trapezoid_inset);
      }
    }
    // trapezoid_prism(trapezoid_size, 0.3);
    /*
    cube([
      square_size[0] + $padding * 2,
      square_size[1],
      $lid_height+$bleed
    ]);
    */
  }
}
