///////////////////////////////////////////////////////////////////////////////////////////////////
// Description
///////////////////////////////////////////////////////////////////////////////////////////////////
// Testbench for the color indexer simulation
//
#include "../src/color_indexer.hpp"

void tb_color_indexer_driver(int num_frames, reg_settings& settings) {
    hls::stream<color_coord_axis> axis_in;
    hls::stream<color_index_axis> axis_out;

    color c = 0;
    color_index index = 0;
    int i = 0;
    for (int f = 0; f < num_frames; f++) {
        bool last = false;
        printf("======Frame %d======\n", f);
        for (int y = settings.bounds.y.lower; y <= settings.bounds.y.upper; y++) {
            for (int x = settings.bounds.x.lower; x <= settings.bounds.x.upper; x++) {
                color_coord_axis pkt_in;
                xy_coordinates coord_in;
                coord_in.x = x;
                coord_in.y = y;
                pkt_in.data = x+y;
                pkt_in.user = COORD_TO_USER(coord_in);
                pkt_in.last = x == settings.bounds.x.upper && y == settings.bounds.y.upper;
                axis_in.write(pkt_in);
                color_indexer(axis_in, axis_out, settings);
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
    reg_settings settings;
    if (VERTICAL) {
        settings.interval = 3;
        settings.bounds.x.lower = 0;
        settings.bounds.x.upper = 3;
        settings.bounds.y.lower = 1;
        settings.bounds.y.upper = 6;
    } else {
        settings.interval = 3;
        settings.bounds.x.lower = 1;
        settings.bounds.x.upper = 18;
        settings.bounds.y.lower = 0;
        settings.bounds.y.upper = 3;
    }
    tb_color_indexer_driver(num_frames, settings);
}