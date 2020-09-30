echo(version=version());

include <../../lib/rounded_cube.scad>
include <../../lib/tile_tray.scad>

// Config
// $fn = 10;
$fn = 50;
$wall_thickness = 2;
$padding = 0.5;
$bleed = 0.01;

padding_size = [
  $padding * 2,
  $padding * 2,
  $padding,
];

valuation_size = [
  63.5,
  89,
  9,
];
padded_valuation_size = valuation_size + padding_size;

upgrade_size = [
  65,
  46,
  13,
];
padded_upgrade_size = upgrade_size + padding_size;

token_diameter = 40;
token_height = 2.2;
token_count = 5;
padded_token_diameter = token_diameter + $padding * 2;
token_stack_height = token_height * token_count + $padding;

inset = 6;

token_cutout_size = [
  30,
  20,
  50,
];

box_size = [
  max(padded_valuation_size[0], padded_upgrade_size[0]) + $wall_thickness * 2,
  max(
    padded_valuation_size[1], 
    padded_upgrade_size[1] 
      + padded_token_diameter 
      + inset 
      + $wall_thickness
  ) + $wall_thickness * 2,
  padded_upgrade_size[2] + padded_valuation_size[2] + $wall_thickness
];

difference() {
  rounded_cube(box_size, flat_top=true, $rounding=2);

  translate([$wall_thickness, $wall_thickness, 0]) {
    translate([
      (padded_upgrade_size[0] - padded_valuation_size[0]) / 2, 
      0, 
      box_size[2] - padded_valuation_size[2]
    ]) {
      rounded_cube([
        padded_valuation_size[0],
        padded_valuation_size[1],
        padded_valuation_size[2] + $bleed,
      ], flat=true, $rounding=2);
    }
  }

  translate([$wall_thickness, $wall_thickness, 0]) {
    translate([0, inset, 0]) {
      tile_cutout([
        upgrade_size[0],
        upgrade_size[1],
        upgrade_size[2] + valuation_size[2] + $bleed,
      ], left_cutout=true, right_cutout=true);
    }
  }

  translate([
    box_size[0] / 2, 
    padded_upgrade_size[1] 
      + inset 
      + padded_token_diameter / 2
      + $wall_thickness * 2, 
    box_size[2] 
      - padded_valuation_size[2]
      - token_stack_height
  ]) {
    cylinder(d=padded_token_diameter, h=token_stack_height + $bleed);
  }

  translate([
    (box_size[0] - token_cutout_size[0]) / 2,
    box_size[1] - token_cutout_size[1] * 0.8, 
    0,
  ]) {
    rounded_cube(token_cutout_size, flat=true);
  }
}
