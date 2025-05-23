wall_thickness = 2;
floor_thickness = 4;
corner_radius = 2;

additional_front_padding = 8; // this should make things easier to assemble

esp_width = 52;
esp_depth = 29;
esp_height = 14;

display_outer_width = 27;
display_outer_height = 28;
display_width = 25;
display_height = 14.5;

button_width = 11;
button_height = 14;

front_plate_angle = 20;

epsilon = 0.01;

module esp_spacer() {
    height = 12.6 - 2.5 - 2 - 1.5;
    radius = 1.6;
    outer_radius = radius + 0.8;
    
    difference() {
        cylinder(height, outer_radius, outer_radius, $fn=64);
        cylinder(height, radius, radius, $fn=64);
    }
}

module rounded_rect(width, depth, height, corner_radius) {
    linear_extrude(height, center = false) {
        hull() {
            translate([corner_radius, corner_radius, 0])
                circle(corner_radius, $fn=64);
            translate([corner_radius, depth - corner_radius, 0])
                circle(corner_radius, $fn=64);
            translate([width - corner_radius, depth - corner_radius, 0])
                circle(corner_radius, $fn=64);
            translate([width - corner_radius, corner_radius, 0])
                circle(corner_radius, $fn=64);
        }
    }
}

module esp_mounts() {
    screw_radius = 1.6;
    nut_radius = 6.2 / 2;
    translate([wall_thickness - 1, wall_thickness, -epsilon]) {
        // mount 1
        translate([1.5 + screw_radius, 1 + screw_radius, 0])
            cylinder(floor_thickness + epsilon * 2, screw_radius, screw_radius, $fn=64);
        translate([1.5 + screw_radius, 1 + screw_radius, 0])
            cylinder(2.7, nut_radius, nut_radius, $fn=6);
        // mount 2
        translate([esp_width - 2 - screw_radius, 1 + screw_radius, 0])
            cylinder(floor_thickness + epsilon * 2, screw_radius, screw_radius, $fn=64);
        translate([esp_width - 2 - screw_radius, 1 + screw_radius, 0])
            cylinder(2.7, nut_radius, nut_radius, $fn=6);
        // mount 3
        translate([esp_width - 2 - screw_radius, esp_depth - 1 - screw_radius, 0])
            cylinder(floor_thickness + epsilon * 2, screw_radius, screw_radius, $fn=64);
        translate([esp_width - 2 - screw_radius, esp_depth - 1 - screw_radius, 0])
            cylinder(2.7, nut_radius, nut_radius, $fn=6);
        // mount 4
        translate([1.5 + screw_radius, esp_depth - 1 - screw_radius, 0])
            cylinder(floor_thickness + epsilon * 2, screw_radius, screw_radius, $fn=64);
        translate([1.5 + screw_radius, esp_depth - 1 - screw_radius, 0])
            cylinder(2.7, nut_radius, nut_radius, $fn=6);
    }
}
module esp_bolt_head_diff() {
    head_radius = 1.6;
    height = 20;
    translate([wall_thickness - 2, wall_thickness, -epsilon]) {
        // mount 1
        translate([1 + head_radius, 1 + head_radius, 0])
            cylinder(height + epsilon * 2, head_radius, head_radius, $fn=64);
        // mount 1
        translate([1 + head_radius, esp_depth - 1 - head_radius, 0])
            cylinder(height + epsilon * 2, head_radius, head_radius, $fn=64);
    }
}

module cooling_holes() {
    width = esp_width + wall_thickness * 2;
    depth = esp_depth + wall_thickness * 2;
    height = floor_thickness;
    
    translate([24, depth * 0.30 - 1.5, -epsilon]) {
        translate([0, 0, 0]) 
            rounded_rect(4, 3, height + epsilon * 2, 1);
        translate([6, 0, 0]) 
            rounded_rect(4, 3, height + epsilon * 2, 1);
        translate([12, 0, 0]) 
            rounded_rect(4, 3, height + epsilon * 2, 1);
        translate([18, 0, 0]) 
            rounded_rect(4, 3, height + epsilon * 2, 1);
    }
    translate([24, depth * 0.70 - 1.5, -epsilon]) {
        translate([0, 0, 0]) 
            rounded_rect(4, 3, height + epsilon * 2, 1);
        translate([6, 0, 0]) 
            rounded_rect(4, 3, height + epsilon * 2, 1);
        translate([12, 0, 0]) 
            rounded_rect(4, 3, height + epsilon * 2, 1);
        translate([18, 0, 0]) 
            rounded_rect(4, 3, height + epsilon * 2, 1);
    }
    translate([24 + 3, depth * 0.50 - 1.5, -epsilon]) {
        translate([0, 0, 0]) 
            rounded_rect(4, 3, height + epsilon * 2, 1);
        translate([6, 0, 0]) 
            rounded_rect(4, 3, height + epsilon * 2, 1);
        translate([12, 0, 0]) 
            rounded_rect(4, 3, height + epsilon * 2, 1);
    }
}

