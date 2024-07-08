include <../primitive/scoop_tray.scad>
include <../lid/dovetail_lid.scad>
include <../config/constants.scad>

default_trapezoid_inset = 1;

module dovetail_scoop_tray(size, matrix=[1, 1], radius=0, rounded=false) {
  // Adjust the scoop tray to allow for wider walls used by dovetail lids
  virtual_adjustment = [0, ($inner_wall_thickness + default_trapezoid_inset - $wall_thickness) * 2, 0];
  virtual_scoop_tray_size = size - virtual_adjustment;

  difference() {
    rounded_cube(size, flat_top=true, $rounding=1);
    translate(virtual_adjustment / 2) {
      scoop_matrix(virtual_scoop_tray_size, matrix);
    }
    dovetail_lid_cutout(size);
  }
}
