/*
 * CR-10S Pro wheel guide for filament: bearing ring
 *
 * Requires OpenSCAD MCAD Library
 * - Unpack: $HOME/.local/share/OpenSCAD/libraries/
 * - URL: https://github.com/openscad/MCAD
 *
 * History
 * -------
 * v01 (2021.06.26): Initial version
 */

use <MCAD/regular_shapes.scad>

// Bearing 608Z: 8mm x 22mm x 7mm (inner dia, outer dia, width)
minor_diameter = 22.4;
major_diameter = 38.0;
height = 8.0;

difference() {
    cylinder(h=height, d=major_diameter, center=false);
    cylinder(h=height, d=minor_diameter, center=false);

    r = 3.2; // must be < height/2
    translate([0, 0, height/2])
        torus2(major_diameter/2, r, $fn=48);
}
