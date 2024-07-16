include <../../lib/primitive/rounded_cube.scad>
include <../../lib/config/minimum_constants.scad>

$fn = 50;

box_side_length = 190;

top_to_large_cards_gap_length = 64;
left_to_large_cards_gap_width = 122;

middle_gap_length = 37;

top_right_square_width = box_side_length - left_to_large_cards_gap_width + middle_gap_length;
top_right_square_height = 96.5;

clearance_height = 35;

padding = 1;
top_right_box_size = [
  96.5, 
  70 + padding,
  20.85, 
];

length_1 = box_side_length;
width_1 = top_to_large_cards_gap_length;
height_1 = clearance_height;

offset = [
  0, 
  left_to_large_cards_gap_width - middle_gap_length,
  0,
];

length_2 = top_right_square_width;
width_2 = top_right_box_size[0];
height_2 = clearance_height;

difference() {
  union() {
    rounded_cube([width_1, length_1, height_1], $rounding=1);
    translate(offset) {
      rounded_cube([width_2, length_2, height_2], $rounding=1);
    } 
  }
  translate([-$bleed, box_side_length - top_right_box_size[1], 23]) {
    cube(top_right_box_size + [$bleed * 2, 0, $bleed]);
  }
}
