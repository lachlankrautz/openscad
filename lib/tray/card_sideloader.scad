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

function sideloader_cutout_with_offset(
  card_stack,
  display_indent_length, 
  wall_thickness,
  padding
) = 
  assert(is_card_stack(card_stack), card_stack)
  let(
    natural_box_size = sideloader_natural_box_size(card_stack_list, display_indent_length, wall_thickness, padding)
  )
  [];

function sideloader_cutout_with_offsets_list(
  card_stack_list, 
  display_indent_length, 
  wall_thickness,
  padding
) = 
  assert(is_card_stack_list(card_stack_list), card_stack_list)
  let(
    
  )
  [];

// TODO make nicer interface for single / multi
module card_sideloader(
  card_stack,

  create_display_indent = false,
  display_indent_depth = default_indent_depth,
  display_indent_margin = 2,

  create_access_cutout = false,

  fit_to_box_size = [0, 0, 0],

  wall_thickness = $wall_thickness,
  padding = $padding,
  bleed = $bleed
) {
  assert(is_card_stack(card_stack), card_stack);
  let(
    cutout_depth = 20,
    _rounding = 5,
    _display_indent_depth = create_display_indent ? display_indent_depth : 0,

    // TODO delete me after altering the module signature
    card_stack_list = [card_stack, card_stack],

    box_size = sideloader_box_size(card_stack_list, fit_to_box_size, _display_indent_depth, wall_thickness, padding), 
    cutouts_with_offsets_new = sideloader_cutout_with_offsets_list(card_stack_list, _display_indent_depth, wall_thickness, padding),

    // TODO create a list of box cutouts and offsets
    //      for list
    //      translate offset
    //      cube cutout size

    padded_card_stack_size = sideloader_card_cube_size(card_stack, padding),
    card_cutout=[
      padded_card_stack_size[0],
      padded_card_stack_size[1],
      padded_card_stack_size[2] + wall_thickness + bleed,
    ],
    natural_box_size=[
      padded_card_stack_size[0] + wall_thickness * 2 + _display_indent_depth,
      padded_card_stack_size[1] + wall_thickness * 2,
      padded_card_stack_size[2] + wall_thickness * 2,
    ],
    cutout_offset = [
      box_size[0] - natural_box_size[0], // stick to the left
      (box_size[1] - natural_box_size[1]) / 2, // in the middle
      box_size[2] - natural_box_size[2], // stick to the top
    ],

    // TODO remove fake one after dynamic one is done
    cutouts_with_offsets = [[card_cutout, [0, 0, 0]], [card_cutout, cutout_offset]]
  ) {
    // echo("card cutout", card_cutout);
    // echo("cutout offset", cutout_offset);
    // echo("box size", box_size);

    echo("cutouts", pick_list(cutouts_with_offsets, 0));
    echo("cutouts new", pick_list(cutouts_with_offsets_new, 0));

    echo("offsets", pick_list(cutouts_with_offsets, 1));
    echo("offsets new", pick_list(cutouts_with_offsets_new, 1));

    difference() {
      // box
      rounded_cube(box_size, $rounding=1);

      // card cutouts
      translate([wall_thickness, wall_thickness, wall_thickness]) {
        for (item=cutouts_with_offsets) let(item_cutout=item[0], item_offset=item[1]) {
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
          box_size[0] + bleed,
          box_size[1]/2 / 2
          // TODO why does this need the centering offset?
          //      will the access cutout work with many card stacks?
            + cutout_offset[1] / 2,
          box_size[2] - cutout_depth
        ]) {
          rotate([0, -90, 0]) {
            rounded_cube(
              [
                cutout_depth + _rounding,
                natural_box_size[1]/2,
                box_size[0] + bleed * 2,
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
