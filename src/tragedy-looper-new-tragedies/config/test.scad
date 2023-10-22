include <./token-config.scad>

// flatten
assert(flatten([[1, 2, 3], [4, 5, 6]]) == [1, 2, 3, 4, 5, 6], "flatten list of lists");

// sum
assert(sum([1, 2, 3, 4]) == 10, "sum list");

// take
assert(take([1, 2, 3, 4], 2) == [1, 2], "take from list");

// fill
assert(fill(5, 3) == [5, 5, 5], "fill list");

// fill_grid
assert(fill_grid(5, [2, 2]) == [[5, 5], [5, 5]], "fill grid");

// pick_list
assert(pick_list(undef, LENGTH) == [], "pick x");
assert(pick_list([], LENGTH) == [], "pick x");
assert(pick_list([[1, 2], [3, 4], [5, 6]], LENGTH) == [1, 3, 5], "pick x");
assert(pick_list([[1, 2], [3, 4], [5, 6]], WIDTH) == [2, 4, 6], "pick y");

// slice
assert(slice([1, 2, 3, 4, 5], 0, 2) == [1, 2, 3], "slice");
assert(slice([1, 2, 3, 4, 5], 2, 3) == [3, 4], "slice");

// cum_sum_list
assert(cum_sum_list([1, 2, 3, 4]) == [1, 3, 6, 10], "cum sum list");

// grid_biggest_column
assert(grid_biggest_column([[1, 2, 3], [1, 2], [1, 2, 3, 4, 5]]) == 5, "biggest column");

// grid_biggest_row
assert(grid_biggest_row([[1, 2, 3], [1, 2], [1, 2, 3, 4, 5]]) == 3, "biggest row");

// grid_row
assert(grid_row([[1, 2, 3], [1, 2], [1, 2, 3, 4, 5]], 1) == [2, 2, 2], "grid row");
assert(grid_row([[1, 2, 3], [1, 2], [1, 2, 3, 4, 5]], 2) == [3, undef, 3], "grid row");

// grid_column
assert(grid_column([[1, 2, 3], [1, 2], [1, 2, 3, 4, 5]], 2) == [1, 2, 3, 4, 5], "grid column");
assert(grid_column([[1, 2, 3], [1, 2], [1, 2, 3, 4, 5]], 1) == [1, 2, undef, undef, undef], "grid column");

// tile_length_x
assert(tile_length_x(["circle", [5], 4]) == 5, "circle length");
assert(tile_length_x(["rectangle", [5, 10]]) == 5, "rectangle length");
assert(tile_length_x(["oval", [5, 10, 1], 4]) == 5, "oval length");

// tile_width_y
assert(tile_width_y(["circle", [5], 4]) == 5, "circle width");
assert(tile_width_y(["rectangle", [5, 10]]) == 10, "rectangle width");
assert(tile_width_y(["oval", [5, 10, 1], 4]) == 10, "oval width");

// tile_stack_height
assert(tile_stack_height(["tile_stack", ["rectangle", [5, 10], 2], 4, [5, 10], "centre", 5]) == 8, "tile stack height");

// sum_walls_in_list
assert(sum_walls_in_list([1, 1, 1, 1], 2) == 10, "walls in list");

// map_tiles_to_tile_lengths
assert(map_tiles_to_tile_lengths([["rectangle", [5, 10], 2],["rectangle", [5, 10], 2],]) == [5, 5], "map tiles to tile lengths");

// map_tiles_to_tile_widths
assert(map_tiles_to_tile_widths([["rectangle", [5, 10], 2],["rectangle", [5, 10], 2],]) == [10, 10], "map tiles to tile lengths");

// map_tile_stacks_to_tiles
assert(map_tile_stacks_to_tiles([["tile_stack", ["rectangle", [5, 10], 2], 4]]) == [["rectangle", [5, 10], 2]], "map tile stacks to tiles");

// map_tile_stacks_to_heights
assert(map_tile_stacks_to_heights([["tile_stack", ["rectangle", [5, 10], 2], 4]]) == [8], "map tile stacks to heights");

// map_tile_stacks_to_tile_lengths
assert(map_tile_stacks_to_tile_lengths([["tile_stack", ["rectangle", [5, 10], 2], 4]]) == [5], "map tile stacks to lengths");

// map_tile_stacks_to_tile_widths
assert(map_tile_stacks_to_tile_widths([["tile_stack", ["rectangle", [5, 10], 2], 4]]) == [10], "map tile stacks to widths");

// map_tile_stacks_to_spacing_boxes
assert(map_tile_stacks_to_spacing_boxes([["tile_stack", ["rectangle", [5, 10], 2], 4, [5, 10]]]) == [[5, 10]], "map tile stacks to spacing boxes");

// map_tile_stacks_to_spacing_box_lengths
assert(map_tile_stacks_to_spacing_box_lengths([["tile_stack", ["rectangle", [5, 10], 2], 4, [5, 10]]]) == [5], "map tile stacks to spacing boxes");

// map_tile_stacks_to_spacing_box_widths
assert(map_tile_stacks_to_spacing_box_widths([["tile_stack", ["rectangle", [5, 10], 2], 4, [5, 10]]]) == [10], "map tile stacks to spacing boxes");

// make_positioned_tile_stacks_grid
// TODO omg how though?
