include <../lid/dovetail_lid.scad>

overhang_tolerance = 0.3;

module box_wall_join(box_size) {
  cutout_box_size = [
    5,
    box_size[1],
    box_size[2],
  ];

  lip_box_size = [
    7,
    box_size[1],
    box_size[2],
  ];

  difference() {
    children();

    // left cutout
    dovetail_lid_cutout(cutout_box_size);
  }

  lip_offset = 3;
  compensation_size = [
    cutout_box_size[0],
    cutout_box_size[1],
    cutout_box_size[2] - $lid_height + overhang_tolerance,
  ];

  // right lip
  translate([box_size[0], 0, 0]) {
    difference() {
      translate([lip_offset, lip_box_size[1] - 1, box_size[2] - $lid_height]) {
        rotate([0, 0, 180]) {
          dovetail_lid(lip_box_size);
        }
      }

      // compensate for overhang droop
      cube(compensation_size);
    }
  }
}
