include <./honeycomb.scad>
include <./trapezoid.scad>

$wall_thickness = 2;
$bleed = 0.01;
$rounding = 3;
$clearance = 0.5;
// 20 too low
// 30 too hight
// 25...
$tolerance = 0.25;

function dovetail_size(size, inset, lid_height = $wall_thickness) = [
  size[0] - $wall_thickness - $tolerance * 1.5,
  size[1] - ($wall_thickness - inset) * 2 - $tolerance * 2,
  lid_height,
];

module dovetail_lid_cutout(size, lid_height = $wall_thickness, trapezoid_inset = 1) {
  padded_size = size + [0, $bleed * 2, $bleed * 2];
  padded_lid_height = lid_height + $bleed * 2;

  // Set tolerance to 0 so the cutout uses the full size
  cutout_size = dovetail_size(padded_size, trapezoid_inset, padded_lid_height, $tolerance=0);

  translate([
    0,
    (size[1] - cutout_size[1]) / 2, // centre
    size[2] - lid_height, // cutout from top
  ]) {
    dovetail_lid(padded_size, padded_lid_height, $tolerance=0);
  }
}

/**
 * Draw a lid for the given tray size
 *
 * @param tray_size [x, y]
 */
module dovetail_lid(
  tray_size,
  lid_height = $wall_thickness,
  trapezoid_inset = 1,
  honeycomb_diameter = false
) {
  honeycomb = honeycomb_diameter > 0;

  lid_size = dovetail_size(tray_size, trapezoid_inset, lid_height);
  honeycomb_size = honeycomb_inset_size(lid_size);

  translate([-$bleed, 0, 0]) {
    difference() {
      trapezoid_prism(lid_size, trapezoid_inset);

      if (honeycomb) {
        translate([
          (lid_size[0] - honeycomb_size[0]) / 2,
          (lid_size[1] - honeycomb_size[1]) / 2,
          -$bleed
        ]) {
          negative_honeycomb_cube(honeycomb_size, honeycomb_diameter);
        }
      }
    }
  }
}
