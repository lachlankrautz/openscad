echo(version=version());

$wall_thickness = 2;
$fn = 50;
$bleed = 0.1;

depth = 15;
card_space_width = 98;
height = 70;

padding = 5;


cube([depth, card_space_width, $wall_thickness]);

difference() {
  cube([$wall_thickness, card_space_width, height]);
  translate([-$bleed, padding, padding]) {
    cube([$wall_thickness + ($bleed * 2) + 100, card_space_width - (padding * 2), height - (padding * 2)]);
  }
}
