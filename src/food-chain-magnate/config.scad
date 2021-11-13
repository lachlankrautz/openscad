top_padding = 0.1;

square_size = [
  18,
  18,
  1.8,
];

function tile_size(x = 1, y = 1) = [
  square_size[0] * x,
  square_size[1] * y,
  square_size[2],
];

function align_x(x, width) = x == 0
  ? 0
  : virtual_col_widths[x] - width;

