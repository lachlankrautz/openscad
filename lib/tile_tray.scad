include <./layout.scad>

$wall_thickness = 2;
$bleed = 0.01;
$gap = 0.5;
$inset = 6;
$cutout_fraction = 0.6;

function get_tile_stack_height (size, count) = size[2] * count + $gap;

module tile_cutout(
  tile_size, 
  count, 
  floor_height=$wall_thickness, 
  roof_height=false,
  left_cutout=false, 
  right_cutout=false,
  top_cutout=false,
  bottom_cutout=false
) {
  tray_size = [
    tile_size[0] + $gap * 2,
    tile_size[1] + $gap * 2,
    get_tile_stack_height(tile_size, count) + $bleed,
  ];

  cutout_size = [
    tray_size[0] * $cutout_fraction,
    tray_size[1] * $cutout_fraction,
    box_size[2] + $bleed * 2,
  ];

  // TODO fix to not rely on box size!
  echo("cutout size: ", cutout_size);

  _floor_height = roof_height 
    ? roof_height - tray_size[2] + $bleed
    : floor_height;

  if (!_floor_height) {
    echo("bad tile: ", tile_size);
    echo("bad tray: ", tray_size);
  }

  translate([0, 0, _floor_height]) {
    rounded_cube(tray_size, flat=true, $rounding=1);
  }

  if (left_cutout) {
    translate([-cutout_size[0] + $inset, (tray_size[1] - cutout_size[1]) / 2, 0]) {
      rounded_cube(cutout_size, flat=true);
    }
  }

  if (right_cutout) {
    translate([tray_size[0] + $wall_thickness - $inset, (tray_size[1] - cutout_size[1]) / 2, 0]) {
      rounded_cube(cutout_size, flat=true);
    }
  }

  if (top_cutout) {
    translate([
      (tray_size[0] - cutout_size[0]) / 2, 
      tray_size[1] + $wall_thickness - $inset,
      0
    ]) {
      rounded_cube(cutout_size, flat=true);
    }
  }

  if (bottom_cutout) {
    translate([
      (tray_size[0] - cutout_size[0]) / 2, 
      0 - cutout_size[1] - $wall_thickness + $inset,
      0
    ]) {
      rounded_cube(cutout_size, flat=true);
    }
  }
}
