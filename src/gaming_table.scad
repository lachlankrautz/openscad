
// width = 145;
width = 115;
length = 145;
height = 20;

table_height = 79;

border_width = 12;
// border_width = 20;
// border_width = 25;

inset_width = width - border_width * 2;
inset_length = length - border_width * 2;
inset_depth = 12;
bleed = 1;

echo("Play width: ", inset_width);
echo("Play length: ", inset_length);

translate([0, 0, table_height - height]) {
  difference() {
    cube([width, length, height]);

    translate([border_width, border_width, height - inset_depth]) {
      cube([inset_width, inset_length, inset_depth + bleed]);
    }
  }
}