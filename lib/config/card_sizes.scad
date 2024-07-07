include <./assert_helpers.scad>

// TODO collect stack heights of many more sizes and ensure the sizing functions
//      actually fit the known data
//      currently the stacks get too loose at high numbers and nearly too tight
//      at lower numbers

// TODO this value for non sleeved cards is a placeholder
//      do not rely on it
card_thickness = 0.30;
card_stack_height = function(card_count) card_count * card_thickness;

// 15 small cards -> 11mm -> 0.733r per card
// 36 cards -> 24mm -> 0.66r per card
// 22 cards -> 15mm -> 0.68 per card
sleeved_card_thickness = 0.65;
sleeved_card_stack_height = function(card_count) card_count * sleeved_card_thickness;

function is_card_size(card_size) = is_num(card_size[0]) 
  && is_num(card_size[1]) 
  && is_function(card_size[2]);

// a card stack is just a card size and a stack count
// e.g. [mini_euro_card_size, 10] -> a stack of 10 mini euro cards
function is_card_stack(card_stack) = is_card_size(card_stack[0]) && is_num(card_stack[1]);
is_card_stack_fn = function(card_stack) is_card_size(card_stack[0]) && is_num(card_stack[1]);

function is_card_stack_list(card_stack_list) = is_list_of(card_stack_list, is_card_stack_fn);

function is_valid_orientation(orientation) = orientation == "back" || orientation == "side";
function orient_card_cube_size(card_size, orientation = "back") = 
  assert(is_valid_orientation(orientation), orientation)
  orientation == "back" 
    ? card_size 
    : orientation == "side" 
      ? [card_size[2], card_size[1], card_size[0]] 
      : undef;

function card_cube_size(card_stack, orientation = "back") = 
  assert(is_card_stack(card_stack), card_stack)
  let(card_size = card_stack[0], stack_count = card_stack[1])
  orient_card_cube_size([card_size[0], card_size[1], card_size[2](stack_count)], orientation);

/**
 * Mini european size eg The crew tasks
 */
mini_euro_card_size = [
  44,
  68,
  card_stack_height,
];

/**
 * Mini european size eg The crew tasks
 * Sleeved with Mayday (blue)
 */
mini_euro_sleeved_card_size = [
  47,
  70,
  sleeved_card_stack_height,
];

/**
 * Standard card size eg MTG
 */
standard_card_size = [
  63,
  88,
  card_stack_height,
];

/**
 * Standard card size eg MTG
 * Sleeved with either gamegenic gray or TODO find mayday colour and double check size
 */
standard_sleeved_card_size = [
  67,
  91.5,
  sleeved_card_stack_height,
];

/**
 * Standard USA card size
 * - Bohnanza
 * - Food Chain Magnate
 * - The Crew
 */
standard_usa_card_size = [
  56,
  87,
  card_stack_height,
];

/**
 * Standard USA card size sleeved with mayday chimera (orange)
 *
 * WARNING: mayday sleeves vary in dimensions
 *          be sure to test large prints first
 *
 * - Bohnanza
 * - Food Chain Magnate
 * - The Crew
 */
standard_usa_sleeved_card_size = [
  59.5,
  91,
  sleeved_card_stack_height,
];

/**
 * Large 80/120
 *
 * - Dixit
 */
large_80_120_card_size = [
  80,
  120,
  card_stack_height,
];

/**
 * Large 80/120 sleeved with Mayday Magnum gold / dixit
 *
 * WARNING: mayday sleeves vary in dimensions
 *          be sure to test large prints first
 *
 * - Dixit
 */
large_80_120_sleeved_card_size = [
  82,
  122.5,
  sleeved_card_stack_height,
];
