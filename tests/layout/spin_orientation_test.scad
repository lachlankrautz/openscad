include <../../lib/layout/layout.scad>

box_size = [
  50,
  20,
  10,
];

spin_size_1 = spin_orientation_size(box_size, 1);
spin_size_2 = spin_orientation_size(box_size, 2);
spin_size_3 = spin_orientation_size(box_size, 3);

echo("box size: ", box_size);
echo("spin once: ", spin_size_1);
echo("spin twice: ", spin_size_2);
echo("spin thrice: ", spin_size_3);

assert(spin_size_1 == [20, 50, 10], "spin once");
assert(spin_size_2 == box_size, "spin twice");
assert(spin_size_3 == [20, 50, 10], "spin trice");

// TODO add tests for spin_orientation_offset
