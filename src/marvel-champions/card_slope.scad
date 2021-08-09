echo(version=version());

$wall_thickness = 3;
$card_space_width = 98;
$fn = 50;

height = 70;
depth = 10;

module triangular_prism(width, height, depth, distance=0) {
  translate([0, depth, 0]) {
    rotate([90, 0, 0]) {
      linear_extrude(depth) {
        polygon([[0, 0], [width, 0], [(distance == 0) ? (width / 2) : distance, height]]);
      }
    }
  }
}

module card_slope(height, depth, width=$card_space_width) {
  triangular_prism(depth, height, width, depth);
}

card_slope(height, depth);
