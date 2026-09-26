///////////////////////////////////////////////////////////////////////////////////////////////////
// Description
///////////////////////////////////////////////////////////////////////////////////////////////////
// Routes color data to different screen edges based on coordinate and bounds loaded by AXI-Lite
//
#include "color_router.hpp"

void color_coordinates(hls::stream<color>& color_in, hls::stream<bool>& last_in, 
hls::stream<color>& color_out, hls::stream<xy_coordinates>& coordinates_out,
reg_settings& settings) {
    static xy_coordinates coords = {0,0};
    #pragma HLS PIPELINE II=1
    if (color_in.empty() || last_in.empty()) {
        return;
    }
    color c = color_in.read();
    bool last = last_in.read();
    color_out.write(c);
    coordinates_out.write(coords);
    coords.x++;
    if (last) {
        coords.x = 0;
        coords.y = 0;
    } else if (coords.x == settings.resolution.x) {
        coords.x = 0;
        coords.y++;
    }
}

void route(color c, xy_coordinates coord, xy_bounds bounds,
hls::stream<color>& color_out, hls::stream<xy_coordinates>& coordinates_out, hls::stream<bool>& last_out) {
    #pragma HLS INLINE
    bool last;
    if (coord.x >= bounds.x.lower && coord.x <= bounds.x.upper
    && coord.y >= bounds.y.lower && coord.y <= bounds.y.upper) {
        last = coord.x == bounds.x.upper && coord.y == bounds.y.upper;
        color_out.write(c);
        coordinates_out.write(coord);
        last_out.write(last);
    }
}

void coord_router(hls::stream<color>& color_in, hls::stream<xy_coordinates>& coordinates_in,
color_streams_dir& color_out, coord_streams_dir& coordinates_out, last_streams_dir& last_out,
reg_settings& settings) {
    #pragma HLS PIPELINE II=1
    if (color_in.empty() || coordinates_in.empty()) {
        return;
    }
    color c = color_in.read();
    xy_coordinates coord = coordinates_in.read();
    bool last_top = false;
    bool last_bottom = false;
    bool last_left = false;
    bool last_right = false;

    route(c, coord, settings.top_bounds, color_out.top, coordinates_out.top, last_out.top);
    route(c, coord, settings.bottom_bounds, color_out.bottom, coordinates_out.bottom, last_out.bottom);
    route(c, coord, settings.left_bounds, color_out.left, coordinates_out.left, last_out.left);
    route(c, coord, settings.right_bounds, color_out.right, coordinates_out.right, last_out.right);
}

void depackage_axis(hls::stream<wide_color_axis>& axis_in, 
hls::stream<color>& color_out,  hls::stream<bool>& last_out) {
    #pragma HLS PIPELINE II=1
    if (axis_in.empty()){
        return;
    }
    wide_color_axis pkt_in = axis_in.read();
    color_out.write(pkt_in.data);
    last_out.write(pkt_in.last);
}

void package_axis(hls::stream<color>& color_in, hls::stream<xy_coordinates>& coordinates_in, hls::stream<bool>& last_in,
hls::stream<color_coord_axis>& axis_out) {
    #pragma HLS PIPELINE II=1
    color_coord_axis pkt_out;
    if (color_in.empty() || coordinates_in.empty() || last_in.empty()) {
        return;
    }
    pkt_out.data = color_in.read();
    xy_coordinates coord_in = coordinates_in.read();
    pkt_out.user = COORD_TO_USER(coord_in);
    pkt_out.last = last_in.read();
    axis_out.write(pkt_out);
}

