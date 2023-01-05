function mm(x) = x;

// Constant

VEC_X = [1, 0, 0];
VEC_Y = [0, 1, 0];
VEC_Z = [0, 0, 1];

NOZZLE = mm(0.4);

BIAS = mm(0.01);

// Settings

$fn = 32;

// Rail - Setting

rail_beam_height       = mm( 2.55);
rail_beam_base_width   = mm( 1.74);
rail_beam_base_height  = mm( 0.40);
rail_beam_sole_width   = mm( 0.45);
rail_beam_head_width   = mm( 0.80);
rail_beam_head_height  = mm( 0.60);
rail_beam_distance     = mm(17.20);
rail_sleeper_length    = mm(30.00);
rail_sleeper_width     = mm( 3.00);
rail_sleeper_height    = mm( 1.90);
rail_sleeper_distance  = mm( 7.50);

rail_clamb_length      = mm( 4.45);
rail_clamb_width       = mm( 1.45);
rail_clamb_height      = mm( 0.85);
rail_clamb_feet_length = mm( 6.60);
rail_clamb_feet_width  = mm( 2.00);
rail_clamb_feet_height = mm( 0.15);

// Rail - Derived

rail_beam_center      = 0;
rail_beam_bottom      = 0;
rail_beam_base_bottom = rail_beam_bottom;
rail_beam_base_top    = rail_beam_base_bottom + rail_beam_base_height;
rail_beam_base_center = rail_beam_center;
rail_beam_base_right  = rail_beam_base_center + rail_beam_base_width / 2;
rail_beam_base_left   = rail_beam_base_center - rail_beam_base_width / 2;

rail_beam_head_top    = rail_beam_base_bottom + rail_beam_height;
rail_beam_head_bottom = rail_beam_head_top - rail_beam_head_height;
rail_beam_head_center = rail_beam_center;
rail_beam_head_right  = rail_beam_head_center + rail_beam_head_width / 2;
rail_beam_head_left   = rail_beam_head_center - rail_beam_head_width / 2;

rail_beam_sole_bottom = rail_beam_base_top;
rail_beam_sole_top    = rail_beam_head_bottom;
rail_beam_sole_center = rail_beam_center;
rail_beam_sole_right  = rail_beam_sole_center + rail_beam_sole_width / 2;
rail_beam_sole_left   = rail_beam_sole_center - rail_beam_sole_width / 2;

rail_sleeper_top      = rail_beam_bottom;
rail_sleeper_bottom   = rail_sleeper_top - rail_sleeper_height;

rail_clamb_bottom     = rail_sleeper_top;
rail_clamb_top        = rail_clamb_bottom + rail_clamb_height;
rail_clamb_center     = rail_beam_center;

// Rail - modules

module Rail(length, center=undef) {
    RailBeams(length, center);
    RailSleepers();
   
    module RailBeams(length, center=undef) {
        rotate(90, VEC_X) {
            linear_extrude(length, center=center) {
                RailBeams2D();
            }
        }
       
        module RailBeams2D() {
            mirror_copy() {
                translate([rail_beam_distance/2, 0]) {
                    RailBeam2D();
                }
            }
        }
       
        module RailBeam2D() {
            points = [
                [rail_beam_base_left, rail_beam_base_bottom],
                [rail_beam_base_left, rail_beam_base_top],
                [rail_beam_sole_left, rail_beam_sole_bottom],
                [rail_beam_sole_left, rail_beam_sole_top],
                [rail_beam_head_left, rail_beam_head_bottom],
                [rail_beam_head_left, rail_beam_head_top],
               
                [rail_beam_head_right, rail_beam_head_top],
                [rail_beam_head_right, rail_beam_head_bottom],
                [rail_beam_sole_right, rail_beam_sole_top],
                [rail_beam_sole_right, rail_beam_sole_bottom],
                [rail_beam_base_right, rail_beam_base_top],
                [rail_beam_base_right, rail_beam_base_bottom],
            ];
            polygon(points);
        }
    }

