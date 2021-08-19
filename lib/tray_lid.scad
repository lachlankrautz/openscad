include <./honeycomb.scad>

$wall_thickness = 2;
$bleed = 0.01;
$rounding = 3;
$clearance = 0.5;

// Put notches in the corner just inset from the corner
function inset() = $rounding * 2 + $clearance;
function notch_length() = $rounding * 2;
function notch_width() = $wall_thickness;
function notch_height() = $wall_thickness + $bleed;

/**
 * Draw the notches to lock in the lid
 * Diff them from the bottom tray to create lock
 *
 * @param tray_size [x, y]
 * @param matrix [x, y] how many divisions on each axis
 */
module tray_lid_notches(tray_size, matrix) {
  inset = inset();
  notch_length = notch_length();
  notch_width = notch_width();
  notch_height = notch_height();

  // bottom left
  translate([$wall_thickness, inset, 0]) {
    rounded_cube([notch_width, notch_length, $wall_thickness], flat_bottom=true, $rounding=0.5);
  }
  translate([inset, $wall_thickness, 0]) {
    rounded_cube([notch_length, notch_width, $wall_thickness], flat_bottom=true, $rounding=0.5);
  }

  // bottom right
  translate([tray_size[0] - notch_width - $wall_thickness, inset, 0]) {
    rounded_cube([notch_width, notch_length, $wall_thickness], flat_bottom=true, $rounding=0.5);
  }
  translate([tray_size[0] - inset - notch_length, $wall_thickness, 0]) {
    rounded_cube([notch_length, notch_width, $wall_thickness], flat_bottom=true, $rounding=0.5);
  }

  // top left
  translate([$wall_thickness, tray_size[1] - inset - notch_length]) {
    rounded_cube([notch_width, notch_length, $wall_thickness], flat_bottom=true, $rounding=0.5);
  }
  translate([inset, tray_size[1] - notch_width - $wall_thickness, 0]) {
    rounded_cube([notch_length, notch_width, $wall_thickness], flat_bottom=true, $rounding=0.5);
  }

  // top right
  translate([tray_size[0] - notch_width - $wall_thickness, tray_size[1] - notch_length - inset, 0]) {
    rounded_cube([notch_width, notch_length, $wall_thickness], flat_bottom=true, $rounding=0.5);
  }
  translate([tray_size[0] - inset - notch_length, tray_size[1] - notch_width - $wall_thickness, 0]) {
    rounded_cube([notch_length, notch_width, $wall_thickness], flat_bottom=true, $rounding=0.5);
  }
}

/**
 * Draw a lid for the given tray size
 *
 * @param tray_size [x, y]
 * @param matrix [x, y] how many divisions on each axis
 */
module tray_lid(tray_size, matrix, honeycomb=false) {
  lid_size = [
    tray_size[0],
    tray_size[1],
    $wall_thickness,
  ];

  inset = inset();
  notch_length = notch_length();
  notch_width = notch_width();
  notch_height = notch_height();

  honeycomb_size = [
    lid_size[0] - notch_width * 4,
    lid_size[1] - notch_width * 4,
    lid_size[2] + $bleed * 2,
  ];

  union() {
    difference() {
      rounded_cube(lid_size, flat_top=true);

      if (honeycomb) {
        translate([notch_width * 2, notch_width * 2 - $bleed]) {
          negative_honeycomb_cube(honeycomb_size);
        }
      }
    }

    translate([0, 0, $wall_thickness - $bleed]) {
      tray_lid_notches(tray_size, matrix);
    }
  }
}
