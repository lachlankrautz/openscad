include <../../lib/primitive/rounded_cube.scad>
include <../../lib/layout/layout.scad>
include <../../lib/compound/notched_cube.scad>
include <../../lib/util/util_functions.scad>

// Config
$fn = 50;

module arc_prism(width, height, angle, distance_to_angle) {
  /*
  polygon([
    [0, 0],
    [0, distance_to_angle],
    // [distance_to_angle, distance_to_angle],
    [distance_to_angle, 0],
  ]);
  */

  polygon([
    [0, distance_to_angle],
    [0, distance_to_angle + width],
    [distance_to_angle + width, 0],
    [distance_to_angle, 0],
  ]);
}

// copied from blog, I don't understand the fn stuff but it seems to be
// to avoid the smaller circle having corners stick out
module sector(radius, angle, fn = 24) {
    r = radius / cos(180 / fn);
    step = -360 / fn;

    points = concat([[0, 0]],
        [for(a = [0 : step : angle - 360]) 
            [r * cos(a), r * sin(a)]
        ],
        [[r * cos(angle), r * sin(angle)]]
    );

    difference() {
        circle(radius, $fn = fn);
        polygon(points);
    }
}

module arc(radius, angles, width = 1, fn = 24) {
    difference() {
        sector(radius + width, angles, fn);
        sector(radius, angles, fn);
    }
} 

radius = 20;
width = 2;
angle = 45;

linear_extrude(1) arc(radius, angle, width, $fn);

tile_thickness = 1.64;

box_size = [
  100,
  100,
  40,
];

// arc_prism(20, tile_thickness, 30, 50);

/*
difference() {
  rounded_cube(box_size, flat_top=true, $rounding=2);


}
*/
