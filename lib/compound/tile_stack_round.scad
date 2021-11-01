include <../layout/layout.scad>
include <../config/constants.scad>
include <./tile_stack.scad>

module tile_stack_round(
  diameter, 
  tile_height,
  count=1, 
  roof_height,
  left_cutout=false, 
  right_cutout=false,
  top_cutout=false,
  bottom_cutout=false,
  lid_height=0,
  inset=8
) {
  // No need to render any cutout if the size is zero
  if (count > 0) {
    tray_size = [
      pad(diameter),
      pad(diameter),
      stack_height(tile_height, count) + $bleed + lid_height,
    ];
  
    floor_height = roof_height - tray_size[2] + $bleed;
  
    translate([tray_size[0]/2, tray_size[1]/2, floor_height]) {
      cylinder(tray_size[2], tray_size[0]/2, tray_size[0]/2);
    }
    
    if (left_cutout) {
      left_cutout_size = [
        inset * 2 + $wall_thickness,
        tray_size[1] * $cutout_fraction,
        roof_height + $cutout_lid_height + $bleed * 2,
      ];
  
      translate([-left_cutout_size[0] + inset, (tray_size[1] - left_cutout_size[1]) / 2, 0]) {
        rounded_cube(left_cutout_size, flat=true);
      }
    }
  
    if (right_cutout) {
      right_cutout_size = [
        inset * 2 + $wall_thickness,
        tray_size[1] * $cutout_fraction,
        roof_height + $cutout_lid_height + $bleed * 2,
      ];
  
      translate([tray_size[0] - inset, (tray_size[1] - right_cutout_size[1]) / 2, 0]) {
        rounded_cube(right_cutout_size, flat=true);
      }
    }
  
    if (top_cutout) {
      top_cutout_size = [
        tray_size[0] * $cutout_fraction,
        inset * 2 + $wall_thickness,
        roof_height + $cutout_lid_height + $bleed * 2,
      ];
  
      translate([
        (tray_size[0] - top_cutout_size[0]) / 2, 
        tray_size[1] + $wall_thickness - inset,
        0
      ]) {
        rounded_cube(top_cutout_size, flat=true);
      }
    }

    if (bottom_cutout) {
      bottom_cutout_size = [
        tray_size[0] * $cutout_fraction,
        inset * 2 + $wall_thickness,
        roof_height + $cutout_lid_height +  $bleed * 2,
      ];
  
      translate([
        (tray_size[0] - bottom_cutout_size[0]) / 2, 
        0 - bottom_cutout_size[1] - $wall_thickness + inset,
        0
      ]) {
        rounded_cube(bottom_cutout_size, flat=true);
      }
    }
  }
}
