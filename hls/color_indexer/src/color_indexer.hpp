#include <ap_int.h>
#include <hls_stream.h>
#include <hls_vector.h>
#include <ap_axi_sdata.h>

#ifndef VERTICAL
    #define VERTICAL 0
#endif

typedef ap_uint<32> color_wide;
typedef ap_uint<24> color;
typedef ap_uint<10> color_index;
typedef hls::axis<color_wide> wide_color_axis;
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

void color_indexer(hls::stream<wide_color_axis>& axis_in, hls::stream<color_index_axis>& axis_out, 
xy_coordinates resolution, bounds x_bounds, bounds y_bounds, coordinate interval);