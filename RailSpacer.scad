include <Constants.scad>
include <Units.scad>
include <Utils.scad>
use <Rail.scad>

$fn = 32;

rail_type             = get_rail_type("piko100_h0");
fixture_rail_distance = mm(61.90);

mirror_copy(VEC_X) translate([fixture_rail_distance/2, 0]) {
    Rail(rail_type, 100, true);
}
translate([0, 0, clamb_top]) Fixture(rail_type);


module Fixture(
    rail_type,
    fixture_rail_distance
) {
    beam_height       = get_rail_beam_height(rail_type);
    beam_base_width   = get_rail_beam_base_width(rail_type);
    beam_base_height  = get_rail_beam_base_height(rail_type);
    beam_sole_width   = get_rail_beam_sole_width(rail_type);
    beam_head_width   = get_rail_beam_head_width(rail_type);
    beam_head_height  = get_rail_beam_head_height(rail_type);
    beam_distance     = get_rail_beam_distance(rail_type);
    sleeper_length    = get_rail_sleeper_length(rail_type);
    sleeper_width     = get_rail_sleeper_width(rail_type);
    sleeper_height    = get_rail_sleeper_height(rail_type);
    sleeper_distance  = get_rail_sleeper_distance(rail_type);
    clamb_length      = get_rail_clamb_length(rail_type);
    clamb_width       = get_rail_clamb_width(rail_type);
    clamb_height      = get_rail_clamb_height(rail_type);
    clamb_feet_length = get_rail_clamb_feet_length(rail_type);
    clamb_feet_width  = get_rail_clamb_feet_width(rail_type);
    clamb_feet_height = get_rail_clamb_feet_height(rail_type);

    beam_bottom      = 0;
    sleeper_top      = beam_bottom;
    clamb_bottom     = sleeper_top;
    clamb_top        = clamb_bottom + clamb_height;

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
    fixture_clip_height           = (beam_head_width - beam_sole_width) / 2;
    fixture_clip_width            = mm(1.0);

    fixture_text_indent           = mm(.3);


    // Fixture - Derived

    fixture_length             = fixture_rail_distance + fixture_head_lenght;

    fixture_beam_channel_width = beam_head_width
                               + 2 * fixture_rail_tolerance_xy;
    fixture_beam_channel_depth = beam_height
                               - clamb_top
                               + fixture_rail_tolerance_z;

    fixture_spring_slot_lenght = fixture_head_width / 4 * 3;
    fixture_spring_slot_depth  = fixture_thickness - fixture_wall_thickness_z;
    
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
                circle(r=fixture_rail_minimum_radius - beam_distance / 2 + delta);
            }
        }
        
        module OuterCircle(delta) {
            translate([-fixture_rail_minimum_radius, 0]) {
                $fn=undef;
                $fa=1.0;
                circle(r=fixture_rail_minimum_radius + beam_distance / 2 - delta);
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



