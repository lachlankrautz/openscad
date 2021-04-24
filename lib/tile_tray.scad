include <./layout.scad>

$wall_thickness = 2;
$bleed = 0.01;
$padding = 0.5;
$inset = 6;
$cutout_fraction = 0.6;

// I have no idea why it needs to be this vaule
// Seems to be to do with how the cube handles rounding
magic_pill_number = 0.4;

function tile_stack_height (size, count=1) = size[2] * count + $padding;

function tile_rounding (size, pill=false) = pill ? min(size[0], size[1]) / 2  + magic_pill_number: 1;

module tile_cutout(
  tile_size, 
  count=1, 
  roof_height,
  left_cutout=false, 
  right_cutout=false,
  top_cutout=false,
  bottom_cutout=false,
  pill=false
) {
  // No need to render any cutout if the size is zero
  if (count > 0) {
    tray_size = [
      pad(tile_size[0]),
      pad(tile_size[1]),
      tile_stack_height(tile_size, count) + $bleed,
    ];
  
    floor_height = roof_height - tray_size[2] + $bleed;
  
    translate([0, 0, floor_height]) {
      rounded_cube(tray_size, flat=true, $rounding=tile_rounding(tile_size, pill));
    }
    
    if (left_cutout) {
      left_cutout_size = [
        $inset * 2 + $wall_thickness,
        tray_size[1] * $cutout_fraction,
        roof_height + $bleed * 2,
      ];
  
      translate([-left_cutout_size[0] + $inset, (tray_size[1] - left_cutout_size[1]) / 2, 0]) {
        rounded_cube(left_cutout_size, flat=true);
      }
    }
  
    if (right_cutout) {
      right_cutout_size = [
        $inset * 2 + $wall_thickness,
        tray_size[1] * $cutout_fraction,
        roof_height + $bleed * 2,
      ];
  
      translate([tray_size[0] - $inset, (tray_size[1] - right_cutout_size[1]) / 2, 0]) {
        rounded_cube(right_cutout_size, flat=true);
      }
    }
  
    if (top_cutout) {
      top_cutout_size = [
        tray_size[0] * $cutout_fraction,
        $inset * 2 + $wall_thickness,
        roof_height + $bleed * 2,
      ];
  
      translate([
        (tray_size[0] - top_cutout_size[0]) / 2, 
        tray_size[1] + $wall_thickness - $inset,
        0
      ]) {
        rounded_cube(top_cutout_size, flat=true);
      }
    }
  
    if (bottom_cutout) {
      bottom_cutout_size = [
        tray_size[0] * $cutout_fraction,
        $inset * 2 + $wall_thickness,
        roof_height + $bleed * 2,
      ];
  
      translate([
        (tray_size[0] - bottom_cutout_size[0]) / 2, 
        0 - bottom_cutout_size[1] - $wall_thickness + $inset,
        0
      ]) {
        rounded_cube(bottom_cutout_size, flat=true);
      }
    }
  }
}
