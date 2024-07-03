include <../lib/config/card_sizes.scad>

large_80_120_sleeved_box = [
  large_80_120_sleeved_card_size[0],
  large_80_120_sleeved_card_size[1],
  large_80_120_sleeved_card_size[2](10),
];

cube(large_80_120_sleeved_box);
