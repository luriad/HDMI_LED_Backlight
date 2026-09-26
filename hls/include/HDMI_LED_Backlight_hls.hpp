///////////////////////////////////////////////////////////////////////////////////////////////////
// Description
///////////////////////////////////////////////////////////////////////////////////////////////////
// Common header for HDMI LED Backlight repo HLS files
//
#include <ap_int.h>
#include <hls_stream.h>
#include <hls_vector.h>
#include <ap_axi_sdata.h>

typedef ap_uint<32> color_wide;
typedef ap_uint<24> color;
typedef ap_uint<10> color_index;
typedef hls::axis<color_wide> wide_color_axis;
typedef hls::axis<color, 22> color_coord_axis;
typedef hls::axis<color, 10> color_index_axis;

typedef ap_uint<11> coordinate;
struct xy_coordinates {
    coordinate y;
    coordinate x;
};
struct bounds {
    coordinate upper;
    coordinate lower;
};
struct xy_bounds {
    bounds x;
    bounds y;
};
struct color_streams_dir {
    hls::stream<color> top;
    hls::stream<color> bottom;
    hls::stream<color> left;
    hls::stream<color> right;
};
struct coord_streams_dir {
    hls::stream<xy_coordinates> top;
    hls::stream<xy_coordinates> bottom;
    hls::stream<xy_coordinates> left;
    hls::stream<xy_coordinates> right;
};
struct last_streams_dir {
    hls::stream<bool> top;
    hls::stream<bool> bottom;
    hls::stream<bool> left;
    hls::stream<bool> right;
};
struct axis_streams_dir {
    hls::stream<color_coord_axis> top;
    hls::stream<color_coord_axis> bottom;
    hls::stream<color_coord_axis> left;
    hls::stream<color_coord_axis> right;
};

#define COORD_TO_USER(coord) ((ap_uint<22>)coord.y << 11) + coord.x
#define USER_TO_COORD_X(user) user
#define USER_TO_COORD_Y(user) user >> 11
