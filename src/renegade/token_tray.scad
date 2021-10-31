include <../../lib/primitive/rounded_cube.scad>
include <../../lib/primitive/scoop.scad>
include <../../lib/layout/layout.scad>
include <../../lib/compound/notched_cube.scad>
include <../../lib/util/util_functions.scad>
include <../../lib/tile_stack_round.scad>
include <../../lib/lid/dovetail_lid.scad>
include <../../lib/tile_stack.scad>

// Config
$fn = 50;
$wall_thickness = 2;
$bleed = 0.01;
// $fn = 10;

tile_map = [
  [5, 5, 5, 5, 5],
];

tile_columns = len(tile_map[0]);
tile_rows = len(tile_map);
max_stack_count = max(flatten(tile_map));

tile_size = [
  23,
  23,
  2,
];
round_tile_count = 3;
tile_diameter = 26;

box_size = [
  186,
  114,
  29,
];

module tray_with_cutouts() {
  scoop_count = 4;
  scoop_size = [
    (box_size[0] - $wall_thickness * (scoop_count + 1)) / scoop_count,
    box_size[1] - padded_offset(tile_diameter) - $wall_thickness * 2,
    box_size[2] - $wall_thickness + $bleed,
  ];

  difference() {
    rounded_cube(box_size, flat_top=true, $rounding=2);

    translate([$wall_thickness, 0, 0]) {
      // token stacks
      for(i=[0:tile_columns-1]) {
        translate([padded_offset(tile_size[0], i), box_size[1] - padded_offset(tile_size[1]), 0]) {
          tile_stack(
            tile_size,
            tile_map[0][i],
            box_size[2] - $wall_thickness,
            top_cutout=true
          );
        }
      }
    }

    // Circle tile stack
    translate([
      box_size[0] - padded_offset(tile_diameter),
      box_size[1] - padded_offset(tile_diameter),
      0
    ]) {
      tile_stack_round(
        tile_diameter,
        tile_size[2],
        round_tile_count,
        box_size[2] - $wall_thickness,
        top_cutout=true
      );
    }

    // round token trays
    translate([$wall_thickness, $wall_thickness, $wall_thickness]) {
      for(i=[0:scoop_count-1]) {
        translate([offset(scoop_size[0], i), 0, 0]) {
          scoop(scoop_size, rounded=false, edge="bottom");
        }
      }
    }
  }
}

module tray_with_lid() {
  difference() {
    tray_with_cutouts();

    translate([box_size[0], 0, 0]) {
      rotate([0, 0, 90]) {
        dovetail_lid_cutout([box_size[1], box_size[0], box_size[2]]);
      }
    }
  }
}

module lid() {
  translate([box_size[0] + 5, box_size[1] - $wall_thickness, 0]) {
    rotate([0, 0, -90]) {
      dovetail_lid([box_size[1], box_size[0], box_size[2]], honeycomb_diameter = 12);
    }
  }
}

tray_with_lid();

lid();
