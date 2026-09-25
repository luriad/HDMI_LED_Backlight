#include "color_indexer.hpp"

void color_coordinates(hls::stream<color>& color_in, hls::stream<bool>& last_in, 
                        hls::stream<color>& color_out, hls::stream<xy_coordinates>& coordinates_out,
                        xy_coordinates resolution) {
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
    } else if (coords.x == resolution.x) {
        coords.x = 0;
        coords.y++;
    }
}

void coord_filter(hls::stream<color>& color_in, hls::stream<xy_coordinates>& coordinates_in,
hls::stream<color>& color_out, hls::stream<xy_coordinates>& coordinates_out, hls::stream<bool>& last_out,
bounds x_bounds, bounds y_bounds) {
    #pragma HLS PIPELINE II=1
    if (color_in.empty() || coordinates_in.empty()) {
        return;
    }
    color c = color_in.read();
    xy_coordinates coord = coordinates_in.read();
    bool last = false;

    if (coord.x >= x_bounds.lower && coord.x <= x_bounds.upper
    && coord.y >= y_bounds.lower && coord.y <= y_bounds.upper) {
        last = coord.x == x_bounds.upper && coord.y == y_bounds.upper;
        color_out.write(c);
        coordinates_out.write(coord);
        last_out.write(last);
    }
}

void color_index_calc(hls::stream<color>& color_in, hls::stream<xy_coordinates>& coordinates_in, hls::stream<bool>& last_in,
hls::stream<color>& color_out, hls::stream<color_index>& index_out, hls::stream<bool>& last_out,
bounds x_bounds, bounds y_bounds, coordinate interval) {
    static color_index idx = 0;
    static coordinate target = VERTICAL ? y_bounds.lower+interval-1 : x_bounds.lower+interval-1;
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
            target = y_bounds.lower+interval-1;
        } else if (coord.x == x_bounds.upper && coord.y == target) {
            idx++;
            target += interval;
        }
    } else {
        if (last || coord.x == x_bounds.upper) {
            idx = 0;
            target = x_bounds.lower+interval-1;
        } else if (coord.x == target) {
            idx++;
            target += interval;
        }
    }
}

void color_indexer_pipeline(hls::stream<color>& color_in, hls::stream<bool>& last_in,
hls::stream<color>& color_out, hls::stream<color_index>& index_out, hls::stream<bool>& last_out,
xy_coordinates resolution, bounds x_bounds, bounds y_bounds, coordinate interval) {
    #pragma HLS DATAFLOW
    hls::stream<color> color_filter_to_coord, color_coord_to_calc;
    hls::stream<xy_coordinates> coord_filter_to_coord, coord_coord_to_calc;
    hls::stream<bool> last_coord_to_calc;
    color_coordinates(color_in, last_in, color_filter_to_coord, coord_filter_to_coord, resolution);
    coord_filter(color_filter_to_coord, coord_filter_to_coord, color_coord_to_calc, coord_coord_to_calc, last_coord_to_calc, x_bounds, y_bounds);
    color_index_calc(color_coord_to_calc, coord_coord_to_calc, last_coord_to_calc, color_out, index_out, last_out, x_bounds, y_bounds, interval);
}
void depackage_axis(hls::stream<wide_color_axis>& axis_in, 
hls::stream<color>& color_out, hls::stream<bool>& last_out) {
    #pragma HLS PIPELINE II=1
    if (axis_in.empty()){
        return;
    }
    wide_color_axis pkt_in = axis_in.read();
    color_out.write(pkt_in.data);
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

void color_indexer(hls::stream<wide_color_axis>& axis_in, hls::stream<color_index_axis>& axis_out, 
xy_coordinates resolution, bounds x_bounds, bounds y_bounds, coordinate interval) {
    #pragma HLS INTERFACE mode=axis port=axis_in
    #pragma HLS INTERFACE mode=axis port=axis_out
    #pragma HLS INTERFACE mode=s_axilite port=resolution
    #pragma HLS INTERFACE mode=s_axilite port=x_bounds
    #pragma HLS INTERFACE mode=s_axilite port=y_bounds
    #pragma HLS INTERFACE mode=s_axilite port=interval

    hls::stream<color> color_in, color_out;
    hls::stream<color_index> index_out;
    hls::stream<bool> last_in, last_out;

    #pragma HLS DATAFLOW
    depackage_axis(axis_in, color_in, last_in);
    color_indexer_pipeline(color_in, last_in, color_out, index_out, last_out, resolution, x_bounds, y_bounds, interval);
    package_axis(color_out, index_out, last_out, axis_out);
}