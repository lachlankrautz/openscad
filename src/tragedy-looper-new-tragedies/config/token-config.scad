// what does an expresive tile tray declaration look like?
// I can't see the config... is the config the actual declaration of state
// then we should make the other two files

wall_inset_length = 1.5;
tile_height = 3;
wall_thickness = 2;

// type: point
// [length, width]
LENGTH=0;
WIDTH=1;

// type: tile
// ["circle", [diameter], height]
// ["rectangle", [length, width], height]
// ["oval", [length, width, rounding], height]
TILE_TYPE = 0;
TILE_SIZE = 1;
TILE_HEIGHT = 2;
TILE_CIRCLE = "circle";
TILE_CIRCLE_DIAMETER = 0;
TILE_RECTANGLE = "rectangle";
TILE_RECTANGLE_LENGTH_X = 0;
TILE_RECTANGLE_WIDTH_Y = 1;
TILE_OVAL = "rectangle";
TILE_OVAL_LENGTH_X = 0;
TILE_OVAL_WIDTH_Y = 1;
TILE_OVAL_ROUNDING = 2;

// type: tile stack
// [
//   "tile_stack"(const),
//   tile_type(tile_type),
//   stack_count(number),
// ]
TILE_STACK_TYPE = 0;
TILE_STACK_TILE = 1;
TILE_STACK_COUNT = 2;

// type: posistioned tile stack: extends tile stack
// [
//   "positioned_tile_stack"(const),
//   tile_type(tile_type),
//   stack_count(number),
//   spacing_box([x, y]),
//   position([x, y])
//   index([x, y])
//   orientation("top", "left", "bottom", "right", "centre"),
//   ? cutout_map
// ]
TILE_STACK_SPACING_BOX = 3;
TILE_STACK_POSITION = 4;
TILE_STACK_INDEX = 5;
TILE_STACK_ORIENTATION = 6;
TILE_STACK_CUTOUT_MAP = 7;

// type: cutout_map
// [
//   "cutout_map",
//   left(cutout | undef),
//   top(cutout | undef),
//   right(cutout | undef),
//   bottom(cutout | undef)
// ]
TILE_STACK_CUTOUT_MAP_TYPE = 0;
TILE_STACK_CUTOUT_MAP_LEFT = 1;
TILE_STACK_CUTOUT_MAP_TOP = 2;
TILE_STACK_CUTOUT_MAP_RIGHT = 3;
TILE_STACK_CUTOUT_MAP_BOTTOM = 4;

// type: cutout
// ["fixed_inset", [length]]
// ["proportional", [percentage, max_length, min_length]]
CUTOUT_TYPE = 0;
CUTOUT_DATA = 1;
CUTOUT_TYPE_FIXED_INSET_LENGTH = 0;
CUTOUT_TYPE_PROPORTIONAL_PERCENGAGE = 0;
CUTOUT_TYPE_PROPORTIONAL_MAX_LENGTH = 1;
CUTOUT_TYPE_PROPORTIONAL_MIN_LENGTH = 2;

EMPTY_CUTOUT_MAP = ["cutout_map", undef, undef, undef, undef];

small_diameter = 20.2;
large_diameter = 28.2;

blue_tile = ["circle", [small_diameter], tile_height];
heart_tile = ["circle", [small_diameter], tile_height];
large_heart_tile = ["circle", [large_diameter], tile_height];
fear_tile = ["circle", [small_diameter], tile_height];
large_fear_tile = ["circle", [large_diameter], tile_height];
mask_tile = ["oval", [0, 0, 0], tile_height];
large_mask_tile = ["circle", [large_diameter], tile_height];

// type: positioned_item
// [[x, y], item]
POSITION = 0;
ITEM = 1;

module print_grid(grid) {
  max_y = grid_biggest_column(grid);
  for(i=[max_y-1:-1:0]) {
    echo(i, grid_row(grid, i));
  }
  echo("");
}

