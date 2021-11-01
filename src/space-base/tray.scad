include <../../lib/decorator/cutout_children.scad>
include <../../lib/layout/grid_layout.scad>
include <../../lib/primitive/scoop.scad>
include <../../lib/primitive/group/grid_scoop.scad>

// Config
$fn = 50;

// Attributes
size = [
  177,
  150,
  21,
];
cube_tray_width = 55;
dice_tray_length = 70;

// Derived Attributes
cube_tray_length = item_size(size[1]);
remainder_width = usable_size(size[0], 2) - cube_tray_width;
ship_tray_length = usable_size(size[1], 2) - dice_tray_length;

grid = [
  [cube_tray_width, remainder_width],
  [ship_tray_length, dice_tray_length],
  [size[2]],
];

// Unable to use grid system for cube tray
// Grid system only good for subdivisions not full length cells
dice_tray_cell = [1, 0];
ship_tray_cell = [1, 1];

// Model
cutout_children(size) {
  scoop([cube_tray_width, cube_tray_length, size[2]]);

  grid_scoop(grid, ship_tray_cell);

  grid_scoop(grid, dice_tray_cell);
}
