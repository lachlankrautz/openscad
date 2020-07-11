include <./rounded_cube.scad>

$bleed = 1;
$rounding = 3;

module cutout_tray(width, length, height) {
  difference() {
    // Base tray
    rounded_cube(width, length, height+$rounding+$bleed, $rounding=$rounding);

    // Cutouts
    children();
 
    // Slice off top
    translate([-$bleed,-$bleed,height]) {
      cube([width+$bleed*2, length+$bleed*2, $rounding+$bleed]);
    }
  }
}
