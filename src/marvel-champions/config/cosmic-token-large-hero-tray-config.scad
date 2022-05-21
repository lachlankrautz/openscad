include <./cosmic-token-config.scad>

matrix = [
  [tile_size, tile_size],
  [tile_size, tile_size],
  [tile_size, tile_size],
  [tile_size, tile_size],
  [tile_size, tile_size],
];

matrix_counts = [
  [5 /* general counter */, 4 /* stunned */],
  [5 /* general counter */, 4 /* confused */],
  [5 /* general counter */, 4 /* tough */],
  [5 /* health */, 5 /* health */],
  [5 /* health */, 5 /* health */],
];
