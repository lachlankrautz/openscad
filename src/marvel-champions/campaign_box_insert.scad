$fn = 50;

bleed = 0.01;

wall_thickness = 2;
inner_box_size = [196, 196, 72.5];

slope_base_width = 10;

campaign_book_size = [192, 190, 2];
campaign_book_ledge_length = 5;

card_tray_size = [
  campaign_book_size[0] - campaign_book_ledge_length * 2,
  inner_box_size[1], 
  70
];

ledge_gap = inner_box_size[0] - campaign_book_size[0];

module triangular_prism(width, height, depth) {
  translate([0, depth, 0]) {
    rotate([90, 0, 0]) {
      linear_extrude(depth) {
        polygon([
          [0, 0], 
          [width, 0], 
          [0, height]
        ]);
      }
    }
  }
}


union() {
  cube([ledge_gap, inner_box_size[1], inner_box_size[2]]);

  translate([ledge_gap - bleed, 0, 0]) {
    cube([campaign_book_ledge_length + bleed * 2, inner_box_size[1], card_tray_size[2]]);
  }

  translate([
    ledge_gap + campaign_book_ledge_length - bleed, 
    (inner_box_size[1] - wall_thickness) / 2,
    0
  ]) {
    cube([card_tray_size[0] + bleed * 2, wall_thickness, card_tray_size[2]]);
  }

  translate([ledge_gap + campaign_book_ledge_length, 0, 0]) {
    triangular_prism(slope_base_width, card_tray_size[2], card_tray_size[1]);
  }

  translate([
    ledge_gap + campaign_book_ledge_length + card_tray_size[0], 
    0, 
    0
  ]) {
    cube([campaign_book_ledge_length, inner_box_size[1], card_tray_size[2]]);
  }
}
