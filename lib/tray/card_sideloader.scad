include <../../lib/primitive/rounded_cube.scad>

// 15 small cards -> 11mm -> 0.733r per card
// 36 cards -> 24mm -> 0.66r per card
// 22 cards -> 15mm -> 0.68 per card
card_thickness = 0.7;
function card_stack_height(card_count) = card_count * card_thickness;

// 80gsm -> 0.065mm
// 250gsm -> 0.23mm
default_indent_depth = 0.25;

module card_sideloader(
  card_size,
  card_count,

  create_display_indent = false,
  display_indent_depth = default_indent_depth,
  display_indent_margin = 2,

  create_access_cutout = false,

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
      // stacked cards can compress and might not need padding
      stack_height + padding / 5,
      card_size[1] + padding,
      card_size[0] + padding,
    ],
    card_cutout=[
      padded_card_stack_size[0],
      padded_card_stack_size[1],
      padded_card_stack_size[2] + wall_thickness + bleed,
    ],
    box_size=[
      padded_card_stack_size[0] + wall_thickness * 2 + _display_indent_depth,
      padded_card_stack_size[1] + wall_thickness * 2,
      padded_card_stack_size[2] + wall_thickness * 2,
    ]
  ) {
    difference() {
      // box
      rounded_cube(box_size, $rounding=1);

      // cards cutout
      translate([wall_thickness, wall_thickness, wall_thickness]) {
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
          box_size[1]/2 / 2,
          box_size[2] - cutout_depth
        ]) {
          rotate([0, -90, 0]) {
            rounded_cube(
              [
                cutout_depth + _rounding,
                box_size[1]/2,
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
