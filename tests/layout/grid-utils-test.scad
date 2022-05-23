include <../../lib/layout/grid_utils.scad>

sizes = [
  [1, 1],
  [2, 2],
  [3, 3],
];

grid = [
  [sizes[0], sizes[2], sizes[0]],
  [sizes[1], sizes[2], sizes[1], sizes[1], sizes[1]],
  [sizes[2], sizes[2], sizes[2]],
];

accumulated_grid = accumulated_grid(grid);
total_x = accumulated_grid_x(accumulated_grid);
total_y = accumulated_grid_y(accumulated_grid);

max_from_bad_list = max([0, 5, undef]);
echo("max: ", max_from_bad_list);

echo("grid: ");
print_sideways_grid(grid);
echo("accumulated grid: ");
print_sideways_grid(accumulated_grid);
echo("total x: ", total_x);
echo("total y: ", total_y);

problem = [3, 3, 3, undef];
filtered = filter(problem);
echo("filtered: ", filtered);
echo("sum: ", sum(filtered));
