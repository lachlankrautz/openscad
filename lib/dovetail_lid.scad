include <./honeycomb.scad>
include <./trapezoid.scad>

$wall_thickness = 2;
$inner_wall_thickness = 1;
$lid_height = 3;
$trapezoid_inset = 2;
$bleed = 0.01;
$rounding = 3;
$clearance = 0.5;
$length_tolerance = 0.25;
$width_tolerance = 0.25;

dovetail_tolerance = [$length_tolerance, $width_tolerance * 2, 0];
dovetail_cutout_bleed = [$bleed, $bleed * 2, $bleed * 2];

function dovetail_size(box_size) = [
  box_size[0] - $wall_thickness,
  box_size[1] - ($wall_thickness - $inner_wall_thickness) * 2,
  $lid_height,
];

/**
 * Draw a lid for the given box size
 *
 * @param box_size [x, y]
 */
module dovetail_lid(box_size, honeycomb_diameter = false) {
  dovetail_size = dovetail_size(box_size);

  // Shrink slightly using tolerance values for a better slotting fit
  tolerant_dovetail_size = dovetail_size - dovetail_tolerance;

  difference() {
    dovetail(tolerant_dovetail_size, honeycomb_diameter=honeycomb_diameter);

    // Need to ensure the fit is as clean as possible
    // TODO this really didn't work
    elephant_foot_compensation(tolerant_dovetail_size);
  }
}

module dovetail_lid_cutout(box_size) {
  dovetail_size = dovetail_size(box_size);

  // Expand slightly with bleed so cutout doesn't leave ghost panels
  dovetail_cutout_size = dovetail_size + dovetail_cutout_bleed;

  translate([
    -$bleed, // move left to bleed over the left wall
    (box_size[1] - dovetail_cutout_size[1]) / 2, // put in the middle using the difference
    box_size[2] - dovetail_cutout_size[2] + $bleed, // cut off the top of the tray box, move up to bleed over the roof
  ]) {
    dovetail(dovetail_cutout_size);
  }
}

module dovetail(size, honeycomb_diameter = false) {
  honeycomb = honeycomb_diameter > 0;
  honeycomb_size = honeycomb_inset_size(size, $trapezoid_inset + $wall_thickness / 2);

  difference() {
    trapezoid_prism(size, $trapezoid_inset);

    if (honeycomb) {
      translate([
        (size[0] - honeycomb_size[0]) / 2,
        (size[1] - honeycomb_size[1]) / 2,
        -$bleed
      ]) {
        negative_honeycomb_cube(honeycomb_size, honeycomb_diameter);
      }
    }
  }
}
