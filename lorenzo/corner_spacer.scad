echo(version=version());

width = 23.5;
base_top_length = 35;
base_top_width = 122;

base_side_length = 72;
base_side_width = 90.5;

top_length = 38;
top_width = 66;

top_edge_length = 72;
top_edge_width = 8;

height = 2;
rounding = 0.5;

$fn=50;
union() {
  minkowski() {
    cube([base_top_length-rounding*2, base_top_width-rounding*2, height-rounding*2]);
    sphere(rounding);
  }

  minkowski() {
    translate([0, base_top_width-base_side_width, 0]) cube([base_side_length-rounding*2, base_side_width-rounding*2, height-rounding*2]);
    sphere(rounding);
  }

  minkowski() {
    translate([base_side_length-top_length, base_top_width-top_width, 0]) cube([top_length-rounding*2, top_width-rounding*2, height*2-rounding*2]);
    sphere(rounding);
  }

  minkowski() {
    translate([0, base_top_width-top_edge_width, 0]) cube([top_edge_length-rounding*2, top_edge_width-rounding*2, height*2-rounding*2]);
    sphere(rounding);
  }
}
