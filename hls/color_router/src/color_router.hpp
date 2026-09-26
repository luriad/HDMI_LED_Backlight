///////////////////////////////////////////////////////////////////////////////////////////////////
// Description
///////////////////////////////////////////////////////////////////////////////////////////////////
// Header for the color router
//
#include "../../include/HDMI_LED_Backlight_hls.hpp"

struct reg_settings {
    xy_coordinates resolution;
    xy_bounds top_bounds;
    xy_bounds bottom_bounds;
    xy_bounds left_bounds;
    xy_bounds right_bounds;
};

void color_router(hls::stream<wide_color_axis>& axis_in, axis_streams_dir& axis_out, hls::stream<wide_color_axis>& axis_passthrough, 
reg_settings& settings);