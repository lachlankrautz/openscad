echo(version=version());

include <../../lib/rounded_cube.scad>
include <../../lib/tile_tray.scad>

// Config
$fn = 50;
// $fn = 10;

function get_offset (size, index=1, padding=0) = (size + padding * 2 + $wall_thickness) * index;

market_tile_count = 6;
market_tile_size = [
  45, 
  96, 
  2.2,
];

crude_market_tile_count = 6;
crude_market_tile_size = [
  49, 
  35, 
  2.2,
];

action_tile_count = 4;
action_tile_size = [
  29, 
  60, 
  2.2,
];

refinement_tile_count = 4;
refinement_tile_size = [
  15,
  15,
  2.2,
];
refinement_rows = 3;

padding = 0.4;
cylinder_diameter = 15 + padding * 2;
cylinder_height = 15 + padding;
disc_height = 5;

meeple_size = [
  17 + padding * 2,
  25 + padding * 2,
  8 + padding * 2,
];
meeple_count = 4;

cutout_height = cylinder_height / 2;

corner_cut_size = [
  5,
  5,
  cutout_height,
];

box_size = [
  get_tile_offset(market_tile_size[0]) + get_tile_offset(action_tile_size[0]) + $wall_thickness,
  get_tile_offset(market_tile_size[1]) 
    + get_tile_offset(crude_market_tile_size[1]) 
    + get_offset(meeple_size[1]) 
    + cylinder_diameter
    + $wall_thickness * 3,
  cylinder_height + $wall_thickness,
];

difference() {
  rounded_cube(box_size, flat_top=true, $rounding=2);

  translate([
    -$bleed, 
    get_tile_offset(market_tile_size[1])
      + get_tile_offset(crude_market_tile_size[1])
      + $wall_thickness, 
    box_size[2] - cutout_height
  ]) {
    cube([
      box_size[0] + $bleed * 2, 
      50, 
      cutout_height + $bleed,
    ]);

    translate([$wall_thickness, $wall_thickness, 0]) {
      for(i=[0:meeple_count-1]) {
        translate([get_offset(meeple_size[0], i), 0, 0]) {
          translate([0, 0, -meeple_size[2] / 2]) {
            rounded_cube(meeple_size, flat=true);
          }

          translate([
            (meeple_size[0] - cylinder_diameter) / 2 + cylinder_diameter / 2, 
            get_offset(meeple_size[1]) + cylinder_diameter / 2, 
            -disc_height / 2,
          ]) {
            cylinder(d=cylinder_diameter, h=cylinder_height);
          }
        }
      }
    }
  }

  translate([$wall_thickness, $wall_thickness, 0]) {
    // Market
    tile_cutout(market_tile_size, market_tile_count, roof_height=box_size[2], left_cutout=true);

    // Crude Market
    translate([0, get_tile_offset(market_tile_size[1]), 0]) {
      tile_cutout(crude_market_tile_size, crude_market_tile_count, roof_height=box_size[2], left_cutout=true);
    }

    // Action
    translate([get_tile_offset(market_tile_size[0]), 0, 0]) {
      tile_cutout(action_tile_size, action_tile_count, roof_height=box_size[2], right_cutout=true);
    }

    // Cutout half height section
    translate([
      box_size[0] - cylinder_diameter - $wall_thickness * 3,
      get_tile_offset(action_tile_size[1]) + get_tile_offset(refinement_tile_size[1], refinement_rows), 
      box_size[2] - cylinder_height * 0.5
    ]) {
      rounded_cube([
        cylinder_diameter + 15, 
        cylinder_diameter + 15, 
        cutout_height + $bleed,
      ], flat=true);
    }
    translate([
      box_size[0] - cylinder_diameter - $wall_thickness * 3 - corner_cut_size[0],
      get_tile_offset(market_tile_size[1])
        + get_tile_offset(crude_market_tile_size[1])
        - corner_cut_size[1],
      box_size[2] - cylinder_height / 2
    ]) {
      difference() {
        cube([
          corner_cut_size[0] + $bleed,
          corner_cut_size[1] + $bleed,
          corner_cut_size[2] + $bleed,
        ]);

        cylinder(r=corner_cut_size[0], h=corner_cut_size[2] + $bleed * 2);
      }
    }


    // Refinement
    translate([box_size[0] - get_tile_offset(refinement_tile_size[0]) - $wall_thickness, get_tile_offset(action_tile_size[1]), 0]) {
      for(i=[0:refinement_rows-1]) {
        translate([0, get_tile_offset(refinement_tile_size[1], i), 0]) {
          tile_cutout(refinement_tile_size, refinement_tile_count, roof_height=box_size[2], right_cutout=true);
        }
      }
      translate([0, get_tile_offset(refinement_tile_size[1], refinement_rows), box_size[2] - cylinder_height]) {
        translate([cylinder_diameter / 2, cylinder_diameter / 2 + $wall_thickness, 0]) {
          cylinder(d=cylinder_diameter, h=cylinder_height + $bleed, center=false);
        }
      }
    }
  }
}
