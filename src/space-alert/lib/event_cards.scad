include <../../../lib/rounded_cube.scad>
include <../../../lib/layout.scad>
include <../../../lib/cutouts.scad>

// Config
$fn = 50;
// $fn = 10;
$wall_thickness = 2;
$padding = 2;
$rounding = 2;
$bleed = 0.01;
$cutout_fraction = 0.8;

stack_gap = 10;

module event_cards(with_tokens) {
  card_size = [
    61.2,
    103.5,
    6,
  ];
  card_stack_count = 2;

  token_base_size = [
    padded_offset(card_size[0], card_stack_count) + stack_gap + $wall_thickness,
    50,
    2.1 + $wall_thickness,
  ];
  
  box_size = [
    padded_offset(card_size[0], card_stack_count) + stack_gap + $wall_thickness,
    padded_offset(card_size[1]) 
      + $wall_thickness,
    stack_height(card_size[2]) + $wall_thickness,
  ];
  
  difference() {
    union() {
      rounded_cube(box_size, flat_top=true);
  
      if (with_tokens) {
        translate([0, padded_offset(card_size[1]) - $wall_thickness, 0]) {
          rounded_cube(token_base_size);

          translate([$wall_thickness * 2, $wall_thickness * 3, token_base_size[2] - $bleed]) {
            linear_extrude(10 + $bleed) {
              offset_circle(10);
            }
          }
        }
      }
    }
  
    translate([$wall_thickness, $wall_thickness, 0]) {
      for(i=[0:card_stack_count-1]) {
        translate([padded_offset(card_size[0] + stack_gap, i), 0, 0]) {
          tile_cutout(card_size, 1, box_size[2], left_cutout=true, right_cutout=true);
        }
      }
    }
  }
}
