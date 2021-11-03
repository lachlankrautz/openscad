include <../../lib/config/card_sizes.scad>
include <../../lib/tray/card_tray.scad>
include <../../lib/lid/dovetail_lid.scad>
include <./card_tray_config.scad>

$fn = 50;

point_rotate(box_size) {
  dovetail_lid(point_rotate_size(box_size), honeycomb_diameter=50);
}
