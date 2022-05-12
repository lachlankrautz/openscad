include <./config/building-tile-config.scad>

spin_orientation(box_size) {
  dovetail_lid(spin_orientation_size(box_size), honeycomb_diameter=25);
}
