$rounding = 3;
$wall_thickness = 2;

module dish (width, length, height) {
  r_width = width - $rounding * 2;
  r_length = length - $rounding * 2;
  r_height = height - $rounding * 2;

  radius = min(r_width,r_length);

  translate([0,0,$wall_thickness]) {
    difference() {
      translate([$rounding,$rounding,$rounding]) {
        minkowski() {
          hull() {
            translate([0,0,r_height/2]) cube([r_width,r_length,height/2]);
            translate([r_width/2,r_length/2,height/4]) resize([r_width,r_length,height/2]) sphere(radius);
          }
          sphere($rounding);
        }
      }     
      translate([0,0,height]) cube([width+$rounding*2,length+$rounding*2,$rounding*4]);
    }
  }
}

module inner_dish_array(width, length, height, count = 1) {
  dish_width = (width - $wall_thickness * (count+1)) / count;
  dish_length = length - 2 * $wall_thickness;
  dish_offset = dish_width+$wall_thickness;

  for (i=[0:count-1]) {
    translate([$wall_thickness+i*dish_offset,$wall_thickness,$wall_thickness]) {
      dish(dish_width, dish_length, height);
    }
  }
}
