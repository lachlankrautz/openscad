include <./assert_helpers.scad>

// 10 cards -> 3mm -> 0.3
// 20 cards -> 6mm
// 30 cards -> 9mm
// 40 cards -> 12mm
// 50 cards -> 15.5mm -> 0.31
// 60 cards -> 18.8mm -> 0.31333
// 70 cards -> 22mm -> 0.314285
// 80 cards -> 25mm
// 90 cards -> 29mm -> 0.32222 per card -> 0.323
// taking the worst case since they are all so close
card_thickness = 0.323; 
card_stack_height = function(card_count) card_count * card_thickness + 1;

// 15 small cards -> 11mm -> 0.733r per card
// 22 cards -> 15mm -> 0.68 per card
// 36 cards -> 24mm -> 0.66r per card
// 60 cards -> 35mm -> 0.5833 per card -> 0.584
// put these numbers into: https://mycurvefit.com/
// to get card thickness maths, it probably should be much simpler
function sleeved_card_thickness(card_count) = -349.9101 + (0.8433182 - -349.9101)/(1 + (card_count/32688540)^0.5466091);
sleeved_card_stack_height = function(card_count) round(card_count * sleeved_card_thickness(card_count));

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
