///////////////////////////////////////////////////////////////////////////////////////////////////
// Description
///////////////////////////////////////////////////////////////////////////////////////////////////
// Testbench for the color indexer simulation
//
#include "../src/color_indexer.hpp"

void tb_color_indexer_driver(int num_frames, xy_coordinates resolution, bounds x_bounds, bounds y_bounds, 
coordinate interval) {
    hls::stream<wide_color_axis> axis_in;
    hls::stream<color_index_axis> axis_out;

    color c = 0;
    color_index index = 0;
    int i = 0;
    for (int f = 0; f < num_frames; f++) {
        bool last = false;
        printf("======Frame %d======\n", f);
        for (int y = 0; y < resolution.y; y++) {
            for (int x = 0; x < resolution.x; x++) {
                wide_color_axis pkt_in;
                pkt_in.data = 1;
                pkt_in.last = x == resolution.x - 1 && y == resolution.y - 1;
                axis_in.write(pkt_in);
                color_indexer(axis_in, axis_out, resolution, x_bounds, y_bounds, interval);
            }
        }
        while(!last) {
            while (axis_out.empty());
            color_index_axis pkt_out = axis_out.read();
            c = pkt_out.data;
            index = pkt_out.user;
            last = pkt_out.last;
            printf("Packet %d: Color = %d, Index = %d, last = %d\n", i++, c, index, last);
        }
    }
}


int main() {
    int num_frames = 4;
    xy_coordinates resolution;
    resolution.y = 8;
    resolution.x = 20;
    coordinate interval = 3;
    bounds x_bounds, y_bounds;
    if (VERTICAL) {
        x_bounds.lower = 0;
        x_bounds.upper = 3;
        y_bounds.lower = 1;
        y_bounds.upper = 6;
    } else {    
        x_bounds.lower = 1;
        x_bounds.upper = 18;
        y_bounds.lower = 0;
        y_bounds.upper = 3;
    }
    tb_color_indexer_driver(num_frames, resolution, x_bounds, y_bounds, interval);
}