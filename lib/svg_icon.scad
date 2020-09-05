$depth = 1;

module svg_icon(file, depth=$depth, icon_size, target_size) {
  assert(file, "File argument missing");
  
  icon_scale = [
    target_size[0] / icon_size[0],
    target_size[1] / icon_size[1],
  ];

  echo("icon scale: ", icon_scale);

  linear_extrude(depth) {
    scale(icon_scale) {
      import(file);
    }
  }
}
