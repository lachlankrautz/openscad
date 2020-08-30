echo(version=version());

include <../../lib/rounded_cube.scad>

// Config
$wall_thickness = 4;
$bleed = 1;
$fn = 50;
floor_height = 2;
cutout_depth = 3;

// Attributes
card_width = 92;
card_length = 67;
card_gap = 1;

resource_width = 40;

health_height = 25;

// Derived Attributes
height = floor_height + cutout_depth;

player_cutout_size = [
  card_width + card_gap*2,
  card_length + card_gap*2,
  cutout_depth + $bleed
];

resource_cutout_size = [
  resource_width,
  player_cutout_size[1] + health_height + $wall_thickness,
  cutout_depth + $bleed
];

health_cutout_size = [
  player_cutout_size[0],
  health_height,
  cutout_depth + $bleed
];

dashboard_size = [
  resource_width + player_cutout_size[0] + $wall_thickness * 3,
  resource_cutout_size[1] + $wall_thickness*2, 
  height
];

hole_size = [
  player_cutout_size[0] * 0.75,
  player_cutout_size[1] * 0.75,
  floor_height + $bleed*2
];

hole_offset = [
  (player_cutout_size[0] - hole_size[0]) / 2,
  (player_cutout_size[1] - hole_size[1]) / 2,
  -(floor_height+$bleed)
];

// Model
difference() {
  // Draw starting dashbaord
  rounded_cube(dashboard_size, flat=true);
  // Inset for outter walls
  translate([$wall_thickness, $wall_thickness, floor_height]) {
    // Cutout left resource tray
    rounded_cube(resource_cutout_size, flat=true);
    translate([resource_cutout_size[0] + $wall_thickness, 0, 0]) {
      // Cutout bottom health cubes
      for (i=[0:10]) {
        translate([i*6, 0, 0]) {
          rounded_cube([5, 5, 5 + $bleed], $rounding=1);
        }
        translate([i*6, 15, 0]) {
          rounded_cube([5, 5, 5 + $bleed], $rounding=1);
        }
      }

      translate([0, health_cutout_size[1] + $wall_thickness, 0]) {
        // Cutout player card tray
        cube(player_cutout_size);
        translate(hole_offset) {
          // Cutout player card hole
          rounded_cube(hole_size, flat=true);
        }
      }
    }
  }
}
