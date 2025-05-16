wall_thickness = 1.5;
bleed = 0.1;

inner_box_size = [183, 153, 43];

book_size = [157, 107, 3];
junk_on_top_size = [183, 107, 2.2];

book_width_offset = (inner_box_size[0] - book_size[0]) / 2;
junk_length_offset = (inner_box_size[1] - junk_on_top_size[1]) / 2;
divider_length_offset = (inner_box_size[1] - wall_thickness) / 2;
divider_width_offset = (inner_box_size[0] - wall_thickness) / 2;

difference () {
  union () {
    cube([inner_box_size[0], inner_box_size[1], wall_thickness]);
    translate([0, divider_length_offset, 0]) {
      cube([inner_box_size[0], wall_thickness, inner_box_size[2]]);
    }     
    translate([divider_width_offset, 0, 0]) {
      cube([wall_thickness, inner_box_size[1], inner_box_size[2]]);
    } 
  }

  // cutout for junk on top
  translate([-bleed, junk_length_offset - bleed, inner_box_size[2] - junk_on_top_size[2]]) {
    cube(junk_on_top_size + [bleed * 2, 0, bleed]);
    translate([book_width_offset, 0, -book_size[2]]) {
      cube(book_size + [0, 0, bleed]);
    }
  }
}
