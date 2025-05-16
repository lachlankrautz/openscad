wall_thickness = 2;

inner_box_size = [183, 153, 42];

divider_length_offset = (inner_box_size[1] - wall_thickness) / 2;
divider_width_offset = (inner_box_size[0] - wall_thickness) / 2;

cube([inner_box_size[0], inner_box_size[1], wall_thickness]);

translate([0, divider_length_offset, 0]) {
  cube([inner_box_size[0], wall_thickness, inner_box_size[2]]);
} 

translate([divider_width_offset, 0, 0]) {
  cube([wall_thickness, inner_box_size[1], inner_box_size[2]]);
} 
