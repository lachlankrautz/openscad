echo(version=version());

$wall_thickness = 3;
$fn = 50;

module triangular_prism(base, distance, h, height, scale) {
  linear_extrude(height, scale) {
    polygon([[0, 0], [base, 0], [distance, h]]);
  }
}

triangular_prism(3, 3, 3, 1, 1);
