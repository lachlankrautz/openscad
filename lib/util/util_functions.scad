function sum(v) = [for(p = v) 1] * v;

function take_sum(v, i) = i == 0 
  ? 0 
  : sum([for(a=[0:i-1]) v[a]]);

// input : nested list
// output : list with the outer level nesting removed
function flatten(l) = [ for (a = l) for (b = a) b ] ;
