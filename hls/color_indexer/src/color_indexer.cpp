///////////////////////////////////////////////////////////////////////////////////////////////////
// Description
///////////////////////////////////////////////////////////////////////////////////////////////////
// Indexes colors received from AXI-S input into horizontal 
// or vertical groups based on AXI-Lite settings
//
#include "color_indexer.hpp"

void color_index_calc(hls::stream<color>& color_in, hls::stream<xy_coordinates>& coordinates_in, hls::stream<bool>& last_in,
hls::stream<color>& color_out, hls::stream<color_index>& index_out, hls::stream<bool>& last_out,
reg_settings& settings) {
    static color_index idx = 0;
    static coordinate target = VERTICAL ? settings.bounds.y.lower+settings.interval-1 : settings.bounds.x.lower+settings.interval-1;
    #pragma HLS PIPELINE II=1
    if (color_in.empty() || coordinates_in.empty() || last_in.empty()) {
        return;
    }
    color c = color_in.read();
    xy_coordinates coord = coordinates_in.read();
    bool last = last_in.read();

    color_out.write(c);
    index_out.write(idx);
    last_out.write(last);

    if (VERTICAL) {
        if (last) {
            idx = 0;
            target = settings.bounds.y.lower+settings.interval-1;
        } else if (coord.x == settings.bounds.x.upper && coord.y == target) {
            idx++;
            target += settings.interval;
        }
    } else {
        if (last || coord.x == settings.bounds.x.upper) {
            idx = 0;
            target = settings.bounds.x.lower+settings.interval-1;
        } else if (coord.x == target) {
            idx++;
            target += settings.interval;
        }
    }
}

void depackage_axis(hls::stream<color_coord_axis>& axis_in, 
hls::stream<color>& color_out, hls::stream<xy_coordinates>& coordinates_out, hls::stream<bool>& last_out) {
    #pragma HLS PIPELINE II=1
    if (axis_in.empty()){
        return;
    }
    color_coord_axis pkt_in = axis_in.read();
    color_out.write(pkt_in.data);
    xy_coordinates coord_out;
    coord_out.x = USER_TO_COORD_X(pkt_in.user);
    coord_out.y = USER_TO_COORD_Y(pkt_in.user);
    coordinates_out.write(coord_out);
    last_out.write(pkt_in.last);
}

void package_axis(hls::stream<color>& color_in, hls::stream<color_index>& index_in, hls::stream<bool>& last_in,
hls::stream<color_index_axis>& axis_out) {
    #pragma HLS PIPELINE II=1
    color_index_axis pkt_out;
    if (color_in.empty() || index_in.empty() || last_in.empty()) {
        return;
    }
    pkt_out.data = color_in.read();
    pkt_out.user = index_in.read();
    pkt_out.last = last_in.read();
    axis_out.write(pkt_out);
}

void color_indexer(hls::stream<color_coord_axis>& axis_in, hls::stream<color_index_axis>& axis_out, reg_settings& settings) {
    #pragma HLS INTERFACE mode=axis port=axis_in
    #pragma HLS INTERFACE mode=axis port=axis_out

    #pragma HLS DISAGGREGATE variable=settings
    #pragma HLS DISAGGREGATE variable=settings.bounds
    #pragma HLS DISAGGREGATE variable=settings.bounds.x
    #pragma HLS DISAGGREGATE variable=settings.bounds.y

    #pragma HLS INTERFACE mode=s_axilite port=settings.bounds.x.upper
    #pragma HLS INTERFACE mode=s_axilite port=settings.bounds.x.lower
    #pragma HLS INTERFACE mode=s_axilite port=settings.bounds.y.upper
    #pragma HLS INTERFACE mode=s_axilite port=settings.bounds.y.lower
    #pragma HLS INTERFACE mode=s_axilite port=settings.interval

    hls::stream<color> color_in, color_out;
    hls::stream<xy_coordinates> coordinates_in;
    hls::stream<color_index> index_out;
    hls::stream<bool> last_in, last_out;

    #pragma HLS DATAFLOW
    depackage_axis(axis_in, color_in, coordinates_in, last_in);
    color_index_calc(color_in, coordinates_in, last_in, color_out, index_out, last_out, settings);
    package_axis(color_out, index_out, last_out, axis_out);
}