width = 23.5;
full_length = 210;
short_length = 130;
height = 2;
rounding = 0.5;

$fn=50;
union() {
  minkowski() {
    cube([full_length-rounding*2, width-rounding*2, height-rounding*2]);
    sphere(rounding);
  }

  minkowski() {
    cube([short_length-rounding*2, width-rounding*2, height*2-rounding*2]);
    sphere(rounding);
  }
}
