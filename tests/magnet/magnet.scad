include <../../lib/magnet/magnet.scad>
include <../../lib/config/magnet-sizes.scad>

$fn = 50;

size = [5, 5, 4];

difference() {
  cube(size);

  vertical_magnet_sockets(
    size,
    small_magnet_diameter,
    small_magnet_height,
    ["left", "right"]
  );
}
