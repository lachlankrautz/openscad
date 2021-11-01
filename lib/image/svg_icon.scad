include <../config/constants.scad>

module svg_icon(file, depth=1, icon_size, target_size) {
  assert(file, "File argument missing");
  
  icon_scale = [
    target_size[0] / icon_size[0],
    target_size[1] / icon_size[1],
  ];

  linear_extrude(depth) {
    scale(icon_scale) {
      import(file);
    }
  }
}
