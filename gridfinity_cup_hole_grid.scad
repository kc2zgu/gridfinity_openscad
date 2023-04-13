include <gridfinity_modules.scad>
use <gridfinity_cup_modules.scad>

// X dimension in grid units
width = 2; // [ 0.5, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 ]
// Y dimension in grid units
depth = 1; // [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 ]
// Z dimension (multiples of 7mm)
height = 4;
// number of holes along X axis
hole_rows = 1;
// number of holes along Y axis
hole_cols = 2;
// X hole pitch
hole_x_pitch = 30;
// Y hole pitch
hole_y_pitch = 10;
// Offset every other row
stagger_holes = false;
// Add or skip a hole every alternate row
extra_alt_row_holes = 0; // [-1,0,1]
// Hole diameter
hole_size = 8;
// (Zack's design uses magnet diameter of 6.5)
magnet_diameter = 0;  // .1
// (Zack's design uses depth of 6)
screw_depth = 0;
// Hole overhang remedy is active only when both screws and magnets are nonzero (and this option is selected)
hole_overhang_remedy = true;
//Only add attachments (magnets and screw) to box corners (prints faster).
box_corner_attachments_only = false;
// Height of solid block floor
block_height = 2;
// Wall thickness (Zack's design is 0.95)
wall_thickness = 0.95;  // .01
// Enable to subdivide bottom pads to allow half-cell offsets
half_pitch = false;
// Remove some or all of lip
lip_style = "normal";  // [ "normal", "reduced", "none" ]

module end_of_customizer_opts() {}

// Separator positions are defined in terms of grid units from the left end
separator_positions = [ 0.25, 0.5, 1.4 ];

center_x = (gridfinity_pitch * (width-1))/2;
center_y = (gridfinity_pitch * (depth-1))/2;

holes_x = hole_x_pitch * (hole_cols-1);
holes_y = hole_y_pitch * (hole_rows-1);

extra_stagger_row_holes = stagger_holes ? extra_alt_row_holes : 0;

difference() {
  grid_block(width, depth, height, magnet_diameter=magnet_diameter,
    screw_depth=screw_depth, hole_overhang_remedy=hole_overhang_remedy,
    half_pitch=half_pitch, box_corner_attachments_only=box_corner_attachments_only, block_height=block_height);

  color("red")
  translate([center_x, center_y, 6])
    for (hole_y=[0:hole_rows-1])
    for (hole_x=[((hole_y % 2 == 1) && (extra_stagger_row_holes == 1) ? -1 : 0):hole_cols+(hole_y % 2 == 0 ? 0 : min(extra_stagger_row_holes, 0))-1])
        translate([(hole_y % 2 == 0) ? hole_x*hole_x_pitch-holes_x/2 : stagger_holes ? (hole_x+0.5)*hole_x_pitch-holes_x/2 : hole_x*hole_x_pitch-holes_x/2, hole_y*hole_y_pitch-holes_y/2, 0])
        cylinder(h=gridfinity_zpitch*height, r=hole_size/2, $fn=32);
}
