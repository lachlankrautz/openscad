echo(version=version());

include <../../lib/rounded_cube.scad>
include <../../lib/elephant_foot.scad>
use <../../fonts/Teutonic.ttf>

// Config
$wall_thickness = 4;
$bleed = 1;
// $fn = 50;
floor_height = 2;
cutout_depth = 3;
card_gap = 1;
cube_foot_rounding = 1;

// Attributes
card_width = 92;
card_length = 67;

resource_width = 40;
action_width = 30;

health_height = 27;

cube_count = 10;
cube_size = 9;
cube_dish_height = 4;

// Derived Attributes
height = floor_height + cutout_depth;
cube_foot_size = cube_size + cube_foot_rounding * 2;

player_cutout_size = [
  card_width + card_gap * 2,
  card_length + card_gap * 2,
  cutout_depth + $bleed
];

resource_cutout_size = [
  resource_width,
  player_cutout_size[1] + health_height + $wall_thickness,
  cutout_depth + $bleed
];

action_tray_size = [
  action_width,
  player_cutout_size[1],
  cutout_depth + $bleed
];

health_length_offset = health_height + $wall_thickness * 2;
health_tray_width = player_cutout_size[0] + action_width + $wall_thickness;
cube_array_width = cube_foot_size * cube_count;
resource_tray_width_offset = resource_width + $wall_thickness * 2;

module base_dashboard() {
  dashboard_size = [
    resource_width + player_cutout_size[0] + action_tray_size[0] + $wall_thickness * 4,
    resource_cutout_size[1] + $wall_thickness*2, 
    height
  ];

  rounded_cube(dashboard_size, flat=true);
}

module letter(l) {
  font = "Teutonic";
  letter_size = 5;
  letter_height = 3;

  // Use linear_extrude() to make the letters 3D objects as they
  // are only 2D shapes when only using text()
  linear_extrude(height = letter_height) {
    text(l, size=letter_size, font=font, halign="center", valign="center", $fn=16);
  }
}

module health_and_sanity_board() {
  foot_size = [
    cube_foot_size,
    cube_foot_size,
    cube_dish_height
  ];
  icon_offset = health_tray_width - cube_array_width + cube_foot_rounding;

  translate([icon_offset, 0, 0]) {
    for(i=[0:cube_count-1]) {
      translate([i * foot_size[0], 0, 0]) {
        translate([cube_foot_size / 2, cube_foot_size * 2.3, cutout_depth - 1]) {
          letter(str(i));
        }
  
        translate([0, 0, -cube_foot_rounding]) {
          elephant_foot(
            foot_size, 
            flat_bottom=true, 
            use_bleed=true, 
            $rounding=cube_foot_rounding
          );
        }
  
        translate([0, cube_foot_size, -cube_foot_rounding]) {
          elephant_foot(
            foot_size, 
            flat_bottom=true, 
            use_bleed=true, 
            $rounding=cube_foot_rounding
          );
        }
      }
    }
  }
}

module player_card_tray() {
  top_notch_size = [
    60,
    25,
    height + $bleed * 2,
  ];

  top_notch_inset = (player_cutout_size[0] - top_notch_size[0]) / 2;

  translate([resource_tray_width_offset, health_length_offset, 0]) {
    translate([0, 0, floor_height]) {
      cube(player_cutout_size);
    }

    translate([top_notch_inset, player_cutout_size[1] - top_notch_size[1] + $wall_thickness + $rounding, -$bleed])  {
      notch(top_notch_size);
    }
  }
}

module action_tray() {
  action_offset = resource_tray_width_offset + player_cutout_size[0] + $wall_thickness;
  translate([action_offset, health_length_offset, floor_height]) {
    rounded_cube(action_tray_size, flat=true);
  }
}

module fillet() {
   offset(r=-$rounding) {
     offset(delta=$rounding) {
       children();
     }
   }
}

module notch(size) {
  notch_buffer = 5;
  // $rounding * 4!
  // *2 from minkowski
  // *2 from fillet
  notch_depth = size[1] - $rounding * 4;
  notch_width = size[0] - $rounding * 4;
  notch_lower_width = notch_width / 2;
  notch_slope_width = (notch_width - notch_lower_width) / 2;

  $fn = 50;
  translate([0, $rounding * 4, 0]) {
    linear_extrude(size[2]) {
      fillet() {
        minkowski() {
          polygon([
            [notch_buffer + notch_slope_width, 0], 
            [notch_buffer, notch_depth], 
            [0, notch_depth], 
            [0, notch_depth + notch_buffer], 
            [notch_buffer * 2 + notch_width, notch_depth + notch_buffer],
            [notch_buffer * 2 + notch_width, notch_depth],
            [notch_buffer + notch_slope_width * 2 + notch_lower_width, notch_depth], 
            [notch_buffer + notch_slope_width + notch_lower_width, 0]
          ]);
          circle($rounding);
        }
      }
    }
  }
}

// Model
difference() {
  base_dashboard();

  // Resource tray
  translate([$wall_thickness, $wall_thickness, floor_height]) {
    rounded_cube(resource_cutout_size, flat=true);
  }

  // Health and sanity tray
  translate([resource_tray_width_offset, $wall_thickness, floor_height]) {
    health_and_sanity_board();
  }

  player_card_tray();

  action_tray();
}
