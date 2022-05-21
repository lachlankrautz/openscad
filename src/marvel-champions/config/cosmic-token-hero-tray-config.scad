include <./cosmic-token-config.scad>

matrix = [
  [tile_size, tile_size],
  [tile_size, tile_size],
  [tile_size, tile_size],
];

matrix_counts = [
  [4 /* damage */, 3 /* stunned */],
  [3 /* damage */, 3 /* confused */],
  [3 /* damage */, 3 /* tough */],
];
