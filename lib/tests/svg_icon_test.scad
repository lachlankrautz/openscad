include <../../lib/svg_icon.scad>

$bleed = 1;
resource_file = "../../assets/images/arkham_horror_lcg_clue_token.svg";
icon_scale = 0.6;
details_depth = 0.5;

base_size = [
  20,
  20,
  1
];

difference() {
  cube(base_size);
  translate([2, 3, base_size[2] - details_depth]) {
    svg_icon(resource_file, details_depth + $bleed, icon_scale);
  }
}
