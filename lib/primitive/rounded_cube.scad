include <./rounded_square.scad>
include <../config/constants.scad>

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
  side_rounding=-1,
  hollow=false
) {
  _flat = flat || (flat_top && flat_bottom);
  _flat_top = flat_top || flat;
  _flat_bottom = flat_bottom || flat;
  _rounding = min($rounding, size[2] / 2);
  _side_rounding = side_rounding > -1 ? side_rounding: $rounding;

  assert(_side_rounding >= $rounding, "side rounding cannot be less than rounding");

  top_height = _flat_top ? 0: _rounding;
  bottom_height = _flat_bottom ? 0: _rounding;

  cube_size = [
    size[0] - _rounding * 2,
    size[1] - _rounding * 2,
    size[2] - (top_height + bottom_height)
  ];

  difference() {
    if (_flat_top && _flat_bottom) {
      linear_extrude(cube_size[2]) {
        rounded_square([size[0], size[1]]);
      }
    } else {
      minkowski() {
        translate([_rounding, _rounding, bottom_height]) {
          if (_side_rounding != _rounding) {
            linear_extrude(cube_size[2]) {
              rounded_square([cube_size[0], cube_size[1]], $rounding=_side_rounding);
            }
          } else {
            cube(cube_size);
          }
        }

        if (_flat_top) {
          difference() {
            sphere(_rounding);
            cylinder(_rounding, _rounding, _rounding);
          }
        } else if (_flat_bottom) {
          difference() {
            sphere(_rounding);
            translate ([0, 0, -_rounding]) {
              cylinder(_rounding, _rounding, _rounding);
            }
          }
        } else {
          sphere(_rounding);
        }
      }
    }
    // end first difference item

    if (hollow) {
      inner_cube_size = size - [$wall_thickness * 2, $wall_thickness * 2, 0] + [0, 0, $bleed * 2];
      translate([$wall_thickness, $wall_thickness, -$bleed]) {
        rounded_cube(inner_cube_size, flat=true, hollow=false, $rounding=$rounding);
      }
    }
  }
}
