// what does an expresive tile tray declaration look like?
// I can't see the config... is the config the actual declaration of state
// then we should make the other two files

wall_inset_length = 1.5;
tile_height = 3;
wall_thickness = 2;

// type: tile
// ["circle", [diameter], height]
// ["square", [length, width], height]
// ["oval", [length, width, rounding], height]
TILE_TYPE = 0;
TILE_SIZE = 1;
TILE_HEIGHT = 2;
TILE_CIRCLE = "circle";
TILE_CIRCLE_DIAMETER = 0;
TILE_SQUARE = "square";
TILE_SQUARE_LENGTH_X = 0;
TILE_SQUARE_WIDTH_Y = 1;
TILE_OVAL = "square";
TILE_OVAL_LENGTH_X = 0;
TILE_OVAL_WIDTH_Y = 1;
TILE_OVAL_ROUNDING = 2;

// type: tile stack
// [
//   "tile_stack"(const),
//   tile_type(tile_type),
//   spacing_box([x, y]),
//   stack_count(number),
//   position("top", "left", "bottom", "right", "centre")
//   wall_inset_length(number)
// ]
TILE_STACK_TYPE = 0;
TILE_STACK_TILE = 1;
TILE_STACK_SPACING_BOX = 2;
TILE_STACK_COUNT = 3;
TILE_STACK_POSITION = 4;
TILE_STACK_CUTOUT_MAP = 5;

// type: cutout_map
// [
//   "cutout_map"
//   left(cutout | undef)
//   top(cutout | undef)
//   right(cutout | undef)
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

function sum(v) = [for(p = v) 1] * v;

// input : nested list
// output : list with the outer level nesting removed
function flatten(outter_vector) = [for(inner_vector=outter_vector) for(item=inner_vector) item];

// type: positioned_item
// [[x, y], item]
function position_grid(grid) = [for(y=[0:len(grid)-1]) [for(x=[0:len(grid[y])]) [[x, y], grid[y][x]]]];

function make_tile_stacks(tile, stack_counts, position, cutout_map) = [for(stack_count=stack_counts) [
  "tile_stack",
  tile,
  [
    tile_length_x(tile),
    tile_width_y(tile),
  ],
  stack_count,
  position,
  cutout_map,
]];

function tile_length_x(tile) = tile[TILE_SIZE][TILE_SQUARE_LENGTH_X];
function tile_width_y(tile) = tile[TILE_TYPE] == TILE_CIRCLE
  ? tile[TILE_SIZE][TILE_CIRCLE_DIAMETER]
  : tile[TILE_SIZE][TILE_SQUARE_WIDTH_Y];

function tile_stack_height(tile_stack) = tile_stack[TILE_STACK_COUNT] * tile_stack[TILE_STACK_TILE][TILE_HEIGHT];

function list_wall_thickness(list, wall_thickness) = wall_thickness * (len(list) + 1);

function map_tile_stack_length_x(tile_stacks) = [for(tile_stack=tile_stacks) tile_length_x(tile_stack[TILE_STACK_TILE])];
function map_tile_stack_width_y(tile_stacks) = [for(tile_stack=tile_stacks) tile_width_y(tile_stack[TILE_STACK_TILE])];
function map_tile_stack_height(tile_stacks) = [for(tile_stack=tile_stacks) tile_stack_height(tile_stack)];

function map_tile_stack_padding_length_x(tile_stacks) = [for(tile_stack=tile_stacks) tile_stack[TILE_STACK_SPACING_BOX][0]];

function max_tile_stack_length_x(tile_stacks) = max(map_tile_stack_length_x(tile_stacks));
function max_tile_stack_width_y(tile_stacks) = max(map_tile_stack_width_y(tile_stacks));

function tile_stacks_length_x(tile_stacks, wall_thickness) = list_wall_thickness(tile_stacks, wall_thickness) + sum(map_tile_stack_padding_length_x(tile_stacks));

function tile_stack_grid_length_x(tile_stack_grid, wall_thickness) = list_wall_thickness(tile_stack_grid, wall_thickness)
  + sum([for(tile_stacks=tile_stack_grid) tile_stacks_length_x(tile_stacks, wall_thickness)]);
function tile_stack_grid_width_y(tile_stack_grid, wall_thickness) = list_wall_thickness(tile_stack_grid, wall_thickness) +
  sum([for(tile_stacks=tile_stack_grid) max_tile_stack_width_y(tile_stacks)]);
function tile_stack_grid_height(tile_stack_grid, wall_thickness) = wall_thickness * 2
  + max(map_tile_stack_height(flatten(tile_stack_grid)));
function tile_stack_grid_box_size(tile_stack_grid, wall_thickness) = [
  tile_stack_grid_length_x(tile_stack_grid, wall_thickness),
  tile_stack_grid_width_y(tile_stack_grid, wall_thickness),
  tile_stack_grid_height(tile_stack_grid, wall_thickness),
];

function make_tile_stacks_spacing_box(tile_stacks, centre_stacks_length_x, centre_stacks_width_y) = [
  centre_stacks_length_x
    ? max_tile_stack_length_x(tile_stacks)
    : undef,
  centre_stacks_width_y
    ? max_tile_stack_width_y(tile_stacks)
    : undef,
];

function space_tile_stacks(tile_stacks, centre_stacks_length_x, centre_stacks_width_y) =
  let(spacing_box=make_tile_stacks_spacing_box(tile_stacks, centre_stacks_length_x, centre_stacks_width_y))
  [for(tile_stack=tile_stacks) [
    tile_stack[0],
    tile_stack[1],
    [
      spacing_box[0] == undef ? tile_stack[TILE_STACK_SPACING_BOX][0] : spacing_box[0],
      spacing_box[1] == undef ? tile_stack[TILE_STACK_SPACING_BOX][1] : spacing_box[1],
    ],
    tile_stack[3],
    tile_stack[4],
    tile_stack[5],
  ]];

heart_tile_row = space_tile_stacks(concat(make_tile_stacks(heart_tile, [5, 5, 5, 5]), make_tile_stacks(large_heart_tile, [5, 5])), false, true);
demo_grid = [heart_tile_row, heart_tile_row];

positioned_grid = flatten(position_grid(demo_grid));

echo("grid: ", demo_grid);
echo("positioned grid: ", positioned_grid);

tile_tray_box = tile_stack_grid_box_size(demo_grid, wall_thickness);

difference() {
  cube(tile_tray_box);
  translate(positioned_grid[0]) {
    echo("tile: ", positioned_grid[1][1][TILE_STACK_TILE]);
    // cube(positioned_grid[1][TILE_STACK_TILE]);
  }
}

