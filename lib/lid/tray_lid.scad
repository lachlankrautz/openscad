include <../design/honeycomb.scad>
include <../config/constants.scad>

lid_clearance = 0.5;

// Put notches in the corner just inset from the corner
function inset() = $rounding * 2 + lid_clearance;
function notch_length() = notch_width() * 2;
function notch_width() = 5;

/**
 * Draw the notches to lock in the lid
 * Diff them from the bottom tray to create lock
 *
 * @param tray_size [x, y]
 * @param matrix [x, y] how many divisions on each axis
 */
module tray_lid_notches(
  tray_size,
  matrix,
  notch_height,
  top=true,
  right=true,
  bottom=true,
  left=true
) {
  inset = inset();
  notch_length = notch_length();
  notch_width = notch_width();

  size = [
    tray_size[0] - (notch_width + $wall_thickness) * 2,
    tray_size[1] - (notch_width + $wall_thickness) * 2,
  ];

  translate([$wall_thickness, $wall_thickness, 0]) {

    if (left) {
      translate([0, notch_width, 0]) {
        rounded_cube([notch_width, notch_length, notch_height], flat_bottom = true, $rounding = 0.5);
      }
      translate([0, size[1] - notch_width]) {
        rounded_cube([notch_width, notch_length, notch_height], flat_bottom=true, $rounding=0.5);
      }
    }

    if (right) {
      translate([size[0] + notch_width , size[1] - notch_width, 0]) {
        rounded_cube([notch_width, notch_length, notch_height], flat_bottom=true, $rounding=0.5);
      }
      translate([size[0] + notch_width, notch_width, 0]) {
        rounded_cube([notch_width, notch_length, notch_height], flat_bottom=true, $rounding=0.5);
      }
    }

    if (bottom) {
      translate([notch_width, 0, 0]) {
        rounded_cube([notch_length, notch_width, notch_height], flat_bottom = true, $rounding = 0.5);
      }
      translate([size[0] - notch_width, 0, 0]) {
        rounded_cube([notch_length, notch_width, notch_height], flat_bottom=true, $rounding=0.5);
      }
    }

    if (top) {
      translate([notch_width, size[1] + notch_width, 0]) {
        rounded_cube([notch_length, notch_width, notch_height], flat_bottom=true, $rounding=0.5);
      }
      translate([size[0] - notch_width, size[1] + notch_width, 0]) {
        rounded_cube([notch_length, notch_width, notch_height], flat_bottom=true, $rounding=0.5);
      }
    }
  }
}


// TODO is this even used anywhere?
/**
 * Draw a lid for the given tray size
 *
 * @param tray_size [x, y]
 * @param matrix [x, y] how many divisions on each axis
 */
module tray_lid(
  tray_size,
  matrix,
  wall_thickness,
  notch_height = 4,
  honeycomb_diameter=false,
  top=true,
  right=true,
  bottom=true,
  left=true
) {
  assert(is_num(wall_thickenss), wall_thickness);

  lid_size = [
    tray_size[0],
    tray_size[1],
    wall_thickness,
  ];
  _notch_height = notch_height + $bleed;
  honeycomb = honeycomb_diameter > 0;

  inset = inset();
  notch_length = notch_length();
  notch_width = notch_width();

  honeycomb_size = [
    lid_size[0] - (notch_width + wall_thickness) * 2,
    lid_size[1] - (notch_width + wall_thickness) * 2,
    lid_size[2] + $bleed * 2,
  ];

  difference() {
    rounded_cube(lid_size, flat=true);

    if (honeycomb) {
      translate([notch_width + wall_thickness, notch_width + wall_thickness, - $bleed]) {
        negative_honeycomb_cube(honeycomb_size, wall_thickness, honeycomb_diameter);
      }
    }
  }

  translate([0, 0, wall_thickness - $bleed]) {
    tray_lid_notches(
      tray_size,
      matrix,
      _notch_height,
      top=top,
      right=right,
      bottom=bottom,
      left=left
    );
  }
}
