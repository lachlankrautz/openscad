$wall_thickness = 2;

function wall_offset(count = 1, i = 0) = (i + 1) * $wall_thickness;

function total_wall_size(count = 1) = (count + 1) * $wall_thickness;

function usable_size(size, count = 1) = size - total_wall_size(count);

function item_size(size, count = 1, i = 0) = usable_size(size, count) / count;

function item_offset(size, count = 1, i = 0) = wall_offset(count, i) + item_size(size, count, i) * i;

module spread_width(width) {
  echo("children: ", $children);
  for(i=[0 : $children - 1]) {
    offset = item_offset(width, $children, i);
    translate([offset, 0, 0]) {
      children(i);
    }
  }
}

module spread_length(length) {
  for(i=[0 : $children - 1]) {
    offset = item_offset(length, $children, i);
    translate([0, offset, 0]) {
      children(i);
    }
  }
}
