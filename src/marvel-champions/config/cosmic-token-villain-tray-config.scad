include <./cosmic-token-config.scad>

matrix = [
  [tile_size, tile_size],
  [tile_size, tile_size],
  [tile_size, tile_size],
  [tile_size, tile_size],
  [tile_size, tile_size],
];

matrix_counts = [
  [4 /* threat */, 2, /* big threat */],
  [4 /* threat */, 1 /* 1st player */],
  [4 /* threat */, 5 /* accelleration */ ],
  [4 /* threat */, 3 /* big health */],
  [4 /* threat */, 5 /* health */],
];
