// Settings
box_length = 105;
box_width = 62.5;
box_height = 13;

// Derived attributes
r_box_length = box_length-$rounding*2;
r_box_width = box_width-$rounding*2;
r_box_height = box_height-$rounding*2+$rounding+$bleed;

r_hollow_length = box_length-$rounding*2-$wall_thickness*2;
r_hollow_width = box_width-$rounding*2-$wall_thickness*2;
r_hollow_height = box_height-$rounding*2+$rounding+$bleed;
r_hollow_offset = $rounding+$wall_thickness;

difference() {
  // Base tray
  minkowski() {
    translate([$rounding, $rounding, $rounding]) {
      cube([r_box_length, r_box_width, r_box_height]);
    }
    sphere($rounding);
  }

  // Slice off top
  translate([-$bleed,-$bleed,box_height]) {
    cube([box_length+$bleed*2, box_width+$bleed*2, $rounding+$bleed]);
  }

  // Hollow out tray
  minkowski() {
    translate([r_hollow_offset, r_hollow_offset, r_hollow_offset]) {
      cube([r_hollow_length, r_hollow_width, r_hollow_height]);
    }
    sphere($rounding);
  }
}
