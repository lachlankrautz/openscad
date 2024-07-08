include <./minimum_constants.scad>

// Shared constants reflect things that are true for the whole model not just a single component.
// They should by definition be required by multiple components.
$abs_filament = false;

$wall_thickness = 2;
$floor_thickness = 2;
$inner_wall_thickness = 1;

$padding = 0.5;
$top_padding = 0.2;
$padding_rect = [$padding * 2, $padding * 2];

$card_padding = 1.5;

$floor_cutout_threshold = 50;

$inset = 6;
$cutout_fraction = 0.6;

$lid_height = 2;
