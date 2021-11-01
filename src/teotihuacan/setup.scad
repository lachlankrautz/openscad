include <../../lib/primitive/rounded_cube.scad>
include <../../lib/compound/notched_cube.scad>
include <../../lib/primitive/disc_socket.scad>
include <../../lib/layout/layout.scad>
include <../../lib/tile_stack.scad>

// Config
$fn = 50;

// Season
season_tile_count = 8;
season_tile_size = [
  60,
  40, 
  2.2,
];

// Royal tiles
royal_tile_count = 11;
royal_tile_size = [
  55,
  40, 
  2.2,
];

// Temple bonus tiles
temple_bonus_count = 7;
temple_bonus_tile_size = [
  38.5,
  19.5,
  2.2,
];

// Technology tiles
technology_tile_count = 10;
technology_tile_stack_count = 2;
technology_tile_size = [
  36,
  45,
  2.2,
];

building_size = [
  12.2,
  12.2,
  16.5,
];
building_count = 5;
building_count_2 = 6;

building_length = pad(building_size[1]);
building_width = pad(building_size[0] * building_count);
building_width_2 = pad(building_size[0] * building_count_2);

eclipse_diameter = 15;
eclipse_height = 10;
eclipse_count = 2;

swoosh_height = building_size[2] / 2 + 2;

box_size = [
  max(
    padded_offset(season_tile_size[0])
      + padded_offset(technology_tile_size[0])
      + $wall_thickness,
    disc_offset(eclipse_diameter, eclipse_count)
      + building_width_2
      + $wall_thickness * 2
  ),
  max(
    padded_offset(technology_tile_size[1], technology_tile_stack_count)
      + building_length * 2
      + $wall_thickness,
    padded_offset(season_tile_size[1])
      + padded_offset(royal_tile_size[1])
      + padded_offset(temple_bonus_tile_size[1])
      + disc_offset(eclipse_diameter)
  ) + $wall_thickness * 2,
  stack_height(royal_tile_size[2], royal_tile_count)
    + $wall_thickness,
];

module fillet() {
   padded_offset(r=-$rounding) {
     padded_offset(delta=$rounding) {
       children();
     }
   }
}

module swish() {
  start_w = -$bleed;
  start_l = -$bleed;
  end_w = box_size[0] + $bleed;

  temple_w = padded_offset(temple_bonus_tile_size[0]) + $wall_thickness * 2+ $rounding;
  eclipse_l = disc_offset(eclipse_diameter) + $wall_thickness - $rounding;
  buildings_l = building_length * 2 + $wall_thickness * 3 - $rounding;

  linear_extrude(swoosh_height + $bleed) {
    fillet() {
      minkowski() {
        polygon([
          [start_w, start_l],
          [start_w, eclipse_l],
          [temple_w, eclipse_l],
          [temple_w, buildings_l],
          [end_w, buildings_l],
          [end_w, start_l],
        ]);
        circle($rounding);
      }
    }
  }
}

difference() {
  rounded_cube(box_size, flat_top=true, $rounding=2);

  translate([0, 0, box_size[2] - swoosh_height]) {
    swish();

    // Layout buildings right of eclipse and above other buildings
    translate([
      box_size[0] - building_width - $wall_thickness, 
      building_length + $wall_thickness * 2,
      0 - building_size[2] / 2
    ]) {
      rounded_cube([
        building_width,
        building_length,
        building_size[2] / 2 + $bleed,
      ], flat=true, $rounding=1);
    }
  }

  translate([$wall_thickness, $wall_thickness, 0]) {
    // Eclipse
    for(i=[0:eclipse_count-1]) {
      translate([disc_offset(eclipse_diameter, i), 0, 0]) {
        disc_socket(eclipse_diameter, eclipse_height, box_size[2] - swoosh_height);
      }
    }

    // Buildings
    translate([
      disc_offset(eclipse_diameter, eclipse_count), 
      0, 
      box_size[2] - swoosh_height - building_size[2] / 2
    ]) {
      rounded_cube([
        building_width_2,
        building_length,
        building_size[2] / 2 + $bleed,
      ], flat=true, $rounding=1);
    }

    // Temple bonus
    translate([0, disc_offset(eclipse_diameter) + $wall_thickness, 0]) {
      tile_stack(temple_bonus_tile_size, temple_bonus_count, box_size[2], left_cutout=true);

      // Royal
      translate([0, padded_offset(temple_bonus_tile_size[1]), 0]) {
        tile_stack(royal_tile_size, royal_tile_count, box_size[2], left_cutout=true);
    
        // Season
        translate([0, padded_offset(royal_tile_size[1]), 0]) {
          tile_stack(season_tile_size, season_tile_count, box_size[2], left_cutout=true);
        }
      }
    }
  }

  // Technology
  translate([
    box_size[0]
      - padded_offset(technology_tile_size[0]),
    box_size[1] 
      - padded_offset(technology_tile_size[1], technology_tile_stack_count),
    0
  ]) {
    for(i=[0:technology_tile_stack_count-1]) {
      translate([0, padded_offset(technology_tile_size[1], i), 0]) {
        tile_stack(technology_tile_size, technology_tile_count, box_size[2], right_cutout=true);
      }
    }
  }
}
