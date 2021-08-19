include <../../lib/rounded_cube.scad>
include <../../lib/elephant_foot.scad>
include <../../lib/svg_icon.scad>

// Config
$wall_thickness = 4;
$bleed = 1;
// $fn = 4;
$fn = 50;
skip_cubes = false;

// Attributes
min_floor_height = 2;
cube_cutout_height = 4;

// Derived Attributes
// TODO compute based on nested component sizes
dashboard_size = [
  20,
  20,
  min_floor_height + cube_cutout_height
];

module letter(l, letter_size, halign="center", valign="center") {
  font = "Teutonic";
  letter_height = 1;

  // Use linear_extrude() to make the letters 3D objects as they
  // are only 2D shapes when only using text()
  linear_extrude(height = letter_height) {
    text(l, size=letter_size, font=font, halign=halign, valign=valign, $fn=16);
  }
}

module magnet_hole() {
  magnet_height = 1;

  translate([magnet_diameter / 2, magnet_diameter / 2, -magnet_height]) {
    cylinder(h=magnet_height + $bleed, d=magnet_diameter);
  }
}

module action_tray() {
}

module player_dashboard() {
  // Positioning Attributes
  
  // Model
  difference() {
    rounded_cube(dashboard_size, flat=true);
 
    // Place all trays inside wall bufer
    translate([$wall_thickness, $wall_thickness, 0]) {
      // Place action tray first
      action_tray();
    }
  }
}

player_dashboard();
