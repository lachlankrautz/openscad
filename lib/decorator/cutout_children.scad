include <../primitive/rounded_cube.scad>
include <../config/constants.scad>

module cutout_children(size) {
  width = size[0];
  length = size[1];
  height = size[2];

  difference() {
    // Base tray
    rounded_cube([width, length, height + $rounding + $bleed]);

    // Cutouts
    translate([$wall_thickness, $wall_thickness, $wall_thickness]) {
      children();
    }
 
    // Slice off top
    translate([-$bleed, -$bleed, height]) {
      cube([
        width + $bleed * 2, 
        length + $bleed * 2, 
        $rounding + $bleed
      ]);
    }
  }
}