module print_grid_code_orientation(grid) {
  for(x=[0:len(grid)-1]) {
    echo(grid[x]);
  }
  echo("");
}

// is the param a grid
function is_grid(grid) = is_list(grid) && [for(list=grid) true] == [for(list=grid) is_list(list)];

// input : nested list
// output : list with the outer level nesting removed
function flatten(outter_vector) = [for(inner_vector=outter_vector) for(item=inner_vector) item];

// sum elements of an array
// sum([1, 2, 3, 4] => 10
function sum(array) =
  // assert(is_list(array), array)
  len(array) == 0
    ? 0
    : [for(item=array) 1] * array;

// take a number of elements from an array
// take([1, 2, 3, 4], 2) => [1, 2]
function take(array, count) = count == 0
  ? []
  : [for(i=[0:count-1]) array[i]];

// fill an array of count with item
// fill(item, 3) -> [item, item, item]
function fill(item, count) = [for(i=[0:count-1]) item];

// fill a grid of [xSize, ySize] with item
// fill_grid(item, [2, 2]) -> [[item, item], [item, item]]
function fill_grid(item, dimensions) = [for(x=[0:dimensions[LENGTH]-1]) [for(y=[0:dimensions[WIDTH]-1]) item]];

// fill a grid's empty spaces with item
// should leave all lists in a grid the same length
function fill_grid_gaps(item, grid) = 
// assert(is_grid(grid), grid)
  let(max_size_x=grid_biggest_row(grid), max_size_y=grid_biggest_column(grid))
    [for(x=[0:max_size_x-1]) [for(y=[0:max_size_y-1]) grid[x][y] == undef ? item : grid[x][y]]];

// map a grid of tile stacks to the dimensions of those tiles
function map_tile_stacks_grid_to_tile_dimensions(tile_stacks_grid) =
// assert(is_grid(tile_stacks_grid), tile_stacks_grid)
  [for(column=tile_stacks_grid)
    [for(tile_stack=column) 
    let(tile=tile_stack[TILE_STACK_TILE]) 
    [tile_length_x(tile), tile_width_y(tile)]]];

// map a grid of dimensions to a grid where:
// - each x is the max length of each x in the column
// - each y is the max width of each y in the row
// this evenly spaces out all cells the in the grid
function map_dimension_grid_to_uniform_spacing(dimensions_grid) =
// assert(is_grid(dimensions_grid), dimensions_grid)
let(
  solid_grid=fill_grid_gaps([0, 0], dimensions_grid),
  max_column_lengths_x=[for(column=solid_grid) max(pick_list(column, LENGTH))],
  max_row_widths_y=[for(row=grid_rows(solid_grid)) max(pick_list(row, WIDTH))]
)
  [for(x=[0:len(solid_grid)-1])
    [for(y=[0:len(solid_grid[0])-1]) [
      max_column_lengths_x[x], 
      max_row_widths_y[y]
    ]]];

// map a dimensions grid to cumulative sums
// - each x is the total x offset along the row
// - each y is the total y offset along the column
// this absolutely positions items within a grid
function map_dimension_grid_to_cum_sum(dimensions_grid) =
// assert(is_grid(dimensions_grid), dimensions_grid)
let(
  solid_grid=fill_grid_gaps([0, 0], dimensions_grid),
  cum_sum_column_lengths_x=cum_sum_list([for(column=solid_grid) max(pick_list(column, LENGTH))]),
  cum_sum_row_widths_y=cum_sum_list([for(row=grid_rows(solid_grid)) max(pick_list(row, WIDTH))])
)
  [for(x=[0:len(solid_grid)-1])
    [for(y=[0:len(solid_grid[x])-1]) [
      cum_sum_column_lengths_x[x], 
      cum_sum_row_widths_y[y]
    ]]];

