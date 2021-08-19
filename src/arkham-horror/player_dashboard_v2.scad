include <../../lib/rounded_cube.scad>
include <../../lib/layout.scad>
include <../../lib/elephant_foot.scad>
include <../../lib/svg_icon.scad>
use <../../assets/fonts/Teutonic.ttf>

// Config
$wall_thickness = 4;
$bleed = 1;
// $fn = 4;
$fn = 50;
skip_cubes = false;
$abs_filament = true;

// Attributes
magnet_diameter = 3.4;
min_floor_height = 2;
cube_dish_height = 4;

card_width = 91;
card_length = 65.5;

// more padding for ABS
card_gap = $abs_filament 
  ? 1 
  : 0.5;

action_tray_gap = 2;

resource_cutout_width = 40;

cube_cols = 10;
// cube_cols = 2;
cube_icon_gap = 1;
cube_size = 9;
cube_foot_rounding = 1;

number_font_size = 8;

number_depth = 0.8;
icon_depth = 0.5;

health_icon_size = [
  9,
  9,
];

// Derived Attributes
cube_foot_size = cube_size + cube_foot_rounding * 2;

action_number_width = number_font_size + action_tray_gap;
action_min_width = action_number_width + cube_foot_size;

health_height = cube_size * 2 + number_font_size * 1.5;
base_dashboard_height = min_floor_height + cube_dish_height;

player_cutout_width = card_width + card_gap * 2;
player_cutout_length = card_length + card_gap * 2;

resource_cutout_length = player_cutout_length + health_height + $wall_thickness;

health_tray_min_width = cube_foot_size * cube_cols + health_icon_size[0] + cube_icon_gap;
health_tray_width = max(
  player_cutout_width + action_min_width + $wall_thickness,
  health_tray_min_width
);

action_full_width = health_tray_width - player_cutout_width - $wall_thickness;

dashboard_size = [
  resource_cutout_width + player_cutout_width + action_full_width + $wall_thickness * 4,
  resource_cutout_length + $wall_thickness * 2, 
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
  left_buffer = health_tray_width - health_tray_min_width;

  cube_rows = 2;
  heart_length_adjustment = 1;
  letter_length_offset = $wall_thickness + cube_foot_size * 2 + $bleed;

  heart_file = "../../assets/images/arkham_horror_lcg_heart_token.svg";
  heart_size = [
    100,
    100
  ];
  translate([
    left_buffer,
    cube_foot_size + heart_length_adjustment,
    base_dashboard_height -icon_depth
  ]) {
    svg_icon(heart_file, number_depth + $bleed, heart_size, health_icon_size);
  }

  brain_file = "../../assets/images/arkham_horror_lcg_brain_token.svg";
  brain_size = [
    100,
    100
  ];
  translate([
    left_buffer,
    0,
    base_dashboard_height -icon_depth
  ]) {
    svg_icon(brain_file, number_depth + $bleed, brain_size, health_icon_size);
  }

  icon_offset = left_buffer + health_icon_size[0] + cube_icon_gap;
  foot_size = [
    cube_foot_size,
    cube_foot_size,
    cube_dish_height
  ];

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

  card_cutout_depth = 2.5;
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
  /*
  magnet_height = $abs_filament
    ? 1.2
    : 1;
  */
  magnet_height = 1.2;

  translate([magnet_diameter / 2, magnet_diameter / 2, -magnet_height]) {
    cylinder(h=magnet_height + $bleed, d=magnet_diameter);
  }
}

module action_tray() {
  slide_cube_count = 6;

  slide_length = cube_size * slide_cube_count + cube_foot_rounding * 2;

  action_tray_size = [
    cube_foot_size,
    slide_length,
    cube_dish_height
  ];

  action_icon_target_size = [
    8,
    8
  ];
  action_icon_offset_length = action_icon_target_size[1] * 0.75;

  hole_offset_width = (cube_foot_size - magnet_diameter) / 2;
  function hole_offset_length(i) = i * cube_size + hole_offset_width + action_icon_offset_length;
  letter_length_adjustment = (number_font_size - magnet_diameter) / 2;
  align_right_offset = action_full_width - action_min_width;

  action_file = "../../assets/images/arkham_horror_lcg_action_token.svg";
  action_icon_size = [
    100,
    100
  ];

  translate([align_right_offset, player_cutout_length - slide_length - action_icon_offset_length, 0]) {
    translate([action_number_width + 2.3, -2, base_dashboard_height -icon_depth]) {
      svg_icon(action_file, number_depth + $bleed, action_icon_size, action_icon_target_size);
    }

    translate([action_number_width, action_icon_offset_length, min_floor_height]) {
       render() elephant_foot(
        action_tray_size, 
        flat_bottom=true, 
        use_bleed=true, 
        $rounding=cube_foot_rounding
      );
    }

    if (slide_cube_count > 0) {
      for(i=[0:slide_cube_count-1]) {
        translate([0, hole_offset_length(i), 0]) {
          translate([number_font_size / 2, -letter_length_adjustment, base_dashboard_height - number_depth]) {
            letter(str(i), number_font_size, valign="bottom");
          }
          translate([action_number_width + hole_offset_width, 0, min_floor_height]) {
            magnet_hole();
          }
        }
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

module test_health_tray() {
  difference() {
    // TODO figure out clean positioning when other elements are absent
    translate([80, 0, 0]) {
      rounded_cube([
        40,
        40,
        base_dashboard_height
      ], flat=true);
    }

    translate([$wall_thickness, $wall_thickness, 0]) {
      health_tray();
    }
  }
}

module test_cube_slide() {
  slide_cube_count = 3;

  slide_length = cube_size * slide_cube_count + cube_foot_rounding * 2;
  gap = 2;

  foot_size = [
    cube_foot_size,
    slide_length,
    cube_dish_height
  ];

  number_width = number_font_size + gap;
  hole_offset_width = (cube_foot_size - magnet_diameter) / 2;
  function hole_offset_length(i) = i * cube_size + hole_offset_width;
  letter_length_adjustment = (number_font_size - magnet_diameter) / 2;

  difference() {
    rounded_cube([
      number_width + cube_foot_size + $wall_thickness * 2,
      slide_length + $wall_thickness * 2,
      base_dashboard_height
    ], flat=true);

    translate([$wall_thickness, $wall_thickness, 0]) {
      translate([number_width, 0, min_floor_height]) {
        render() elephant_foot(
          foot_size, 
          flat_bottom=true, 
          use_bleed=true, 
          $rounding=cube_foot_rounding
        );
      }

      if (slide_cube_count > 0) {
        for(i=[0:slide_cube_count-1]) {
          translate([0, hole_offset_length(i), 0]) {

            translate([number_font_size / 2, -letter_length_adjustment, base_dashboard_height - number_depth]) {
              letter(str(i), number_font_size, valign="bottom");
            }
            translate([number_width + hole_offset_width, 0, min_floor_height]) {
              magnet_hole();
            }
          }
        }
      }
    }
  }
}

module player_dashboard() {
  // Positioning
  resource_tray_width_offset = resource_cutout_width + $wall_thickness;
  health_length_offset = health_height + $wall_thickness;
  player_card_offset = resource_tray_width_offset + player_cutout_width + $wall_thickness;
  
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
// test_health_tray();
// test_cube_slide();