    module RailSleepers() {    
        distribute(
            vec      = VEC_Y,
            length   = length,
            distance = rail_sleeper_distance,
            center=center
        ) {
            RailSleeper();
            RailClambs();
        }
       
        module RailSleeper() {
            translate([0, 0, rail_sleeper_bottom]) {
                linear_extrude(rail_sleeper_height) {
                    square(
                        [rail_sleeper_length, rail_sleeper_width],
                        center = true
                    );
                }
            }
        }
       
        module RailClambs() {
            mirror_copy(VEC_X) {
                translate([rail_beam_distance / 2, 0]) {
                    RailClamb();
                }
            }
        }
       
        module RailClamb() {
            Feet();
            Clamb();
           
            module Feet() {
                linear_extrude(rail_clamb_feet_height) {
                    square(
                        [rail_clamb_feet_length, rail_clamb_feet_width],
                        center=true
                    );
                }
            }
            module Clamb() {
                linear_extrude(rail_clamb_height) {
                    square(
                        [rail_clamb_length, rail_clamb_width],
                        center=true
                    );
                }
            }
        }
    }
}


// Fixture - Setting

fixture_rail_count        = 2;
fixture_rail_distance     = mm(61.90);

fixture_thickness         = mm( 3.50);
fixture_head_width        = mm(25.00);
fixture_head_lenght       = mm(30.00);

fixture_sole_width        = mm(12.50);
fixture_sole_wall_thickness1= 4 * NOZZLE;
fixture_sole_wall_thickness2= 2.5 * NOZZLE;
fixture_corner_radius     = mm( 3.00);

fixture_wall_thickness_xy = 4 * NOZZLE;
fixture_wall_thickness_z  = mm(0.5);

fixture_rail_tolerance_xy = mm(0.05);
fixture_rail_tolerance_z  = mm(0.0);

fixture_rail_minimum_radius   = mm(500.0);

fixture_spring_slot_width     = mm(1.0);
fixture_spring_wall_thickness = 2 * NOZZLE;
fixture_spring_wall_y         = mm(3.0);

fixture_finger_hole_radius    = fixture_thickness - mm(0.8);
fixture_finger_y_hole_length  = fixture_head_width / 2;
fixture_finger_x_hole_length  = mm(8.0);

fixture_clip_length           = mm(10.0);
fixture_clip_height           = (rail_beam_head_width - rail_beam_sole_width) / 2;
fixture_clip_width            = mm(1.0);

fixture_text_indent           = mm(.3);


// Fixture - Derived

fixture_length             = fixture_rail_distance + fixture_head_lenght;

fixture_beam_channel_width = rail_beam_head_width
                           + 2 * fixture_rail_tolerance_xy;
fixture_beam_channel_depth = rail_beam_height
                           - rail_clamb_top
                           + fixture_rail_tolerance_z;

fixture_spring_slot_lenght = fixture_head_width / 4 * 3;
fixture_spring_slot_depth  = fixture_thickness - fixture_wall_thickness_z;

// Fixture - 3D

module Fixture() {
    if(fixture_rail_count == 1) {
        Middle();
        Text(0);
    }
    else {
        translate([-fixture_rail_distance/2,0]) {
            mirror(VEC_X) End();
            Text(0);
        }
        for(i=[0:fixture_rail_count-2]) {
            translate([i * fixture_rail_distance, 0]) {
                Strud();
                translate([fixture_rail_distance/2,0]) {
                    if(i == fixture_rail_count-2) {
                        End();
                        Text(1);
                    } else {
                        Middle();
                        Text(2);
                    }
                }
            }
        }
    }
    
    module Strud() {
        BasicShape();
                
        module BasicShape() {
            bias = mm(0.01);
            length = fixture_rail_distance - fixture_head_lenght;
            linear_extrude(fixture_thickness) {
                mirror_copy(VEC_Y) {
                    translate([0, (fixture_sole_width - fixture_sole_wall_thickness1) / 2]) {
                        square(
                            [length + bias, 
                             fixture_sole_wall_thickness1],
                            center = true
                        );
                    }
                    a = atan(
                        (fixture_sole_width - 2 * fixture_sole_wall_thickness1)
                        / (length / 3 * 2)
                    );
                    mirror_copy(VEC_X) {
                        translate([-length / 2, fixture_sole_width / 2 - fixture_sole_wall_thickness1]) {
                            rotate(-a) square([
                                (fixture_sole_width - fixture_sole_wall_thickness1) / tan(a),
                                fixture_sole_wall_thickness2]);
                        }
                    }
                }
            }
        }
    }
    
