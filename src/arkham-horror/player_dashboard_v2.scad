echo(version=version());

include <../../lib/rounded_cube.scad>
include <../../lib/elephant_foot.scad>
include <../../lib/svg_icon.scad>
use <../../assets/fonts/Teutonic.ttf>

// Config
$wall_thickness = 4;
$bleed = 1;
$fn = 4;
// $fn = 50;
skip_cubes = false;

// Attributes
min_floor_height = 2;
cube_dish_height = 4;

card_width = 92;
card_length = 67;
card_gap = 0.5;

resource_cutout_width = 40;
action_min_width = 25;

cube_size = 9;

number_font_size = 8;
health_height = cube_size * 2 + number_font_size * 1.5;

number_depth = 0.8;
icon_depth = 0.5;

// Derived Attributes
base_dashboard_height = min_floor_height + cube_dish_height;

player_cutout_width = card_width + card_gap * 2;
player_cutout_length = card_length + card_gap * 2;

resource_cutout_length = player_cutout_length + health_height + $wall_thickness;

health_tray_width = max(
  player_cutout_width + action_min_width,
  100
);

action_full_width = health_tray_width - player_cutout_width;

dashboard_size = [
  resource_cutout_width + player_cutout_width + action_full_width + $wall_thickness * 2,
  resource_cutout_length + $wall_thickness*2, 
  base_dashboard_height
];

module letter(l, letter_size, halign="center", valign="center") {
  font = "Teutonic";
  letter_height = 1;

  // Use linear_extrude() to make the letters 3D objects as they
  // are only 2D shapes when only using text()
  linear_extrude(height = letter_height) {
    text(l, size=letter_size, font=font, halign=halign, valign=valign, $fn=16);
  }
}

module health_tray() {
  cube_foot_rounding = 1;
  cube_foot_size = cube_size + cube_foot_rounding * 2;

  foot_size = [
    cube_foot_size,
    cube_foot_size,
    cube_dish_height
  ];

  cube_rows = 2;
  cube_cols = 10;

  icon_target_size = [
    9,
    9,
  ];

  cube_array_width = cube_foot_size * cube_cols;
  icon_offset = health_tray_width - cube_array_width + cube_foot_rounding;
  icon_width_buffer = icon_offset - icon_target_size[0];
  heart_length_adjustment = 1;
  letter_length_offset = $wall_thickness + cube_foot_size * 2 + $bleed;

  heart_file = "../../assets/images/arkham_horror_lcg_heart_token.svg";
  heart_size = [
    100,
    100
  ];
  translate([
    icon_width_buffer,
    cube_foot_size + heart_length_adjustment,
    base_dashboard_height -icon_depth
  ]) {
    svg_icon(heart_file, icon_depth + $bleed, heart_size, icon_target_size);
  }

  brain_file = "../../assets/images/arkham_horror_lcg_brain_token.svg";
  brain_size = [
    100,
    100
  ];
  translate([
    icon_width_buffer,
    0,
    base_dashboard_height -icon_depth
  ]) {
    svg_icon(brain_file, icon_depth + $bleed, brain_size, icon_target_size);
  }

