include <../primitive/rounded_cube.scad>
include <../config/card_sizes.scad>

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
  
function sideloader_box_size(
  card_stack_list, 
  fit_to_box_size, 
  display_indent_length, 
  wall_thickness,
  padding
) = 
  assert(is_card_stack_list(card_stack_list), card_stack_list)
  let(
    padded_cube_size_list = [for(card_stack=card_stack_list) sideloader_card_cube_size(card_stack, padding)],
    total_wall_size = sideloader_box_total_wall_thickness_size(len(card_stack_list), wall_thickness),
    indent_size = [display_indent_length, 0, 0],
    natural_box_size = padded_cube_size_list[0] 
      + total_wall_size 
      + indent_size
  )
  [
    max(natural_box_size[0], fit_to_box_size[2]),
    max(natural_box_size[1], fit_to_box_size[1]),
    max(natural_box_size[2], fit_to_box_size[0]),
  ];

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

    // TODO continue to convert everything to be list based 
    //      so that many card stacks can be cut out of the box
    //      while keeping everything centered
    padded_card_stack_size = sideloader_card_cube_size(card_stack, padding),

    box_size = sideloader_box_size([card_stack], fit_to_box_size, _display_indent_depth, wall_thickness, padding), 

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
    cutout_centering_offset = [
      box_size[0] - natural_box_size[0], // stick to the left
      (box_size[1] - natural_box_size[1]) / 2, // in the middle
      box_size[2] - natural_box_size[2], // stick to the top
    ]
  ) {
    // echo("card cutout", card_cutout);
    // echo("cutout offset", cutout_centering_offset);
    // echo("box size", box_size);

    difference() {
      // box
      rounded_cube(box_size, $rounding=1);

      // cards cutout
      translate([wall_thickness, wall_thickness, wall_thickness] + cutout_centering_offset) {
        cube(card_cutout);
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
            + cutout_centering_offset[1] / 2,
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
