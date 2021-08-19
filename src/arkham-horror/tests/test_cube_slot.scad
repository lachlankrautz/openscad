include <../../../lib/rounded_cube.scad>
include <../../../lib/elephant_foot.scad>
use <../../../assets/fonts/Teutonic.ttf>

// Config
$fn = 50;
$bleed = 1;
$rounding = 2;

size = 9;
// height = 4;
height = 2;
base_height = 2;
foot_rounding = 1;
foot_size = [
  size + foot_rounding * 2,
  size + foot_rounding * 2,
  height
];

spacing = 2;
letter_size = 8;
font_spacing = letter_size + 2;

cols = 2;
rows = 1;

base_size = [
  foot_size[0] * cols + spacing * 2,
  foot_size[1] * rows + font_spacing + spacing * 2,
  height + base_height
];

// 0.8 was best in tests of many heights
letter_depth = 0.8;
letter_height = height - letter_depth;

module letter(l) {
  font = "Teutonic";

  // Use linear_extrude() to make the letters 3D objects as they
  // are only 2D shapes when only using text()
  linear_extrude(height = letter_height) {
    text(l, size=letter_size, font=font, halign="center", valign="center", $fn=16);
  }
}

difference() {
  cube(base_size);
  translate([spacing, spacing, base_height]) {
    for(i=[0:cols-1]) {
      translate([i * foot_size[0], 0, 0]) {
        translate([foot_size[0] / 2, foot_size[1] * (rows + 0.5), letter_height]) {
          letter(str(i));
        }

        if (rows > 0) {
          for(j=[0:rows-1]) {
            translate([0, foot_size[1] * j, 0]) {
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
  }
}