  translate([icon_offset, 0, 0]) {
    for(i=[0:cube_cols-1]) {
      translate([i * foot_size[0], 0, 0]) {
        translate([cube_foot_size / 2, letter_length_offset, base_dashboard_height - number_depth]) {
          letter(str(i), number_font_size);
        }
  
        if (!skip_cubes) {
          for(j=[0:cube_rows-1]) {
            translate([0, j * cube_foot_size, min_floor_height]) {
              // cache rendered foot for faster preview
              render() elephant_foot(
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
  }
}

module player_card_tray() {
  top_notch_size = [
    60,
    25,
    base_dashboard_height + $bleed * 2,
  ];

  card_cutout_depth = 2;
  top_notch_inset = (player_cutout_width - top_notch_size[0]) / 2;

  render() translate([0, 0, base_dashboard_height - card_cutout_depth]) {

    cube([
      player_cutout_width,
      player_cutout_length,
      card_cutout_depth + $bleed
    ]);

    translate([player_cutout_width / 2, player_cutout_length / 2, -icon_depth]) {
      letter("Arkham Horror");
    }
  }

  translate([top_notch_inset, player_cutout_length - top_notch_size[1] + $wall_thickness + $rounding, -$bleed])  {
    notch(top_notch_size);
  }
}

module magnet_hole() {
  magnet_diameter = 3.4;
  magnet_height = 1;

  translate([magnet_diameter / 2, magnet_diameter / 2, -magnet_height]) {
    cylinder(h=magnet_height + $bleed, d=magnet_diameter);
  }
}

module action_tray() {
  action_cutout_depth = 3;
  action_card_inset = 1;

  // TODO not sure if used
  action_card_height = 0.7;

  action_tray_size = [
    action_full_width + $wall_thickness + $bleed,
    player_cutout_length + $wall_thickness + $bleed,
    action_cutout_depth + $bleed
  ];

  action_cutout_height = min_floor_height + 1;

  magnet_inset = 0.5;
  magnet_positions = [
    [magnet_inset, magnet_inset],
    [action_full_width - magnet_inset, magnet_inset],
    [action_full_width - magnet_inset, player_cutout_length - magnet_inset],
    [magnet_inset, player_cutout_length - magnet_inset],
  ];


  translate([0, 0, action_cutout_height]) {
    cube(action_tray_size);

    translate([0, 0, magnet_inset]) {
      cube([
        action_tray_size[0] - 4,
        action_tray_size[1] - 4,
        action_card_inset + $bleed
      ]);
    }

    for(p=magnet_positions) {
      translate(p) {
        magnet_hole();
      }
    }
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

module resource_tray() {
  resource_file = "../../assets/images/arkham_horror_lcg_resource_token.svg";
  resource_size = [
    211,
    250
  ];

  clue_file = "../../assets/images/arkham_horror_lcg_clue_token.svg";
  clue_size = [
    72,
    72
  ];

  resource_cutout_size = [
    resource_cutout_width,
    resource_cutout_length,
    base_dashboard_height - min_floor_height + $bleed
  ];

  icon_target_size = [
    resource_cutout_width / 3,
    resource_cutout_width / 3
  ];

  icon_offset = (resource_cutout_width - icon_target_size[0]) / 2;

  translate([0, 0, min_floor_height]) {
    rounded_cube(resource_cutout_size, flat=true);

    translate([
      icon_offset,
      resource_cutout_length - icon_offset - icon_target_size[1],
      -icon_depth
    ]) {
      svg_icon(resource_file, icon_depth + $bleed, resource_size, icon_target_size);
    }
  
    translate([
      icon_offset,
      icon_offset,
      -icon_depth
    ]) {
      svg_icon(clue_file, icon_depth + $bleed, clue_size, icon_target_size);
    }
  }
}

module player_dashboard() {
  // Positioning
  resource_tray_width_offset = resource_cutout_width + $wall_thickness;
  health_length_offset = health_height + $wall_thickness;
  player_card_offset = resource_tray_width_offset + player_cutout_width;
  
  // Model
  difference() {
    rounded_cube(dashboard_size, flat=true);
  
    // Place all trays inside wall bufer
    translate([$wall_thickness, $wall_thickness, 0]) {
      resource_tray();
  
      // Place health tray to the right of the resource tray 
      translate([resource_tray_width_offset, 0, 0]) {
        health_tray();
      }
  
      // Place card tray to the right of the resource tray 
      translate([resource_tray_width_offset, health_length_offset, 0]) {
        player_card_tray();
      }
  
      // Place action tray immediately next to player card tray
      translate([player_card_offset, health_length_offset, 0]) {
        action_tray();
      }
    }
  }
}

player_dashboard();
