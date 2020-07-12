echo(version=version());

include <../../lib/cutout_tray.scad>
include <../../lib/layout.scad>
include <../../lib/scoop.scad>

// Config
$fn = 50;

// Attributes
length = 150;
width = 170;
height = 21;

cube_tray_width = 60;
dice_tray_length = 100;

// Derived Attributes
cube_tray_length = item_size(length);
remainder_width = usable_size(width, 2) - cube_tray_width;
ship_tray_length = usable_size(length, 2) - dice_tray_length;

grid = [
  [cube_tray_width, remainder_width],
  [dice_tray_length, ship_tray_length],
];

// Model
cutout_tray([width, length, height]) {
  // Cube Tray
  scoop([cube_tray_width, cube_tray_length, height]);

  // Dice Tray
  translate(grid_offset(grid, [1, 0])) {
    scoop([remainder_width, dice_tray_length, height]);
  }

  // Ship Tray
  translate(grid_offset(grid, [1, 1])) {
    scoop([remainder_width, ship_tray_length, height]);
  }
}
