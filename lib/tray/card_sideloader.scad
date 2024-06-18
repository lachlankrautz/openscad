include <../../lib/primitive/rounded_cube.scad>

// 15 small cards -> 11mm -> 0.733r per card
// 36 cards -> 24mm -> 0.66r per card
// 22 cards -> 15mm -> 0.68 per card
// card_thickness = 0.7;
card_thickness = 0.65;
function card_stack_height(card_count) = card_count * card_thickness;

// 80gsm -> 0.065mm
// 250gsm -> 0.23mm
default_indent_depth = 0.35;

module card_sideloader(
  card_size,
  card_count,

  create_display_indent = false,
  display_indent_depth = default_indent_depth,
  display_indent_margin = 2,

  create_access_cutout = false,

  fit_to_box_size = [0, 0, 0],

  wall_thickness = $wall_thickness,
  padding = $padding,
  bleed = $bleed
) {
  let(
    cutout_depth = 20,
    _rounding = 5,
    stack_height = card_stack_height(card_count),
    _display_indent_depth = create_display_indent ? display_indent_depth : 0,

    padded_card_stack_size = [
      // stacked cards can compress and do not need padding
      stack_height,
      card_size[1] + padding,
      // no need to pad the width as there is a wall thickness of overhang at the opening
      card_size[0],
    ],

    card_cutout=[
      padded_card_stack_size[0],
      padded_card_stack_size[1],
      padded_card_stack_size[2] + wall_thickness + bleed,
    ],

    natural_box_size=[
      padded_card_stack_size[0] + wall_thickness * 2 + _display_indent_depth,
      padded_card_stack_size[1] + wall_thickness * 2,
      padded_card_stack_size[2] + wall_thickness * 2,
    ],

    box_size=[
      max(natural_box_size[0], fit_to_box_size[2]),
      max(natural_box_size[1], fit_to_box_size[1]),
      max(natural_box_size[2], fit_to_box_size[0]),
    ],

    cutout_offset = [
      box_size[0] - natural_box_size[0],
      (box_size[1] - natural_box_size[1]) / 2,
      box_size[2] - natural_box_size[2],
    ]
  ) {
    difference() {
      // box
      rounded_cube(box_size, $rounding=1);

      // cards cutout
      translate([wall_thickness, wall_thickness, wall_thickness] + cutout_offset) {
        cube(card_cutout);
      }

      // display_indent
      if (create_display_indent) {
        translate([
          box_size[0] * 2 - display_indent_depth,
          display_indent_margin,
          display_indent_margin,
        ]) {
          rotate([0, -90, 0]) {
            rounded_cube(
              [
                box_size[2] - display_indent_margin * 2,
                box_size[1] - display_indent_margin * 2,
                box_size[0],
              ],
              flat=true,
              $rounding=1
            );
          }
        }
      }

      // access cutout
      if (create_access_cutout) {
        translate([
          box_size[0] + bleed,
          box_size[1]/2 / 2
            + cutout_offset[1] / 2,
          box_size[2] - cutout_depth
        ]) {
          rotate([0, -90, 0]) {
            rounded_cube(
              [
                cutout_depth + _rounding,
                natural_box_size[1]/2,
                box_size[0] + bleed * 2,
              ],
              flat_top=true,
              flat_bottom=true,
              $rounding=_rounding
            );
          }
        }
      }
    }
  }
}