    module End() {
        difference() {
            BasicShape();
            RailBeams();
            FingerHole();
        }
    }
    module Middle() {
        difference() {
            BasicShape();
            RailBeams();
        }
    }
    
        
    module BasicShape() {
        linear_extrude(fixture_thickness) {
            difference() {
                round_off(fixture_corner_radius) {
                    square(
                        [fixture_head_lenght, fixture_head_width],
                        center = true
                    );
                }
                square([mm(9),mm(15)], true);
            }
        }
    }
    
    module RailBeams() {
        mirror_copy(VEC_X) {
            mirror_copy(VEC_X) {
                RailBeam();
            }
        }
    }
    
    module RailBeam() {
        RailBeamSlot();
        SpringSlots();
        
        module RailBeamSlot() {
            difference() {
                linear_extrude(fixture_beam_channel_depth * 2, center=true) {
                    bias = mm(1.0);
                    RailBeamSlot2D(bias);
                }
                SpringClips();
            }
        }
        
        module SpringSlots() {
            linear_extrude(2 * fixture_spring_slot_depth, center=true) {
                InnerSpringSlot2D();
                OuterSpringSlot2D();
                
            }
            difference() {
                linear_extrude(2 * fixture_spring_slot_depth, center=true) {
                    MiddleSpringSlot2D();
                }
                SpringClips();
            }
                
            module InnerSpringSlot2D() {
                a = fixture_beam_channel_width / 2;
                intersection() {
                    square([
                        fixture_head_lenght, 
                        fixture_head_width - 2*fixture_spring_wall_y], true);
                    difference() {
                        OuterCircle(a + fixture_spring_wall_thickness);
                        OuterCircle(a + fixture_spring_wall_thickness + fixture_spring_slot_width);
                    }
                }
            }
            
            module OuterSpringSlot2D() {
                a = fixture_beam_channel_width / 2;
                intersection() {
                    square([
                        fixture_head_lenght, 
                        fixture_head_width - 2 * fixture_spring_wall_y], true);
                    difference() {
                        InnerCircle(-a - fixture_spring_wall_thickness);
                        InnerCircle(-a - fixture_spring_wall_thickness - fixture_spring_slot_width);
                        
                        
                    }
                }
            }
                
            module MiddleSpringSlot2D() {
                RailBeamSlot2D(-2 * fixture_spring_wall_y);
            }    
        }
        
        module SpringClips() {
            OuterSpringClip();
            InnerSpringClip();
            
            module OuterSpringClip() {
                hull() {
                    translate([0,0,fixture_clip_width/3]) linear_extrude(fixture_clip_width/3) {
                        intersection() {
                            square([fixture_head_lenght, fixture_clip_length], true);
                            InnerCircle(-fixture_beam_channel_width/2 + fixture_clip_height);
                        }
                    }
                    translate([0,0,0]) linear_extrude(fixture_clip_width) {
                        intersection() {
                            square([
                                fixture_head_lenght,
                                fixture_head_width - 2*fixture_spring_wall_y], true);
                            InnerCircle(-fixture_beam_channel_width/2);
                        }
                    }
                }
            }
            module InnerSpringClip() {
                hull() {
                    translate([0,0,fixture_clip_width/3]) linear_extrude(fixture_clip_width/3) {
                        intersection() {
                            square([fixture_head_lenght, fixture_clip_length], true);
                            OuterCircle(fixture_beam_channel_width/2 - fixture_clip_height);
                        }
                    }
                    translate([0,0,0]) linear_extrude(fixture_clip_width) {
                        intersection() {
                            square([
                                fixture_head_lenght, 
                                fixture_head_width - 2*fixture_spring_wall_y], true);
                            OuterCircle(fixture_beam_channel_width/2);
                        }
                    }
                }
            }
        }
        
