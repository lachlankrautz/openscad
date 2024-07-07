// true if each item of the list passes the check function
// e.g. 
// is_list_of(card_stack_list, is_card_stack);
//
function is_list_of(list, check_fn) = is_list(list)
  && is_function(check_fn)
  && [for(item=list) true] == [for(item=list) check_fn(item)];

// true if size is an array of 3 numbers used to size a cube 
// e.g. 
// is_cube_size([5, 5, 5]);
function is_cube_size(size) = is_num(size[0]) && is_num(size[1]) && is_num(size[2]);
