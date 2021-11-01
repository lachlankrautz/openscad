$fn = 50;

card_space_width = 98;

height = 70;
depth = 10;

module triangular_prism(width, height, depth, distance=0) {
  translate([0, depth, width]) {
    rotate([90, 90, 0]) {
      linear_extrude(depth) {
        polygon([[0, 0], [width, 0], [(distance == 0) ? (width / 2) : distance, height]]);
      }
    }
  }
}

module card_slope(height, depth, width=card_space_width) {
  triangular_prism(depth, height, width, depth);
}

card_slope(height, depth);
