include <../primitive/rounded_cube.scad>
include <../config/card_sizes.scad>
include <../util/util_functions.scad>

// 80gsm -> 0.065mm
// 250gsm -> 0.23mm
default_indent_depth = 0.35;

function card_stack_padding_size(padding) = [
  // stacked cards can compress and do not need padding
  0, 
  padding, 
  // no need to pad the width as there is a wall thickness of overhang at the opening
  0
];

function sideloader_card_cube_size(
  card_stack,
  padding,
) = 
  assert(is_card_stack(card_stack), card_stack)
  card_cube_size(card_stack, "side") 
      + card_stack_padding_size(padding);

function sideloader_box_total_wall_thickness_size(list_length, wall_thickness) = [
  (list_length+1) * wall_thickness, 
  wall_thickness * 2, 
  wall_thickness * 2
];

function sideloader_natural_box_size(
  card_stack_list, 
  display_indent_length, 
  wall_thickness,
  padding
) = 
  assert(is_card_stack_list(card_stack_list), card_stack_list)
  let(
    padded_cube_size_list = [for(card_stack=card_stack_list) sideloader_card_cube_size(card_stack, padding)],
    total_wall_size = sideloader_box_total_wall_thickness_size(len(card_stack_list), wall_thickness),
    indent_size = [display_indent_length, 0, 0],
    combined_padded_cube_size_list = [
      sum(pick_list(padded_cube_size_list, 0)),
      max(pick_list(padded_cube_size_list, 1)),
      max(pick_list(padded_cube_size_list, 2)),
    ]
  )
  combined_padded_cube_size_list
    + total_wall_size 
    + indent_size;

function sideloader_box_size(
  card_stack_list, 
  fit_to_box_size, 
  display_indent_length, 
  wall_thickness,
  padding
) = 
  assert(is_card_stack_list(card_stack_list), card_stack_list)
  let(
    natural_box_size = sideloader_natural_box_size(card_stack_list, display_indent_length, wall_thickness, padding)
  )
  [
    max(natural_box_size[0], fit_to_box_size[2]),
    max(natural_box_size[1], fit_to_box_size[1]),
    max(natural_box_size[2], fit_to_box_size[0]),
  ];

function sideloader_card_stack_cutout_size(
  card_stack,
  display_indent_length, 
  wall_thickness,
  padding,
) = 
  assert(is_card_stack(card_stack), card_stack)
  let(
    padded_card_stack_size = sideloader_card_cube_size(card_stack, padding),
    card_cutout=[
      padded_card_stack_size[0],
      padded_card_stack_size[1],
      padded_card_stack_size[2] + wall_thickness + $bleed,
    ]
  )
  card_cutout;

function sideloader_cutout_with_offsets_list(
  card_stack_list, 
  fit_to_box_size,
  display_indent_length, 
  wall_thickness,
  padding
) = 
  assert(is_card_stack_list(card_stack_list), card_stack_list)
  assert(is_cube_size(fit_to_box_size), fit_to_box_size)
  let(
    natural_box_size = sideloader_natural_box_size(card_stack_list, display_indent_length, wall_thickness, padding),
    box_size = sideloader_box_size(card_stack_list, fit_to_box_size, display_indent_length, wall_thickness, padding), 
    cutout_list = [for(card_stack=card_stack_list) sideloader_card_stack_cutout_size(
      card_stack,
      display_indent_length,
      wall_thickness,
      padding
    )],
    spacing_offset_list = unshift(cum_sum_list(add_to_each(pick_list(cutout_list, 0), wall_thickness)), 0),
    cutout_with_offset_list = [for(i=list_range(cutout_list)) 
      [
        cutout_list[i],
        [
          box_size[0] - natural_box_size[0] // stick to the indent face (where the image will be)
            + spacing_offset_list[i], // space out each cutout in the list
          (box_size[1] - natural_box_width(cutout_list[i], wall_thickness)) / 2, // in the middle
          box_size[2] - cutout_list[i][2], // stick to the top
        ]
      ]
    ]
  )
  cutout_with_offset_list;

