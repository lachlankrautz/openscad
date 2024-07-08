include <../lib/config/card_sizes.scad>

wall_thickness = 1.5; // possible minimumn possible wall thickness
card_padding = 2; // aiming for snug fit

card_box_size = card_cube_size([large_80_120_sleeved_card_size, 10]);

cube(card_box_size);

sleeved_card_stack_height_cases = [
  [15, 11],
  [22, 15],
  [36, 24],
  [60, 35],
];
for (case=sleeved_card_stack_height_cases) {
  let(
    height = sleeved_card_stack_height(case[0]),
    diff = abs(case[1] - height)
  ) {
    assert(diff <= 1, case);
  }
}
