$padding = 0.5;
$wall_thickness = 2;

function stack_height (size, count=1) = size * count + $padding;

function padded_offset (length, index=1) = (length + $padding * 2 + $wall_thickness) * index;

function offset (size, index=1) = (size + $wall_thickness) * index;

function pad (size) = size + $padding * 2;

module offset_cylinder(d, h) {
  translate([d / 2, d / 2, 0]) {
    cylinder(d=d, h=h);
  }
}

module offset_circle(d) {
  translate([d / 2, d / 2, 0]) {
    circle(d=d);
  }
}

module offset_square(size, center=false) {
  translate([size[0] / 2, size[1] / 2, 0]) {
    square(size, center=center);
  }
}
