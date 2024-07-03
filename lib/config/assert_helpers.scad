// true if each item of the list passes the check function
// e.g. 
// is_list_of(card_stack_list, is_card_stack);
//
function is_list_of(list, check_fn) = is_list(list)
  && is_function(check_fn)
  && [for(item=list) true] == [for(item=list) check_fn(item)];