module usb_hole() {
    depth = 9;
    height = 3.5;
    translate([-epsilon, wall_thickness + 10, floor_thickness + 7 - height]) {
        cube([10, depth, height], center = false);
    }
}

module bottom_plate() {
    width = esp_width + wall_thickness * 2;
    depth = esp_depth + wall_thickness * 2 + additional_front_padding;
    height = floor_thickness;
    
    difference() {
        rounded_rect(width, depth, height, corner_radius);
        translate([0, additional_front_padding,0]) {
            esp_mounts();
            cooling_holes();
        }
    }
}

module bottom_walls() {
    width = esp_width + wall_thickness * 2;
    depth = esp_depth + wall_thickness * 2 + additional_front_padding;
    height = 7;
    
    difference() {
        translate([0, 0, floor_thickness]) {
            difference() {
                rounded_rect(width, depth, height, corner_radius);
                translate([wall_thickness, wall_thickness, -epsilon])
                    rounded_rect(esp_width, esp_depth + additional_front_padding, height + epsilon * 2, 1);
            }
        }
        translate([0, additional_front_padding,0]) {
            usb_hole();
            esp_bolt_head_diff();
        }
    }
}

module bottom() {
    union() {
        bottom_plate();
        bottom_walls();
    }
}

module front_wall() {
    width = esp_width + wall_thickness * 2;
    height = display_outer_height + 4;
    difference() {
        hull() {
            translate([corner_radius, corner_radius, 0])
                cylinder(height, corner_radius, corner_radius, $fn=64);
            translate([width - corner_radius, corner_radius, 0])
                cylinder(height, corner_radius, corner_radius, $fn=64);
            translate([corner_radius, corner_radius, 0])
                sphere(corner_radius, $fn=64);
            translate([width - corner_radius, corner_radius, 0])
                sphere(corner_radius, $fn=64);
            translate([corner_radius, corner_radius, height])
                sphere(corner_radius, $fn=64);
            translate([width - corner_radius, corner_radius, height])
                sphere(corner_radius, $fn=64);
        }
        // making front wall thinner, as half of corner diameter
        translate([0, corner_radius, -corner_radius])
            cube([width, 5, height + corner_radius * 2], center = false);
    }
}

module display_slot_outline() {
    translate([wall_thickness + 4, -epsilon, 2])
        cube([display_outer_width, wall_thickness * 2 + epsilon * 2, display_outer_height], center = false);
}
module display_slot() {
    translate([wall_thickness + 4, 0, 2]) {
        union() {
            difference() {
                // same as slot outline
                cube([display_outer_width, wall_thickness + epsilon * 2, display_outer_height], center = false);
                // display hole
                translate([1, -epsilon, 5.5 + 2.5])
                    cube([display_width, wall_thickness * 2 + epsilon * 2, display_height], center = false);
                // display lower strip
                translate([1, 0.6, 5.5])
                    cube([display_width, wall_thickness * 2 + epsilon * 2, display_height], center = false);
                // display connector
                translate([display_outer_height / 2 - 5, 0.2, 0])
                    cube([10, wall_thickness * 2 + epsilon * 2, display_height], center = false);
                // display pcb
                translate([0, 1.2, 0])
                    cube([display_outer_width, wall_thickness * 2 + epsilon * 2, display_outer_height], center = false);
            }
            // pocket
            translate([0, 3.5, 0]) {
                cube([display_outer_width, 1.2, display_outer_height * 0.5], center = false);
            }
            translate([0, 0, -1.2]) {
                cube([display_outer_width, 3.5 + 1.2, 1.2], center = false);
            }
            translate([-1.2, 0, -1.2]) {
                cube([1.2, 3.5 + 1.2, display_outer_height * 0.4], center = false);
            }
            translate([display_outer_width, 0, -1.2]) {
                cube([1.2, 3.5 + 1.2, display_outer_height * 0.4], center = false);
            }
        }
    }
}