void color_router(hls::stream<wide_color_axis>& axis_in, axis_streams_dir& axis_out, reg_settings& settings) {
    #pragma HLS DISAGGREGATE variable=axis_out
    #pragma HLS INTERFACE mode=axis port=axis_in
    #pragma HLS INTERFACE mode=axis port=axis_out.top
    #pragma HLS INTERFACE mode=axis port=axis_out.bottom
    #pragma HLS INTERFACE mode=axis port=axis_out.left
    #pragma HLS INTERFACE mode=axis port=axis_out.right

    #pragma HLS DISAGGREGATE variable=settings
    #pragma HLS DISAGGREGATE variable=settings.resolution
    #pragma HLS DISAGGREGATE variable=settings.top_bounds
    #pragma HLS DISAGGREGATE variable=settings.top_bounds.x
    #pragma HLS DISAGGREGATE variable=settings.top_bounds.y
    #pragma HLS DISAGGREGATE variable=settings.bottom_bounds
    #pragma HLS DISAGGREGATE variable=settings.bottom_bounds.x
    #pragma HLS DISAGGREGATE variable=settings.bottom_bounds.y
    #pragma HLS DISAGGREGATE variable=settings.left_bounds
    #pragma HLS DISAGGREGATE variable=settings.left_bounds.x
    #pragma HLS DISAGGREGATE variable=settings.left_bounds.y
    #pragma HLS DISAGGREGATE variable=settings.right_bounds
    #pragma HLS DISAGGREGATE variable=settings.right_bounds.x
    #pragma HLS DISAGGREGATE variable=settings.right_bounds.y

    #pragma HLS INTERFACE mode=s_axilite port=settings.resolution.x
    #pragma HLS INTERFACE mode=s_axilite port=settings.resolution.y
    #pragma HLS INTERFACE mode=s_axilite port=settings.top_bounds.x.upper
    #pragma HLS INTERFACE mode=s_axilite port=settings.top_bounds.x.lower
    #pragma HLS INTERFACE mode=s_axilite port=settings.top_bounds.y.upper
    #pragma HLS INTERFACE mode=s_axilite port=settings.top_bounds.y.lower
    #pragma HLS INTERFACE mode=s_axilite port=settings.bottom_bounds.x.upper
    #pragma HLS INTERFACE mode=s_axilite port=settings.bottom_bounds.x.lower
    #pragma HLS INTERFACE mode=s_axilite port=settings.bottom_bounds.y.upper
    #pragma HLS INTERFACE mode=s_axilite port=settings.bottom_bounds.y.lower
    #pragma HLS INTERFACE mode=s_axilite port=settings.left_bounds.x.upper
    #pragma HLS INTERFACE mode=s_axilite port=settings.left_bounds.x.lower
    #pragma HLS INTERFACE mode=s_axilite port=settings.left_bounds.y.upper
    #pragma HLS INTERFACE mode=s_axilite port=settings.left_bounds.y.lower
    #pragma HLS INTERFACE mode=s_axilite port=settings.right_bounds.x.upper
    #pragma HLS INTERFACE mode=s_axilite port=settings.right_bounds.x.lower
    #pragma HLS INTERFACE mode=s_axilite port=settings.right_bounds.y.upper
    #pragma HLS INTERFACE mode=s_axilite port=settings.right_bounds.y.lower

    hls::stream<color> color_in, color_coord_to_router;
    hls::stream<xy_coordinates> coord_coord_to_router;
    hls::stream<bool> last_in;
    color_streams_dir color_out;
    coord_streams_dir coord_out;
    last_streams_dir last_out;

    #pragma HLS DATAFLOW
    depackage_axis(axis_in, color_in, last_in);

    color_coordinates(color_in, last_in, color_coord_to_router, coord_coord_to_router, settings);
    coord_router(color_coord_to_router, coord_coord_to_router, color_out, coord_out, last_out, settings);

    package_axis(color_out.top, coord_out.top, last_out.top, axis_out.top);
    package_axis(color_out.bottom, coord_out.bottom, last_out.bottom, axis_out.bottom);
    package_axis(color_out.left, coord_out.left, last_out.left, axis_out.left);
    package_axis(color_out.right, coord_out.right, last_out.right, axis_out.right);
}