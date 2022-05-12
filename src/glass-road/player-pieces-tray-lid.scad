include <./config/player-pieces-config.scad>

spin = 2;

// This is so messy

length_tolerance = 0.25;
width_tolerance = 0.12;
bump_tolerance = 0.2;

card_cutout_size = padded_card_size(standard_usa_sleeved_card_size, card_stack_height + $bleed);

card_border_size = [
  card_cutout_size[0] + $wall_thickness,
  card_cutout_size[1] + $wall_thickness * 2,
  card_stack_height + $lid_height - $bleed,
];

card_border_offset = [
  $wall_thickness + length_tolerance,
  $trapezoid_inset + 10,
  0,
];
card_cutout_offset = card_border_offset + [
  0,
  $wall_thickness,
  -$bleed,
];

echo("card cutout: ", card_cutout_size);

rotate([0, 180, 0]) {
  translate([0, 0, -card_stack_height - $lid_height]) {
    difference() {
      union() {
        spin_orientation(box_size, spin) {
          dovetail_lid(
            spin_orientation_size(box_size, spin),
            honeycomb_diameter=20,
            lid_height = card_stack_height + $lid_height,
            elephant_foot_compensation=false
          );
        }

        translate(card_border_offset) {
          rounded_cube(card_border_size, flat=true, hollow=true, $rounding=1);
        }
      }

      translate(card_cutout_offset + [-5, 0, 0]) {
        rounded_cube(card_cutout_size + [5, 0, 0], flat=true, $rounding=1);
      }
    }
  }
}
