module cosmic_token_tray(tile_size, matrix, matrix_counts) {
  box_size = box_size(tile_size, matrix, matrix_counts);

  difference() {
    rounded_cube(box_size, flat_top=true, $rounding=1);

    translate($wall_rect) {
      for(x=[0:len(matrix)-1]) {
        for(y=[0:len(matrix[x])-1]) {
          translate([padded_offset(tile_size[0], x), padded_offset(tile_size[1], y), 0]) {
            tile_stack(
            matrix[x][y],
            matrix_counts[x][y],
            box_size[2],
            top_cutout = y == len(matrix[x])-1,
            bottom_cutout= y == 0,
            lid_height = $lid_height,
            use_rounded_cube = false
            );
          }
        }
      }
    }

    spin_orientation(box_size) {
      dovetail_lid_cutout(spin_orientation_size(box_size));
    }
  }
}
