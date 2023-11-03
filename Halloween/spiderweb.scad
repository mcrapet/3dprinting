/*
 * Halloween spider web
 * Copyright (C) 2023  Matthieu Crapet <mcrapet@gmail.com>
 *
 * Licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
 *
 * You should have received a copy of the license along with this
 * work. If not, see <http://creativecommons.org/licenses/by-sa/4.0/>.
 *
 * History
 * -------
 * v01 | 30.oct.2023 | Initial version
 */

$fn = 100;

height = 2.8;
angle = 45; // 40;

stick_distance  = 90;
stick_thickness = 10;
ring1_distance  = 30;
ring1_thickness = 8;  // lower (closest to center)
ring2_distance  = 50;
ring2_thickness = 9;  // middle
ring3_distance  = 70;
ring3_thickness = 9;  // upper (furthest)

hook_enable   = true;
hook_diameter = 2.4;  // small value is thiner
hook_radius   = 3;    // does not include thickness of hook_diameter

/*
 * r1: radius 1 (outer)
 * r2: radius 2 (inner)
 * a1: angle 1 (start at 0), X-axis counterclockwise
 * a2: angle 2 (end), a2 - a1 < 180
 */
module arc(r1, r2, a1, a2) {
    difference() {
        difference() {
            depth = r1*r1; // approx
            polygon([[0,0], [cos(a1) * depth, sin(a1) * depth], [cos(a2) * depth, sin(a2) * depth]]);
            circle(r = r2);
        }
        difference() {
            depth = r1*r1; // approx
            circle(r = r1 + depth);
            circle(r = r1);
        }
    }
}

module arc_upside_down(r, thickness, a, extra_a=0) {
    translate([0, 2*r - thickness])
        mirror([0, 1, 0])
            rotate([0, 0, 90 - a + a/2 - extra_a])
                arc(r, r - thickness, 0, a + 2*extra_a);
}

// Centered on Y-axis
module branche(width, height) {
    bevel = width/2;
    union() {
        translate([0, height - bevel, 0])
            circle(bevel);
        translate([-width/2, 0, 0])
            square([width, height - bevel]);
    }
}

linear_extrude(height) {
    for(i = [0:angle:360]) {
        rotate([0,0,i])
            branche(stick_thickness, stick_distance);
        rotate([0,0,-angle/2-i]) {
            arc_upside_down(ring1_distance, ring1_thickness, angle, 0);
            arc_upside_down(ring2_distance, ring2_thickness, angle, angle/8);
            arc_upside_down(ring3_distance, ring3_thickness, angle, angle/8);
        }
    }
}

if (hook_enable) {
    offset_y = stick_distance - 6.5;
    offset_z = height;
    translate([0, offset_y, offset_z])
        rotate([90,0,90])
            rotate_extrude(convexity = 10, angle = 180)
                translate([hook_radius, 0, 0])
                    circle(d=hook_diameter);
}
