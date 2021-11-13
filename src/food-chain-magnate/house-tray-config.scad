include <./config.scad>
include <../../lib/layout/layout.scad>

top_padding = 0.1;

house_size = tile_size(2, 3);
house_count = 8;

garden_size = tile_size(2);
garden_count = 8;

resturant_size = tile_size(2, 2);
resturant_counts = [9, 7];

box_size = [
  padded_list_length([
    resturant_size[0],
    house_size[0],
  ]),
  padded_list_length([
    house_size[1],
    garden_size[1],
  ]),
  stack_height(square_size[2], resturant_counts[0], top_padding) + $wall_thickness + $lid_height,
];
