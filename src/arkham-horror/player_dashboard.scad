echo(version=version());

include <../../lib/rounded_cube.scad>

// config
$wall_thickness = 4;
$bleed = 1;
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
  player_cutout_size[1] + health_height*2 + $wall_thickness*2,
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

// Model

difference() {
  cube(dashboard_size);

  translate([$wall_thickness, $wall_thickness, floor_height]) {
    cube(resource_cutout_size);
    translate([resource_cutout_size[0] + $wall_thickness, 0, 0]) {
      cube(health_cutout_size);
      translate([0, health_cutout_size[1] + $wall_thickness, 0]) {
        cube(player_cutout_size);
      }
      translate([0, health_cutout_size[1] + player_cutout_size[1] + $wall_thickness*2, 0]) {
        cube(health_cutout_size);
      }
    }
  }
}