module button_up_slot_outline() {
    full_width = esp_width + wall_thickness * 2;
    translate([full_width - button_height - 4, -epsilon, display_outer_height - button_height + 5])
        cube([button_height, wall_thickness * 2 + epsilon * 2, button_width], center = false);
}
module button_up_slot() {
    full_width = esp_width + wall_thickness * 2;
    pcb_height = 2;
    
    translate([full_width - button_height - 4, 0, display_outer_height - button_height + 5]) {
        union() {
            difference() {
                union() {
                    cube([button_height, wall_thickness, button_width], center = false);
                    translate([-1, 1, -1]) {
                        cube([3, 3, 3], center = false);
                    }
                }
                translate([0, 1.2, 0]) {
                    cube([button_height, wall_thickness + epsilon * 2, button_width], center = false);
                }
            }
            // pad
            translate([button_height * 0.4, 0, -1.2]) {
                difference() {
                    cube([button_height * 0.6, 1.2 + pcb_height + 1 + 1.2, button_width + 2.4], center = false);
                        
                    translate([-epsilon, 0, 1.2]) {
                        cube([button_height * 0.6, 1.2 + pcb_height + 1, button_width], center = false);
                    }
                }
                
            }
        }
    }
}
module button_down_slot_outline() {
    full_width = esp_width + wall_thickness * 2;
    translate([full_width - button_height - 4, -epsilon, 2])
        cube([button_height, wall_thickness * 2 + epsilon * 2, button_width], center = false);
}
module button_down_slot() {
    full_width = esp_width + wall_thickness * 2;
    pcb_height = 2;
    
    translate([full_width - button_height - 4, 0, 2]) {
        union() {
            difference() {
                union() {
                    cube([button_height, wall_thickness, button_width], center = false);
                    translate([-1, 1, -1]) {
                        cube([3, 3, 3], center = false);
                    }
                }
                translate([0, 1.2, 0]) {
                    cube([button_height, wall_thickness + epsilon * 2, button_width], center = false);
                }
            }
            // pad
            translate([button_height * 0.4, 0, -1.2]) {
                difference() {
                    cube([button_height * 0.6, 1.2 + pcb_height + 1 + 1.2, button_width + 2.4], center = false);
                    translate([-epsilon, 0, 1.2]) {
                        cube([button_height * 0.6, 1.2 + pcb_height + 1, button_width], center = false);
                    }
                }
                
            }
        }
    }
}

module led_slot_outline() {
    led_radius = 2;
    pcb_radius = 7;
    translate([0, 0, -epsilon]) {
        union() {
            cylinder(wall_thickness + epsilon * 2, led_radius, led_radius, $fn = 64);
            cylinder(wall_thickness / 2, pcb_radius, pcb_radius, $fn = 64);
            // todo make nested circle for diffusor?
        }
    }
}

module led_slot() {
    pcb_radius = 7;
    translate([0, 0, -wall_thickness]) {
        difference() {
            union() {
                translate([-pcb_radius - 1, 0, -1.2])
                    cube([2, 2, 2 + 1.2], center = false);
                translate([pcb_radius - 1, 0, -1.2])
                    cube([2, 2, 2 + 1.2], center = false);
                translate([0, -pcb_radius - 1,  -1.2])
                    cube([2, 2, 2 + 1.2], center = false);
                translate([0, pcb_radius - 1,  0])
                    cube([2, 2, 2 ], center = false);
            }
            cylinder(2, pcb_radius, pcb_radius, $fn = 64);
        }
    }
}


module button_ok_slot_outline() {
    translate([0, 0, -epsilon])
        cube([button_height, button_width, wall_thickness * 2 + epsilon * 2 ], center = false);
}
module button_ok_slot() {
    pcb_height = 2;
    
    translate([0, 0, 0]) {
        difference() {
            union() {
                cube([button_height, button_width, wall_thickness ], center = false);
                translate([-1, -1, -2]) {
                    cube([3, 3, 3], center = false);
                }
                translate([-1, button_width - 1, -2]) {
                    cube([3, 3, 3], center = false);
                }
                translate([button_height * 0.6, -1.2, -2]) {
                    cube([button_height * 0.4 + 1.2, button_width + 2.4, 4], center = false);
                }
            }
            translate([0, 0, -pcb_height + 1.2]) {
                cube([button_height, button_width, pcb_height], center = false);
            }
        }
    }
}

