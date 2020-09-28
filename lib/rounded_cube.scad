include <./rounded_square.scad>

$bleed = 1;
$rounding = 3;

// Render a rounded cube
// flat_top: do not round the top edges
// flat_bottom: do not round the bottom edges
// flat: equals flat_top && flat_bottom
// 
// Limitations:
// requires height > $rounding * 2
// flat_top || flat_bottom requires height > $rounding
// flat_top && flat_bottom requires height > $bleed
module rounded_cube(
  size, 
  flat=false, 
  flat_top=false, 
  flat_bottom=false,
  side_rounding=-1
) {
  _flat_top = flat_top || flat;
  _flat_bottom = flat_bottom || flat;
  _side_rounding = side_rounding > -1 ? side_rounding: $rounding;

  top_height = _flat_top ? 0: $rounding;
  bottom_height = _flat_bottom ? 0: $rounding;

  cube_size = [
    size[0] - $rounding * 2,
    size[1] - $rounding * 2,
    size[2] - (top_height + bottom_height)
  ];

  if (_flat_top && _flat_bottom) {
     linear_extrude(cube_size[2]) {
       rounded_square([size[0], size[1]]);
     }
   } else {
     minkowski() {
       translate([$rounding, $rounding, bottom_height]) {
         if (_side_rounding != $rounding) {
           linear_extrude(cube_size[2]) {
             rounded_square([cube_size[0], cube_size[1]], $rounding=_side_rounding);
           }
         } else {
           cube(cube_size);
         }
       }
       if (_flat_top) {
         difference() {
           sphere($rounding);
           cylinder($rounding, $rounding, $rounding);
         }
       } else if (_flat_bottom) {
         difference() {
           sphere($rounding);
           translate ([0, 0, -$rounding]) {
             cylinder($rounding, $rounding, $rounding);
           }
         }
       } else {
         sphere($rounding);
       }
    }
  }
}
