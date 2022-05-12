include <../../lib/config/card_sizes.scad>
include <../../lib/tray/card_tray.scad>
include <../../lib/lid/dovetail_lid.scad>
include <./card_tray_config.scad>

$fn = 50;

difference() {
  card_grid(card_grid_sizes, box_size[2], top_cutout=false, bottom_cutout=false, inner_cutout=false);

  spin_orientation(box_size) {
    dovetail_lid_cutout(spin_orientation_size(box_size));
  }
}