module top_wall(width, depth, height) {
    // remove rounded corners from front
    union() {
        rounded_rect(width, depth - 2, height, corner_radius);
        cube([width, depth / 2, height], center = false); 
    }
}


module front_plate() {
    full_width = esp_width + wall_thickness * 2;
    
    union() {
        // front wall with rough holes for components
        difference() {
            front_wall();
            display_slot_outline();
            button_up_slot_outline();
            button_down_slot_outline();
            
            translate([1, corner_radius + 1, 32])
            rotate([0, 90, 0])
                cylinder(full_width - 2, corner_radius, corner_radius, $fn = 64);
        }
        // detailed component slots
        display_slot();
        button_up_slot();
        button_down_slot();
        
        
    }
}

module top_plate() {
    width = esp_width + wall_thickness; // * 2; // half of wall_thickness will be rails for each side
    full_depth = esp_depth + wall_thickness * 2 + additional_front_padding;
    
    front_wall_length = display_outer_height + 4;
    front_wall_x_diff = cos(90 - front_plate_angle) * front_wall_length;
    depth = full_depth - front_wall_x_diff - corner_radius;
    
    height = wall_thickness;
    
    union() {
        // top plate with rough holes for components
        difference() {
            top_wall(width, depth, height);
            translate([width / 2, depth * 0.3, 0])
                led_slot_outline();
            translate([width * 0.7, depth * 0.2, 0])
                button_ok_slot_outline();
        }
        
        translate([0.8, 0.8, height])
            top_wall(width - 0.4, depth - 0.4, 0.5);
        translate([width / 2, depth * 0.3, 0])
            led_slot();
        translate([width * 0.7, depth * 0.2, 0])
            button_ok_slot();
    }
}

module left_wall() {
    front_wall_length = display_outer_height + 4;
    front_wall_x_diff = cos(90 - front_plate_angle) * front_wall_length;
    
    front_plate_height = sin(90 - front_plate_angle) * front_wall_length;
    
    bottom_depth = esp_depth + wall_thickness * 2 + additional_front_padding - corner_radius * 2;
    top_depth = bottom_depth - front_wall_x_diff;
    
    difference() {
        hull() {
            union() {
                cube([wall_thickness, bottom_depth, 1], center = false);
                translate([corner_radius, front_wall_x_diff, front_plate_height])
                rotate([0, 90, 90])
                    cylinder(top_depth, corner_radius, corner_radius, $fn=64);
            }
        }
        translate([wall_thickness, 0, 0])
            cube([corner_radius, bottom_depth + epsilon, front_plate_height + corner_radius], center = false);
        translate([corner_radius + 1, 0, front_plate_height + 0.5])
        rotate([0, 90, 90])
                cylinder(bottom_depth + epsilon, corner_radius, corner_radius, $fn = 64);
    }
}


module right_wall() {
    front_wall_length = display_outer_height + 4;
    front_wall_x_diff = cos(90 - front_plate_angle) * front_wall_length;
    
    front_plate_height = sin(90 - front_plate_angle) * front_wall_length;
    
    bottom_depth = esp_depth + wall_thickness * 2 + additional_front_padding - corner_radius * 2;
    top_depth = bottom_depth - front_wall_x_diff;
    
    difference() {
        hull() {
            union() {
                cube([wall_thickness, bottom_depth, 1], center = false);
                translate([0, front_wall_x_diff, front_plate_height])
                rotate([0, 90, 90])
                    cylinder(top_depth, corner_radius, corner_radius, $fn=64);
            }
        }
        translate([-corner_radius, 0, 0])
            cube([corner_radius, bottom_depth + epsilon, front_plate_height + corner_radius], center = false);
        translate([-1, 0, front_plate_height + 0.5])
        rotate([0, 90, 90])
                cylinder(bottom_depth + epsilon, corner_radius, corner_radius, $fn = 64);
    }
}

module back_wall() {
    width = esp_width + wall_thickness * 2;
    depth = esp_depth + wall_thickness * 2 + additional_front_padding;
    
    
    front_wall_length = display_outer_height + 4;
    front_wall_x_diff = cos(90 - front_plate_angle) * front_wall_length;
    
    front_plate_height = sin(90 - front_plate_angle) * front_wall_length;
    height = front_plate_height + wall_thickness - 0.5; // assume we union this with top wall
    
