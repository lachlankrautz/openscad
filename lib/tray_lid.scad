include <./honeycomb.scad>

$wall_thickness = 2;
$bleed = 0.01;
$rounding = 3;
$clearance = 0.5;

// Put notches in the corner just inset from the corner
function inset() = $rounding * 2 + $clearance;
function notch_length() = notch_width() * 2;
function notch_width() = 5;
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

  size = [
    tray_size[0] - (notch_width + $wall_thickness) * 2,
    tray_size[1] - (notch_width + $wall_thickness) * 2,
  ];

  translate([$wall_thickness, $wall_thickness, 0]) {

    // bottom left
    translate([0, notch_width, 0]) {
      rounded_cube([notch_width, notch_length, $wall_thickness], flat_bottom = true, $rounding = 0.5);
    }
    translate([notch_width, 0, 0]) {
      rounded_cube([notch_length, notch_width, $wall_thickness], flat_bottom = true, $rounding = 0.5);
    }

    // bottom right
    translate([size[0] + notch_width, notch_width, 0]) {
      rounded_cube([notch_width, notch_length, $wall_thickness], flat_bottom=true, $rounding=0.5);
    }
    translate([size[0] - notch_width, 0, 0]) {
      rounded_cube([notch_length, notch_width, $wall_thickness], flat_bottom=true, $rounding=0.5);
    }

    // top left
    translate([0, size[1] - notch_width]) {
      rounded_cube([notch_width, notch_length, $wall_thickness], flat_bottom=true, $rounding=0.5);
    }
    translate([notch_width, size[1] + notch_width, 0]) {
      rounded_cube([notch_length, notch_width, $wall_thickness], flat_bottom=true, $rounding=0.5);
    }

    // top right
    translate([size[0] + notch_width , size[1] - notch_width, 0]) {
      rounded_cube([notch_width, notch_length, $wall_thickness], flat_bottom=true, $rounding=0.5);
    }
    translate([size[0] - notch_width, size[1] + notch_width, 0]) {
      rounded_cube([notch_length, notch_width, $wall_thickness], flat_bottom=true, $rounding=0.5);
    }
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
    lid_size[0] - (notch_width + $wall_thickness) * 2,
    lid_size[1] - (notch_width + $wall_thickness) * 2,
    lid_size[2] + $bleed * 2,
  ];

  difference() {
    rounded_cube(lid_size, flat_top=true);

    if (honeycomb) {
      translate([notch_width + $wall_thickness, notch_width + $wall_thickness - $bleed]) {
        negative_honeycomb_cube(honeycomb_size);
      }
    }
  }

  translate([0, 0, $wall_thickness - $bleed]) {
    tray_lid_notches(tray_size, matrix);
  }
}
