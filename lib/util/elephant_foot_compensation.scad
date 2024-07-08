include <../config/minimum_constants.scad>

default_foot_offset = 0.25;

module triangular_prism(l, w, h) {
  polyhedron(
    points = [[0, 0, 0], [l, 0, 0], [l, w, 0], [0, w, 0], [0, w, h], [l, w, h]],
    faces = [[0, 1, 2, 3], [5, 4, 3, 2], [0, 4, 5, 1], [0, 3, 4], [5, 2, 1]]
  );
}

module elephant_foot_compensation_trapezoid(size, foot_offset=default_foot_offset) {
  bleed_size = size + [$bleed * 2, $bleed * 2, $bleed * 2];
  bleed_offset = [-$bleed, -$bleed, -$bleed];
  edge_size = [bleed_size[0], foot_offset * 5, foot_offset * 5];

  translate(bleed_offset) {
    translate([0, -edge_size[1] + foot_offset, 0]) {
        cube(edge_size);
    }

    translate([0, bleed_size[1] - foot_offset, 0]) {
      cube(edge_size);
    }
  }
}

module elephant_foot_compensation(size, foot_offset=default_foot_offset) {
  bleed_size = size + [$bleed * 2, $bleed * 2, $bleed * 2];
  bleed_offset = [-$bleed, -$bleed, -$bleed];

  translate(bleed_offset) {
    translate([0, 0, foot_offset]) {
      rotate([-90, 0, 0]) {
        triangular_prism(bleed_size[0], foot_offset, foot_offset);
      }
    }

    translate([foot_offset, 0, 0]) {
      rotate([0, 0, 90]) {
        triangular_prism(bleed_size[1], foot_offset, foot_offset);
      }
    }

    translate([bleed_size[0] - foot_offset, bleed_size[1], 0]) {
      rotate([0, 0, -90]) {
        triangular_prism(bleed_size[1], foot_offset, foot_offset);
      }
    }

    translate([0, bleed_size[1] - foot_offset, 0]) {
      rotate([0, 0, 0]) {
        triangular_prism(bleed_size[0], foot_offset, foot_offset);
      }
    }
  }
}
