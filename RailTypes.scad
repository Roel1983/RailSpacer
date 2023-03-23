include <Units.scad>

rail_types = [
    ["piko100_h0", rail_type(
        label             = ["H0", "PIKO100"],
        beam_height       = mm( 2.55),
        beam_base_width   = mm( 1.74),
        beam_base_height  = mm( 0.40),
        beam_sole_width   = mm( 0.45),
        beam_head_width   = mm( 0.80),
        beam_head_height  = mm( 0.60),
        beam_distance     = mm(17.20),
        sleeper_length    = mm(30.00),
        sleeper_width     = mm( 3.00),
        sleeper_height    = mm( 1.90),
        sleeper_distance  = mm( 7.50),

        clamb_length      = mm( 4.45),
        clamb_width       = mm( 1.45),
        clamb_height      = mm( 0.85),
        clamb_feet_length = mm( 6.60),
        clamb_feet_width  = mm( 2.00),
        clamb_feet_height = mm( 0.15)
    )]
];

function rail_type(
    label,
    beam_height,
    beam_base_width,
    beam_base_height,
    beam_sole_width,
    beam_head_width,
    beam_head_height,
    beam_distance,
    sleeper_length,
    sleeper_width,
    sleeper_height,
    sleeper_distance,
    clamb_length,
    clamb_width,
    clamb_height,
    clamb_feet_length,
    clamb_feet_width,
    clamb_feet_height
) = [
    label,
    beam_height,
    beam_base_width,
    beam_base_height,
    beam_sole_width,
    beam_head_width,
    beam_head_height,
    beam_distance,
    sleeper_length,
    sleeper_width,
    sleeper_height,
    sleeper_distance,
    clamb_length,
    clamb_width,
    clamb_height,
    clamb_feet_length,
    clamb_feet_width,
    clamb_feet_height
];

function get_rail_label(type)             = type[ 0];
function get_rail_beam_height(type)       = type[ 1];
function get_rail_beam_base_width(type)   = type[ 2];
function get_rail_beam_base_height(type)  = type[ 3];
function get_rail_beam_sole_width(type)   = type[ 4];
function get_rail_beam_head_width(type)   = type[ 5];
function get_rail_beam_head_height(type)  = type[ 6];
function get_rail_beam_distance(type)     = type[ 7];
function get_rail_sleeper_length(type)    = type[ 8];
function get_rail_sleeper_width(type)     = type[ 9];
function get_rail_sleeper_height(type)    = type[10];
function get_rail_sleeper_distance(type)  = type[11];
function get_rail_clamb_length(type)      = type[12];
function get_rail_clamb_width(type)       = type[13];
function get_rail_clamb_height(type)      = type[14];
function get_rail_clamb_feet_length(type) = type[15];
function get_rail_clamb_feet_width(type)  = type[16];
function get_rail_clamb_feet_height(type) = type[17];

function get_rail_type(id, _index = 0) = (
    (_index >= len(rail_types)) ? (
        undef
    ) : (
        (rail_types[_index][0] == id) ? (
            rail_types[_index][1]
        ) : (
            get_rail_type(id, _index + 1)
        )
    )
);