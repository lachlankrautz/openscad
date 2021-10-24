include <./rounded_cube.scad>
include <./cutouts.scad>
include <./layout.scad>

// Config
// $fn = 50;
$fn = 10;
$wall_thickness = 2;

// Default padding is for tokens
// Cards need more space than tokens
// default was really tight
// 2 was a bit loose
// 1 was...
$padding = 1;
$rounding = 2;
$bleed = 0.01;

/**
 * Standard card size eg MTG
 * Sleeved with either gamegenic gray or mayday green
 */
standard_sleeved_card_size = [
  67,
  91.5,
];

/**
 * Standard card size eg MTG
 */
standard_card_size = [
  63,
  88,
];

/**
 * Standard USA card size eg Bohnanza
 */
standard_usa_card_size = [
  56,
  87
];

/**
 * Pad around the exact card size and create a tray of the given height.
 *
 * @param card_size [x, y]
 * @param height total height of the container
 */
module card_tray(card_size, height, matrix=[1, 1], honeycomb_diameter=undef) {
  // Pad out the card size to get the cutout size
  card_cutout_size = [
    pad(card_size[0]),
    pad(card_size[1]),
    height,
  ];

  // Add walls for total box size
  box_size = [
    (card_cutout_size[0] + $wall_thickness) * matrix[0] + $wall_thickness,
    (card_cutout_size[1] + $wall_thickness) * matrix[1] + $wall_thickness,
    height,
  ];

  // Cut the tray out from the box
  difference() {
    rounded_cube(box_size, flat_top=true);

    translate([$wall_thickness, $wall_thickness, 0]) {
      for(i=[0:matrix[0]-1]) {
        for(j=[0:matrix[1]-1]) {
          translate([
            offset(card_cutout_size[0], i),
            offset(card_cutout_size[1], j),
            0
            ]) {
            cutout(
              card_cutout_size,
              left_cutout = true,
              right_cutout = true,
              top_cutout = true,
              bottom_cutout = true,
              honeycomb_diameter = honeycomb_diameter,
              floor_cutout = !honeycomb_diameter
            );
          }
        }
      }
    }
  }
}