function unshift_dimensions_grid(grid) =
// assert(is_grid(grid), grid)
  [for(x=[0:len(grid)-1])
    [for(y=[0:len(grid[x])-1]) [
      x == 0 ? 0 : grid[x-1][y][LENGTH],
      y == 0 ? 0 : grid[x][y-1][WIDTH],
    ]]];

// Map to just the given index of a list of arrays
//
// list = [
//   [1, 2],
//   [3, 4],
// ];
// pick_list(list, 0) -> [1, 3]
// pick_list(list, 1) -> [2, 4]
function pick_list(list, index) = list == undef || len(list) == 0
  ? []
  : [for(i=[0:len(list)-1]) list[i][index]];

// slice an array
// slice([1, 2, 3, 4], 0, 2) => [1, 2, 3]
function slice(array, start, end) = [for(i=[start:end]) array[i]];

// cumulatively sum a list
// [1, 2, 3] -> [1, 3, 6]
function cum_sum_list(list) = [for(i=[0:len(list)-1]) sum(slice(list, 0, i))];

// get the size of the tallest collumn
// grid_biggest_column([
//   [ x, x,
//   [ x, x, x, x ]
// ]) => 4
function grid_biggest_column(matrix) = max([for(x=[0:len(matrix)-1]) len(matrix[x])]);

// get the size of the widest row (always the first row)
// grid_biggest_row([
//   [ x, x,
//   [ x, x, x, x ]
// ]) => 2
// grid_biggest_row([]) => 0
function grid_biggest_row(grid) =
// assert(is_grid(grid), grid)
  len(grid);

// get a grid row as an array
// grid_row([
//   [ [1, 1], [2, 2] ],
//   [ [3, 3], [4, 4] ]
// ], 1) => [ [2, 2], [4, 4] ]
function grid_row(grid, row_y) =
// assert(is_grid(grid), grid)
  [for(col=grid) col[row_y]];

// get a grid as a list of rows instead of a list of columns
function grid_rows(grid) =
// assert(is_grid(grid), grid)
let(max_y=grid_biggest_column(grid))
  [for(row_y=[0:max_y-1]) grid_row(grid, row_y)];

// get a grid column as an array
// grid_column([
//   [ [1, 1], [2, 2] ],
//   [ [3, 3], [4, 4], [5, 5], [6, 6] ]
// ], 1) => [ [3, 3], [4, 4], [5, 5], [6, 6] ]
// grid_column([
//   [ [1, 1], [2, 2] ],
//   [ [3, 3], [4, 4], [5, 5], [6, 6] ]
// ], 0) => [ [1, 1], [2, 2], undef, undef]
function grid_column(grid, col) =
// assert(is_grid(grid), grid)
let(height=grid_biggest_column(grid)) [for(i=[0:height-1]) grid[col][i]];

// get the length(x) of a tile type
// tile_length_x(["circle", [5], 4]) -> 5
// tile_length_x(["rectangle", [5, 10], 4]) -> 5
// tile_length_x(["oval", [5, 10, 1], 4]) -> 5
function tile_length_x(tile) = tile[TILE_SIZE][TILE_RECTANGLE_LENGTH_X];

// get the width(y) of a tile type
// tile_length_x(["circle", [5], 4]) -> 5
// tile_length_x(["rectangle", [5, 10], 4]) -> 10
// tile_length_x(["oval", [5, 10, 1], 4]) -> 10
function tile_width_y(tile) = tile[TILE_TYPE] == TILE_CIRCLE
  ? tile[TILE_SIZE][TILE_CIRCLE_DIAMETER]
  : tile[TILE_SIZE][TILE_RECTANGLE_WIDTH_Y];

// get the total height of a tile stack -> (count * tile height)
// tile_stack_height([
//   "tile_stack",
//   ["rectangle", [5, 10], 2],
//   4,
//   [5, 10],
//   "centre",
//   5
// ]) -> 8
function tile_stack_height(tile_stack) = tile_stack[TILE_STACK_COUNT] * tile_stack[TILE_STACK_TILE][TILE_HEIGHT];

