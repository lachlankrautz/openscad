include <../design/honeycomb.scad>
include <../primitive/trapezoid.scad>
include <../util/elephant_foot_compensation.scad>
include <../config/minimum_constants.scad>
include <../config/assert_helpers.scad>

// TODO review all of these constants
// are they needed by other components?
// can they just be regular variables or parameter defaults?
length_tolerance = 0.25;
width_tolerance = 0.12;
bump_tolerance = 0.2;
default_bump_radius = 0.5;

dovetail_tolerance = [length_tolerance, width_tolerance * 2, 0];
dovetail_cutout_bleed = [$bleed, $bleed * 2, $bleed * 2];

default_trapezoid_inset = 1;

function dovetail_size(
  box_size, 
  lid_height, 
  wall_thickness, 
  inner_wall_thickness
) = 
  assert(is_cube_size(box_size), box_size)
  assert(is_num(lid_height), lid_height)
  assert(is_num(wall_thickness), wall_thickness)
  assert(is_num(inner_wall_thickness), inner_wall_thickness)
  [
    box_size[0] - wall_thickness,
    box_size[1] - inner_wall_thickness * 2,
    lid_height,
  ];

/**
 * Draw a lid for the given box size
 *
 * @param box_size [x, y]
 */
module dovetail_lid(
  box_size, 
  lid_height, 
  wall_thickness,
  inner_wall_thickness,
  honeycomb_diameter=0, 
  elephant_foot_compensation=true
) {
  assert(is_cube_size(box_size), box_size);
  assert(is_num(lid_height), lid_height);
  assert(is_num(wall_thickness), wall_thickness);
  assert(is_num(inner_wall_thickness), inner_wall_thickness);

  dovetail_size = dovetail_size(box_size, lid_height, wall_thickness, inner_wall_thickness);

  // Shrink slightly using tolerance values for a better slotting fit
  tolerant_dovetail_size = dovetail_size - dovetail_tolerance;

  difference() {
    dovetail(tolerant_dovetail_size, honeycomb_diameter=honeycomb_diameter);

    // Need to ensure the fit is as clean as possible
    if (elephant_foot_compensation) {
      elephant_foot_compensation_trapezoid(tolerant_dovetail_size);
    }
  }
}

module dovetail_lid_cutout(
  box_size, 
  lid_height,
  wall_thickness,
  inner_wall_thickness,
) {
  assert(is_cube_size(box_size), box_size);
  assert(is_num(lid_height), lid_height);
  assert(is_num(wall_thickness), wall_thickness);
  assert(is_num(inner_wall_thickness), inner_wall_thickness);

  bump_radius = default_bump_radius + bump_tolerance;
  dovetail_size = dovetail_size(box_size, lid_height, wall_thickness, inner_wall_thickness);

  // Expand slightly with bleed so cutout doesn't leave ghost panels
  dovetail_cutout_size = dovetail_size + dovetail_cutout_bleed;

  translate([
    -$bleed, // move left to bleed over the left wall
    (box_size[1] - dovetail_cutout_size[1]) / 2, // put in the middle using the difference
    box_size[2] - dovetail_cutout_size[2] + $bleed, // cut off the top of the tray box, move up to bleed over the roof
  ]) {
    dovetail(dovetail_cutout_size, wall_thickness);
  }
}

module dovetail(
  size, 
  wall_thickness,
  bump_radius=undef, 
  honeycomb_diameter=0
) {
  assert(is_cube_size(size), size);
  assert(is_num(wall_thickness), wall_thickness);

  honeycomb = honeycomb_diameter > 0;
  honeycomb_size = honeycomb_inset_size(
    size - [wall_thickness * 2, wall_thickness * 2, 0], 
    default_trapezoid_inset + wall_thickness / 2,
    wall_thickness
  );

  _bump_radius = bump_radius ? bump_radius: default_bump_radius;
  bump_inset = 1.5;
  disc_height = $bleed;

  difference() {
    union() {
      trapezoid_prism(size, default_trapezoid_inset);

      // Right bump
      translate([bump_inset, 0, 0]) {
        // Combine two discs to create a slanted cylinder
        hull() {
          translate([0, 0, 0]) {
            cylinder(r=_bump_radius, h=disc_height);
          }
          translate([0, default_trapezoid_inset, size[2] - disc_height]) {
            cylinder(r=_bump_radius, h=disc_height);
          }
        }
      }

      // Left bump
      translate([bump_inset, size[1], 0]) {
        // Combine two discs to create a slanted cylinder
        hull() {
          translate([0, 0, 0]) {
            cylinder(r=_bump_radius, h=disc_height);
          }
          translate([0, -default_trapezoid_inset, size[2] - disc_height]) {
            cylinder(r=_bump_radius, h=disc_height);
          }
        }
      }
    }

    if (honeycomb) {
      translate([
        (size[0] - honeycomb_size[0]) / 2,
        (size[1] - honeycomb_size[1]) / 2,
        -$bleed
      ]) {
        negative_honeycomb_cube(honeycomb_size, wall_thickness, honeycomb_diameter);
      }
    }
  }
}
