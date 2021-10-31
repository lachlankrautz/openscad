include <../layout/layout.scad>

$bleed = 0.01;
$padding = 0.4;

function disc_offset (diameter, index=1) = (diameter + $padding * 2 + $wall_thickness) * index;

/**
 * A cylinder positioned to be subtracted from a box creating a socket for a
 * disc / cynlinder
 */
module disc_socket(diameter, height, box_height) {
  padded_diameter = diameter + $padding * 2;
  padded_height = height + $padding;
  cutout_height = padded_height / 2;
  radius = padded_diameter / 2;

  translate([radius, radius, box_height - cutout_height]) {
    cylinder(d=padded_diameter, h=cutout_height + $bleed, center=false);
  }
}
