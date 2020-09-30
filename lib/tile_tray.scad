$wall_thickness = 2;
$bleed = 0.01;
$tile_gap = 0.5;
$inset = 6;

function get_tile_offset (size, index=1) = (size + $tile_gap * 2 + $wall_thickness) * index;

module tile_cutout(
  tile_size, 
  count, 
  floor_height=$wall_thickness, 
  roof_height=false,
  left_cutout=false, 
  right_cutout=false
) {
  tray_size = [
    tile_size[0] + $tile_gap * 2,
    tile_size[1] + $tile_gap * 2,
    tile_size[2] * count + $tile_gap + $bleed,
  ];

  fraction = 0.6;
  cutout_size = [
    tray_size[0] * fraction,
    tray_size[1] * fraction,
    box_size[2] + $bleed * 2,
  ];

  _floor_height = roof_height 
    ? roof_height - tray_size[2] + $bleed
    : floor_height;

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
}
