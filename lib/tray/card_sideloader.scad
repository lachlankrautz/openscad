include <../../lib/primitive/rounded_cube.scad>

card_thickness = 0.8;

function card_stack_height(card_count) = card_count * card_thickness;

module card_sideloader(card_size, card_count, wall_thickness, padding, bleed = 0.1) {
  let(
    cutout_depth = 20,
    _rounding = 5,
    stack_height = card_stack_height(card_count),
    padded_card_box_size = [
      stack_height + padding / 2, // stacked cards can compress and don't need as much padding
      card_size[1] + padding,
      card_size[0] + padding,
    ],
    card_cutout=[
      padded_card_box_size[0],
      padded_card_box_size[1],
      padded_card_box_size[2] + wall_thickness + bleed,
    ],
    box_size=[
      padded_card_box_size[0] + wall_thickness * 2,
      padded_card_box_size[1] + wall_thickness * 2,
      padded_card_box_size[2] + wall_thickness * 2,
    ]
  ) {
     difference() {
      rounded_cube(box_size, $rounding=1);
      translate([wall_thickness, wall_thickness, wall_thickness]) {
        cube(card_cutout);
      }
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
