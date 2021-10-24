$wall_thickness = 3;
$card_space_width = 97;
$fn = 50;

height = 70;
depth = 10;

module triangular_prism(width, height, depth, distance="undef") {
  _distance = (distance == "undef")
    ? (width / 2)
    : distance;

  translate([0, depth, width]) {
    rotate([90, 90, 0]) {
      linear_extrude(depth) {
        polygon([[0, 0], [width, 0], [_distance, height]]);
      }
    }
  }
}

module card_slope(height, depth, width=$card_space_width) {
  triangular_prism(depth, height, width, depth);
}

card_slope(height, depth);
