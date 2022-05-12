module cosmic_token_tray_lid(tile_size, matrix, matrix_counts) {
  box_size = box_size(tile_size, matrix, matrix_counts);

  spin_orientation(box_size) {
    dovetail_lid(spin_orientation_size(box_size), honeycomb_diameter=16);
  }
}
