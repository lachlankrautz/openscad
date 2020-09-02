echo(version=version());

include <../../../lib/rounded_cube.scad>
include <../../../lib/elephant_foot.scad>
use <../../../fonts/Teutonic.ttf>

// Config
$fn = 50;
$bleed = 1;
$rounding = 2;

size = 9;
height = 4;
base_height = 2;
foot_rounding = 1;
foot_size = [
  size + foot_rounding * 2,
  size + foot_rounding * 2,
  height
];

spacing = 2;
font_spacing = 6;

count = 3;
base_size = [
  foot_size[0] * count + spacing * 2,
  foot_size[1] * 2 + font_spacing + spacing * 2,
  height + base_height
];

letter_height = 3;
module letter(l) {
  font = "Teutonic";
  letter_size = 5;

  // Use linear_extrude() to make the letters 3D objects as they
  // are only 2D shapes when only using text()
  linear_extrude(height = letter_height) {
    text(l, size=letter_size, font=font, halign="center", valign="center", $fn=16);
  }
}

difference() {
  cube(base_size);
  translate([spacing, spacing, base_height]) {
    for(i=[0:count-1]) {
      translate([i * foot_size[0], 0, 0]) {
        translate([foot_size[0] / 2, foot_size[1] * 2.3, letter_height]) {
          letter(str(i));
        }

        translate([foot_size[0] / 2, foot_size[1] * 1.5, -1]) {
          letter(str(i));
        }

        elephant_foot(
          foot_size, 
          flat_bottom=true, 
          use_bleed=true, 
          $rounding=foot_rounding
        );

        translate([0, foot_size[1], 0]) {
          elephant_foot(
            foot_size, 
            flat_bottom=true, 
            use_bleed=true, 
            $rounding=foot_rounding
          );
        }
      }
    }
  }
}
