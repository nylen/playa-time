function inches(qty) = qty * 25.4;
function feet(qty) = inches(qty) * 12;

pole_rotation = -15;
pole_height = feet(10);
pole_radius = inches(1);

wire_angle_steepness = 48.5;
wire_angle_rotation  = -pole_rotation * 1;
wire_length = pole_height * 1.49;
wire_radius = inches(0.2);

pole_face_bottom     = feet(6);
pole_face_bottom_low = pole_face_bottom - inches(8);
pole_face_top        = feet(8);

face_width = feet(3);

color_steel   = [.61, .65, .70, .7];
color_wire    = [.30, .35, .40, .8];
color_acrylic = [.90, .89, .78, .15];

// Rotate everything so that the poles don't point outwards
rotate_fudge_1 = 5;

// None of the adjacent poles are actually in the same plane,so
// rotate each panel to bring it approximately into the plane
// in the middle of the two poles.
rotate_fudge_2 = -5;

module section(hour) {
    rotate([rotate_fudge_1, pole_rotation, 0]) {
        color(c = color_steel) {
            cylinder(h = pole_height, r = pole_radius, center = false);
        }
    }
    
    //if (hour == 0)
    rotate([wire_angle_steepness, wire_angle_rotation, 0]) {
        color(c = color_wire) {
            cylinder(h = wire_length, r = wire_radius, center = false);
        }
    }
    
    y0 = -inches(.75);
    y1 =  inches(.75);
    // Push the outer edges of the panels away from center
    y_fudge = inches(2);
    
    face_bottom     = pole_face_bottom     * cos(pole_rotation);
    face_bottom_low = pole_face_bottom_low * cos(pole_rotation);
    face_top        = pole_face_top        * cos(pole_rotation);
    
    x0_bottom = pole_face_bottom * sin(pole_rotation);
    x0_top    = pole_face_top    * sin(pole_rotation);
    
    x1_bottom     = pole_face_bottom     * sin(pole_rotation) + face_width;
    x1_bottom_low = pole_face_bottom_low * sin(pole_rotation) + face_width;
    x1_top        = pole_face_top        * sin(pole_rotation) + face_width;

    coords = [
        [ x0_bottom, y0, face_bottom ],  // 0
        [ x1_bottom_low, y0 + y_fudge, face_bottom_low ],  // 1
        [ x1_bottom_low, y1 + y_fudge, face_bottom_low ],  // 2
        [ x0_bottom, y1, face_bottom ],  // 3
        [ x0_top   , y0, face_top ],     // 4
        [ x1_top   , y0 + y_fudge, face_top ],     // 5
        [ x1_top   , y1 + y_fudge, face_top ],     // 6
        [ x0_top   , y1, face_top ]      // 7
    ];
    
    faces = [
        [0,1,2,3],  // bottom
        [4,5,1,0],  // front
        [7,6,5,4],  // top
        [5,6,2,1],  // right
        [6,7,3,2],  // back
        [7,4,0,3]   // left
    ];
    
    rotate([rotate_fudge_1, 0, 0]) {
        color(c = color_acrylic) {
            // Temporary z-offset for rotation.
            z_midpoint = (face_bottom + face_top) / 2;
            translate([0, 0, z_midpoint]) {
                rotate([rotate_fudge_2, 0, 0]) {
                    translate([0, 0, -z_midpoint]) {
                        // '%' is fix for transparency issues
                        %polyhedron(coords, faces);
                    }
                }
            }
        }
    }
}

//section();

for (hour = [0 : 11]) {
    rotate([0, 0, 360 * hour / 12]) {
        translate([0, feet(6), 0]) {
            section(hour);
        }
    }
}

//#cylinder(h = feet(10), r = feet(6), center = false, $fn = 300);