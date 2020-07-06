echo(version=version());

// space
// width 54.5
// length 187
// height 33

// Config
$fn = 50;
wall_thickness = 2;
rounding = 3;
bleed = 1;

// Attributes
tray_length = 187;
tray_width = 54.5;
tray_height = 33;
large_dish_share = 0.4;

// Derived attributes
r_tray_length = tray_length-rounding*2;
r_tray_width = tray_width-rounding*2;
r_tray_height = tray_height-rounding*2+rounding+bleed;

r_hollow_offset = rounding+wall_thickness;
r_hollow_gap = 2*rounding+wall_thickness;

small_dish_share = (1 - large_dish_share) / 2;
total_dish_length = tray_length-wall_thickness*4;
small_dish_length = small_dish_share * total_dish_length;
large_dish_length = large_dish_share * total_dish_length;

dish_width = tray_width - wall_thickness * 2;

module dish (width, length, height, rounding) {
  r_width = width - rounding * 2;
  r_length = length - rounding * 2;
  r_height = height - rounding * 2;
  radius = min(r_width,r_length);
  difference() {
    translate([rounding,rounding,rounding]) {
      minkowski() {
        hull() {
          translate([0,0,r_height/2]) cube([r_width,r_length,height/2]);
          translate([r_width/2,r_length/2,height/4]) resize([r_width,r_length,height/2]) sphere(radius);
        }
        sphere(rounding);
      }
    }     
    translate([0,0,height]) cube([width+rounding*2,length+rounding*2,rounding*4]);
  }
}

difference() {
  // Base tray
  minkowski() {
    translate([rounding, rounding, rounding]) {
      cube([r_tray_width, r_tray_length, r_tray_height]);
    }
    sphere(rounding);
  }

  // Hollow out tray
  translate([wall_thickness,wall_thickness,wall_thickness]) {
    dish(dish_width, small_dish_length, tray_height+bleed, 3);
  }

  translate([wall_thickness,wall_thickness*2+small_dish_length,wall_thickness]) {
    dish(dish_width, small_dish_length, tray_height+bleed, 3);
  }

  translate([wall_thickness,wall_thickness*3+small_dish_length*2,wall_thickness]) {
    dish(dish_width, large_dish_length, tray_height+bleed, 3);
  }

  // Slice off top
  translate([-bleed,-bleed,tray_height]) {
    cube([tray_width+bleed*2, tray_length+bleed*2, rounding+bleed]);
  }
}
