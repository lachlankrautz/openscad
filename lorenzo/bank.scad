echo(version=version());

// Tray
tray_width = 95;
tray_height = 15;
tray_depth = 48;

// Text
font = "Times New Roman";
letter_size = tray_height / 2;
letter_height = 3;

// Coins
coin_i_diameter = 27;
coin_iii_diameter = 25;
coin_v_diameter = 29;

coin_i_length = 43.5;
coin_iii_length = 35;
coin_v_length = 25;

max_d = max(coin_i_diameter, coin_iii_diameter, coin_v_diameter);
rounding = 1;

// Derived values
tray_side_offset = tray_depth / 2 - letter_height / 2;
tray_chunk = tray_width / 6;

module letter(l) {
  // Use linear_extrude() to make the letters 3D objects as they
  // are only 2D shapes when only using text()
  linear_extrude(height = letter_height) {
    text(l, size=letter_size, font=font, halign="center", valign="center", $fn=16);
  }
}

$fn=50;
difference() {
  minkowski() {
    cube([tray_width, tray_depth, tray_height], center=true);
    sphere(rounding);
  }
  
  translate([-tray_chunk*2,0,tray_height/2+rounding*2]) 
    rotate([90, 0, 0]) 
    cylinder(h=coin_i_length, d=coin_i_diameter, center=true);

  translate([0,0,tray_height/2+rounding*2])
    rotate([90, 0, 0])
    cylinder(h=coin_iii_length, d=coin_iii_diameter, center=true);

  translate([tray_chunk*2,0,tray_height/2+rounding*2]) 
    rotate([90, 0, 0])
    cylinder(h=coin_v_length, d=coin_v_diameter, center=true);

  // Emboss I II IV to mark denominations
  translate([-tray_chunk*2, -tray_side_offset, 0]) 
    rotate([90, 0, 0]) 
    letter("I");

  translate([0, -tray_side_offset, 0])
    rotate([90, 0, 0])
    letter("III");

  translate([tray_chunk*2, -tray_side_offset, 0])
    rotate([90, 0, 0])
    letter("V");
}