        module RailBeamSlot2D(width_delta = 0) {
            a = fixture_beam_channel_width / 2;
            difference() {
                square([fixture_head_lenght, fixture_head_width + width_delta], true);
                InnerCircle(-a);
                OuterCircle(a);
            }
        }
                  
        module InnerCircle(delta) {
            translate([fixture_rail_minimum_radius, 0]) {
                $fn=undef;
                $fa=1.0;
                circle(r=fixture_rail_minimum_radius - rail_beam_distance / 2 + delta);
            }
        }
        
        module OuterCircle(delta) {
            translate([-fixture_rail_minimum_radius, 0]) {
                $fn=undef;
                $fa=1.0;
                circle(r=fixture_rail_minimum_radius + rail_beam_distance / 2 - delta);
            }
        }
    }
    module FingerHole() {
        translate([fixture_head_lenght/2, 0]) {
            hull() {
                mirror_copy(VEC_Y) {
                    translate([
                        0,
                        (fixture_finger_y_hole_length - fixture_finger_hole_radius) /2]
                    ) {
                        sphere(r=fixture_finger_hole_radius);
                    }
                }
            }                    
        }
        mirror_copy(VEC_Y) translate([0, fixture_head_width/2]) {
            hull() {
                mirror_copy(VEC_X) {
                    translate([
                        (fixture_finger_x_hole_length - fixture_finger_hole_radius) /2,
                        0]
                    ) {
                        sphere(r=fixture_finger_hole_radius);
                    }
                }
            }
        }
    }
    module Text(index = 0) {
        translate([0,0, fixture_thickness]) {
            linear_extrude(2 * fixture_text_indent, center=true) offset(mm(.1)){
                if(index == 0) {
                    translate([-fixture_head_lenght/3,0]) {
                        scale(0.08) rotate(90) import("MSA-logo.dxf");
                    }
                    translate([+fixture_head_lenght/3-2.4,0]) {
                        rotate(90) text(
                            text   = "Rail",
                            size   = mm(4.4),
                            valign = "center",
                            halign = "center"
                        );
                    }
                    translate([+fixture_head_lenght/3+2.4,0]) {
                        rotate(90) text(
                            text   = "Spacer",
                            size   = mm(4.4),
                            valign = "center",
                            halign = "center"
                        );
                    }
                } else if (index == 1) {
                    translate([-fixture_head_lenght/3,0]) {
                        rotate(90) text(
                            text   = "H0",
                            size   = mm(4.4),
                            valign = "center",
                            halign = "center"
                        );
                    }
                    translate([+fixture_head_lenght/3,0]) {
                        rotate(90) text(
                            text   = str(fixture_rail_distance, "mm"),
                            size   = mm(4.4),
                            valign = "center",
                            halign = "center"
                        );
                    }
                } else if (index == 2) {
                    translate([-fixture_head_lenght/3,0]) {
                        rotate(90) text(
                            text   = str(fixture_rail_count),
                            size   = mm(4.4),
                            valign = "center",
                            halign = "center"
                        );
                    }
                    translate([+fixture_head_lenght/3,0]) {
                        rotate(90) text(
                            text   = "Rails",
                            size   = mm(4.4),
                            valign = "center",
                            halign = "center"
                        );
                    }
                }
                
            }
        }
    }
}

*mirror_copy(VEC_X) translate([fixture_rail_distance/2, 0]) {
    Rail(100, true);
}
translate([0, 0, rail_clamb_top]) Fixture();

// Utility - modules

module round_off(r) {
    offset(r=r)offset(-r) children();
}

module mirror_copy(vec = undef) {
    children();
    mirror(vec) children();
}

module distribute(vec, length, distance, center) {
    count       = floor(length / distance) + 1;
    start_index = -count / 2 + 1;
    end_index   =  count / 2 - 1;
   
    for(index = [start_index:1:end_index]) {
        a = index * distance;
        translate(vec * a) {
            children();
        }
    }
}

