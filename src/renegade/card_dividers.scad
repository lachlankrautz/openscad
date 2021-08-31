include <../../lib/trapezoid.scad>

$fn = 50;
$wall_thickness = 2;
$bleed = 0.01;

height = 54;
card_gap_width = 70;
mid_grip_width = 45;
side_grip_width = 25;
trapezoid_inset = 5;
model_gap = 5;

cube([card_gap_width + $bleed, $wall_thickness, height]);


translate([card_gap_width, -(mid_grip_width - $wall_thickness) / 2, 0 ]) {
  trapezoid_prism([$wall_thickness, mid_grip_width, height], trapezoid_inset);
}

// hacky way to get a slope on just one side
// TODO extend the trapezoid modules to handle this case
module side_prism() {
  difference() {
    trapezoid_prism([$wall_thickness, side_grip_width, height], trapezoid_inset);

    translate([-$bleed, 0, -$bleed]) {
      cube([$wall_thickness + $bleed * 2, trapezoid_inset + $bleed, height + $bleed * 2]);
    }
  }
}

translate([card_gap_width + $wall_thickness + model_gap, 0, $wall_thickness]) {
  rotate([0, 90, 0]) {
    side_prism();
  }
}

translate([card_gap_width + $wall_thickness + height + model_gap * 2, 0, $wall_thickness]) {
  rotate([0, 90, 0]) {
    side_prism();
  }
}
