/*
 * CR-10S Pro wheel guide for filament: base part
 * Clip on filament cut detection box (near extruder)
 *
 * History
 * -------
 * v01 (2021.06.26): Initial version
 */

$fn = 96;

part_width =  42.3; // inner part
part_depth =  11.4; // inner part
part_height = 13.5; // inner part
part_border_front = 0.2; // border front thickness
part_border = [ 2.2, 5.0, 2.2, 2.2 ]; // [top, right, bottom, left]
border_radius = 2.5; // minkowski thickness, cannot be 0
hole_diameter = [6.2, 5.8]; // [filament (front), bars (bottom)]

module bar_hole(x,y,d) {
    height = part_border[2];
    translate([x, y, -height]) {
        hull() {
            cylinder(h=height, d=d, center=false);
            translate([0, part_depth])
                cylinder(h=height, d=d, center=false);
        }
    }
}

/* Hex socket flat head screw */
module top_screw_hole(x,y) {
    screw_m3_diameter      = 3.1;
    screw_m3_head_diameter = 6.2;
    screw_m3_head_height   = 2.0;
    translate([x, y, part_height]) {
        union() {
            h1 = min(part_border[0], max(part_border[0] - screw_m3_head_height, 0));
            cylinder(d=screw_m3_diameter, h=h1);
            translate([0, 0, h1])
                cylinder(d1=screw_m3_diameter, d2=screw_m3_head_diameter, h=screw_m3_head_height);
        }
    }
}

module arm_slot(w,d,h) {
    trapeze_points = [
        [ 0,  0, -3.4 ],
        [ w,  0, -3.4 ],
        [ w,  d,  0 ],
        [ 0,  d,  0 ],
        [ 0,  0,  h ],
        [ w,  0,  h ],
        [ w,  d,  h ],
        [ 0,  d,  h ]];
    trapeze_faces = [
        [0, 1, 2, 3],  // bottom
        [4, 5, 1, 0],  // front
        [7, 6, 5, 4],  // top
        [5, 6, 2, 1],  // right
        [6, 7, 3, 2],  // back
        [7, 4, 0, 3]]; // left

    right_border_margin = 0.6; // right_border_margin + w < part_border[1]
    /* Tune exact location */
    translate([part_width + right_border_margin, -part_border_front -border_radius/2 + 7.0, 3.5])
        rotate([60, 0, 0])
            polyhedron(trapeze_points, trapeze_faces);
}

difference() {
    translate([-part_border[3] + border_radius,
               -part_border_front + border_radius/2, -part_border[2]]) {
        minkowski() {
            h = part_height + part_border[0] + part_border[2];
            translate([-border_radius/2, -border_radius/2, 0])
                cube([part_width + part_border[1] + part_border[3] - border_radius/2,
                      part_depth + part_border_front - border_radius/2,
                      h/2], center=false);
            cylinder(r=border_radius/2, h=h/2);
        }
    }
    cube([part_width, part_depth, part_height], center=false);

    // notches
    bar_hole( 9.5, 4.9, hole_diameter[1]);
    bar_hole(24.6, 4.9, hole_diameter[1]);

    // top holes (for screws, M3x18mm)
    top_screw_hole(10.1, 5.2);
    top_screw_hole(25.0, 5.2);

    // front hole (for filament)
    translate([37.2, part_height/2, 8.2])
        rotate([90,0,0])
            cylinder(d=hole_diameter[0], h=part_height);

    // arm grip (rectangle window: 3x6mm)
    arm_slot(3.0, 6.0, 12);
}