// sum the thickness of all walls in a list
// sum_walls_in_list([1, 1, 1], 2) -> list of three items has 4 walls of width 2 -> (3 + 1) * 2 -> 8
function sum_walls_in_list(list, wall_thickness) = wall_thickness * (len(list) + 1);
//echo("sum walls in list: ", sum_walls_in_list([1, 1, 1], 2));

// get the [x, y] offset for wall thickness in a grid
function wall_index_offset(index, wall_thickness) = 
assert(is_list(index))
[
  wall_thickness * (index[LENGTH] + 1),
  wall_thickness * (index[WIDTH] + 1),
];

// [tile, tile, tile] -> [x, x, x]
function map_tiles_to_tile_lengths(tiles) = [for(tile=tiles) tile_length_x(tile)];

// [tile, tile, tile] -> [y, y, y]
function map_tiles_to_tile_widths(tiles) = [for(tile=tiles) tile_width_y(tile)];

// [tile_stack, tile_stack, tile_stack] -> [tile, tile, tile]
function map_tile_stacks_to_tiles(tile_stacks) =
pick_list(tile_stacks, TILE_STACK_TILE);

// [tile_stack, tile_stack, tile_stack] -> [z, z, z]
function map_tile_stacks_to_heights(tile_stacks) =
  [for(tile_stack=tile_stacks) tile_stack_height(tile_stack)];

// [tile_stack, tile_stack, tile_stack] -> [x, x, x]
function map_tile_stacks_to_tile_lengths(tile_stacks) =
let(tiles = map_tile_stacks_to_tiles(tile_stacks))
map_tiles_to_tile_lengths(tiles);

// [tile_stack, tile_stack, tile_stack] -> [y, y, y]
function map_tile_stacks_to_tile_widths(tile_stacks) =
let(tiles = map_tile_stacks_to_tiles(tile_stacks))
map_tiles_to_tile_widths(tiles);

// [tile_stack, tile_stack, tile_stack] -> [box, box, box]
function map_tile_stacks_to_spacing_boxes(tile_stacks) =
  [for(tile_stack=tile_stacks) tile_stack[TILE_STACK_SPACING_BOX]];

// [tile_stack, tile_stack, tile_stack] -> [x, x, x]
function map_tile_stacks_to_spacing_box_lengths(tile_stacks) =
let(tiles = map_tile_stacks_to_spacing_boxes(tile_stacks))
pick_list(tiles, LENGTH);

// [tile_stack, tile_stack, tile_stack] -> [y, y, y]
function map_tile_stacks_to_spacing_box_widths(tile_stacks) =
let(tiles = map_tile_stacks_to_spacing_boxes(tile_stacks))
pick_list(tiles, WIDTH);

// [
//   [tile_stack, tile_stack, tile_stack],
//   [tile_stack, tile_stack, tile_stack],
//   [tile_stack, tile_stack, tile_stack],
// ] -> [x, y, z]
function tile_stack_grid_box_size(tile_stacks_grid, wall_thickness) = 
// assert(is_grid(tile_stacks_grid), tile_stacks_grid)
let(
  solid_grid=fill_grid_gaps(["tile_stack", undef, 0], tile_stacks_grid),
  dimension_grid=map_tile_stacks_grid_to_tile_dimensions(solid_grid),
  cum_sum_grid=map_dimension_grid_to_cum_sum(dimension_grid),
  max_size_x=(cum_sum_grid),
  max_size_y=(cum_sum_grid),
  max_cell=cum_sum_grid[max_size_x][max_size_y]
) 
[
  max_cell[LENGTH],
  max_cell[WIDTH],
  // TODO find max height
  10,
];