    union() {
        translate([0, -depth + wall_thickness, 0]) {
            difference() {
                rounded_rect(width, depth, height - corner_radius + 0.5, corner_radius);
                translate([ -epsilon, -wall_thickness, -epsilon])
                    cube([width + epsilon * 2, depth, height + epsilon * 2], center = false);
            }
        }
        hull() {
            translate([corner_radius, 0, height - corner_radius + 0.5])
                sphere(corner_radius, $fn = 64);
            translate([width - corner_radius, 0, height - corner_radius + 0.5])
                sphere(corner_radius, $fn = 64);
        }
    }
}

// back plate and top plate will be one part
// front plate, sides and bottow will be second part

// add ears for screws on side panels


// testing parts

// bottom();

// esp_spacer();

//front_plate();

// top_plate();

// left_wall();
// right_wall();
// back_wall();



module alltogether() {
    width = esp_width + wall_thickness * 2;
    depth = esp_depth + wall_thickness * 2 + additional_front_padding;
    bottom_height = floor_thickness + 7;
    
    front_wall_length = display_outer_height + 4;
    front_wall_x_diff = cos(90 - front_plate_angle) * front_wall_length;
    
    front_plate_height = sin(90 - front_plate_angle) * front_wall_length;
    
    union() {
        bottom();
        translate([0, 0.12, bottom_height + 0.8])
        rotate([-front_plate_angle, 0, 0])
            front_plate();
        translate([wall_thickness / 2, front_wall_x_diff + corner_radius, bottom_height + front_plate_height - 0.5])
            top_plate();
        translate([0, depth - wall_thickness, bottom_height])
            back_wall();
        translate([0, corner_radius, bottom_height])
            left_wall();
        translate([width - corner_radius, corner_radius, bottom_height])
            right_wall();
    }
}

// alltogether();


module part1() {
    width = esp_width + wall_thickness * 2;
    depth = esp_depth + wall_thickness * 2 + additional_front_padding;
    bottom_height = floor_thickness + 7;
    
    front_wall_length = display_outer_height + 4;
    front_wall_x_diff = cos(90 - front_plate_angle) * front_wall_length;
    
    front_plate_height = sin(90 - front_plate_angle) * front_wall_length;
    
    union() {
        bottom();
        translate([0, 0.12, bottom_height + 0.8])
        rotate([-front_plate_angle, 0, 0])
            front_plate();
        /*translate([wall_thickness / 2, front_wall_x_diff + corner_radius, bottom_height + front_plate_height - 0.5])
            top_plate();
        translate([0, depth - wall_thickness, bottom_height])
            back_wall();*/
        translate([0, corner_radius, bottom_height])
            left_wall();
        translate([width - corner_radius, corner_radius, bottom_height])
            right_wall();
    }
}

module part2() {
    width = esp_width + wall_thickness * 2;
    depth = esp_depth + wall_thickness * 2 + additional_front_padding;
    bottom_height = floor_thickness + 7;
    
    front_wall_length = display_outer_height + 4;
    front_wall_x_diff = cos(90 - front_plate_angle) * front_wall_length;
    
    front_plate_height = sin(90 - front_plate_angle) * front_wall_length;
    
    union() {
        /*bottom();
        translate([0, 0.12, bottom_height + 0.8])
        rotate([-front_plate_angle, 0, 0])
            front_plate();*/
        translate([wall_thickness / 2, front_wall_x_diff + corner_radius, bottom_height + front_plate_height - 0.5])
            top_plate();
        translate([0, depth - wall_thickness, bottom_height])
            back_wall();
        /*translate([0, corner_radius, bottom_height])
            left_wall();
        translate([width - corner_radius, corner_radius, bottom_height])
            right_wall();*/
    }
}

// part1();
// part2();

// tpu parts
module tpu_button_pad() {
    cube([button_height, button_width, 1 ], center = false);
}

module tpu_led_pad1() {
    led_radius = 2;
    pcb_radius = 7;
    cylinder(1, pcb_radius, pcb_radius);
}
module tpu_led_pad2() {
    led_radius = 2.5;
    pcb_radius = 7;
    difference() {
        cylinder(1, pcb_radius, pcb_radius);
        cylinder(1, led_radius, led_radius);
    }
}

// button_pad();
// tpu_led_pad1();
tpu_led_pad2();