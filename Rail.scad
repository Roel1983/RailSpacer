include <Constants.scad>
include <RailTypes.scad>
include <Units.scad>
include <Utils.scad>

rail_type = get_rail_type("piko100_h0");
Rail(rail_type, 100);

module Rail(rail_type, length, center = true) {
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
    
    beam_center      = 0;
    beam_bottom      = 0;
    beam_base_bottom = beam_bottom;
    beam_base_top    = beam_base_bottom + beam_base_height;
    beam_base_center = beam_center;
    beam_base_right  = beam_base_center + beam_base_width / 2;
    beam_base_left   = beam_base_center - beam_base_width / 2;

    beam_head_top    = beam_base_bottom + beam_height;
    beam_head_bottom = beam_head_top - beam_head_height;
    beam_head_center = beam_center;
    beam_head_right  = beam_head_center + beam_head_width / 2;
    beam_head_left   = beam_head_center - beam_head_width / 2;

    beam_sole_bottom = beam_base_top;
    beam_sole_top    = beam_head_bottom;
    beam_sole_center = beam_center;
    beam_sole_right  = beam_sole_center + beam_sole_width / 2;
    beam_sole_left   = beam_sole_center - beam_sole_width / 2;

    sleeper_top      = beam_bottom;
    sleeper_bottom   = sleeper_top - sleeper_height;

    clamb_bottom     = sleeper_top;
    clamb_top        = clamb_bottom + clamb_height;
    clamb_center     = beam_center;

    RailBeams(length, center);
    RailSleepers();
   
    module RailBeams(length, center) {
        rotate(90, VEC_X) {
            linear_extrude(length, center=center) {
                RailBeams2D();
            }
        }
       
        module RailBeams2D() {
            mirror_copy(VEC_X) {
                translate([beam_distance / 2, 0]) {
                    RailBeam2D();
                }
            }
        }
       
        module RailBeam2D() {
            
            points = [
                [beam_base_left, beam_base_bottom],
                [beam_base_left, beam_base_top],
                [beam_sole_left, beam_sole_bottom],
                [beam_sole_left, beam_sole_top],
                [beam_head_left, beam_head_bottom],
                [beam_head_left, beam_head_top],
               
                [beam_head_right, beam_head_top],
                [beam_head_right, beam_head_bottom],
                [beam_sole_right, beam_sole_top],
                [beam_sole_right, beam_sole_bottom],
                [beam_base_right, beam_base_top],
                [beam_base_right, beam_base_bottom],
            ];
            polygon(points);
        }
    }

    module RailSleepers() {    
        distribute(
            vec      = VEC_Y,
            length   = length,
            distance = sleeper_distance
        ) {
            RailSleeper();
            RailClambs();
        }
       
        module RailSleeper() {
            translate([0, 0, sleeper_bottom]) {
                linear_extrude(sleeper_height) {
                    square(
                        [sleeper_length, sleeper_width],
                        center = true
                    );
                }
            }
        }
       
        module RailClambs() {
            mirror_copy(VEC_X) {
                translate([beam_distance / 2, 0]) {
                    RailClamb();
                }
            }
        }
       
        module RailClamb() {
            Feet();
            Clamb();
           
            module Feet() {
                linear_extrude(clamb_feet_height) {
                    square(
                        [clamb_feet_length, clamb_feet_width],
                        center=true
                    );
                }
            }
            module Clamb() {
                linear_extrude(clamb_height) {
                    square(
                        [clamb_length, clamb_width],
                        center=true
                    );
                }
            }
        }
    }
}