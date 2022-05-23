function matrix_max_y_len(matrix) = max([for(x=[0:len(matrix)-1]) len(matrix[x])]);

function make_accumulated_flow_matrix(matrix) = [
  for(x=[0:len(matrix)-1]) [
    for(y=[0:len(matrix[x])-1]) [
      sum(filter([for(i=[0:x]) matrix[i][y][0]])),
      sum(filter([for(i=[0:y]) matrix[x][i][1]])),
    ]
  ]
];
