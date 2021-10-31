$fn=50;

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

dish(60, 40, 30, 2);
