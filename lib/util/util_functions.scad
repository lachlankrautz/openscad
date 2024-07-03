function sum(v) = [for(p = v) 1] * v;

// Map to just the given index of a list of arrays
//
// list = [
//   [1, 2],
//   [3, 4],
// ];
// pick_list(list, 0) -> [1, 3]
// pick_list(list, 1) -> [2, 4]
function pick_list(list, index) = [for(i=[0:len(list)-1]) list[i][index]];

function take_sum(v, i) = i == 0 
  ? 0 
  : sum([for(a=[0:i-1]) v[a]]);

// input : nested list
// output : list with the outer level nesting removed
function flatten(outter_vector) = [for(inner_vector=outter_vector) for(item=inner_vector) item];

module test_window(size, position) {
  intersection() {
    children();
    translate(position) {
      cube(size);
    }
  }
}
