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

// Model
cutout_tray([width, length, height]) {
  scoop(item_size(width, 2), item_size(length), height);

  scoop(item_size(width, 2), item_size(length, 2), height);
  scoop(item_size(width, 2), item_size(length, 2), height);
}