// [[tile_stack, tile_stack], [tile_stack, tile_stack]]
// -> [[positioned_tile_stack, positioned_tile_stack], [positioned_tile_stack, positioned_tile_stack]]
function make_positioned_tile_stacks_grid(tile_stacks_grid, wall_thickness) =
let(
  solid_grid=fill_grid_gaps(["tile_stack", undef, 0], tile_stacks_grid),
  dimension_grid=map_tile_stacks_grid_to_tile_dimensions(solid_grid),
  spacing_boxes_grid=map_dimension_grid_to_uniform_spacing(dimension_grid),
  positioning_grid=unshift_dimensions_grid(map_dimension_grid_to_cum_sum(dimension_grid)),
  cutout_map=undef
)
  [for(x=[0:len(tile_stacks_grid)-1])
    [for(y=[0:len(tile_stacks_grid[x])-1])
    let(tile_stack=tile_stacks_grid[x][y])
      [
        "positioned_tile_stack",
        tile_stack[TILE_STACK_TILE],
        tile_stack[TILE_STACK_COUNT],
        spacing_boxes_grid[x][y],
        positioning_grid[x][y],
        [x, y],
        "top",
        cutout_map,
      ]
    ]
  ];

module tile_stacks_grid_wells(tile_stacks_grid, wall_thickness) {
  list = flatten(tile_stacks_grid);
  for(tile_stack=list) {
    let(
      tile=tile_stack[TILE_STACK_TILE],
      wall_offset=wall_index_offset(tile_stack[TILE_STACK_INDEX], wall_thickness),
      position=tile_stack[TILE_STACK_POSITION] + wall_offset
    ) {
      translate(position) {
        cube([
          tile_length_x(tile),
          tile_width_y(tile),
          tile_stack_height(tile_stack)
        ]);
      }
    }
  }
}

//////////////////
//////////////////

// TODO is this used?
// length of the longest stack in the list
// max_tile_stack_length_x([
//   ["tile_stack", ["rectangle", [5, 12], 2], 4, [5, 10], "centre", 5],
//   ["tile_stack", ["rectangle", [8, 14], 2], 4, [5, 10], "centre", 5],
//   ["tile_stack", ["rectangle", [7, 15], 2], 4, [5, 10], "centre", 5],
// ]) -> 8
// function max_tile_stack_length_x(tile_stacks) = max(map_tile_stack_length_x(tile_stacks));
//echo("max tile stack length: ", max_tile_stack_length_x([["tile_stack", ["rectangle", [5, 12], 2], 4, [5, 10], "centre", 5], ["tile_stack", ["rectangle", [8, 14], 2], 4, [5, 10], "centre", 5], ["tile_stack", ["rectangle", [7, 15], 2], 4, [5, 10], "centre", 5]]));

// TODO is this used?
// width of the widest stack in the list
// map_tile_stack_width_y([
//   ["tile_stack", ["rectangle", [5, 12], 2], 4, [5, 10], "centre", 5],
//   ["tile_stack", ["rectangle", [8, 14], 2], 4, [5, 10], "centre", 5],
//   ["tile_stack", ["rectangle", [7, 15], 2], 4, [5, 10], "centre", 5],
// ]) -> 15
// function max_tile_stack_width_y(tile_stacks) = max(map_tile_stack_width_y(tile_stacks));
//echo("max tile stack width: ", max_tile_stack_width_y([["tile_stack", ["rectangle", [5, 12], 2], 4, [5, 10], "centre", 5], ["tile_stack", ["rectangle", [8, 14], 2], 4, [5, 10], "centre", 5], ["tile_stack", ["rectangle", [7, 15], 2], 4, [5, 10], "centre", 5]]));

// TODO rename
// TODO compose from better functions
// TODO these are terrible
// TODO it's atrocious
// function tile_stacks_length_x(tile_stacks, wall_thickness) = sum_walls_in_list(tile_stacks, wall_thickness)
//   + sum(map_tile_stack_spacing_box_length_x(tile_stacks));
//echo("tile stacks length x: ", tile_stacks_length_x([["tile_stack", ["rectangle", [5, 12], 2], 4, [5, 10], "centre", 5], ["tile_stack", ["rectangle", [8, 14], 2], 4, [5, 10], "centre", 5], ["tile_stack", ["rectangle", [7, 15], 2], 4, [5, 10], "centre", 5]], 2));

