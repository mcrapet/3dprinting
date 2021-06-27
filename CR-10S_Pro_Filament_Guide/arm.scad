/*
 * CR-10S Pro wheel guide for filament: arm with wheel support part
 *
 * History
 * -------
 * v01 (2021.06.21): Initial version
 */

width1  = 37.0; // long width of trapeze
width2  = 34.0; // short width of trapeze

// Rectangle window: 3x6 mm
depth  =  5.6;
height =  2.7; /* depending filament/printer take 2.6 */

trapeze_points = [
    [ 0,  0,  0 ],
    [ width2, 0,  0 ],
    [ width1, depth, 0 ],
    [ 0, depth,  0 ],
    [ 0, 0, height ],
    [ width2, 0, height ],
    [ width1, depth, height ],
    [ 0, depth, height ]];
trapeze_faces = [
    [0, 1, 2, 3],  // bottom
    [4, 5, 1, 0],  // front
    [7, 6, 5, 4],  // top
    [5, 6, 2, 1],  // right
    [6, 7, 3, 2],  // back
    [7, 4, 0, 3]]; // left

function cumsum(values) =
    [ for (a=0, b=values[0]; a < len(values); a= a+1, b=b+values[a]) b];

module pilar() {
        round1_height = 3.2; d1=20;
        round2_height = 1.4; d2=13;
        round3_height = 6.8; d3=8;
        cylinder(h=round1_height, d=d1);
        translate([0, 0, round1_height])
            cylinder(h=round2_height, d=d2);
        translate([0, 0, round1_height + round2_height])
            cylinder(h=round3_height, d=d3);

        roundX_height = round1_height + round2_height + round3_height;
        h = [ 0.4, 0.2, 1.0 ]; z = cumsum(h);
        d3_offset = 0.14; /* 8.14 */
        hull() {
            translate([0, 0, roundX_height])
                cylinder(h=h[0], d=d3);
            translate([0, 0, roundX_height + z[0]])
                cylinder(h=h[1], d=d3+d3_offset);
            translate([0, 0, roundX_height + z[1]])
                cylinder(h=h[2], d1=d3, d2=d3-d3_offset);
        }
}

union() {
    polyhedron(trapeze_points, trapeze_faces);
    translate([0, depth/2])
        pilar();
}
