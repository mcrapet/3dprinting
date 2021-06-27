/*
 * CR-10S Pro wheel guide for filament: bended arm with wheel support part
 *
 * History
 * -------
 * v01 (2021.06.21): Initial version
 */

// Rectangle window: 3x6 mm
depth  =  5.6;
height =  2.7; /* depending filament/printer take 2.6 */

angle = -26;    /* reduce number to get shorter arm */
distance = 100; /* increase number to get a more plane curbe */

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

difference() {
    translate([0, -distance + depth/2, 0]) {
        union()  {
            /* curved arm */
            translate([0, -depth/2, 0])
                rotate([0,0, 90-angle])
                    rotate_extrude(angle=angle, convexity = 10, $fn=128)
                        translate([distance, 0, 0])
                            square([depth,height]);
            /* pilar */
            translate([distance * sin(angle), distance * cos(angle), 0])
                pilar();
        }
    }

    /* bevel cut */
    translate([0, depth, 0])
        rotate([0, 0, -20])
            translate([0, -2*depth, 0])
                cube([depth, 2*depth, height], center=false);
}