// function tile_stack_grid_length_x(tile_stack_grid, wall_thickness) = sum_walls_in_list(tile_stack_grid, wall_thickness)
//   + sum([for(tile_stacks=tile_stack_grid) tile_stacks_length_x(tile_stacks, wall_thickness)]);

// function tile_stack_grid_width_y(tile_stack_grid, wall_thickness) = sum_walls_in_list(tile_stack_grid, wall_thickness) +
//   sum([for(tile_stacks=tile_stack_grid) max_tile_stack_width_y(tile_stacks)]);

// function tile_stack_grid_height(tile_stack_grid, wall_thickness) = wall_thickness * 2
//   + max(map_tile_stack_height(flatten(tile_stack_grid)));

//function position_grid(grid) = let()
//  [for(y=[0:len(grid)-1]) [for(x=[0:len(grid[y])]) [[x, y], grid[y][x]]]];

// [tile, [2, 3, 5], "top", []] -> [tile_stack, tile_stack, tile_stack]
// function make_tile_stacks(tile, stack_counts, position, cutout_map) = [for(stack_count=stack_counts) [
//   "tile_stack",
//   tile,
//     [
//     tile_length_x(tile),
//     tile_width_y(tile),
//     ],
//   stack_count,
//   position,
//   cutout_map,
//   ]];

// function make_tile_stacks_spacing_box(tile_stacks, centre_stacks_length_x, centre_stacks_width_y) = [
//     centre_stacks_length_x
//     ? max_tile_stack_length_x(tile_stacks)
//     : undef,
//     centre_stacks_width_y
//     ? max_tile_stack_width_y(tile_stacks)
//     : undef,
//   ];

// function space_tile_stacks(tile_stacks, centre_stacks_length_x, centre_stacks_width_y) =
// let(spacing_box=make_tile_stacks_spacing_box(tile_stacks, centre_stacks_length_x, centre_stacks_width_y))
//   [for(tile_stack=tile_stacks) [
//   tile_stack[0],
//   tile_stack[1],
//     [
//       spacing_box[0] == undef ? tile_stack[TILE_STACK_SPACING_BOX][0] : spacing_box[0],
//       spacing_box[1] == undef ? tile_stack[TILE_STACK_SPACING_BOX][1] : spacing_box[1],
//     ],
//   tile_stack[3],
//   tile_stack[4],
//   tile_stack[5],
//   ]];

// rewrite this accumulated sum
// function map_tile_stacks_spacing_boxes(tile_stacks) = [for(tile_stack=tile_stacks) tile_stack[TILE_STACK_SPACING_BOX]];

// function map_tile_stack_grid_spacing_boxes(tile_stack_grid) = [for(tile_stacks=tile_stack_grid) map_tile_stacks_spacing_boxes(tile_stacks)];

// module positioned_tile_stack(positioned_tile_stack) {
//   translate(positioned_tile_stack[POSITION]) {
//     tile_stack(positioned_tile_stack[ITEM]);
//   }
// }

// module tile_stack(tile_stack) {
//   cube([10, 10, 10]);
// }

//heart_tile_row = space_tile_stacks(concat(make_tile_stacks(heart_tile, [5, 5, 5, 5]), make_tile_stacks(large_heart_tile, [5, 5])), false, true);
//demo_grid = [heart_tile_row, heart_tile_row];

//positioned_grid = flatten(position_grid(demo_grid));

//echo("grid: ", demo_grid);
//echo("positioned grid: ", positioned_grid);
//echo("boxes: ", map_tile_stack_grid_spacing_boxes(demo_grid));

//tile_tray_box = tile_stack_grid_box_size(demo_grid, wall_thickness);

//difference() {
//  cube(tile_tray_box);
//  positioned_tile_stack(positioned_grid[0]);
//}
