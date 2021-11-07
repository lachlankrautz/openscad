include <../primitive/rounded_cube.scad>
include <../compound/notched_cube.scad>
include <../layout/layout.scad>
include <../layout/grid_utils.scad>
include <../config/constants.scad>

function padded_card_size_grid(cards, height) = add_grid_xyz(cards, [$card_padding * 2, $card_padding * 2, height]);
function padded_card_size(size, height) = [
  size[0] + $card_padding * 2,
  size[1] + $card_padding * 2,
  size[2] + height,
];

function card_grid_size(cards, height) = accumulated_grid_cube(accumulated_grid(walled_grid(padded_card_size_grid(cards, height))))
   + [$wall_thickness, $wall_thickness, height];

// TODO stil creates a box
// maybe it shouldn't
/**
 * Create a box with card cutouts:
 * Pad around the exact card size and create a tray of the given height.
 *
 * @param grid of card_sizes [
 *   [[x, y],[x, y],[x, y]],
 *   [[x, y],[x, y],[x, y]],
 *   [[x, y],[x, y],[x, y]],
 * ]
 * @param height total height of the container
 */
module card_grid(
  card_size_grid,
  height,
  left_cutout=true,
  right_cutout=true,
  top_cutout=true,
  bottom_cutout=true,
  inner_cutout=true,
  honeycomb_diameter=undef
) {
  card_offset_grid = accumulated_grid(walled_grid(padded_card_size_grid(card_size_grid, height)));

  box_size = [
    accumulated_grid_x(card_offset_grid) + $wall_thickness,
    accumulated_grid_y(card_offset_grid) + $wall_thickness,
    height,
  ];

  difference() {
    rounded_cube(box_size, flat_top=true, $rounding=1);

    card_tray_grid_cutout(
      card_size_grid,
      height,
      left_cutout=left_cutout,
      right_cutout=right_cutout,
      top_cutout=top_cutout,
      bottom_cutout=bottom_cutout,
      inner_cutout=inner_cutout,
      honeycomb_diameter=honeycomb_diameter
    );
  }
}

/**
 * Pad around the exact card size cutout trays
 *
 * @param grid of card_sizes [
 *   [[x, y],[x, y],[x, y]],
 *   [[x, y],[x, y],[x, y]],
 *   [[x, y],[x, y],[x, y]],
 * ]
 * @param height total height of the container
 */
module card_tray_grid_cutout(
  card_size_grid,
  height,
  left_cutout=true,
  right_cutout=true,
  top_cutout=true,
  bottom_cutout=true,
  inner_cutout=true,
  honeycomb_diameter=undef
) {
  // Add padding and set height for cutout
  print_grid(card_size_grid);
  card_cutout_size_grid = padded_card_size_grid(card_size_grid, height);
  print_grid(card_cutout_size_grid);
  normal_grid = max_grid(card_cutout_size_grid);
  median_grid = median_grid(card_cutout_size_grid);

  // Map layout offsets with wall thickness
  card_offset_grid = accumulated_grid(walled_grid(card_cutout_size_grid));

  translate([$wall_thickness, $wall_thickness, 0]) {
    for (x = [0:len(card_cutout_size_grid) - 1]) {
      for (y = [0:len(card_cutout_size_grid[x]) - 1]) {
        translate(card_offset_grid[x][y]) {
          notched_cube(
            card_cutout_size_grid[x][y],
            left_cutout = left_cutout && (x == 0 || inner_cutout),
            right_cutout = right_cutout && ((x == len(card_cutout_size_grid)-1) || inner_cutout),
            top_cutout = top_cutout && ((y == len(card_cutout_size_grid[x])-1) || inner_cutout),
            bottom_cutout = bottom_cutout && (y == 0 || inner_cutout),
            honeycomb_diameter = honeycomb_diameter,
            floor_cutout = !honeycomb_diameter,
            cutout_size = median_grid[x][y],
            bounding_box = normal_grid[x][y]
          );
        }
      }
    }
  }
}

module card_tray_top_spacer(card_size, height, matrix=[1, 1]) {
  card_spacer_size = [
    card_size[0] - $card_padding * 5,
    card_size[1] - $card_padding * 5,
    height,
  ];
  // spacer hole inset is proportional to the height
  card_spacer_hole_size = [
    card_spacer_size[0] - height * 4,
    card_spacer_size[1] - height * 4,
    height + $bleed * 2,
  ];

  card_cutout_size = padded_card_size([
    card_size[0],
    card_size[1],
    0,
  ], 0);

  centre_offset = [
    (card_cutout_size[0] - card_spacer_size[0]) / 2,
    (card_cutout_size[1] - card_spacer_size[1]) / 2,
    0
  ];
  centre_hole_offset = [
    (card_spacer_size[0] - card_spacer_hole_size[0]) / 2,
    (card_spacer_size[1] - card_spacer_hole_size[1]) / 2,
    -$bleed
  ];

  join_length = $wall_thickness * 5;
  join_x_size = [
    cutout_fraction_size(card_size[0]) - $card_padding * 4,
    join_length,
    height,
  ];
  join_y_size = [
    join_length,
    cutout_fraction_size(card_size[1]) - $card_padding * 4,
    height,
  ];

  translate([$wall_thickness, $wall_thickness, 0]) {
    for (i = [0:matrix[0] - 1]) {
      for (j = [0:matrix[1] - 1]) {
        translate([
          offset(card_cutout_size[0], i),
          offset(card_cutout_size[1], j),
          0
        ]) {
          translate(centre_offset) {
            difference() {
              rounded_cube(card_spacer_size, flat = true);

              // middle hole space
              translate(centre_hole_offset) {
                rounded_cube(card_spacer_hole_size, flat = true);
              }
            }
          }

          // joins
          if (i < matrix[0] - 1) {
            translate([
              card_size[0] - $wall_thickness,
              (card_cutout_size[1] - join_y_size[1]) / 2,
              0
            ]) {
              cube(join_y_size);
            }
          }
          if (j < matrix[1] - 1) {
            translate([
              (card_cutout_size[0] - join_x_size[0]) / 2,
              card_size[1] - $wall_thickness,
              0
            ]) {
              cube(join_x_size);
            }
          }
        }
      }
    }
  }
}
