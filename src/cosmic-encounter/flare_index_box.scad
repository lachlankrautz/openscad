echo(version=version());

include <../../lib/rounded_cube.scad>
include <../../lib/layout.scad>

$fn = 50;
$wall_thickness = 2;
$bleed = 0.01;
$padding = 0.5;
$cutout_fraction = 0.6;

module index_card_tray(
  cards_size, 
  count=1, 
  roof_height
) {
  tray_size = [
    pad(cards_size[0]),
    pad(cards_size[1]),
    cards_size[2] + $bleed,
  ];

  floor_height = roof_height 
    ? roof_height - tray_size[2] + $bleed
    : $wall_thickness;

  translate([0, 0, floor_height]) {
    rounded_cube(tray_size, flat=true, $rounding=1);
  }
}

card_tray_size = [
  129,
  144,
  50
];

box_size = [
  card_tray_size[0] + $wall_thickness * 2,
  card_tray_size[1] + $wall_thickness * 2,
  card_tray_size[2] + $wall_thickness,
];

incline_width = 7;

difference() {
  rounded_cube(box_size, flat_top=true);

  translate([$wall_thickness, $wall_thickness, $wall_thickness]) {
    hull() {
      translate([0, incline_width, 0]) {
        cube([card_tray_size[0], card_tray_size[1] - incline_width * 2, $bleed]);
      }

      translate([0, 0, card_tray_size[2]]) {
        cube([card_tray_size[0], card_tray_size[1], $bleed]);
      }
    }
  }
}
