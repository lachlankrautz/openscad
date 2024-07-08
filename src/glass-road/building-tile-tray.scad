include <./config/building-tile-config.scad>

difference() {
  rounded_cube(box_size, flat_top=true, $rounding=1);

  translate([$wall_thickness, $wall_thickness]) {
    for(x=[0:len(matrix)-1]) {
      for(y=[0:len(matrix[x])-1]) {
        translate([padded_offset(tile_size[0], x), padded_offset(tile_size[1], y), 0]) {
          tile_stack(
            matrix[x][y],
            matrix_counts[x][y],
            box_size[2],
            left_cutout = x == 0,
            right_cutout = x > 0,
            lid_height = $lid_height
          );
        }
      }
    }
  }

  spin_orientation(box_size) {
    dovetail_lid_cutout(spin_orientation_size(box_size));
  }
}
