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

// slice an array
// slice([1, 2, 3, 4], 0, 2) => [1, 2, 3]
function slice(array, start, end) = [for(i=[start:end]) array[i]];

// cumulatively sum a list
// [1, 2, 3] -> [1, 3, 6]
function cum_sum_list(list) = [for(i=[0:len(list)-1]) sum(slice(list, 0, i))];

function list_range(list) = [0:len(list)-1];

// add to teach item in a list
// add_to_each([1, 2, 3], 2) -> [3, 4, 5];
function add_to_each(list, add) = [for(item=list) item + add];

// add a value to the start of a list
function unshift(list, value) = 
  assert(is_list(list), list)
  [value, for(item=list) item];

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
