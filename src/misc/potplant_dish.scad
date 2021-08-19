$wall_thickness = 3;
$fn = 50;

height = 12;
inner_diameter = 75;
outer_diameter = inner_diameter + $wall_thickness * 2;

difference() {
  cylinder(height, outer_diameter/2, outer_diameter/2);
  translate([0, 0, $wall_thickness]) {
    cylinder(height, inner_diameter/2, inner_diameter/2);
  }
}
