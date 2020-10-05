$gap = 0.5;
// $bleed = 0.01;
$wall_thickness = 2;

function padded_offset (size, index=1) = (size + $gap * 2 + $wall_thickness) * index;

function offset (size, index=1) = (size + $wall_thickness) * index;