// return the smallest cutout going by width i.e. [1]
function smallest_cutout_with_offset(cutout_with_offset_list) =
  let(
    // find the smallest value
    min = min([for (cutout_with_offset=cutout_with_offset_list) cutout_with_offset[0][1]]),
    // find the index of the first instance of that smallest value
    min_index = search(min, [for (cutout_with_offset=cutout_with_offset_list) cutout_with_offset[0][1]])[0]
  )
    // return the first item in the list with that smallest size by the index
    cutout_with_offset_list[min_index];

// if there is not fit_to_box, what is the minimum
// size this box would have to be? (add walls, etc)
function natural_box_width(size, wall_thickness) = 
  assert(is_cube_size(size), size)
  assert(is_num(wall_thickness), wall_thickness)
  size[1] + wall_thickness * 2;

module card_sideloader_stacked(
  card_stack_list,

  create_display_indent = false,
  display_indent_depth = default_indent_depth,
  display_indent_margin = 2,

  create_access_cutout = false,

  fit_to_box_size = [0, 0, 0],

  wall_thickness = $wall_thickness,
  padding = $padding,
) {
  assert(is_card_stack_list(card_stack_list), card_stack_list);
  let(
    cutout_depth = 20,
    _rounding = 5,
    _display_indent_depth = create_display_indent ? display_indent_depth : 0,

    natural_box_size = sideloader_natural_box_size(card_stack_list, _display_indent_depth, wall_thickness, padding),
    box_size = sideloader_box_size(card_stack_list, fit_to_box_size, _display_indent_depth, wall_thickness, padding), 
    cutout_with_offset_list = sideloader_cutout_with_offsets_list(
      card_stack_list, 
      fit_to_box_size,
      _display_indent_depth, 
      wall_thickness, 
      padding
    ),
    smallest_cutout_with_offset = smallest_cutout_with_offset(cutout_with_offset_list)
  ) {
    difference() {
      // box
      rounded_cube(box_size, $rounding=1);

      // card cutouts
      translate([wall_thickness, wall_thickness, wall_thickness]) {
        for (item=cutout_with_offset_list) let(item_cutout=item[0], item_offset=item[1]) {
          translate(item_offset) {
            cube(item_cutout);
          }
        }
      }

      // display_indent
      if (create_display_indent) {
        translate([
          box_size[0] * 2 - display_indent_depth,
          display_indent_margin,
          display_indent_margin,
        ]) {
          rotate([0, -90, 0]) {
            rounded_cube(
              [
                box_size[2] - display_indent_margin * 2,
                box_size[1] - display_indent_margin * 2,
                box_size[0],
              ],
              flat=true,
              $rounding=1
            );
          }
        }
      }

      // access cutout
      if (create_access_cutout) {
        translate([
          box_size[0] + $bleed,
          box_size[1]/4
            + smallest_cutout_with_offset[1][1] / 2, 
          box_size[2] - cutout_depth
        ]) {
          rotate([0, -90, 0]) {
            rounded_cube(
              [
                cutout_depth + _rounding,
                natural_box_width(smallest_cutout_with_offset[0], wall_thickness)/2,
                box_size[0] + $bleed * 2,
              ],
              flat_top=true,
              flat_bottom=true,
              $rounding=_rounding
            );
          }
        }
      }
    }
  }
}

module card_sideloader(
  card_stack,
  create_display_indent = false,
  display_indent_depth = default_indent_depth,
  display_indent_margin = 2,
  create_access_cutout = false,
  fit_to_box_size = [0, 0, 0],
  wall_thickness = $wall_thickness,
  padding = $padding,
) {
  card_sideloader_stacked(
    [card_stack],
    create_display_indent,
    display_indent_depth,
    display_indent_margin,
    create_access_cutout,
    fit_to_box_size,
    wall_thickness,
    padding
  );
}
