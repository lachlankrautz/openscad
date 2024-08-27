include <../../lib/util/util_functions.scad>

scaleFactor = 0.02;
gap = 100 * scaleFactor;
rowGap = 800 * scaleFactor;

function scaleFurniture(size) = size * scaleFactor;
function scaleFurnitureList(sizes) = [for(size=sizes) scaleFurniture(size)];
function scaleFurnitureGrid(grid) = [for(row=grid) scaleFurnitureList(row)];

module placeFurniture(grid) {
  for (i=[0:len(grid)-1]) {
    let(
      sizes = grid[i]
    ) {
      translate([0, i > 0 ? rowGap: 0, 0]) {
        for (j=[0:len(sizes)-1]) {
          let(
            offset = j == 0 ? 0 : take_sum(pick_list(sizes, 0), j) + (gap * j)
          ) {
            echo("offset: ", offset);
            translate([offset, 0, 0]) {
              cube(sizes[j]);
            }
          }
        }
      }
    }
  }
}

kalax_5_x_5 = [1822, 395, 1822];
kalax_2_x_4 = [766, 394, 1470];
lachlan_work_desk = [1200, 600, 735];
bec_work_desk = [1020, 1020, 745];
kids_computer_desk = [1213, 600, 724];
craft_desk = [1420, 500, 750];
dtolf = [427, 370, 1625];
printer_cabinet = [450, 800, 720];

grid = [
  [
    kalax_5_x_5,
    kalax_5_x_5,
    kalax_2_x_4,
    kalax_2_x_4,
    lachlan_work_desk,
  ],
  [
    bec_work_desk,
    kids_computer_desk,
    craft_desk,
    dtolf,
    printer_cabinet,
  ],
];

placeFurniture(scaleFurnitureGrid(grid));
